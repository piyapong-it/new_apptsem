class ProductMasterByVisit {
  ProductMasterByVisit({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory ProductMasterByVisit.fromJson(Map<String, dynamic> json) => ProductMasterByVisit(
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
    this.pmId,
    this.pmName,
    this.pmType,
    this.pmSize,
    this.bmId,
    this.bmName,
    this.bmOwn,
    this.selectedPm,
    this.visitId,
    this.agendaId,
    this.premas,
    this.mas,
    this.price,
    this.stock,
    this.productionDate,
    this.outletId,
    this.visitDate,
  });

  String pmId;
  String pmName;
  String pmType;
  String pmSize;
  int bmId;
  String bmName;
  String bmOwn;
  int selectedPm;
  String visitId;
  int agendaId;
  double premas;
  double mas;
  double price;
  double stock;
  DateTime productionDate;
  String outletId;
  DateTime visitDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    pmId: json["PM_ID"].toString(),
    pmName: json["PM_NAME"],
    pmType: json["PM_TYPE"] == null ? null : json["PM_TYPE"],
    pmSize: json["PM_SIZE"] == null ? null : json["PM_SIZE"],
    bmId: json["BM_ID"],
    bmName: json["BM_NAME"],
    bmOwn: json["BM_OWN"],
    selectedPm: json["SelectedPM"],
    visitId: json["VISIT_ID"] == null ? null : json["VISIT_ID"],
    agendaId: json["AGENDA_ID"] == null ? null : json["AGENDA_ID"],
    premas: json["PREMAS"] == null ? null : double.parse(json["PREMAS"].toString()),
    mas: json["MAS"] == null ? null : double.parse(json["MAS"].toString()),
    price: json["PRICE"] == null ? null : double.parse(json["PRICE"].toString()),
    stock: json["STOCK"] == null ? null : double.parse(json["STOCK"].toString()),
    productionDate: json["PRODUCTION_DATE"] == null ? null : DateTime.parse(json["PRODUCTION_DATE"]),
    outletId: json["OutletID"] == null ? null : json["OutletID"],
    visitDate: json["VISIT_DATE"] == null ? null : DateTime.parse(json["VISIT_DATE"]),
  );

  Map<String, dynamic> toJson() => {
    "PM_ID": pmId,
    "PM_NAME": pmName,
    "PM_TYPE": pmType == null? null : pmType,
    "PM_SIZE": pmSize == null? null : pmSize,
    "BM_ID": bmId,
    "BM_NAME": bmName,
    "BM_OWN": bmOwn,
    "SelectedPM": selectedPm,
    "VISIT_ID": visitId == null ? null : visitId,
    "AGENDA_ID": agendaId == null ? null : agendaId,
    "PREMAS": premas == null ? null : premas,
    "MAS": mas == null ? null : mas,
    "PRICE": price == null ? null : price,
    "STOCK": stock == null ? null : stock,
    "PRODUCTION_DATE": productionDate == null ? null : productionDate.toIso8601String(),
    "OutletID": outletId == null ? null : outletId,
    "VISIT_DATE": visitDate == null ? null : visitDate.toIso8601String(),
  };
}




