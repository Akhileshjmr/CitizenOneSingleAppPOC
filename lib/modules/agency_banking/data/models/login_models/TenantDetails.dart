import 'dart:typed_data';
import 'dart:convert';

class TenantDetails {
  String? bankcode;
  String? bankName;
  String? bankthemeColor;
  String? org_type;
  Uint8List? logoImage;

  TenantDetails({
    this.bankcode,
    this.bankName,
    this.bankthemeColor,
    this.logoImage,
    this.org_type,
  });

  factory TenantDetails.fromJson(Map<String, dynamic> json) {
    return TenantDetails(
      bankcode: json['bankcode']?.toString(),
      bankName: json['bankName']?.toString(),
      org_type: json['org_type']?.toString(),
      bankthemeColor: json['banktheme_color']?.toString(),

      // ✅ Decode Base64 safely
      logoImage: (json['logoImage'] != null && json['logoImage'] is String && json['logoImage'].isNotEmpty)
          ? base64Decode(json['logoImage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankcode': bankcode,
      'bankName': bankName,
      'org_type': org_type,
      'banktheme_color': bankthemeColor,
      'logoImage': logoImage != null ? base64Encode(logoImage!) : null, // ✅ Encode back
    };
  }
}