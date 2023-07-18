import 'dart:ffi';

import 'package:tsem/models/dmlmessage.dart';
import 'package:tsem/models/extendbyasm.dart';
import 'package:tsem/services/approve_api.dart';

class ApproveProvider {
  ApproveApi api = ApproveApi();

  Future<DmLmessage> UpdateStatusAndSendMail(
    String outletId,
    String EmpJDE,
    String Status,
  ) async {
    return api.UpdateStatusAndSendMail(
        VisitDate: outletId, EmpJDE: EmpJDE, Status: Status);
  }

  Future<ExtendByAsm> getExtendByAsm(String AsmCode) async {
    return api.fetchExtendByAsm(AsmCode: AsmCode);
  }
}
