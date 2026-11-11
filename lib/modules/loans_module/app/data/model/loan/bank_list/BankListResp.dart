import '../PersonalLoan/pl_chat/ComResp.dart';
import '../deal_chat/Paging.dart';
import 'GdbShopEmiRespList.dart';

class BankListResp {
  BankListResp({this.paging, this.comResp, this.gdbShopEmiRespList});

  BankListResp.fromJson(dynamic json) {
    paging = json['paging'] != null ? Paging.fromJson(json['paging']) : null;
    comResp =
        json['comResp'] != null ? ComResp.fromJson(json['comResp']) : null;
    if (json['gdbShopEmiRespList'] != null) {
      gdbShopEmiRespList = [];
      json['gdbShopEmiRespList'].forEach((v) {
        gdbShopEmiRespList?.add(GdbShopEmiRespList.fromJson(v));
      });
    }
  }
  Paging? paging;
  ComResp? comResp;
  List<GdbShopEmiRespList>? gdbShopEmiRespList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (paging != null) {
      map['paging'] = paging?.toJson();
    }
    if (comResp != null) {
      map['comResp'] = comResp?.toJson();
    }
    if (gdbShopEmiRespList != null) {
      map['gdbShopEmiRespList'] =
          gdbShopEmiRespList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
