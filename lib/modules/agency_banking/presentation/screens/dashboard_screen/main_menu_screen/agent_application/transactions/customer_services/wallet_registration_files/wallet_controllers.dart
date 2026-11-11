// Controllers
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbGenLovValDesc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../../data/models/CommKycUpload.dart';

final TextEditingController fNameController = TextEditingController();
final TextEditingController mNameController = TextEditingController();
final TextEditingController lNameController = TextEditingController();
final TextEditingController dobController = TextEditingController();

AbGenLovValDesc? selectedGender;
AbGenLovValDesc? selectedNationality;
final TextEditingController mobileNumberController = TextEditingController();
final TextEditingController residentialNumberController = TextEditingController();
final TextEditingController officeNumberController = TextEditingController();
final TextEditingController houseNoController = TextEditingController();
final TextEditingController subCityController = TextEditingController();
final TextEditingController cityController = TextEditingController();
final TextEditingController zipController = TextEditingController();
CommKycUpload res=CommKycUpload();
// Dropdown values
AbGenLovValDesc? selectedCountryCode;
AbGenLovValDesc? selectedCountry;

// Controllers
final TextEditingController designationController = TextEditingController();
final TextEditingController employerController = TextEditingController();
final TextEditingController monthlyIncomeController = TextEditingController();
final TextEditingController annualIncomeController = TextEditingController();
final TextEditingController idNumberController = TextEditingController();
final TextEditingController issuedByController = TextEditingController();

// Dropdowns
AbGenLovValDesc? selectedCustType;
AbGenLovValDesc? selectedAccType;
AbGenLovValDesc? selectedIdType;
final TextEditingController remarksController = TextEditingController();