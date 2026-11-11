class BodyStylesEntity {
  final int id;
  final String name;
  final String imageUrl;

  const BodyStylesEntity(
      {required this.id, required this.name, required this.imageUrl});
}

class VehicleMakeEntity {
  final int id;
  final String name;

  const VehicleMakeEntity({required this.id, required this.name});
}

class PolicyDurationEntity {
  final int id;
  final int quarters;
  final int months;

  const PolicyDurationEntity(
      {required this.id, required this.quarters, required this.months});
}
