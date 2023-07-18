class ItemVisitEoE {
  ItemVisitEoE({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory ItemVisitEoE.fromJson(Map<String, dynamic> json) => ItemVisitEoE(
        success: json["success"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result({
    this.pm_id,
    this.pm_name,
    this.bm_id,
    this.bm_name,
    this.bm_own,
    this.selected,
    this.agenda_id,
    this.eoe_focus,
    this.eoe_flag,
    this.eoe_seq,
    this.eoe_text,
    this.eoe_image,
  });

  int pm_id;
  String pm_name;
  int bm_id;
  String bm_name;
  String bm_own;
  int selected;
  int agenda_id;
  String eoe_focus;
  String eoe_flag;
  int eoe_seq;
  String eoe_text;
  String eoe_image;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      pm_id: json["PM_ID"],
      pm_name: json["PM_NAME"],
      bm_id: json["BM_ID"],
      bm_name: json["BM_NAME"],
      bm_own: json["BM_OWN"],
      selected: json["Selected"],
      agenda_id: json["AGENDA_ID"],
      eoe_focus: json["EOE_FOCUS"],
      eoe_flag: json["EOE_FLAG"],
      eoe_seq: json["EOE_SEQ"],
      eoe_text: json["EOE_TEXT"],
      eoe_image: json["EOE_IMAGE"]);

  Map<String, dynamic> toJson() => {
        "PM_ID": pm_id == null ? 0 : pm_id,
        "PM_NAME": pm_name,
        "BM_ID": bm_id == null ? 0 : bm_id,
        "BM_NAME": bm_name,
        "BM_OWN": bm_own,
        "Selected": selected == null ? 0 : selected,
        "AGENDA_ID": agenda_id == null ? 0 : agenda_id,
        "EOE_FOCUS": eoe_focus == null ? '' : eoe_focus,
        "EOE_FLAG": eoe_flag == null ? '' : eoe_flag,
        "EOE_SEQ": eoe_seq == null ? 0 : eoe_seq,
        "EOE_TEXT": eoe_text == null ? '' : eoe_text,
        "EOE_IMAGE": eoe_image == null ? '' : eoe_image,
      };
}
