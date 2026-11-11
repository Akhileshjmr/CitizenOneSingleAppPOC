import 'package:citizenone_app/modules/loans_module/app/data/model/loan/track/paging_req.dart';

import '../../../../modules/profile/ProfileStatusResp.dart';
import '../../otp/url_decision.dart';
import 'ApplicationSubmitted.dart';
import 'TrackOrderMediaOptions.dart';

class TrackOrderResp {
  String? reqSecureKey;
  List<String>? addiParams;
  late ChMessage? chMessage;
  UrlDecision? urlDecision;
  String? smsVendorResp;
  PagingReq? paging;
  List<TrackOrderMediaOptions>? options;
  List<ApplicationSubmitted>? applicationSubmitted;

  TrackOrderResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.smsVendorResp,
    this.paging,
    this.options,
  });

  @override
  String toString() {
    return 'TrackOrderResp{reqSecureKey: $reqSecureKey, addiParams: $addiParams, chMessage: $chMessage, urlDecision: $urlDecision, smsVendorResp: $smsVendorResp, paging: $paging, options: $options, applicationSubmitted: $applicationSubmitted}';
  }

  TrackOrderResp.fromJson(Map<String, dynamic> json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams =
        json["addiParams"] == null
            ? []
            : List<String>.from(json["addiParams"].map((x) => x));
    chMessage = ChMessage.fromJson(json['chMessage']);
    urlDecision =
        json['urlDecision'] != null
            ? UrlDecision.fromJson(json['urlDecision'])
            : null;
    smsVendorResp = json['smsVendorResp'];
    options =
        json['options'] == null
            ? []
            : List<TrackOrderMediaOptions>.from(
              json["options"].map((x) => TrackOrderMediaOptions.fromJson(x)),
            );

    applicationSubmitted =
        json['applicationSubmitted'] == null
            ? []
            : List<ApplicationSubmitted>.from(
              json["applicationSubmitted"].map(
                (x) => ApplicationSubmitted.fromJson(x),
              ),
            );

    paging = json['paging'] != null ? PagingReq.fromJson(json['paging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reqSecureKey'] = reqSecureKey;
    data['addiParams'] = addiParams;
    data['chMessage'] = chMessage?.toJson();
    if (urlDecision != null) {
      data['urlDecision'] = urlDecision!.toJson();
    }
    data['smsVendorResp'] = smsVendorResp;
    if (paging != null) {
      data['paging'] = paging!.toJson();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (applicationSubmitted != null) {
      data['applicationSubmitted'] =
          applicationSubmitted!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
