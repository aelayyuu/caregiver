import 'package:caregiver/models/alarm_info.dart';
import 'package:caregiver/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'frm_first_aid.dart';

class SetAlarmForm extends StatefulWidget {
  const SetAlarmForm({Key? key}) : super(key: key);

  @override
  State<SetAlarmForm> createState() => _SetAlarmFormState();
}

class _SetAlarmFormState extends State<SetAlarmForm> {
  String alarmTime = "";
  List<AlarmInfo> alarmInfoList = [];
  bool switchValue = true;

  @override
  void initState() {
    getAlarm();
    super.initState();
  }

  getAlarm() {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    serviceProvider.getAlarmDataList().then((value) async {
      setState(() {
        alarmInfoList = value;
      });
    });
  }

  @override
  void dispose() {
    getAlarm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const FirstAidForm()),
            (route) => false);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Alarm")),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: TimePickerSpinner(
                  is24HourMode: false,
                  normalTextStyle:
                      const TextStyle(fontSize: 20, color: Colors.black),
                  highlightedTextStyle:
                      const TextStyle(fontSize: 20, color: Colors.red),
                  spacing: 50,
                  itemHeight: 60,
                  isForce2Digits: false,
                  onTimeChange: (time) {
                    setState(() {
                      alarmTime = DateFormat('HH:mm:ss').format(time);
                    });
                    debugPrint(time.toString());
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    serviceProvider
                        .setAlarm(AlarmInfo(alarmTime: alarmTime, flag: "1"))
                        .then((value) {
                      if (value.status == "success") {
                        setState(() {
                          alarmInfoList.add(value);
                        });
                        Fluttertoast.showToast(
                            msg: "Alarm created successfully!");
                        setState(() {
                          getAlarm();
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Alarm not created!");
                      }
                    });
                  },
                  child: const Text("Add")),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: alarmInfoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var formatTime = DateFormat.jm().format(
                        DateFormat("hh:mm:ss")
                            .parse(alarmInfoList[index].alarmTime));
                    return SizedBox(
                      height: MediaQuery.of(context).size.width / 5,
                      child: Card(
                        elevation: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text.rich(TextSpan(
                              text: formatTime,
                              // children: <InlineSpan>[TextSpan(text: ' PM')]
                            )),
                            Switch.adaptive(
                                value: alarmInfoList[index].flag == "0"
                                    ? false
                                    : true,
                                onChanged: (newValue) async {
                                  await serviceProvider
                                      .updateAlarmFlag(AlarmInfo(
                                          alid: alarmInfoList[index].alid,
                                          alarmTime:
                                              alarmInfoList[index].alarmTime,
                                          flag: alarmInfoList[index].flag == "0"
                                              ? "1"
                                              : "0"))
                                      .then((result) {
                                    debugPrint(result);
                                    setState(() {
                                      switchValue = newValue;
                                      getAlarm();
                                    });
                                  });
                                })
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
