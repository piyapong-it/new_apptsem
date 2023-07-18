class DmLmessage {
  DmLmessage({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<dynamic> result;

  factory DmLmessage.fromJson(Map<String, dynamic> json) => DmLmessage(
    success: json["success"],
    message: json["message"],
    result: List<dynamic>.from(json["result"].map((x) => x)),
  );
}