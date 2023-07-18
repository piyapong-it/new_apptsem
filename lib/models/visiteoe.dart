class VisitEoE {
  VisitEoE({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory VisitEoE.fromJson(Map<String, dynamic> json) => VisitEoE(
    success: json["success"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    this.visitId,
    this.agendaId,
    this.agendaGroup,
    this.eoeSeq,
    this.eoePmId,
    this.outletId,
    this.visitDate,
    this.eoeImage,
    this.eoeText,
    this.eoeFocus,
    this.eoeFlag,
  });

  String visitId;
  int agendaId;
  String agendaGroup;
  int eoeSeq;
  int eoePmId;
  String outletId;
  DateTime visitDate;
  String eoeImage;
  String eoeText;
  String eoeFocus;
  String eoeFlag;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    visitId: json["VISIT_ID"],
    agendaId: json["AGENDA_ID"],
    agendaGroup: json["AGENDA_GROUP"],
    eoeSeq: json["EOE_SEQ"],
    eoePmId: json["EOE_PM_ID"],
    outletId: json["OutletID"],
    visitDate: DateTime.parse(json["VISIT_DATE"]),
    eoeImage: json["EOE_IMAGE"],
    eoeText: json["EOE_TEXT"],
    eoeFocus: json["EOE_FOCUS"],
    eoeFlag: json["EOE_FLAG"],
  );
}
