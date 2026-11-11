import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/models/lov_models/AbGenLovValDesc.dart';

// Customer New Account Creation Screen

// Basic details controllers
final TextEditingController firstNameController = TextEditingController();
final TextEditingController customerTypeController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController middleNameController = TextEditingController();
final TextEditingController shortNameController = TextEditingController();
final TextEditingController remarksController = TextEditingController();

// Address details controllers
final TextEditingController address1Controller = TextEditingController();
final TextEditingController address2Controller = TextEditingController();
final TextEditingController address3Controller = TextEditingController();
final TextEditingController addressNameController = TextEditingController();
final TextEditingController pincodeController = TextEditingController();


final permanentAddress1Controller = TextEditingController();
final permanentAddress2Controller = TextEditingController();
final permanentAddress3Controller = TextEditingController();
final permanentCityController = TextEditingController();
final permanentPincodeController = TextEditingController();

bool _isSameAsCorrespondence = false;
// Additional details controllers
final TextEditingController birthPlaceController = TextEditingController();
final TextEditingController birthCountryController = TextEditingController();
final TextEditingController passportNoController = TextEditingController();
final TextEditingController relationshipController = TextEditingController();
final TextEditingController emailIdController = TextEditingController();

// Nominee details controllers
final TextEditingController nAddress1Controller = TextEditingController();
final TextEditingController nAddress2Controller = TextEditingController();
final TextEditingController nAddress3Controller = TextEditingController();
final TextEditingController nAddress4Controller = TextEditingController();
final TextEditingController nGuardianController = TextEditingController();
final TextEditingController nNameController = TextEditingController();
final TextEditingController mobileNoController = TextEditingController();


TextEditingController liaNameController= TextEditingController();
TextEditingController cityController = TextEditingController();


String? custCategeory;
String? accBranch;
String? accCurrency;
String? accClass;
String? location;
String? title;
String? gender;
String? birthCountry;
String? language;
String? commMode;
String? media;
String? country;
String? countryCode;
String? maritalStatus;
String? imagePath;
String? currency;
String? nationality;
String? mobileIsdCode;
String? currentEmployer;
String? liaBranch;
String? selectedGender;

// Term Deposit Screen

final TextEditingController termDepositAccountNumberController = TextEditingController();
final TextEditingController accountStatusController = TextEditingController();
final TextEditingController depositBranchCodeController = TextEditingController();
final TextEditingController customerNameController = TextEditingController();
final TextEditingController productNameController = TextEditingController();
final TextEditingController depositCurrencyController = TextEditingController();
final TextEditingController currencyCodeController = TextEditingController();
final TextEditingController instrumentNumberController = TextEditingController();
final TextEditingController instrumentDateController = TextEditingController();
final TextEditingController accountNameController = TextEditingController();
final TextEditingController valueDateController = TextEditingController();
final TextEditingController bookDateController = TextEditingController();
final TextEditingController othersController = TextEditingController();
final TextEditingController dobController = TextEditingController();
final TextEditingController initialDepositAmountController = TextEditingController();
final TextEditingController depositTenorMonthsController = TextEditingController();
final TextEditingController depositTenorDaysController = TextEditingController();
final TextEditingController maturityDateController = TextEditingController();
final TextEditingController interestRateController = TextEditingController();
final TextEditingController spreadController = TextEditingController();
final TextEditingController appliedInterestRateController = TextEditingController();
final TextEditingController currentDepositAmountController = TextEditingController();
final TextEditingController maturityAmountController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController nomineeaddressController = TextEditingController();
final TextEditingController nominnedobController = TextEditingController();

String? custType;
String? customer;
String? product;
String? bookingBy;
String? draweeAccountNo;
String? customerId;
String? interestTransfer;
String? principleTransfer;
String? interestPaymentType;
String? interestPayment;
String? principlePayment;
String? relationship;
String? maturityInstructions;

