import 'dart:convert';
import 'package:caregiver/models/aid_info.dart';
import 'package:caregiver/models/alarm_info.dart';
import 'package:caregiver/models/hospital_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/admin_or_user_info.dart';

class ServiceProvider with ChangeNotifier {
  Future<String> createAdmin(AdminInfo info) async {
    String url = "https://tharlar.site/caregiver/user/create-user.php";
    Uri uri = Uri.parse(url);
    final response = await http
        .post(uri,
            body: json.encode({
              "username": info.username,
              "contact": info.contact,
              "password": info.password
            }))
        .catchError((onError) async {
      throw Exception(onError);
    });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.statusCode.toString();
    }
  }

  Future<AdminInfo> userLogin(AdminInfo info) async {
    String url = "https://tharlar.site/caregiver/user/login-user.php";
    Uri uri = Uri.parse(url);
    final response = await http
        .post(uri,
            body: json
                .encode({"username": info.username, "password": info.password}))
        .catchError((onError) async {
      throw Exception(onError);
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return AdminInfo.fromJson(data);
    } else {
      throw Exception("Fail to login");
    }
  }

  Future<String> createAid(AidInfo aidInfo) async {
    String url = "https://tharlar.site/caregiver/aid/create-aid.php";
    Uri uri = Uri.parse(url);
    final response = await http
        .post(uri,
            body: json.encode({
              "name": aidInfo.name,
              "instruction": aidInfo.instruction,
              "caution": aidInfo.caution,
              "photo": aidInfo.photo
            }))
        .catchError((onError) async {
      throw Exception(onError);
    });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Fail to create aid");
    }
  }

  Future<List<AidInfo>> fetchAidList() async {
    String url = "https://tharlar.site/caregiver/aid/aid-api.php";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri).catchError((onError) async {
      throw Exception(onError);
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<AidInfo> aidList = [];
      data['list'].forEach((aid) {
        aidList.add(AidInfo.fromJson(aid));
      });
      return aidList;
    } else {
      throw Exception("Fail to fetch aid list");
    }
  }

  Future<AlarmInfo> setAlarm(AlarmInfo alarmInfo) async {
    String url = "https://tharlar.site/caregiver/alarm/create-alarm.php";
    Uri uri = Uri.parse(url);
    final response = await http
        .post(uri,
            body: json.encode(
                {"alarm_time": alarmInfo.alarmTime, "flag": alarmInfo.flag}))
        .catchError((onError) async {
      throw Exception(onError);
    });
    if (response.statusCode == 200) {
      return AlarmInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception("Fail to set alarm time!");
    }
  }

  Future<String> updateAlarmFlag(AlarmInfo alarmInfo) async {
    String url =
        "https://tharlar.site/caregiver/alarm/update-alarm.php/?alid=${alarmInfo.alid}";
    debugPrint(url);
    Uri uri = Uri.parse(url);
    final response = await http
        .post(uri,
            body: json.encode(
                {"alarm_time": alarmInfo.alarmTime, "flag": alarmInfo.flag}))
        .catchError((onError) async {
      throw Exception(onError);
    });
    debugPrint("response >> ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.statusCode.toString();
    }
  }

  Future<List<AlarmInfo>> getAlarmDataList() async {
    String url = "https://tharlar.site/caregiver/alarm/alarm-api.php";
    Uri uri = Uri.parse(url);
    final response = await http
        .get(
      uri,
    )
        .catchError((onError) async {
      throw Exception(onError);
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<AlarmInfo> alarmList = [];
      data['list'].forEach((al) {
        alarmList.add(AlarmInfo.fromJson(al));
      });
      return alarmList;
    } else {
      throw Exception("Fail to get alarm data list!");
    }
  }

  Future<List<Hospital>> fetchHospital() async {
    String url = "https://tharlar.site/caregiver/hospital/hospital-api.php";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri).catchError((onError) async {
      throw Exception(onError);
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Hospital> hospitalList = [];
      data['list'].forEach((hid) {
        hospitalList.add(Hospital.fromJson(hid));
      });
      return hospitalList;
    } else {
      throw Exception("Fail to fetch aid list");
    }
  }
}
