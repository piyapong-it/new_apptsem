import 'dart:ffi';

import 'package:tsem/models/OutlVisitPlans.dart';
import 'package:tsem/models/VisitPlans.dart';
import 'package:tsem/models/brandactive.dart';
import 'package:tsem/models/dmlmessage.dart';
import 'package:tsem/models/visit.dart';
import 'package:tsem/models/visitagenda.dart';
import 'package:tsem/models/visitcallcard.dart';
import 'package:tsem/models/visitcount.dart';
import 'package:tsem/models/visiteoe.dart';
import 'package:tsem/models/visitmjp.dart';
import 'package:tsem/models/itemvisiteoe.dart';
import 'package:tsem/services/visit_api.dart';

class VisitProvider {
  VisitApi api = VisitApi();

  Future<DmLmessage> insertVisit({
    String outletId,
    DateTime visitDate,
    String lat,
    String lng,
  }) async {
    return api.insertVisit(
        outletid: outletId, visitdate: visitDate, lat: lat, lng: lng);
  }

  Future<VisitAgenda> getVisitAgenda(
      {String outletid, DateTime visitdate}) async {
    return api.fetchVisitAgenda(outletid: outletid, visitdate: visitdate);
  }

  Future<VisitEoE> getVisitEOE(
      {String outletid, DateTime visitdate, String group}) async {
    return api.fetchVisitEOE(
        outletid: outletid, visitdate: visitdate, group: group);
  }

  Future<DmLmessage> updateVisit({
    String visitId,
    String visitStatus,
    String OultetID,
    String Date
  }) async {
    return api.updateVisit(visitId, visitStatus, OultetID, Date);
  }

  Future<DmLmessage> updateVisitAgenda({
    String visitId,
    int agendaId,
    String visitStatus,
  }) async {
    return api.updateVisitAgenda(
        visitId: visitId, agendaId: agendaId, visitStatus: visitStatus);
  }

  Future<DmLmessage> updateVisitEoE({
    String visitId,
    int agendaId,
    int eoeSeq,
    String eoeFlag,
  }) async {
    return api.updateVisitEoE(
        visitId: visitId, agendaId: agendaId, eoeSeq: eoeSeq, eoeFlag: eoeFlag);
  }

  Future<VisitMjp> getMjp() async {
    return api.fetchMjp();
  }

  Future<VisitPlans> getVisitPlans(String visitDate, String JdeCode) async {
    return api.fetchVisitPlans(visitDate, JdeCode);
  }

  Future<OutlVisitPlans> getOutlVisitPlans(String visitDate) async {
    return api.fetchOutlVisitPlans(visitDate);
  }

  Future<DmLmessage> updateOutlVisitPlan(Object data) async {
    return api.fetchUpdateOutlVisitPlan(data);
  }

  Future<VisitCount> getVisitCount() async {
    return api.fetchVisitCount();
  }

  Future<Visit> getVisitHistory(String outletId) async {
    return api.fetchVisitHistory(outletId);
  }

  Future<VisitCallCard> getVisitCallCard({String visitid}) async {
    return api.fetchCallCard(visitid: visitid);
  }

  Future<DmLmessage> updateVisitCallCard(
      {String visitId,
      int agendaId,
      String pmid,
      double premas,
      double mas,
      double price,
      double stock,
      String productdate,
      String outletid,
      String visitdate,
      String remark,
      int seq}) async {
    return api.updateVisitCallCard(
        visitId: visitId,
        agendaId: agendaId,
        pmid: pmid,
        premas: premas,
        mas: mas,
        price: price,
        stock: stock,
        productdate: productdate,
        outletid: outletid,
        visitdate: visitdate,
        remark: remark,
        seq: seq);
  }

  Future<DmLmessage> deleteVisitCallCard(
      {String visitId, int agendaId, String pmid, int seq}) async {
    return api.deleteVisitCallCard(
        visitId: visitId, agendaId: agendaId, pmid: pmid, eoeSeq: seq);
  }

  Future<ItemVisitEoE> getItemVisitEoE(Object data) async {
    return api.fetchItemVisitEoE(data);
  }
 Future<BrandActive> getItemBrandActive() async {
    return api.fetchItemBrandActive();
  }
  

  Future<DmLmessage> updateVisitEOEFlag(Object data) async {
    return api.fetchUpdateVisitEOEFlag(data);
  }
}
