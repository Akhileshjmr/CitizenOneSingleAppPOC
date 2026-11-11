import 'package:flutter/material.dart';

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
