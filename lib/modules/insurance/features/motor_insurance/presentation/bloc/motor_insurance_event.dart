import 'package:equatable/equatable.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/customer_details_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_maintainence_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/quotation_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/risk_category_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/vehicle_create_entity.dart';

abstract class MotorInsuranceEvent extends Equatable {
  const MotorInsuranceEvent();

  @override
  List<Object?> get props => [];
}

class NextStepEvent extends MotorInsuranceEvent {}

class PrevStepEvent extends MotorInsuranceEvent {}

class CustomStepEvent extends MotorInsuranceEvent {
  final int index;

  const CustomStepEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class UpdatePolicyHolderTypeEvent extends MotorInsuranceEvent {
  final bool isForMyself;
  const UpdatePolicyHolderTypeEvent(this.isForMyself);

  @override
  List<Object?> get props => [isForMyself];
}

class UpdateSomeoneElseDetailsEvent extends MotorInsuranceEvent {
  final String name;
  final String relationship;
  const UpdateSomeoneElseDetailsEvent(
      {required this.name, required this.relationship});

  @override
  List<Object?> get props => [name, relationship];
}

class UpdateVehicleInfoEvent extends MotorInsuranceEvent {
  final String vehicleRegNo;
  final String vehicleMakeModel;
  final String vehicleYear;
  const UpdateVehicleInfoEvent({
    required this.vehicleRegNo,
    required this.vehicleMakeModel,
    required this.vehicleYear,
  });

  @override
  List<Object?> get props => [vehicleRegNo, vehicleMakeModel, vehicleYear];
}

class LookupVehicleEvent extends MotorInsuranceEvent {
  final String regNo;
  const LookupVehicleEvent(this.regNo);

  @override
  List<Object?> get props => [regNo];
}

class SetVehicleManualEntryEvent extends MotorInsuranceEvent {
  final bool isManualEntry;
  const SetVehicleManualEntryEvent(this.isManualEntry);

  @override
  List<Object?> get props => [isManualEntry];
}

class SelectVehicleBodyStyleEvent extends MotorInsuranceEvent {
  final String bodyStyle;
  const SelectVehicleBodyStyleEvent(this.bodyStyle);

  @override
  List<Object?> get props => [bodyStyle];
}

class UpdateVehicleManualDetailsEvent extends MotorInsuranceEvent {
  final String vehicleRegNo;
  final String vehicleMake;
  final String vehicleModel;
  final String yearOfManufacture;
  final String chassisNumber;
  final String engineNumber;
  final String motorRiskCategoryId;
  final String riskCategoryName;
  final String vehicleColor;
  final int sumInsured;
  final int? capacity;
  final int? tonnage;
  final int? seatingCapacity;

  const UpdateVehicleManualDetailsEvent(
      {required this.vehicleRegNo,
      required this.vehicleMake,
      required this.vehicleModel,
      required this.yearOfManufacture,
      required this.vehicleColor,
      required this.engineNumber,
      required this.chassisNumber,
      required this.motorRiskCategoryId,
      required this.riskCategoryName,
      required this.sumInsured,
      this.capacity,
      this.tonnage,
      this.seatingCapacity});

  @override
  List<Object?> get props => [
        vehicleRegNo,
        vehicleMake,
        vehicleModel,
        yearOfManufacture,
        engineNumber,
        chassisNumber,
        vehicleColor,
        motorRiskCategoryId,
        riskCategoryName,
        sumInsured,
        capacity,
        tonnage,
        seatingCapacity
      ];
}

class UpdatePolicyDetailsEvent extends MotorInsuranceEvent {
  final String coverageType;
  final DateTime startDate;
  const UpdatePolicyDetailsEvent(
      {required this.coverageType, required this.startDate});

  @override
  List<Object?> get props => [coverageType, startDate];
}

class UpdateDriverDetailsEvent extends MotorInsuranceEvent {
  final String driverLicense;
  final String driverExperience;
  final String driverPhone;
  const UpdateDriverDetailsEvent({
    required this.driverLicense,
    required this.driverExperience,
    required this.driverPhone,
  });

