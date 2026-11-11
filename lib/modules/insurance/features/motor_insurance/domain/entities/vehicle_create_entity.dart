class VehicleCreateEntity {
  final String registrationNumber;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleColor;
  final String yearOfManufacture;
  final String chassisNumber;
  final String engineNumber;
  final String motorRiskCategoryId;
  final String riskCategoryName;
  final int sumInsured;
  final int? capacity;
  final int? tonnage;
  final int? seatingCapacity;

  VehicleCreateEntity({
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.registrationNumber,
    required this.yearOfManufacture,
    required this.chassisNumber,
    required this.engineNumber,
    required this.motorRiskCategoryId,
    required this.riskCategoryName,
    required this.sumInsured,
    this.capacity,
    this.tonnage,
    this.seatingCapacity,
  });
}
