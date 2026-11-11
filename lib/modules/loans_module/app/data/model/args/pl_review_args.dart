import 'package:get/get.dart';

/// Specifications for customer interest
class PLReviewArgs {

  /// Specifications to open the PDF
  PLReviewArgs({
    required this.controller,
  });

  /// request secure key
  final List<GetxController> controller;
}