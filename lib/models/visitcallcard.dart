class VisitCallCard {
  VisitCallCard({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory VisitCallCard.fromJson(Map<String, dynamic> json) => VisitCallCard(
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
    this.visitId,
    this.agendaId,
    this.pmId,
    this.pmName,
    this.pmType,
    this.pmSize,
    this.bmId,
    this.bmName,
    this.bmOwn,
    this.premas,
    this.mas,
    this.price,
    this.stock,
    this.productionDate,
    this.outletId,
    this.visitDate,
    this.pmImage,
    this.disCase,
    this.targetCase,
    this.eoeSeq,
    this.remark
  });

  String visitId;
  int agendaId;
  String pmId;
  String pmName;
  String pmType;
  String pmSize;
  String bmId;
  String bmName;
  String bmOwn;
  double premas;
  double mas;
  double price;
  double stock;
  DateTime productionDate;
  String outletId;
  DateTime visitDate;
  String pmImage;
  double disCase;
  double targetCase;
  int eoeSeq;
  String remark;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    visitId: json["VISIT_ID"],
    agendaId: json["AGENDA_ID"],
    pmId: json["PM_ID"].toString(),
    pmName: json["PM_NAME"],
    pmType: json["PM_TYPE"],
    pmSize: json["PM_SIZE"],
    bmId: json["BM_ID"].toString(),
    bmName: json["BM_NAME"],
    bmOwn: json["BM_OWN"],
    premas: double.parse(json["PREMAS"].toString()),
    mas: double.parse(json["MAS"].toString()),
    price: double.parse(json["PRICE"].toString()) ,
    stock: double.parse(json["STOCK"].toString()),
    productionDate: json["PRODUCTION_DATE"] == null ? null : DateTime.parse(json["PRODUCTION_DATE"]),
    outletId: json["OutletID"],
    visitDate: DateTime.parse(json["VISIT_DATE"]),
    pmImage: json["PM_IMAGE"],
    disCase: double.parse(json["DIS_CASE"].toString()),
    targetCase: double.parse(json["TARGET_CASE"].toString()),
    eoeSeq: json["EOE_SEQ"],
    remark: json["REMARK"],
  );

  Map<String, dynamic> toJson() => {
    "VISIT_ID": visitId,
    "AGENDA_ID": agendaId,
    "PM_ID": pmId,
    "PM_NAME": pmName,
    "PM_TYPE": pmType,
    "PM_SIZE": pmSize,
    "BM_ID": bmId,
    "BM_NAME": bmName,
    "BM_OWN": bmOwn,
    "PREMAS": premas,
    "MAS": mas,
    "PRICE": price,
    "STOCK": stock,
    "PRODUCTION_DATE": productionDate == null ? null : productionDate.toIso8601String(),
    "OutletID": outletId,
    "VISIT_DATE": visitDate.toIso8601String(),
    "PM_IMAGE": pmImage,
    "DIS_CASE": disCase,
    "TARGET_CASE": targetCase,
    "EOE_SEQ": eoeSeq,
    "REMARK": remark
  };
}