  @override
  List<Object?> get props => [driverLicense, driverExperience, driverPhone];
}

class UpdateAddonsEvent extends MotorInsuranceEvent {
  final bool zeroDepSelected;
  final bool roadsideSelected;
  final bool engineSelected;
  const UpdateAddonsEvent({
    required this.zeroDepSelected,
    required this.roadsideSelected,
    required this.engineSelected,
  });

  @override
  List<Object?> get props =>
      [zeroDepSelected, roadsideSelected, engineSelected];
}

class SubmitMotorInsuranceEvent extends MotorInsuranceEvent {}

class ResetMotorInsuranceEvent extends MotorInsuranceEvent {}

class UpdateSelectedQuarterEvent extends MotorInsuranceEvent {
  final int quarters;
  const UpdateSelectedQuarterEvent(this.quarters);

  @override
  List<Object?> get props => [quarters];
}

class ToggleAddonEvent extends MotorInsuranceEvent {
  final String addonKey;
  final bool value;

  const ToggleAddonEvent({
    required this.addonKey,
    required this.value,
  });
}

class SearchUserEvent extends MotorInsuranceEvent {
  final String mobileNumber;
  final String nationalId;

  const SearchUserEvent({required this.mobileNumber, required this.nationalId});
  @override
  List<Object> get props => [mobileNumber, nationalId];
}

class UpdateCustomerDetailsEvent extends MotorInsuranceEvent {
  final CustomerDetails customerDetails;

  const UpdateCustomerDetailsEvent({required this.customerDetails});

  @override
  List<Object?> get props => [customerDetails];
}

class CreateIndividualUserEvent extends MotorInsuranceEvent {
  final CustomerDetails customerDetails;

  const CreateIndividualUserEvent({required this.customerDetails});

  @override
  List<Object?> get props => [customerDetails];
}

class DownloadDocument extends MotorInsuranceEvent {
  final String url;
  final String fileName;
  const DownloadDocument({required this.url, required this.fileName});
  @override
  List<Object> get props => [url, fileName];
}

class FetchMotorMaintainenceEvent extends MotorInsuranceEvent {}

class FetchVehicleDetailsEvent extends MotorInsuranceEvent {
  final String registrationNo;
  const FetchVehicleDetailsEvent({required this.registrationNo});

  @override
  List<Object> get props => [registrationNo];
}

class GetMotorInsuranceMasterDataEvent extends MotorInsuranceEvent {
  const GetMotorInsuranceMasterDataEvent();
}

class UpdatePolicyForEvent extends MotorInsuranceEvent {
  final String code;
  final String label;
  const UpdatePolicyForEvent({required this.code, required this.label});

  @override
  List<Object> get props => [code];
}

class VehicleCreateEvent extends MotorInsuranceEvent {
  final VehicleCreateEntity vehicleCreateEntity;
  final String clientId;

  const VehicleCreateEvent({
    required this.vehicleCreateEntity,
    required this.clientId,
  });

  @override
  List<Object> get props => [vehicleCreateEntity];
}

class FetchRiskCategoriesEvent extends MotorInsuranceEvent {}

class GenerateMotorOtpEvent extends MotorInsuranceEvent {
  final String destination;

  const GenerateMotorOtpEvent({required this.destination});

  @override
  List<Object> get props => [destination];
}

class VerifyMotorOtpEvent extends MotorInsuranceEvent {
  final String otp;

  const VerifyMotorOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class MotorOtpTimerTickedEvent extends MotorInsuranceEvent {
  final int remainingSeconds;

  const MotorOtpTimerTickedEvent({required this.remainingSeconds});

  @override
  List<Object> get props => [remainingSeconds];
}

class MotorOtpExpiredEvent extends MotorInsuranceEvent {}

class ClearMotorOtpEvent extends MotorInsuranceEvent {}

class MotorInsuranceSelectPlanEvent extends MotorInsuranceEvent {
  final PlanType selectedPlan;

