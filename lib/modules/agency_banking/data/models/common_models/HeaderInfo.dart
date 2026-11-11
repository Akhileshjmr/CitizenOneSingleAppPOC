class HeaderInfo {
  String applicationId;
  String applicationKey;
  String orgCode;
  String currency;
  String branchCode;
  String userName;
  String userCode;
  String userType;
  String userRole;
  String userSessionId;
  String? deviceID;
  String? language;
  String? message;
  String? messageDesc;
  String? cb_account_no;
  String? cbBranch;
  String? wallet_account_no;
  String? walletBranch;
  String? authorizationToken;
  String? logout;
  bool initialAccess;

  HeaderInfo({
    this.applicationId = '',
    this.applicationKey = '',
    this.orgCode = '',
    this.currency = '',
    this.branchCode = '',
    this.userName = '',
    this.userCode = '',
    this.userType = '',
    this.userRole = '',
    this.userSessionId = '',
    this.deviceID,
    this.language,
    this.message,
    this.messageDesc,
    this.cb_account_no,
    this.cbBranch,
    this.wallet_account_no,
    this.walletBranch,
    this.authorizationToken,
    this.initialAccess = false,
    this.logout = 'N',
  });

  factory HeaderInfo.fromJson(Map<String, dynamic> json) {
    return HeaderInfo(
      applicationId: json['applicationId'] ?? '',
      applicationKey: json['applicationKey'] ?? '',
      orgCode: json['orgCode'] ?? '',
      currency: json['currency'] ?? '',
      branchCode: json['branchCode'] ?? '',
      userName: json['userName'] ?? '',
      userCode: json['userCode'] ?? '',
      userType: json['userType'] ?? '',
      userRole: json['userRole'] ?? '',
      userSessionId: json['userSessionId'] ?? '',
      deviceID: json['deviceID'],
      language: json['language'],
      message: json['message'],
      messageDesc: json['messageDesc'],
      cb_account_no: json['cb_account_no'],
      cbBranch: json['cb_branch'],
      wallet_account_no: json['wallet_account_no'],
      walletBranch: json['wallet_branch'],
      authorizationToken: json['authorizationToken'],
      initialAccess: json['initial_access'] ?? false,
      logout: json['logout'],
    );
  }

  Map<String, dynamic> toJson() => {
        'applicationId': applicationId,
        'applicationKey': applicationKey,
        'orgCode': orgCode,
        'currency': currency,
        'branchCode': branchCode,
        'userName': userName,
        'userCode': userCode,
        'userType': userType,
        'userRole': userRole,
        'userSessionId': userSessionId,
        'deviceID': deviceID,
        'language': language,
        'message': message,
        'messageDesc': messageDesc,
        'cb_account_no': cb_account_no,
        'cb_branch': cbBranch,
        'wallet_account_no': wallet_account_no,
        'wallet_branch': walletBranch,
        'authorizationToken': authorizationToken,
        'initial_access': initialAccess,
        'logout': logout,
      };
}
