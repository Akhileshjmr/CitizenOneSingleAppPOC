
// Controllers
import 'package:flutter/cupertino.dart';

final TextEditingController fullNameController = TextEditingController();
final TextEditingController dobController = TextEditingController();
final TextEditingController nationalityController = TextEditingController();
final TextEditingController nrcController = TextEditingController();

final TextEditingController mobileController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController cityController = TextEditingController();
final TextEditingController postalController = TextEditingController();

// Controllers
final TextEditingController employerController = TextEditingController();
final TextEditingController incomeController = TextEditingController();
final TextEditingController occupationController = TextEditingController();
final TextEditingController yearsController = TextEditingController();

// Dropdown & selections
String? employmentType;
String? policyTerm;
String? premiumFrequency;


// Add-on Riders
Map<String, bool> riders = {
  "Accidental Death Benefit": false,
  "Critical Illness Cover": false,
  "Disability Cover": false,
  "Return of Premium Option": false,
};

// Dropdown values
String? gender;
String? maritalStatus;
