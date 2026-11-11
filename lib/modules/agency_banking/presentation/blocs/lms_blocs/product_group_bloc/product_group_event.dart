import '../../../../data/models/lms_models/loan_product_models/GdbProductGroupRequest.dart';

abstract class ProductGroupEvent {}

class ProductGroupSubmitted extends ProductGroupEvent {

  final GdbProductGroupRequest productGroup;

  ProductGroupSubmitted(this.productGroup);
}