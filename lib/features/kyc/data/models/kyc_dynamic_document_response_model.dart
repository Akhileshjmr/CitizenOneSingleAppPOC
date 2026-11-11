class KycDynamicDocument {
  final String name;
  final bool isMandatory;
  final bool showDates;

  // UI state
  final List<int>? file;
  final String? fileName;
  final DateTime? issueDate;
  final DateTime? expiryDate;

  KycDynamicDocument({
    required this.name,
    required this.isMandatory,
    required this.showDates,
    this.file,
    this.fileName,
    this.issueDate,
    this.expiryDate,
  });

  KycDynamicDocument copyWith({
    List<int>? file,
    String? fileName,
    DateTime? issueDate,
    DateTime? expiryDate,
  }) {
    return KycDynamicDocument(
      name: name,
      isMandatory: isMandatory,
      showDates: showDates,
      file: file ?? this.file,
      fileName: fileName ?? this.fileName,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  factory KycDynamicDocument.fromJson(Map<String, dynamic> json) {
    return KycDynamicDocument(
      name: json['friendlyType'],
      isMandatory: json['other']?['type'] == "true",
      showDates: json['other']?['friendlyType'] == "true",
    );
  }
}