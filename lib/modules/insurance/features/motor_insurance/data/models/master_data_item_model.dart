import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/master_data_item_entity.dart';

class MasterDataItemModel extends MasterDataItemEntity {
  const MasterDataItemModel({
    required super.code,
    required super.label,
  });

  factory MasterDataItemModel.fromJson(Map<String, dynamic> json) {
    return MasterDataItemModel(
      code: json['code'] as String,
      label: json['label'] as String,
    );
  }
}