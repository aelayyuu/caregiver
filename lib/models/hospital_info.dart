class Hospital {
  Hospital({
    required this.hid,
    required this.hospitalName,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String hid;
  final String hospitalName;
  final String phone;
  final String address;
  final String latitude;
  final String longitude;
  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        hid: json["hid"],
        hospitalName: json["hospital_name"],
        phone: json["phone"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
}
