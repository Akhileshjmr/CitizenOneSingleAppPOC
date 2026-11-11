import '../../../../data/models/lms_models/loan_product_models/GdbMerchantDisProductListRequest.dart';

abstract class ProductsListEvent {}

class ProductsListSubmitted extends ProductsListEvent {
  final GdbMerchantDisProductListRequest gdbMerchantDisProductPurRequest;
  ProductsListSubmitted(this.gdbMerchantDisProductPurRequest);
}
