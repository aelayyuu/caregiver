import 'package:caregiver/models/admin_or_user_info.dart';
import 'package:caregiver/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'frm_first_aid.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  saveUserData(AdminInfo info) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("username", info.username);
    sharedPreferences.setString("password", info.password);
  }

  @override
  void dispose() {
    userNameController.clear();
    passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProider = Provider.of<ServiceProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Care Giver")),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter Username'),
                controller: userNameController,
                keyboardType: TextInputType.text,
                validator: (validator) {
                  if (validator == null || validator.isEmpty) {
                    return "Please fill Username field";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 35, bottom: 15),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (validator) {
                  if (validator == null || validator.isEmpty) {
                    return "Please fill Password field";
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    serviceProider
                        .userLogin(AdminInfo(
                      username: userNameController.text,
                      password: passwordController.text,
                    ))
                        .then((result) {
                      if (result.status == 'success') {
                        Fluttertoast.showToast(msg: "Login successfully!");
                        saveUserData(result);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const FirstAidForm()));
                      } else if (result.status == 'fail') {
                        Fluttertoast.showToast(
                            msg: "Invalid username or password!");
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: const Text("Login")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not Registered?"),
                TextButton(
                  child: const Text(
                    "Go to Newsfeed",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const FirstAidForm()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
