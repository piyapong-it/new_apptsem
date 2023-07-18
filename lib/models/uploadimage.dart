class UploadImage {
  UploadImage({
    this.success,
    this.message,
    this.profileUrl,
  });

  bool success;
  String message;
  String profileUrl;

  factory UploadImage.fromJson(Map<String, dynamic> json) => UploadImage(
    success: json["success"],
    message: json["message"],
    profileUrl: json["profile_url"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "profile_url": profileUrl,
  };
}
