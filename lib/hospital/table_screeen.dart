import 'package:caregiver/models/hospital_info.dart';
import 'package:caregiver/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({Key? key}) : super(key: key);

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  List<Hospital> hospital = [];
  bool hasCallSupport = false;
  Future<void>? launched;

  getHospital() {
    final serviceProider = Provider.of<ServiceProvider>(context, listen: false);
    serviceProider.fetchHospital().then((result) {
      setState(() {
        hospital = result;
        //ascending order of alphabet
        hospital.sort((a, b) {
          return a.hospitalName
              .toLowerCase()
              .compareTo(b.hospitalName.toLowerCase());
        });
      });
    });
  }

  @override
  void initState() {
    getHospital();
    canLaunchUrl(Uri(scheme: 'tel')).then((bool result) {
      setState(() {
        hasCallSupport = result;
      });
    });
    super.initState();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget randomHeightContainer(String title, {String? phone}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 6.5,
      width: MediaQuery.of(context).size.width / 6.5,
      child: Center(
        child: GestureDetector(
          onTap: hasCallSupport
              ? () => setState(() {
                    launched = _makePhoneCall(phone!);
                  })
              : null,
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  TableRow tableRow(String hospitalName, String phone, String address) {
    return TableRow(
      children: [
        randomHeightContainer(hospitalName),
        randomHeightContainer(phone,phone: phone),
        randomHeightContainer(address)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Table(
          border: TableBorder.all(),
          children: [
            tableRow('Hospital', 'Phone', 'Address'),
            for (int i = 0; i < hospital.length; i++)
              tableRow(hospital[i].hospitalName, hospital[i].phone,
                  hospital[i].address),
          ],
        ),
      ],
    );
  }
}
