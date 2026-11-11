import 'package:citizenone_app/modules/agency_banking/data/models/kyc/location_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object> get props => [];
}

class SearchUserEvent extends KycEvent {
  final String mobileNumber;
  final String nationalId;
  final bool fromHistory;

  const SearchUserEvent({required this.mobileNumber, required this.nationalId,this.fromHistory= false});
  @override
  List<Object> get props => [mobileNumber, nationalId,fromHistory];
}

class FetchSearchUserEvent extends KycEvent {
  final String mobileNumber;
  final String nationalId;

  const FetchSearchUserEvent({required this.mobileNumber, required this.nationalId});
  @override
  List<Object> get props => [mobileNumber, nationalId];
}

class CheckUserExistsEvent extends KycEvent {
  final String mobileNumber;
  final String nationalId;

  const CheckUserExistsEvent(
      {required this.mobileNumber, required this.nationalId});
  @override
  List<Object> get props => [mobileNumber, nationalId];
}

class SelectGender extends KycEvent {
  final String? gender;

  const SelectGender({required this.gender});
  @override
  List<Object> get props => [gender!];
}

class SelectDob extends KycEvent {
  final DateTime? dob;

  const SelectDob({required this.dob});
  @override
  List<Object> get props => [dob!];
}

class SelectNationality extends KycEvent {
  final String nationality;

  const SelectNationality({required this.nationality});
  @override
  List<Object> get props => [nationality];
}

class SelectEmploymentType extends KycEvent {
  final String? employmentType;

  const SelectEmploymentType({required this.employmentType});
  @override
  List<Object> get props => [employmentType!];
}

class LoadSectorEvent extends KycEvent {}

class SelectSectorEvent extends KycEvent {
  final LocationOption sector;

  const SelectSectorEvent(this.sector);

  @override
  List<Object> get props => [sector];
}

class UpdatePersonalInfoEvent extends KycEvent {
  final String firstName;
  final String lastName;
  final String nationalId;
  final String mobileNumber;

  const UpdatePersonalInfoEvent({
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    required this.mobileNumber,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        nationalId,
        mobileNumber,
      ];
}

class UpdateProfessionalInfoEvent extends KycEvent {
  final String monthlyIncome;
  final String sourceFunds;
  final String employerName;
  final String natureOfBusiness;
  final String businessName;

  const UpdateProfessionalInfoEvent(
      {required this.monthlyIncome,
      required this.sourceFunds,
      required this.employerName,
      required this.natureOfBusiness,
      required this.businessName});

  @override
  List<Object> get props => [
        monthlyIncome,
        sourceFunds,
        employerName,
        natureOfBusiness,
        businessName
      ];
}

class UpdateAddressInfoEvent extends KycEvent {
  final String email;
  final String addressLine;
  final String phNumber;
  final String pbNumber;

  const UpdateAddressInfoEvent({
    required this.email,
    required this.addressLine,
    required this.phNumber,
    required this.pbNumber,
  });

  @override
  List<Object> get props => [email, addressLine, phNumber, pbNumber];
}

class LoadLocationsEvent extends KycEvent {}

class SelectCountryEvent extends KycEvent {
  final LocationOption country;

  const SelectCountryEvent(this.country);
  @override
  List<Object> get props => [
        country,
      ];
}

class SelectOriginCountryEvent extends KycEvent {
  final LocationOption country;

  const SelectOriginCountryEvent(this.country);
  @override
  List<Object> get props => [
        country,
      ];
}

class SelectStateEvent extends KycEvent {
  final LocationOption state;

  const SelectStateEvent(this.state);
  @override
  List<Object> get props => [
        state,
      ];
}

class SelectDistrictEvent extends KycEvent {
  final LocationOption district;
  const SelectDistrictEvent(this.district);
  @override
  List<Object> get props => [
        district,
      ];
}

class SelectCityEvent extends KycEvent {
  final LocationOption city;

  const SelectCityEvent(this.city);
  @override
  List<Object> get props => [
        city,
      ];
}

class SubmitKycEvent extends KycEvent {
  // final String firstName;
  // final String lastName;
  // final String mobileNumber;
  // final String email;
  // final String addressLine;
  // final String phNumber;
  // final String pbNumber;

  // final String nationalId;
  // final String monthlyIncome;
  // final String sourceFunds;
  // final String employerName;
  // final String natureOfBusiness;
  // final String businessName;

  const SubmitKycEvent(
    //{
    // required this.firstName,
    // required this.lastName,
    // required this.mobileNumber,
    // required this.email,
    // required this.addressLine,
    // required this.phNumber,
    // required this.pbNumber,
    // required this.nationalId,
    // required this.monthlyIncome,
    // required this.sourceFunds,
    // required this.employerName,
    // required this.natureOfBusiness,
    // required this.businessName,
 // }
  );

  @override
  List<Object> get props => [
        // firstName,
        // lastName,
        // mobileNumber,
        // email,
        // addressLine,
        // phNumber,
        // nationalId,
        // monthlyIncome,
        // sourceFunds,
        // employerName,
        // natureOfBusiness,
        // businessName,
        // pbNumber
      ];
}

class UpdateKycEvent extends KycEvent {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String email;
  final String addressLine;
  final String phNumber;
  final String pbNumber;

