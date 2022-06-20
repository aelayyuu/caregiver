class AlarmInfo {
   String? alid;
  final String alarmTime;
  String flag;
  final String? status;

  AlarmInfo({
    this.alid,
    required this.alarmTime,
    required this.flag,
    this.status,
  });
  factory AlarmInfo.fromJson(Map<String, dynamic> json) {
    return AlarmInfo(
      alid: json["alid"],
      alarmTime: json["alarm_time"],
      flag: json['flag'],
      status: json['status']
    );
  }
}
