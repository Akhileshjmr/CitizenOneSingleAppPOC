// features/kyc/domain/entities/location_entity.dart

class LocationOptionEntity {
  final int id;
  final String name;
  final int? parentId;

  const LocationOptionEntity({
    required this.id,
    required this.name,
    this.parentId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationOptionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class KycLocationsEntity {
  final List<LocationOptionEntity> countries;
  final List<LocationOptionEntity> states;
  final List<LocationOptionEntity> districts;
  final List<LocationOptionEntity> cities;
  final List<LocationOptionEntity> sectors;
  final List<KycDynamicDocumentEntity> dynamicDocuments;

  const KycLocationsEntity({
    required this.countries,
    required this.states,
    required this.districts,
    required this.cities,
    required this.sectors,
    required this.dynamicDocuments,
  });
}

class KycDynamicDocumentEntity {
  final String name;
  final bool isMandatory;
  final bool showDates;

  // UI-side mutable state — kept here so BLoC can copy/update
  final List<int>? file;
  final String? fileName;
  final DateTime? issueDate;
  final DateTime? expiryDate;

  const KycDynamicDocumentEntity({
    required this.name,
    required this.isMandatory,
    required this.showDates,
    this.file,
    this.fileName,
    this.issueDate,
    this.expiryDate,
  });

  KycDynamicDocumentEntity copyWith({
    List<int>? file,
    String? fileName,
    DateTime? issueDate,
    DateTime? expiryDate,
  }) {
    return KycDynamicDocumentEntity(
      name: name,
      isMandatory: isMandatory,
      showDates: showDates,
      file: file ?? this.file,
      fileName: fileName ?? this.fileName,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
