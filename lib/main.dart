import 'package:caregiver/forms/frm_first_aid.dart';
import 'package:caregiver/providers/service_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forms/frm_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String username = "";
  String password = "";
  @override
  void initState() {
    getUserData();
    _checkPermission();
    super.initState();
  }

  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      if (kDebugMode) {
        print('Turn on location services before requesting permission.');
      }
      return;
    }
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      if (kDebugMode) {
        print('Permission granted');
      }
    } else if (status == PermissionStatus.denied) {
      if (kDebugMode) {
        print(
            'Permission denied. Show a dialog and again ask for the permission');
      }
    } else if (status == PermissionStatus.permanentlyDenied) {
      if (kDebugMode) {
        print('Take the user to the settings page.');
      }
      await openAppSettings();
    }
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString("username") != null
          ? sharedPreferences.getString("username")!
          : "";
      password = sharedPreferences.getString("password") != null
          ? sharedPreferences.getString("password")!
          : "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ServiceProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Care Giver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: (username != "" && password != "")
            ? const FirstAidForm()
            : const LoginForm(),
      ),
    );
  }
}