//Account Specific Repayment
final TextEditingController productCodeController = TextEditingController();
final TextEditingController principalOsController = TextEditingController();
final TextEditingController paymentRefController = TextEditingController();
final TextEditingController currencyController = TextEditingController();
final TextEditingController lastPaymentReceivedDateController = TextEditingController();
final TextEditingController noOfPaymentDuesController = TextEditingController();
final TextEditingController excessAmountController = TextEditingController();
final TextEditingController totalDueAmountController = TextEditingController();
final TextEditingController settledAmountController = TextEditingController();
final TextEditingController dateOfPaymentController = TextEditingController();
final TextEditingController actualDueAmountController = TextEditingController();
final TextEditingController principalController = TextEditingController();
final TextEditingController interestController = TextEditingController();
final TextEditingController scheduleNumberController = TextEditingController();
final TextEditingController dateController = TextEditingController();
final TextEditingController emiController = TextEditingController();
final TextEditingController penaltyController = TextEditingController();
final TextEditingController totalDueController = TextEditingController();
final TextEditingController overDueDaysController = TextEditingController();
final TextEditingController transactionDateController = TextEditingController();
final TextEditingController amountPaidController = TextEditingController();
final TextEditingController paymentModeController = TextEditingController();
final TextEditingController scheduleController = TextEditingController();
final TextEditingController scheduleDateController = TextEditingController();
final TextEditingController principalWaiverController = TextEditingController();
final TextEditingController interestWaiverController = TextEditingController();
final TextEditingController penaltyWaiverController = TextEditingController();
final TextEditingController commentsController = TextEditingController();
final TextEditingController totalAmountWaivedController = TextEditingController();


String? disburseAccounts;
String? paymentMode;

//Disbursement Schedule Details controllers
final TextEditingController accountNumberController = TextEditingController();
final TextEditingController amountFinancedController = TextEditingController();
final TextEditingController branchDateController = TextEditingController();
final TextEditingController tenureController = TextEditingController();
final TextEditingController referenceNumberController = TextEditingController();
final TextEditingController disbursementModeController = TextEditingController();
final TextEditingController repaymentTypeController = TextEditingController();
final TextEditingController payableToController = TextEditingController();
final TextEditingController approvalStatusController = TextEditingController(text:"NEW");
final TextEditingController disbursementDateController = TextEditingController();
final TextEditingController disbursementAmountController = TextEditingController();
final TextEditingController amountDisbursedTillDateController = TextEditingController();
final TextEditingController remainingDisbursementAmountController = TextEditingController();
final TextEditingController disbursementStatusController = TextEditingController();
final TextEditingController disbursementOrderController = TextEditingController();
final TextEditingController repaymentDateController = TextEditingController();

String? accCategory;
String? accountNumber;

// Customer specific controllers

final TextEditingController paymentNoController = TextEditingController();
final TextEditingController loanProductController = TextEditingController();
final TextEditingController outstandingPrincipalController = TextEditingController();
final TextEditingController totalEmiController = TextEditingController();
final TextEditingController totalExcessAmountController = TextEditingController();
final TextEditingController totalPayableAmountController = TextEditingController();


// customer specific repayments
String? selectedCustomerNo;
String? modeOfPayment;


// disbursement schedule screen

final TextEditingController customerNamesController = TextEditingController();
final TextEditingController amountsFinancedController = TextEditingController();
final TextEditingController loanStartDateController = TextEditingController();
final TextEditingController tenureUnitController = TextEditingController();
final TextEditingController referenceRateCodeController = TextEditingController();
final TextEditingController rateOfInterestController = TextEditingController();
final TextEditingController interestSpreadController = TextEditingController();
final TextEditingController disbursedAmountController = TextEditingController();
final TextEditingController outstandingPrincipalsController = TextEditingController();
final TextEditingController interestsController = TextEditingController();
final TextEditingController principalsController = TextEditingController();
final TextEditingController statusController = TextEditingController();
final TextEditingController outstandingPrincipalScheduleController = TextEditingController();
final TextEditingController schedulerNumbersController = TextEditingController();
final TextEditingController emiDisbursementController = TextEditingController();


////

final TextEditingController salutationController = TextEditingController();
final TextEditingController fNameController = TextEditingController();
final TextEditingController lController = TextEditingController();
final TextEditingController fullNameController = TextEditingController();
final TextEditingController dofbController = TextEditingController();
final TextEditingController educationController = TextEditingController();
final TextEditingController areaController = TextEditingController();
final TextEditingController nationalityController = TextEditingController();
final TextEditingController nationalIdController = TextEditingController();
final TextEditingController dateofExpiryController = TextEditingController();
final TextEditingController dateofIssueController = TextEditingController();
final TextEditingController placeOfIssueController = TextEditingController();
final TextEditingController addressTypeController = TextEditingController();
final TextEditingController addresscontroller = TextEditingController();
final TextEditingController citycontroller = TextEditingController();
final TextEditingController governateController = TextEditingController();
final TextEditingController timeAtAddressController = TextEditingController();
final TextEditingController countryController = TextEditingController();
final TextEditingController flatNumberController = TextEditingController();
final TextEditingController districtController = TextEditingController();
final TextEditingController buildingNoController = TextEditingController();
final TextEditingController areaCodeController = TextEditingController();
final TextEditingController numberController = TextEditingController();
final TextEditingController phoneTypeController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController emergencyContactPersonController = TextEditingController();
final TextEditingController emergencyPhoneController = TextEditingController();
final TextEditingController emergencyAddressController = TextEditingController();
final TextEditingController otpController = TextEditingController();
String? selectedSalutation;
String? selectedEducation;
String? selectedPlaceOfIssue;
DateTime? selectedDob;
DateTime? selectedDateOfIssue;
DateTime? selectedDateOfExpiry;


