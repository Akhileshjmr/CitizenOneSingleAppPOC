import 'AbCommJointCustDetails.dart';
import 'CommAccountRequest.dart';
import 'CommCustDoc.dart';
import 'CommCustImageSignList.dart';
import 'CommCustKYCEnrollment.dart';
import 'CommCustUdf.dart';
import 'CommKycUpload.dart';
import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommCustEnrollment {
  // Private variables
  HeaderInfo _headerInfo;
  ServerMessage _resMessage;
  String? _enrollmentRefId;
  String? _titleName;
  String? _firstName;
  String? _middleName;
  String? _lastName;
  String? _shortName;
  DateTime? _dob;
  String? _gender;
  String? _residenceType;
  String? _usresstatus;
  String? vstusprev;
  String? _nationlity;
  String? _address1;
  String? _address2;
  String? _city;
  String? _state;
  String? _country;
  String? _zipcode;
  String? _emailid;
  String? _phoneNo;
  String? _isKycOnly;
  String? _smsRequired;
  String? _customerID;
  String? _countryCode;
  String? _mobBankAcc;
  String? _interntBankAcc;
  DateTime? _initTime;
  String? _lBrn;
  String? _cCateg;
  String? _location;
  String? _media;
  String? _trackLimits;
  String? _pptNo;
  DateTime? _pptIssuedDate;
  DateTime? _pptExpDate;
  String? _language;
  String? _birthCountry;
  String? _sameAsCorrAddr;
  String? _pAddr1;
  String? _pAddr2;
  String? _pCity;
  String? _pState;
  String? _pPinCode;
  String? _custCommMode;
  String? _liabName;
  String? _liabBrn;
  String? _liabCcy;
  String? _isJointCustomer;
  String? _isAccIncluded;
  String? _cType;
  bool? _internetBanking;
  bool? _mobileBanking;
  String? _documentType;
  String? _docUniqueNum;
  String? _remarks;
  String? _visaDebitCard;
  String? _udfValue;
  String? _udfDesc;
  String? _relShip;
  String? _nAddr1;
  String? _nAddr2;
  String? _nAddr3;
  String? _nAddr4;
  String? _nAccNo;
  String? _nAccBranch;
  DateTime? _nDateofbirth;
  String? _nName;
  String? _nGaurdainName;
  String? _rmCode;
  String? _guardian;
  String? _minor;
  String? _mobilenprovider;
  String? _residentstatus;
  String? _maritalstatus;
  String? _currentdesignation;
  String? _currentemployer;
  String? _salary;
  String? _salaryfrequency;
  String? _employeetype;
  String? _tenure;
  String? _identificationstatus;
  String? _eligibilitypoints;
  String? _kyc_refno;
  String? _occupationcodes;
  String? _birthplace;
  String? _nationalid;
  String? _addressName;
  String? _chkbookName;
  String? _cust_mode;
  String? _title;
  String? _mothermaidn_name;
  CommAccountRequest? _accRequest;
  List<CommKycUpload>? _kycDoc;
  CommCustImageSignList? _commCustImageSignList;
  CommCustKYCEnrollment? _commCustKYCEnrollment;
  List<AbCommJointCustDetails>? _jointCustomer;
  List<CommCustDoc>? _custDoc;
  List<CommCustUdf>? _custUdf;
  // Constructor
  CommCustEnrollment({
    HeaderInfo? headerInfo,
    ServerMessage? resMessage,
    String? enrollmentRefId,
    String? titleName,
    String? firstName,
    String? middleName,
    String? lastName,
    String? shortName,
    DateTime? dob,
    String? gender,
    String? residenceType,
    String? usresstatus,
    String? vstusprev,
    String? nationlity,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? country,
    String? zipcode,
    String? emailid,
    String? phoneNo,
    String? isKycOnly,
    String? smsRequired,
    String? customerID,
    String? countryCode,
    String? mobBankAcc,
    String? interntBankAcc,
    DateTime? initTime,
    String? lBrn,
    String? cCateg,
    String? location,
    String? media,
    String? trackLimits,
    String? pptNo,
    DateTime? pptIssuedDate,
    DateTime? pptExpDate,
    String? language,
    String? birthCountry,
    String? sameAsCorrAddr,
    String? pAddr1,
    String? pAddr2,
    String? pCity,
    String? pState,
    String? pPinCode,
    String? custCommMode,
    String? liabName,
    String? liabBrn,
    String? liabCcy,
    String? isJointCustomer,
    String? isAccIncluded,
    String? cType,
    bool? internetBanking,
    bool? mobileBanking,
    String? documentType,
    String? docUniqueNum,
    String? remarks,
    String? visaDebitCard,
    String? udfValue,
    String? udfDesc,
    String? relShip,
    String? nAddr1,
    String? nAddr2,
    String? nAddr3,
    String? nAddr4,
    String? nAccNo,
    String? nAccBranch,
    DateTime? nDateofbirth,
    String? nName,
    String? nGaurdainName,
    String? rmCode,
    String? guardian,
    String? minor,
    String? mobilenprovider,
    String? residentstatus,
    String? maritalstatus,
    String? currentdesignation,
    String? currentemployer,
    String? salary,
    String? salaryfrequency,
    String? employeetype,
    String? tenure,
    String? identificationstatus,
    String? eligibilitypoints,
    String? kyc_refno,
    String? occupationcodes,
    String? birthplace,
    String? nationalid,
    String? addressName,
    String? chkbookName,
    String? cust_mode,
    String? title,
    String? mothermaidn_name,
    CommAccountRequest? accRequest,
    List<CommKycUpload>? kycDoc,
    CommCustImageSignList? commCustImageSignList,
    CommCustKYCEnrollment? commCustKYCEnrollment,
    List<AbCommJointCustDetails>? jointCustomer,
    List<CommCustDoc>? custDoc,
    List<CommCustUdf>? custUdf,
  })  : _headerInfo = headerInfo ?? HeaderInfo(),
        _resMessage = resMessage ?? ServerMessage(),
        _enrollmentRefId = enrollmentRefId,
        _titleName = titleName,
        _firstName = firstName,
        _middleName = middleName,
        _lastName = lastName,
        _shortName = shortName,
        _dob = dob,
        _gender = gender,
        _residenceType = residenceType,
        _usresstatus = usresstatus,
        vstusprev = vstusprev,
        _nationlity = nationlity,
        _address1 = address1,
        _address2 = address2,
        _city = city,
        _state = state,
        _country = country,
        _zipcode = zipcode,
        _emailid = emailid,
        _phoneNo = phoneNo,
        _isKycOnly = isKycOnly,
        _smsRequired = smsRequired,
        _customerID = customerID,
        _countryCode = countryCode,
        _mobBankAcc = mobBankAcc,
        _interntBankAcc = interntBankAcc,
        _initTime = initTime,
        _lBrn = lBrn,
        _cCateg = cCateg,
        _location = location,
        _media = media,
        _trackLimits = trackLimits,
        _pptNo = pptNo,
        _pptIssuedDate = pptIssuedDate,
        _pptExpDate = pptExpDate,
        _language = language,
        _birthCountry = birthCountry,
        _sameAsCorrAddr = sameAsCorrAddr,
        _pAddr1 = pAddr1,
        _pAddr2 = pAddr2,
        _pCity = pCity,
        _pState = pState,
        _pPinCode = pPinCode,
        _custCommMode = custCommMode,
        _liabName = liabName,
        _liabBrn = liabBrn,
        _liabCcy = liabCcy,
        _isJointCustomer = isJointCustomer,
        _isAccIncluded = isAccIncluded,
        _cType = cType,
        _internetBanking = internetBanking,
        _mobileBanking = mobileBanking,
        _documentType = documentType,
        _docUniqueNum = docUniqueNum,
        _remarks = remarks,
        _visaDebitCard = visaDebitCard,
        _udfValue = udfValue,
        _udfDesc = udfDesc,
        _relShip = relShip,
        _nAddr1 = nAddr1,
        _nAddr2 = nAddr2,
        _nAddr3 = nAddr3,
        _nAddr4 = nAddr4,
        _nAccNo = nAccNo,
        _nAccBranch = nAccBranch,
        _nDateofbirth = nDateofbirth,
        _nName = nName,
        _nGaurdainName = nGaurdainName,
        _rmCode = rmCode,
        _guardian = guardian,
        _minor = minor,
        _mobilenprovider = mobilenprovider,
        _residentstatus = residentstatus,
        _maritalstatus = maritalstatus,
        _currentdesignation = currentdesignation,
        _currentemployer = currentemployer,
        _salary = salary,
        _salaryfrequency = salaryfrequency,
        _employeetype = employeetype,
        _tenure = tenure,
        _identificationstatus = identificationstatus,
        _eligibilitypoints = eligibilitypoints,
        _kyc_refno = kyc_refno,
        _occupationcodes = occupationcodes,
        _birthplace = birthplace,
        _nationalid = nationalid,
        _addressName = addressName,
        _chkbookName = chkbookName,
        _cust_mode = cust_mode,
        _title = title,
        _mothermaidn_name = mothermaidn_name,
        _accRequest = accRequest ?? CommAccountRequest(),
        _kycDoc = kycDoc,
        _commCustImageSignList = commCustImageSignList,
        _commCustKYCEnrollment = commCustKYCEnrollment,
        _jointCustomer = jointCustomer,
        _custDoc = custDoc,
        _custUdf = custUdf;
  // Getters and Setters for each field
  HeaderInfo get headerInfo => _headerInfo;
  set headerInfo(HeaderInfo value) => _headerInfo = value;

  ServerMessage get resMessage => _resMessage;
  set resMessage(ServerMessage value) => _resMessage = value;

  String? get enrollmentRefId => _enrollmentRefId;
  set enrollmentRefId(String? value) => _enrollmentRefId = value;

  String? get titleName => _titleName;
  set titleName(String? value) => _titleName = value;

  String? get firstName => _firstName;
  set firstName(String? value) => _firstName = value;

  String? get middleName => _middleName;
  set middleName(String? value) => _middleName = value;

  String? get lastName => _lastName;
  set lastName(String? value) => _lastName = value;

  String? get shortName => _shortName;
  set shortName(String? value) => _shortName = value;

  DateTime? get dob => _dob;
  set dob(DateTime? value) => _dob = value;

  String? get gender => _gender;
  set gender(String? value) => _gender = value;

  String? get residenceType => _residenceType;
  set residenceType(String? value) => _residenceType = value;
  // Getters and Setters for each new field
  String? get usresstatus => _usresstatus;
  set usresstatus(String? value) => _usresstatus = value;

  String? get nationlity => _nationlity;
  set nationlity(String? value) => _nationlity = value;

  String? get address1 => _address1;
  set address1(String? value) => _address1 = value;

  String? get address2 => _address2;
  set address2(String? value) => _address2 = value;

  String? get city => _city;
  set city(String? value) => _city = value;

  String? get state => _state;
  set state(String? value) => _state = value;

  String? get country => _country;
  set country(String? value) => _country = value;

  String? get zipcode => _zipcode;
  set zipcode(String? value) => _zipcode = value;

  String? get emailid => _emailid;
  set emailid(String? value) => _emailid = value;

  String? get phoneNo => _phoneNo;
  set phoneNo(String? value) => _phoneNo = value;

  String? get isKycOnly => _isKycOnly;
  set isKycOnly(String? value) => _isKycOnly = value;

  String? get smsRequired => _smsRequired;
  set smsRequired(String? value) => _smsRequired = value;

  String? get customerID => _customerID;
  set customerID(String? value) => _customerID = value;

  String? get countryCode => _countryCode;
  set countryCode(String? value) => _countryCode = value;

  String? get mobBankAcc => _mobBankAcc;
  set mobBankAcc(String? value) => _mobBankAcc = value;

  String? get interntBankAcc => _interntBankAcc;
  set interntBankAcc(String? value) => _interntBankAcc = value;

  DateTime? get initTime => _initTime;
  set initTime(DateTime? value) => _initTime = value;
  // Getters and Setters for each new field
  String? get lBrn => _lBrn;
  set lBrn(String? value) => _lBrn = value;

  String? get cCateg => _cCateg;
  set cCateg(String? value) => _cCateg = value;

  String? get location => _location;
  set location(String? value) => _location = value;

  String? get media => _media;
  set media(String? value) => _media = value;

  String? get trackLimits => _trackLimits;
  set trackLimits(String? value) => _trackLimits = value;

  String? get pptNo => _pptNo;
  set pptNo(String? value) => _pptNo = value;

  DateTime? get pptIssuedDate => _pptIssuedDate;
  set pptIssuedDate(DateTime? value) => _pptIssuedDate = value;

  DateTime? get pptExpDate => _pptExpDate;
  set pptExpDate(DateTime? value) => _pptExpDate = value;

  String? get language => _language;
  set language(String? value) => _language = value;

  String? get birthCountry => _birthCountry;
  set birthCountry(String? value) => _birthCountry = value;

  String? get sameAsCorrAddr => _sameAsCorrAddr;
  set sameAsCorrAddr(String? value) => _sameAsCorrAddr = value;

  String? get pAddr1 => _pAddr1;
  set pAddr1(String? value) => _pAddr1 = value;

  String? get pAddr2 => _pAddr2;
  set pAddr2(String? value) => _pAddr2 = value;

  String? get pCity => _pCity;
  set pCity(String? value) => _pCity = value;

  String? get pState => _pState;
  set pState(String? value) => _pState = value;

  String? get pPinCode => _pPinCode;
  set pPinCode(String? value) => _pPinCode = value;

  String? get custCommMode => _custCommMode;
  set custCommMode(String? value) => _custCommMode = value;

  String? get liabName => _liabName;
  set liabName(String? value) => _liabName = value;

  String? get liabBrn => _liabBrn;
  set liabBrn(String? value) => _liabBrn = value;

  String? get liabCcy => _liabCcy;
  set liabCcy(String? value) => _liabCcy = value;

  String? get isJointCustomer => _isJointCustomer;
  set isJointCustomer(String? value) => _isJointCustomer = value;

  String? get isAccIncluded => _isAccIncluded;
  set isAccIncluded(String? value) => _isAccIncluded = value;

  String? get cType => _cType;
  set cType(String? value) => _cType = value;

  bool? get internetBanking => _internetBanking;
  set internetBanking(bool? value) => _internetBanking = value;

  bool? get mobileBanking => _mobileBanking;
  set mobileBanking(bool? value) => _mobileBanking = value;

  String? get documentType => _documentType;
  set documentType(String? value) => _documentType = value;

  String? get docUniqueNum => _docUniqueNum;
  set docUniqueNum(String? value) => _docUniqueNum = value;

  String? get remarks => _remarks;
  set remarks(String? value) => _remarks = value;

  String? get visaDebitCard => _visaDebitCard;
  set visaDebitCard(String? value) => _visaDebitCard = value;

  String? get udfValue => _udfValue;
  set udfValue(String? value) => _udfValue = value;

  String? get udfDesc => _udfDesc;
  set udfDesc(String? value) => _udfDesc = value;

  String? get relShip => _relShip;
  set relShip(String? value) => _relShip = value;

  String? get nAddr1 => _nAddr1;
  set nAddr1(String? value) => _nAddr1 = value;

  String? get nAddr2 => _nAddr2;
  set nAddr2(String? value) => _nAddr2 = value;

  String? get nAddr3 => _nAddr3;
  set nAddr3(String? value) => _nAddr3 = value;

  String? get nAddr4 => _nAddr4;
  set nAddr4(String? value) => _nAddr4 = value;

  String? get nAccNo => _nAccNo;
  set nAccNo(String? value) => _nAccNo = value;

  String? get nAccBranch => _nAccBranch;
  set nAccBranch(String? value) => _nAccBranch = value;

  DateTime? get nDateofbirth => _nDateofbirth;
  set nDateofbirth(DateTime? value) => _nDateofbirth = value;

  String? get nName => _nName;
  set nName(String? value) => _nName = value;

  String? get nGaurdainName => _nGaurdainName;
  set nGaurdainName(String? value) => _nGaurdainName = value;

  String? get rmCode => _rmCode;
  set rmCode(String? value) => _rmCode = value;

  String? get guardian => _guardian;
  set guardian(String? value) => _guardian = value;

  String? get minor => _minor;
  set minor(String? value) => _minor = value;

  String? get mobilenprovider => _mobilenprovider;
  set mobilenprovider(String? value) => _mobilenprovider = value;

  String? get residentstatus => _residentstatus;
  set residentstatus(String? value) => _residentstatus = value;

  String? get maritalstatus => _maritalstatus;
  set maritalstatus(String? value) => _maritalstatus = value;

  String? get currentdesignation => _currentdesignation;
  set currentdesignation(String? value) => _currentdesignation = value;

  String? get currentemployer => _currentemployer;
  set currentemployer(String? value) => _currentemployer = value;

  String? get salary => _salary;
  set salary(String? value) => _salary = value;

  String? get salaryfrequency => _salaryfrequency;
  set salaryfrequency(String? value) => _salaryfrequency = value;

  String? get employeetype => _employeetype;
  set employeetype(String? value) => _employeetype = value;

  String? get tenure => _tenure;
  set tenure(String? value) => _tenure = value;

  String? get identificationstatus => _identificationstatus;
  set identificationstatus(String? value) => _identificationstatus = value;

  String? get eligibilitypoints => _eligibilitypoints;
  set eligibilitypoints(String? value) => _eligibilitypoints = value;

  String? get kyc_refno => _kyc_refno;
  set kyc_refno(String? value) => _kyc_refno = value;
  // Getters and setters
  String? get occupationcodes => _occupationcodes;
  set occupationcodes(String? value) => _occupationcodes = value;

  String? get birthplace => _birthplace;
  set birthplace(String? value) => _birthplace = value;

  String? get nationalid => _nationalid;
  set nationalid(String? value) => _nationalid = value;

  String? get addressName => _addressName;
  set addressName(String? value) => _addressName = value;

  String? get chkbookName => _chkbookName;
  set chkbookName(String? value) => _chkbookName = value;

  String? get cust_mode => _cust_mode;
  set cust_mode(String? value) => _cust_mode = value;

  String? get title => _title;
  set title(String? value) => _title = value;

  String? get mothermaidn_name => _mothermaidn_name;
  set mothermaidn_name(String? value) => _mothermaidn_name = value;
  CommAccountRequest? get accRequest => _accRequest;
  set accRequest(CommAccountRequest? value) => _accRequest = value;

  List<CommKycUpload>? get kycDoc => _kycDoc;
  set kycDoc(List<CommKycUpload>? value) => _kycDoc = value;

  CommCustImageSignList? get commCustImageSignList => _commCustImageSignList;
  set commCustImageSignList(CommCustImageSignList? value) =>
      _commCustImageSignList = value;

  CommCustKYCEnrollment? get commCustKYCEnrollment => _commCustKYCEnrollment;
  set commCustKYCEnrollment(CommCustKYCEnrollment? value) =>
      _commCustKYCEnrollment = value;

  List<AbCommJointCustDetails>? get jointCustomer => _jointCustomer;
  set jointCustomer(List<AbCommJointCustDetails>? value) =>
      _jointCustomer = value;

  List<CommCustDoc>? get custDoc => _custDoc;
  set custDoc(List<CommCustDoc>? value) => _custDoc = value;

  List<CommCustUdf>? get custUdf => _custUdf;
  set custUdf(List<CommCustUdf>? value) => _custUdf = value;

  factory CommCustEnrollment.fromJson(Map<String, dynamic> json) {
    return CommCustEnrollment(
      headerInfo: json['headerInfo'] != null
          ? HeaderInfo.fromJson(json['headerInfo'])
          : null,
      resMessage: json['resMessage'] != null
          ? ServerMessage.fromJson(json['resMessage'])
          : null,
      enrollmentRefId: json['enrollmentRefId'],
      titleName: json['titleName'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      shortName: json['shortName'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: json['gender'],
      residenceType: json['residenceType'],
      usresstatus: json['usresstatus'],
      vstusprev: json['vstusprev'],
      nationlity: json['nationlity'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zipcode: json['zipcode'],
      emailid: json['emailid'],
      phoneNo: json['phoneNo'],
      isKycOnly: json['isKycOnly'],
      smsRequired: json['smsRequired'],
      customerID: json['customerID'],
      countryCode: json['countryCode'],
      mobBankAcc: json['mobBankAcc'],
      interntBankAcc: json['interntBankAcc'],
      initTime:
          json['initTime'] != null ? DateTime.parse(json['initTime']) : null,
      lBrn: json['lBrn'],
      cCateg: json['cCateg'],
      location: json['location'],
      media: json['media'],
      trackLimits: json['trackLimits'],
      pptNo: json['pptNo'],
      pptIssuedDate: json['pptIssuedDate'] != null
          ? DateTime.parse(json['pptIssuedDate'])
          : null,
      pptExpDate: json['pptExpDate'] != null
          ? DateTime.parse(json['pptExpDate'])
          : null,
      language: json['language'],
      birthCountry: json['birthCountry'],
      sameAsCorrAddr: json['sameAsCorrAddr'],
      pAddr1: json['pAddr1'],
      pAddr2: json['pAddr2'],
      pCity: json['pCity'],
      pState: json['pState'],
      pPinCode: json['pPinCode'],
      custCommMode: json['custCommMode'],
      liabName: json['liabName'],
      liabBrn: json['liabBrn'],
      liabCcy: json['liabCcy'],
      isJointCustomer: json['isJointCustomer'],
      isAccIncluded: json['isAccIncluded'],
      cType: json['cType'],
      internetBanking: json['internetBanking'],
      mobileBanking: json['mobileBanking'],
      documentType: json['documentType'],
      docUniqueNum: json['docUniqueNum'],
      remarks: json['remarks'],
      visaDebitCard: json['visaDebitCard'],
      udfValue: json['udfValue'],
      udfDesc: json['udfDesc'],
      relShip: json['relShip'],
      nAddr1: json['nAddr1'],
      nAddr2: json['nAddr2'],
      nAddr3: json['nAddr3'],
      nAddr4: json['nAddr4'],
      nAccNo: json['nAccNo'],
      nAccBranch: json['nAccBranch'],
      nDateofbirth: json['nDateofbirth'] != null
          ? DateTime.parse(json['nDateofbirth'])
          : null,
      nName: json['nName'],
      nGaurdainName: json['nGaurdainName'],
      rmCode: json['rmCode'],
      guardian: json['guardian'],
      minor: json['minor'],
      mobilenprovider: json['mobilenprovider'],
      residentstatus: json['residentstatus'],
      maritalstatus: json['maritalstatus'],
      currentdesignation: json['currentdesignation'],
      currentemployer: json['currentemployer'],
      salary: json['salary'],
      salaryfrequency: json['salaryfrequency'],
      employeetype: json['employeetype'],
      tenure: json['tenure'],
      identificationstatus: json['identificationstatus'],
      eligibilitypoints: json['eligibilitypoints'],
      kyc_refno: json['kyc_refno'],
      occupationcodes: json['occupationcodes'],
      birthplace: json['birthplace'],
      nationalid: json['nationalid'],
      addressName: json['addressName'],
      chkbookName: json['chkbookName'],
      cust_mode: json['cust_mode'],
      title: json['title'],
      mothermaidn_name: json['mothermaidn_name'],
      accRequest: json['accRequest'] != null
          ? CommAccountRequest.fromJson(json['accRequest'])
          : CommAccountRequest(),
      kycDoc: (json['kycDoc'] as List?)
          ?.map((e) => CommKycUpload.fromJson(e))
          .toList(),
      jointCustomer: (json['jointCustomer'] as List?)
          ?.map((e) => AbCommJointCustDetails.fromJson(e))
          .toList(),
      custDoc: (json['custDoc'] as List?)
          ?.map((e) => CommCustDoc.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headerInfo': _headerInfo.toJson(),
      'resMessage': _resMessage.toJson(),
      'enrollmentRefId': _enrollmentRefId,
      'titleName': _titleName,
      'firstName': _firstName,
      'middleName': _middleName,
      'lastName': _lastName,
      'shortName': _shortName,
      'dob': _dob?.toIso8601String(),
      'gender': _gender,
      'residenceType': _residenceType,
      'usresstatus': _usresstatus,
      'vstusprev': vstusprev,
      'nationlity': _nationlity,
      'address1': _address1,
      'address2': _address2,
      'city': _city,
      'state': _state,
      'country': _country,
      'zipcode': _zipcode,
      'emailid': _emailid,
      'phoneNo': _phoneNo,
      'isKycOnly': _isKycOnly,
      'smsRequired': _smsRequired,
      'customerID': _customerID,
      'countryCode': _countryCode,
      'mobBankAcc': _mobBankAcc,
      'interntBankAcc': _interntBankAcc,
      'initTime': _initTime?.toIso8601String(),
      'lBrn': _lBrn,
      'cCateg': _cCateg,
      'location': _location,
      'media': _media,
      'trackLimits': _trackLimits,
      'pptNo': _pptNo,
      'pptIssuedDate': _pptIssuedDate?.toIso8601String(),
      'pptExpDate': _pptExpDate?.toIso8601String(),
      'language': _language,
      'birthCountry': _birthCountry,
      'sameAsCorrAddr': _sameAsCorrAddr,
      'pAddr1': _pAddr1,
      'pAddr2': _pAddr2,
      'pCity': _pCity,
      'pState': _pState,
      'pPinCode': _pPinCode,
      'custCommMode': _custCommMode,
      'liabName': _liabName,
      'liabBrn': _liabBrn,
      'liabCcy': _liabCcy,
      'isJointCustomer': _isJointCustomer,
      'isAccIncluded': _isAccIncluded,
      'cType': _cType,
      'internetBanking': _internetBanking,
      'mobileBanking': _mobileBanking,
      'documentType': _documentType,
      'docUniqueNum': _docUniqueNum,
      'remarks': _remarks,
      'visaDebitCard': _visaDebitCard,
      'udfValue': _udfValue,
      'udfDesc': _udfDesc,
      'relShip': _relShip,
      'nAddr1': _nAddr1,
      'nAddr2': _nAddr2,
      'nAddr3': _nAddr3,
      'nAddr4': _nAddr4,
      'nAccNo': _nAccNo,
      'nAccBranch': _nAccBranch,
      'nDateofbirth': _nDateofbirth?.toIso8601String(),
      'nName': _nName,
      'nGaurdainName': _nGaurdainName,
      'rmCode': _rmCode,
      'guardian': _guardian,
      'minor': _minor,
      'mobilenprovider': _mobilenprovider,
      'residentstatus': _residentstatus,
      'maritalstatus': _maritalstatus,
      'currentdesignation': _currentdesignation,
      'currentemployer': _currentemployer,
      'salary': _salary,
      'salaryfrequency': _salaryfrequency,
      'employeetype': _employeetype,
      'tenure': _tenure,
      'identificationstatus': _identificationstatus,
      'eligibilitypoints': _eligibilitypoints,
      'kyc_refno': _kyc_refno,
      'occupationcodes': _occupationcodes,
      'birthplace': _birthplace,
      'nationalid': _nationalid,
      'addressName': _addressName,
      'chkbookName': _chkbookName,
      'cust_mode': _cust_mode,
      'title': _title,
      'mothermaidn_name': _mothermaidn_name,
      'kycDoc': _kycDoc?.map((e) => e.toJson()).toList(),
      'jointCustomer': _jointCustomer?.map((e) => e.toJson()).toList(),
      'custDoc': _custDoc?.map((e) => e.toJson()).toList(),
      'accRequest': accRequest?.toJson(),
    };
  }
}
