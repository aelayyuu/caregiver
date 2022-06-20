import 'package:caregiver/fab_boom/boom_menu.dart';
import 'package:caregiver/fab_boom/boom_menu_item.dart';
import 'package:caregiver/forms/frm_add_newfeed.dart';
import 'package:caregiver/forms/frm_admin_registration.dart';
import 'package:caregiver/forms/frm_search_hospital.dart';
import 'package:caregiver/forms/frm_set_alarm.dart';
import 'package:caregiver/models/aid_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/service_provider.dart';

class FirstAidForm extends StatefulWidget {
  const FirstAidForm({Key? key}) : super(key: key);

  @override
  State<FirstAidForm> createState() => _FirstAidFormState();
}

class _FirstAidFormState extends State<FirstAidForm> {
  List<AidInfo> tempAidDataList = [];
  List<AidInfo> aidDataList = [];
  bool isSearchClick = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getAidList();
    super.initState();
  }

  @override
  void dispose() {
    getAidList();
    searchController.clear();
    super.dispose();
  }

  getAidList() {
    final serviceProider = Provider.of<ServiceProvider>(context, listen: false);
    serviceProider.fetchAidList().then((result) {
      setState(() {
        tempAidDataList = result;
        //ascending order of alphabet
        tempAidDataList.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        aidDataList = tempAidDataList;
      });
    });
  }

  Widget createTextWidget(String lable, double font) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 18.0, right: 18.0, top: 10.0, bottom: 10.0),
      child: Text(
        lable,
        maxLines: 3,
        style: TextStyle(fontSize: font),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearchClick
            ? const Text("First Aid")
            : Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      List<AidInfo> list = [];
                      for (var element in tempAidDataList) {
                        if (element.name.contains(value)|| element.caution.contains(value) ||
                            element.instruction.contains(value)) {
                          setState(() {
                            list.add(element);
                          });
                        }
                      }
                      setState(() {
                        aidDataList = list;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              isSearchClick = false;
                              searchController.clear();
                              aidDataList = tempAidDataList;
                            });
                          },
                        ),
                        hintText: 'Search...',
                        border: InputBorder.none),
                  ),
                ),
              ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchClick = true;
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: ListView.builder(
          itemCount: aidDataList.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, right: 10.0, bottom: 5.0, left: 10.0),
              child: Card(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      createTextWidget(aidDataList[i].name, 14),
                      (aidDataList[i].photo == null ||
                              aidDataList[i].photo == "")
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Image.network(aidDataList[i].photo!,
                                  width: double.infinity, height: 100),
                            ),
                      createTextWidget(aidDataList[i].instruction, 14),
                      createTextWidget(aidDataList[i].caution, 14),
                    ]),
              ),
            );
          }),
      floatingActionButton: BoomMenu(
        animatedIconTheme: const IconThemeData(size: 22.0),
        scrollVisible: true,
        children: [
          MenuItemBoom(
            title: "Registration",
            titleColor: Colors.white,
            backgroundColor: Colors.deepOrange,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AdminRegistrationForm()));
            },
            elevation: 1,
          ),
          MenuItemBoom(
            title: "Add New Feed",
            titleColor: Colors.white,
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddNewFeedForm()));
            },
            elevation: 1,
          ),
          MenuItemBoom(
            title: "Set Alarm Time",
            titleColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SetAlarmForm(),
                 ));
            },
            elevation: 1,
          ),
          MenuItemBoom(
            title: "Search Hospital",
            titleColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchHospitalForm()));
            },
            elevation: 1,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
