import '../model/user/documents/Documents.dart';

extension DocumentsExtension on Documents {
  /// Whether document is uploaded
  bool get isUploaded {
    return (isAttachedInProcess == true) ||
        (originalDocName?.trim().isNotEmpty ?? false);
  }

  /// Whether document is mandatory
  bool get isRequired {
    return isMandatory == true;
  }
}