String? employmentStatus;
String? currentEmployer1;
String? governateName;
String? profession;
String? yearsCurrent;
String? previousEmployer;
String? yearsPrevious;
String? frequency;
String? incomeType;
String? documentName;
String? residentialStatus;
String? education;

final TextEditingController employerName = TextEditingController();
final TextEditingController employerType = TextEditingController();
final TextEditingController buildingNo = TextEditingController();
final TextEditingController streetNo = TextEditingController();
final TextEditingController districtName = TextEditingController();
final TextEditingController designation = TextEditingController();
final TextEditingController workingPhoneNo = TextEditingController();
final TextEditingController workingEmail = TextEditingController();
final TextEditingController hireDate = TextEditingController();
final TextEditingController organisationName = TextEditingController();
final TextEditingController incomeValue = TextEditingController();
final TextEditingController totalIncome = TextEditingController();
final TextEditingController documentNo = TextEditingController();
final TextEditingController tenureMonthsController = TextEditingController();
final TextEditingController amountController = TextEditingController();
final TextEditingController downPaymentAmountController = TextEditingController();
final TextEditingController scoreController = TextEditingController();
String? selectedProduct;
String? selectedVendor;
String? selectedStore;

String? industry;
TextEditingController titleController = TextEditingController();
TextEditingController netMonthlyIncomeController = TextEditingController();
TextEditingController netMonthlyExpenseController = TextEditingController();
TextEditingController currentEmployerController = TextEditingController();
TextEditingController workingAddressController = TextEditingController();
final TextEditingController floorNumberController = TextEditingController();
final TextEditingController streetNumberController = TextEditingController();

// Dropdown values
String? accountType;
String? selectedCustomerCode;
String? selectedProductCode;
String? selectedModeOfOperation;

// Text controllers
TextEditingController primaryCustomer = TextEditingController();
final openingDate = TextEditingController(
  text: DateFormat('yyyy-MM-dd').format(DateTime.now()), // ✅ default today
);
TextEditingController openingBalance = TextEditingController();
TextEditingController vendorNameController = TextEditingController();
TextEditingController accountOpeningCharges = TextEditingController();
String? modeOfOperation;
String? selectedCustomer;

bool isVendorAccount = false;
bool isWaiverOff = false;
bool hasChequeBook = false;
bool hasPassbook = false;
bool hasATM = false;
bool hasStandingInstruction = false;
bool hasOverdraft = false;
bool hasNominationFacility = false;
bool hasTeleBanking = false;
bool hasInternetBanking = false;
bool hasMobileBanking = false;
bool hasSMSBanking = false;
bool hasSMSAlert = false;
bool hasEmailAlert = false;
bool hasBothAlert = false;
/*onboarding customer*/
String? selectedBankAccType;
// String? selectedResidentialStatus;
// String? selectedNationalityResidency;
// String? selectedMaritalStatus;
// String? selectedProfession;
// String? selectedEducationLevel;
String? selectedAcademicDegree;
AbGenLovValDesc? selectedResidentialStatus;
AbGenLovValDesc? selectedNationalityResidency;
AbGenLovValDesc? selectedMaritalStatus;
AbGenLovValDesc? selectedProfession;
AbGenLovValDesc? selectedEducationLevel;

TextEditingController bankaccTypecontroller = TextEditingController();
TextEditingController academicDegree = TextEditingController();
TextEditingController empStatusController = TextEditingController();
// String? selectedCity;
// String? selectedArea;
AbGenLovValDesc? selectedCity;
AbGenLovValDesc? selectedArea;
AbGenLovValDesc? selectedNationality;






//======================   Wallet Registration========================


