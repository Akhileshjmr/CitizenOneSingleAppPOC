import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/master_data_item_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/master_data_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/master_data_item_entity.dart';

class MotorInsuranceMasterDataModel extends MotorInsuranceMasterData {
  const MotorInsuranceMasterDataModel({
    required super.genders,
    required super.maritalStatuses,
    required super.occupations,
    required super.relationships,
    required super.nationalities,
    required super.idTypes,
    required super.policyFor,
    required super.planTypes,
    required super.paymentMethods,
    required super.paymentGateways,
  });

  factory MotorInsuranceMasterDataModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    List<MasterDataItemEntity> parseList(String key) {
      return (data[key] as List<dynamic>? ?? [])
          .map((e) => MasterDataItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return MotorInsuranceMasterDataModel(
      genders: parseList('genders'),
      maritalStatuses: parseList('maritalStatuses'),
      occupations: parseList('occupations'),
      relationships: parseList('relationships'),
      nationalities: parseList('nationalities'),
      idTypes: parseList('idTypes'),
      policyFor: parseList('policyFor'),
      planTypes: parseList('planTypes'),
      paymentMethods: parseList('paymentMethods'),
      paymentGateways: parseList('paymentGateways'),
    );
  }
}
