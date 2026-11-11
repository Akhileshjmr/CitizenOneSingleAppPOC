import '../../../../data/models/lms_models/loan_product_models/GdbMerchantDisProductListResponse.dart';

abstract class ProductsListState {}

class ProductsListInitial extends ProductsListState {}

class ProductsListLoading extends ProductsListState {}

class ProductsListSuccess extends ProductsListState {
  final String? message;
  final GdbMerchantDisProductListResponse gdbMerchantDisProductPurResponse;
  ProductsListSuccess(this.message,this.gdbMerchantDisProductPurResponse);
}

class ProductsListFailure extends ProductsListState {
  final String? error;
  ProductsListFailure(this.error);
}
