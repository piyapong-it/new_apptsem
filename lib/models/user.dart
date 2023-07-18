class User {
  User({
    this.success,
    this.message,
    this.firstName,
    this.lastName,
    this.department,
    this.level,
    this.email,
    this.jdeCode,
    this.token,
    this.appversion
  });

  bool success;
  String message;
  String firstName;
  String lastName;
  String department;
  String level;
  String email;
  String jdeCode;
  String token;
  String appversion;

  factory User.fromJson(Map<String, dynamic> json) => User(
    success: json["success"],
    message: json["message"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    department: json["department"],
    level: json["level"],
    email: json["email"],
    jdeCode: json["jdeCode"],
    token: json["token"],
    appversion: json["appVersion"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "firstName": firstName,
    "lastName": lastName,
    "department": department,
    "level": level,
    "email": email,
    "jdeCode": jdeCode,
    "token": token,
    "appVersion": appversion
  };
}
