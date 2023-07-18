class VisitAgenda {
  VisitAgenda({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory VisitAgenda.fromJson(Map<String, dynamic> json) => VisitAgenda(
    success: json["success"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    this.visitId,
    this.outletid,
    this.visitDate,
    this.agendaId,
    this.agendaGroup,
    this.agendaName,
    this.status,
    this.minreq,
  });

  String visitId;
  String outletid;
  DateTime visitDate;
  int agendaId;
  String agendaGroup;
  String agendaName;
  String status;
  int minreq;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    visitId: json["VISIT_ID"],
    outletid: json["OUTLETID"],
    visitDate: DateTime.parse(json["VISIT_DATE"]),
    agendaId: json["AGENDA_ID"],
    agendaGroup: json["AGENDA_GROUP"],
    agendaName: json["AGENDA_NAME"],
    status: json["STATUS"],
    minreq: json["MINREQ"],
  );
}
