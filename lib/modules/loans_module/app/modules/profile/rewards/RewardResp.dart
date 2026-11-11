import 'package:citizenone_app/modules/loans_module/app/modules/profile/rewards/RewardBalance.dart';


class RewardResp {
  RewardResp({
      this.commonRsp, 
      this.rewardBalance,});

  RewardResp.fromJson(dynamic json) {
    commonRsp = json['commonRsp'];
    rewardBalance = json['rewardBalance'] != null ? RewardBalance.fromJson(json['rewardBalance']) : null;
  }
  dynamic commonRsp;
  RewardBalance? rewardBalance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['commonRsp'] = commonRsp;
    if (rewardBalance != null) {
      map['rewardBalance'] = rewardBalance?.toJson();
    }
    return map;
  }

}