  final String nationalId;
  final String monthlyIncome;
  final String sourceFunds;
  final String employerName;
  final String natureOfBusiness;
  final String businessName;

  const UpdateKycEvent({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    required this.addressLine,
    required this.phNumber,
    required this.pbNumber,
    required this.nationalId,
    required this.monthlyIncome,
    required this.sourceFunds,
    required this.employerName,
    required this.natureOfBusiness,
    required this.businessName,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        mobileNumber,
        email,
        addressLine,
        phNumber,
        nationalId,
        monthlyIncome,
        sourceFunds,
        employerName,
        natureOfBusiness,
        businessName,
        pbNumber
      ];
}

class DownloadDocument extends KycEvent {
  final String url;
  final String fileName;
  const DownloadDocument({required this.url, required this.fileName});
  @override
  List<Object> get props => [url, fileName];
}

class FetchRecentHistory extends KycEvent {
  final String filter;
  final int page;
  final DateTime? fromDate;
  final DateTime? toDate;

  const FetchRecentHistory({
    this.filter = "RECENT",
    this.page = 1,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object> get props => [filter, page, fromDate!, toDate!];
}

class ResetFormData extends KycEvent {
  const ResetFormData();
  @override
  List<Object> get props => [];
}

class PickPhotoEvent extends KycEvent {
  final List<int> fileData;
  final String name;

  const PickPhotoEvent({
    required this.fileData,
    required this.name,
  });

  @override
  List<Object> get props => [fileData, name];
}

class PickSignatureEvent extends KycEvent {
  final List<int> fileData;
  final String name;

  const PickSignatureEvent({
    required this.fileData,
    required this.name,
  });

  @override
  List<Object> get props => [fileData, name];
}

class LocalSearchKycHistory extends KycEvent {
  final String query;

  const LocalSearchKycHistory(this.query);
}

class UpdateDynamicDocIssueDate extends KycEvent {
  final String name;
  final DateTime date;

  const UpdateDynamicDocIssueDate(this.name, this.date);
  @override
  List<Object> get props => [name];
}

class UpdateDynamicDocExpiryDate extends KycEvent {
  final String name;
  final DateTime date;

  const UpdateDynamicDocExpiryDate(this.name, this.date);
  @override
  List<Object> get props => [name];
}

class PickDynamicDocumentEvent extends KycEvent {
  final String name;
  final List<int> fileData;
  final String fileName;

  const PickDynamicDocumentEvent(
      {required this.name, required this.fileData, required this.fileName});
  @override
  List<Object> get props => [name, fileData, fileName];
}

class EditDynamicDocIssueDate extends KycEvent {
  final int docId;
  final DateTime date;

  const EditDynamicDocIssueDate(this.docId, this.date);

  @override
  List<Object> get props => [docId, date];
}

class EditDynamicDocExpiryDate extends KycEvent {
  final int docId;
  final DateTime date;

  const EditDynamicDocExpiryDate(this.docId, this.date);

  @override
  List<Object> get props => [docId, date];
}

class EditDynamicDocumentEvent extends KycEvent {
  final int docId;
  final String fileName;
  final List<int> fileData;

  const EditDynamicDocumentEvent(
      {required this.docId, required this.fileData, required this.fileName});

  @override
  List<Object> get props => [docId, fileData, fileName];
}

class MergeDocumentsEvent extends KycEvent {
  const MergeDocumentsEvent();
}

class PickMergedDocumentEvent extends KycEvent {
  final String name;
  final List<int> fileData;
  final String fileName;
  const PickMergedDocumentEvent({
    required this.name,
    required this.fileData,
    required this.fileName,
  });
}

class UpdateMergedDocIssueDate extends KycEvent {
  final String name;
  final DateTime date;
  const UpdateMergedDocIssueDate(this.name, this.date);
}

class UpdateMergedDocExpiryDate extends KycEvent {
  final String name;
  final DateTime date;
  const UpdateMergedDocExpiryDate(this.name, this.date);
}
class ClearErrorEvent extends KycEvent {}

class SendOtpEvent extends KycEvent {
  final String mobile;

  const SendOtpEvent(this.mobile);

  @override
  List<Object> get props => [mobile];
}

class VerifyOtpEvent extends KycEvent {
  final String mobile;
  final String otp;

  const VerifyOtpEvent(this.mobile, this.otp);

  @override
  List<Object> get props => [mobile, otp];
}

class ResendOtpEvent extends KycEvent {
  final String mobile;

  const ResendOtpEvent(this.mobile);

  @override
  List<Object> get props => [mobile];
}

class StartOtpTimer extends KycEvent {}

class ResetOtpStateEvent extends KycEvent {
  const ResetOtpStateEvent();
}

class ConnectivityChanged extends KycEvent {
  final bool isConnected;

  const ConnectivityChanged(this.isConnected);
}
