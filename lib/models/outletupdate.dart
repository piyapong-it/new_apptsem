class UpdateOutl {
  UpdateOutl({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<dynamic> result;

  factory UpdateOutl.fromJson(Map<String, dynamic> json) => UpdateOutl(
    success: json["success"],
    message: json["message"],
    result: List<dynamic>.from(json["result"].map((x) => x)),
  );
}