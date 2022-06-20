import 'package:caregiver/forms/frm_first_aid.dart';
import 'package:caregiver/models/aid_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/service_provider.dart';

class AddNewFeedForm extends StatefulWidget {
  const AddNewFeedForm({Key? key}) : super(key: key);

  @override
  State<AddNewFeedForm> createState() => _AddNewFeedFormState();
}

class _AddNewFeedFormState extends State<AddNewFeedForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  TextEditingController cautionController = TextEditingController();
  TextEditingController photoPathController = TextEditingController();

  Widget createLable(String lable) {
    return Row(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width / 4, child: Text(lable)),
        const Text(":")
      ],
    );
  }

  @override
  void dispose() {
    nameController.clear();
    instructionController.clear();
    cautionController.clear();
    photoPathController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProider = Provider.of<ServiceProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const FirstAidForm()),
            (route) => false);
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Add New Feed")),
        body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      createLable("Name"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please fill aid name!";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      createLable("Instruction"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                          controller: instructionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please fill instruction!";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      createLable("Caution"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                          controller: cautionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please fill caution!";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      createLable("Photo Path"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                          controller: photoPathController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              serviceProider
                                  .createAid(AidInfo(
                                      name: nameController.text,
                                      instruction: instructionController.text,
                                      caution: cautionController.text,
                                      photo: photoPathController.text))
                                  .then((value) {
                                if (value == "Aid created successfully.") {
                                  Fluttertoast.showToast(
                                      msg: "Adding aid successfully");
                                  nameController.clear();
                                  instructionController.clear();
                                  cautionController.clear();
                                  photoPathController.clear();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Failed to add aid");
                                }
                              });
                            }
                          },
                          child: const Text("Save"))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
