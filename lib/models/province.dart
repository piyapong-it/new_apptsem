class Province {
  Province({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<resProvince> result;

 factory Province.fromJson(Map<String, dynamic> json) => Province(
        success: json["success"],
        message: json["message"],
        result:
            List<resProvince>.from(json["result"].map((x) => resProvince.fromJson(x))),
      );
}

class resProvince {
  resProvince({
    this.provinceId,
    this.provinceName,
    this.provinceEng,
    this.strategic
  });

  String provinceId;
  String provinceName;
  String provinceEng;
  String strategic;
 

  factory resProvince.fromJson(Map<String, dynamic> json) => resProvince(
    provinceId: json["PROVINCE_ID"].toString(),
    provinceName: json["PROVINCE_NAME"],
    provinceEng: json["PROVINCE_EN"],
    strategic: json["STRATEGIC"].toString()
  );
}
