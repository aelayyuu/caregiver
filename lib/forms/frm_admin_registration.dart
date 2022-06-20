import 'package:caregiver/forms/frm_login.dart';
import 'package:caregiver/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../models/admin_or_user_info.dart';
import 'frm_first_aid.dart';

class AdminRegistrationForm extends StatefulWidget {
  const AdminRegistrationForm({Key? key}) : super(key: key);

  @override
  State<AdminRegistrationForm> createState() => _AdminRegistrationFormState();
}

class _AdminRegistrationFormState extends State<AdminRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phnoController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  bool validate = false;

  createAdmin(BuildContext c, AdminInfo adminInfo) {
    final serviceProider = Provider.of<ServiceProvider>(c, listen: false);
    serviceProider.createAdmin(adminInfo).then((result) async {
      if (result == "success") {
        Fluttertoast.showToast(msg: "Admin registration successfully!");
      } else {
        Fluttertoast.showToast(msg: "Admin registration failed!");
      }
    });
  }

  @override
  void dispose() {
    usernameController.clear();
    phnoController.clear();
    pwdController.clear();
    confirmPwdController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const FirstAidForm()),
            (route) => false);
        return Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('Admin Registration')),
        body: Form(
          key: _formKey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 35, bottom: 15),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter Username'),
                controller: usernameController,
                validator: (userName) {
                  if (userName == null || userName.isEmpty) {
                    return "Please fill user name!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 35.0, right: 35.0, bottom: 15),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Gmail or Phone Number',
                    hintText: 'Enter Gmail or Phone Number'),
                controller: phnoController,
                validator: (phNo) {
                  if (phNo == null || phNo.isEmpty) {
                    return "Please fill gmail or phone number!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 35.0, right: 35.0, bottom: 15),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Password'),
                controller: pwdController,
                validator: (pwd) {
                  if (pwd == null || pwd.isEmpty) {
                    return "Please fill password!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 35.0, right: 35.0, bottom: 15),
              child: TextFormField(
                controller: confirmPwdController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Enter Confirm Password',
                    errorText: validate
                        ? "Please check your confirm password!"
                        : null),
                onChanged: (value) {
                  if (pwdController.text != value) {
                    setState(() {
                      validate = true;
                    });
                  } else {
                    setState(() {
                      validate = false;
                    });
                  }
                },
                validator: (confirmPwd) {
                  if (confirmPwd == null || confirmPwd.isEmpty) {
                    return "Please fill confirm password!";
                  } else if (pwdController.text != confirmPwd) {
                    return "Not Same password!";
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createAdmin(
                        context,
                        AdminInfo(
                            username: usernameController.text,
                            contact: phnoController.text,
                            password: pwdController.text));
                  }
                },
                child: const Text("Done")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginForm()));
                },
                child: const Text(
                  "Login",
                  style: TextStyle(decoration: TextDecoration.underline),
                ))
          ]),
        ),
      ),
    );
  }
}
