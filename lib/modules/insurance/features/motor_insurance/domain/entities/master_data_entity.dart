import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/master_data_item_entity.dart';

class MotorInsuranceMasterData {
  final List<MasterDataItemEntity> genders;
  final List<MasterDataItemEntity> maritalStatuses;
  final List<MasterDataItemEntity> occupations;
  final List<MasterDataItemEntity> relationships;
  final List<MasterDataItemEntity> nationalities;
  final List<MasterDataItemEntity> idTypes;
  final List<MasterDataItemEntity> policyFor;
  final List<MasterDataItemEntity> planTypes;
  final List<MasterDataItemEntity> paymentMethods;
  final List<MasterDataItemEntity> paymentGateways;

  const MotorInsuranceMasterData({
    required this.genders,
    required this.maritalStatuses,
    required this.occupations,
    required this.relationships,
    required this.nationalities,
    required this.idTypes,
    required this.policyFor,
    required this.planTypes,
    required this.paymentMethods,
    required this.paymentGateways,
  });
}
