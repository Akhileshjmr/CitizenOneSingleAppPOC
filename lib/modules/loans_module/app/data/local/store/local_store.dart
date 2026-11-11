import 'package:get_storage/get_storage.dart';

part 'store_helper.dart';

/// Local storage keys with built in helpers
class LocalStore {
  /// User Id of the current user
  static final _StoreObject<String> userData =
      _StoreObject<String>(key: 'user_data');


  static final _StoreObject<String> userPhone =
  _StoreObject<String>(key: 'user_phone');

  /// Logged in user's auth token
  static final _StoreObject<String> authToken =
      _StoreObject<String>(key: 'auth_token');

  /// User's selected locale
  static final _StoreObject<String> currentLocale = _StoreObject<String>(
    key: 'current_locale',
    initialValue: 'en_US',
  );

  /// Current selected theme
  static final _StoreObject<int> theme = _StoreObject<int>(key: 'theme_mode');

  /// personalLoan loan_amount
  static final _StoreObject<int> loanAmount = _StoreObject<int>(key: 'loanAmount');

  /// personalLoan loan_ref_id
  static final _StoreObject<String> loanRefId = _StoreObject<String>(key: 'loanRefId');

  /// personalLoan status
  static final _StoreObject<bool> loanStatus = _StoreObject<bool>(key: 'loanStatus');

  /// personalLoan monthly salary amount
  static final _StoreObject<int> monthlySalary = _StoreObject<int>(key: 'monthlySalary');

  /// personalLoan category
  static final _StoreObject<String> category = _StoreObject<String>(key: 'category');

  /// personalLoan category
  static final _StoreObject<String> emailId = _StoreObject<String>(key: 'emailId');

  /// personalLoan bank Id
  static final _StoreObject<String> bankId = _StoreObject<String>(key: 'bankId');

  /// credit card salary
  static final _StoreObject<bool> isCreditCard = _StoreObject<bool>(key: 'creditUrl');

  /// personalLoan bank Id
  static final _StoreObject<String> editString = _StoreObject<String>(key: 'editString');

  /// credit card applier name
  static final _StoreObject<String> firstName = _StoreObject<String>(key: 'firstname');

  /// credit card salary
  static final _StoreObject<String> salary = _StoreObject<String>(key: 'salary');

  /// credit card name
  static final _StoreObject<String> productName = _StoreObject<String>(key: 'productName');

  /// credit card code
  static final _StoreObject<String> productCode = _StoreObject<String>(key: 'productCode');

  /// credit card type
  static final _StoreObject<String> creditCardType = _StoreObject<String>(key: 'creditCardType');

  /// Logged in auto Buynow value
  static late String  buyNowFilterVal = '';

  /// third party
  static late String thirdParty = '';

  /// third party
  static late bool isReward = false;

  /// Selected Bank Id
  static final _StoreObject<String> BankId = _StoreObject<String>(key: 'productKey');

  /// Logged in Cart Total value
  static late String  cartTotalVal = '';

  /// Logged in instore order value
  static late String  instoreOrderVal = '';

  /// Selected Bank Id
  static final _StoreObject<String> customerInterest = _StoreObject<String>(key: 'customerInterest');
  static final _StoreObject<String> custEmirate = _StoreObject<String>(key: 'custEmirate');
  static final _StoreObject<String> custPersonalInfo = _StoreObject<String>(key: 'custPersonalInfo');
  static final _StoreObject<String> custGender = _StoreObject<String>(key: 'custGender');
  static final _StoreObject<String> custDob = _StoreObject<String>(key: 'custDob');
  static final _StoreObject<String> custMaritalStatus = _StoreObject<String>(key: 'custMaritalStatus');
  static final _StoreObject<String> custSpecialPerson = _StoreObject<String>(key: 'custSpecialPerson');

  ///Flight booking order id
  static final _StoreObject<String> flightBookingId = _StoreObject<String>(key: 'flightBookingId');


}