  const MotorInsuranceSelectPlanEvent(this.selectedPlan);
}

class CompareQuotationEvent extends MotorInsuranceEvent {
  const CompareQuotationEvent();
}

class RiskCategoriesSelectedEvent extends MotorInsuranceEvent {
  final RiskCategoryModel selectedRiskCategory;
  const RiskCategoriesSelectedEvent({
    required this.selectedRiskCategory,
  });
}

class SelectInsuranceQuoteEvent extends MotorInsuranceEvent {
  final Quotation selectedInsuranceQuotation;
  const SelectInsuranceQuoteEvent({
    required this.selectedInsuranceQuotation,
  });
}

class CreateQuotationEvent extends MotorInsuranceEvent {}

class DisableErrorMessageEvent extends MotorInsuranceEvent {}

class InstantIssueEvent extends MotorInsuranceEvent {}

class ResetFormData extends MotorInsuranceEvent {}

class ResetVehicleData extends MotorInsuranceEvent {}

class DownloadInvoice extends MotorInsuranceEvent {
  final String policyId;

  const DownloadInvoice({required this.policyId});

  @override
  List<Object> get props => [policyId];
}

class FetchInsuranceTransactionsEvent extends MotorInsuranceEvent {
  final String? search;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String agentCode;

  const FetchInsuranceTransactionsEvent({
    this.search,
    this.fromDate,
    this.toDate,
    required this.agentCode,
  });

  @override
  List<Object?> get props => [search, fromDate, toDate, agentCode];
}

class LoadMoreInsuranceTransactionsEvent extends MotorInsuranceEvent {
  final String agentCode;

  const LoadMoreInsuranceTransactionsEvent({required this.agentCode});

  @override
  List<Object?> get props => [agentCode];
}

class RefreshInsuranceTransactionsEvent extends MotorInsuranceEvent {
  const RefreshInsuranceTransactionsEvent();
}

class ClearInsuranceTransactionFiltersEvent extends MotorInsuranceEvent {
  const ClearInsuranceTransactionFiltersEvent();
}

class ToggleViewMore extends MotorInsuranceEvent {
  final int index;

  const ToggleViewMore(this.index);
}

class PaymentMethodChanged extends MotorInsuranceEvent {
  final String selectedPaymentMethod;
  const PaymentMethodChanged({required this.selectedPaymentMethod});

  @override
  List<Object?> get props => [selectedPaymentMethod];
}

class MobileProviderChanged extends MotorInsuranceEvent {
  final String selectedMobileProvider;
  const MobileProviderChanged({required this.selectedMobileProvider});

  @override
  List<Object?> get props => [selectedMobileProvider];
}

class PhoneNumberChanged extends MotorInsuranceEvent {
  final String phoneNumber;
  const PhoneNumberChanged({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class CardNumberChanged extends MotorInsuranceEvent {
  final String cardNumber;
  const CardNumberChanged({required this.cardNumber});

  @override
  List<Object?> get props => [cardNumber];
}

class CardExpiryChanged extends MotorInsuranceEvent {
  final String expiry;
  const CardExpiryChanged({required this.expiry});

  @override
  List<Object?> get props => [expiry];
}

class CardCVVChanged extends MotorInsuranceEvent {
  final String cvv;
  const CardCVVChanged({required this.cvv});

  @override
  List<Object?> get props => [cvv];
}

class CardHolderChanged extends MotorInsuranceEvent {
  final String cardHolder;
  const CardHolderChanged({required this.cardHolder});

  @override
  List<Object?> get props => [cardHolder];
}

class ProcessInsurancePayment extends MotorInsuranceEvent {}

class PrintReceipt extends MotorInsuranceEvent {
  final String policyId;

  const PrintReceipt({required this.policyId});

  @override
  List<Object> get props => [policyId];
}

class IssuePolicyBuQuoteIDEvent extends MotorInsuranceEvent {}

class SumInsuredFieldChangeEvent extends MotorInsuranceEvent {
  final double sumInusredValue;
  const SumInsuredFieldChangeEvent({required this.sumInusredValue});
  @override
  List<Object> get props => [sumInusredValue];
}

class FetchMotorProductDetailsEvent extends MotorInsuranceEvent {
  final String productId;
  const FetchMotorProductDetailsEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

class SendSMSForPolicyKeyFactsEvent extends MotorInsuranceEvent {
  final String productId;
  final String customerMobileNumber;
  const SendSMSForPolicyKeyFactsEvent(
      {required this.productId, required this.customerMobileNumber});

  @override
  List<Object> get props => [productId, customerMobileNumber];
}

class FetchKeyFactsDocumentEvent extends MotorInsuranceEvent {
  final String productId;
  const FetchKeyFactsDocumentEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
