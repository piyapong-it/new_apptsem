class OutletRequest {
  OutletRequest({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<NewOutletRequest> result;

  factory OutletRequest.fromJson(Map<String, dynamic> json) => OutletRequest(
        success: json["success"],
        message: json["message"],
        result: List<NewOutletRequest>.from(
            json["result"].map((x) => NewOutletRequest.fromJson(x))),
      );
}

class NewOutletRequest {
  NewOutletRequest({
    this.requestId,
    this.requestBy,
    this.requestStatus,
    this.cmOutlName,
    this.cmOutlCont,
    this.cmOutlAddr1,
    this.cmOutlAddr2,
    this.cmOutlAddr3,
    this.cmOutlAddr4,
    this.cmOutlAddr5,
    this.cmOutlAddr6,
    this.cmOutlZip,
    this.cmProvinceId,
    this.cmKeyoutl,
    this.cmOutlCate,
    this.cmGradeId,
    this.cmStrategy,
    this.outlTypeId,
    this.cmOutlTel,
    this.cmOutlMobile,
    this.cmOutlFax,
    this.cmBuyfrom1,
    this.cmBuyfrom2,
    this.cmLat,
    this.cmLong,
    this.cmAnniversary,
    this.cmOpenTime,
    this.cmCloseTime,
    this.processId,
    this.viewflow,
    this.attachfile,
    this.cmCreatedDate,
    this.cmCreatedBy,
    this.cmCreatedApp,
    this.cmUpdatedDate,
    this.cmUpdatedBy,
    this.cmUpdatedApp,
    this.requestPending,
    this.cmProvinceName,
    this.cmProvinceEn,
    this.udcDesc1,
  });

  String requestId;
  String requestStatus;
  String requestBy;
  String cmOutlName;
  String cmOutlCont;
  String cmOutlAddr1;
  dynamic cmOutlAddr2;
  dynamic cmOutlAddr3;
  dynamic cmOutlAddr4;
  String cmOutlAddr5;
  String cmOutlAddr6;
  String cmOutlZip;
  String cmProvinceId;
  String cmKeyoutl;
  dynamic cmOutlCate;
  dynamic cmGradeId;
  String cmStrategy;
  String outlTypeId;
  String cmOutlTel;
  dynamic cmOutlMobile;
  dynamic cmOutlFax;
  String cmBuyfrom1;
  dynamic cmBuyfrom2;
  String cmLat;
  String cmLong;
  dynamic cmAnniversary;
  dynamic cmOpenTime;
  dynamic cmCloseTime;
  dynamic processId;
  dynamic viewflow;
  dynamic attachfile;
  dynamic cmCreatedDate;
  dynamic cmCreatedBy;
  dynamic cmCreatedApp;
  dynamic cmUpdatedDate;
  dynamic cmUpdatedBy;
  dynamic cmUpdatedApp;
  dynamic requestPending;
  String cmProvinceName;
  String cmProvinceEn;
  String udcDesc1;

  factory NewOutletRequest.fromJson(Map<String, dynamic> json) =>
      NewOutletRequest(
        requestId: json["REQUEST_ID"],
        requestStatus: json["REQUEST_STATUS"],
        requestBy: json["REQUEST_BY"],
        cmOutlName: json["CM#OUTL_NAME"],
        cmOutlCont: json["CM#OUTL_CONT"],
        cmOutlAddr1: json["CM#OUTL_ADDR1"],
        cmOutlAddr2: json["CM#OUTL_ADDR2"],
        cmOutlAddr3: json["CM#OUTL_ADDR3"],
        cmOutlAddr4: json["CM#OUTL_ADDR4"],
        cmOutlAddr5: json["CM#OUTL_ADDR5"],
        cmOutlAddr6: json["CM#OUTL_ADDR6"],
        cmOutlZip: json["CM#OUTL_ZIP"],
        cmProvinceId: json["CM#PROVINCE_ID"],
        cmKeyoutl: json["CM#KEYOUTL"],
        cmOutlCate: json["CM#OUTL_CATE"],
        cmGradeId: json["CM#GRADE_ID"],
        cmStrategy: json["CM#STRATEGY"],
        outlTypeId: json["OUTL#TYPE_ID"],
        cmOutlTel: json["CM#OUTL_TEL"],
        cmOutlMobile: json["CM#OUTL_MOBILE"],
        cmOutlFax: json["CM#OUTL_FAX"],
        cmBuyfrom1: json["CM#BUYFROM1"],
        cmBuyfrom2: json["CM#BUYFROM2"],
        cmLat: json["CM#LAT"],
        cmLong: json["CM#LONG"],
        cmAnniversary: json["CM#ANNIVERSARY"],
        cmOpenTime: json["CM#OPEN_TIME"],
        cmCloseTime: json["CM#CLOSE_TIME"],
        processId: json["PROCESS_ID"],
        viewflow: json["VIEWFLOW"],
        attachfile: json["ATTACHFILE"],
        cmCreatedDate: json["CM#CREATED_DATE"],
        cmCreatedBy: json["CM#CREATED_BY"],
        cmCreatedApp: json["CM#CREATED_APP"],
        cmUpdatedDate: json["CM#UPDATED_DATE"],
        cmUpdatedBy: json["CM#UPDATED_BY"],
        cmUpdatedApp: json["CM#UPDATED_APP"],
        requestPending: json["REQUEST_PENDING"],
        cmProvinceName: json["CM#PROVINCE_NAME"],
        cmProvinceEn: json["CM#PROVINCE_EN"],
        udcDesc1: json["UDC_DESC1"],
      );
}
