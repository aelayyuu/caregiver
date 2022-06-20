class AdminInfo {
  final String? userId;
  final String username;
  final String? contact;
  final String password;
  final String? status;

  AdminInfo({
    this.userId,
    required this.username,
    this.contact,
    required this.password,
    this.status,
  });
  factory AdminInfo.fromJson(Map<String, dynamic> json) {
    return AdminInfo(
        userId: json["userid"],
        username: json["username"],
        contact: json['contact'],
        password: json['password'],
        status: json['status']);
  }
}
