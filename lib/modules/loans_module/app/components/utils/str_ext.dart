import 'package:citizenone_app/modules/loans_module/app/components/utils/common_utilities.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/remote/api_service/init_api_service.dart';

/// String Extension
extension StringExtenstion on String? {
  /// Add Image Url
  String get addBaseUrl => '${APIService.imageBaseUrl}$this';

  /// Add form f Image Url
  String get addFormBaseUrl =>
      '${APIService.baseUrl}realestate/home/orders$this';

  /// Add Review Image Url
  String get addReviewBaseUrl => '${APIService.baseUrl}customer/reg$this';

  /// Add Review Image Url
  String get addNotificationUrl =>
      '${APIService.baseUrl.replaceAll('credeze/', '')}$this';

  /// Return value with negative sign if greater than 0
  String? formatAsOfferAmount() {
    final parsedOfferAmount = double.tryParse(toString()) ?? 0.0;
    return parsedOfferAmount > 0
        ? '- ${parsedOfferAmount.toStringAsFixed(2)}'
        : '0.00';
  }

  /// Return value with negative sign and Currency if greater than 0
  String? formatAsOfferAmountCurrency() {
    final parsedOfferAmount = double.tryParse(toString()) ?? 0.0;
    return parsedOfferAmount > 0
        ? '- ${CommonUtilities.AppCurrency} ${parsedOfferAmount.toStringAsFixed(2)}'
        : ' ${CommonUtilities.AppCurrency} 0.00';
  }

  /// TO launch URLs
  Future<void> launchUri() async {
    if (this?.isNotEmpty ?? false) {
      final Uri _uri = Uri.parse(this!);
      try {
        await launchUrl(_uri);
      } on Exception catch (e) {
        // logE(e);
      }
    }
  }

  String get cascading => this?.toUpperCase().replaceAll(' ', '_') ?? '';
}

extension StringExt on String {
  ///
  bool get isPhone {
    if (length > 16 || length < 9) {
      return false;
    }

    final RegExp phone = RegExp(r'^\+?\d{0,3}\d{9,16}$');
    return phone.hasMatch(this ?? '');
  }

  ///
  bool get areAllCharactersZero {
    for (int i = 0; i < length; i++) {
      if (this[i] != '0') {
        return false;
      }
    }
    return true;
  }
}
