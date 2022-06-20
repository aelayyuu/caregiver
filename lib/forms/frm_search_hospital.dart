import 'package:caregiver/hospital/map_screen.dart';
import 'package:caregiver/hospital/table_screeen.dart';
import 'package:flutter/material.dart';

import 'frm_first_aid.dart';

class SearchHospitalForm extends StatefulWidget {
  const SearchHospitalForm({Key? key}) : super(key: key);

  @override
  State<SearchHospitalForm> createState() => _SearchHospitalFormState();
}

class _SearchHospitalFormState extends State<SearchHospitalForm> {
  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const FirstAidForm()),
            (route) => false);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Nearest Hospital")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const MapScreen()),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: TableScreen(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
