class SalesFolder {
  SalesFolder({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory SalesFolder.fromJson(Map<String, dynamic> json) => SalesFolder(
    success: json["success"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.fileSeq,
    this.fileGroupName,
    this.fileTitle,
    this.fileSubTitle,
    this.fileName,
    this.fileUrl,
    this.createBy,
    this.createDate,
  });

  int id;
  int fileSeq;
  String fileGroupName;
  String fileTitle;
  String fileSubTitle;
  String fileName;
  String fileUrl;
  String createBy;
  DateTime createDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    fileSeq: json["File_SEQ"] == null ? null : json["File_SEQ"],
    fileGroupName: json["File_GroupName"] == null ? null : json["File_GroupName"],
    fileTitle: json["File_Title"] == null ? null : json["File_Title"],
    fileSubTitle: json["File_SubTitle"] == null ? null : json["File_SubTitle"],
    fileName: json["File_Name"] == null ? null : json["File_Name"],
    fileUrl: json["fileUrl"],
    createBy: json["CREATE_BY"] == null ? null : json["CREATE_BY"],
    createDate: json["CREATE_DATE"] == null ? null : DateTime.parse(json["CREATE_DATE"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "File_SEQ": fileSeq == null ? null : fileSeq,
    "File_GroupName": fileGroupName == null ? null : fileGroupName,
    "File_Title": fileTitle == null ? null : fileTitle,
    "File_SubTitle": fileSubTitle == null ? null : fileSubTitle,
    "File_Name": fileName == null ? null : fileName,
    "fileUrl": fileUrl,
    "CREATE_BY": createBy == null ? null : createBy,
    "CREATE_DATE": createDate == null ? null : createDate.toIso8601String(),
  };
}
