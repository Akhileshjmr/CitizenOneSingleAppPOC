import 'package:get/get.dart';

class ContactUsController extends GetxController {
  //TODO: Implement ContactUsController
  final companyName = 'JMR Infotech Pvt Ltd';
  final addressLines = [
    'Beta Building, Sigma Soft Tech Park,',
    'Whitefield Main Road, Bengaluru,',
    'Karnataka 560066.',
  ];
  final phone = '7899294984';
  final email = 'test@gmail.com';

  // Uncomment if you add url_launcher
  /*
  Future<void> callNow() async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> sendMail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
  */
}
