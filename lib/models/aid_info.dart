class AidInfo {
  final String? faid;
  final String name;
  final String instruction;
  final String caution;
  final String? photo;

  AidInfo(
      {this.faid,
      required this.name,
      required this.instruction,
      required this.caution,
      this.photo});
  factory AidInfo.fromJson(Map<String, dynamic> json) {
    return AidInfo(
        faid: json["faid"],
        name: json["name"],
        instruction: json['instruction'],
        caution: json['caution'],
        photo: json['photo']);
  }
}
