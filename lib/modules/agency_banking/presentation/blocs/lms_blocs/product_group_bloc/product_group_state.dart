import '../../../../data/models/lms_models/loan_product_models/GdbProductGroupResponse.dart';

abstract class ProductGroupState {}

class ProductGroupInitial extends ProductGroupState {}

class ProductGroupLoading extends ProductGroupState {}

class ProductGroupSuccess extends ProductGroupState {
  final GdbProductGroupResponse productGroup;
  final String? message;

  ProductGroupSuccess(this.productGroup, this.message);
}

class ProductGroupFailure extends ProductGroupState {
  final String? error;

  ProductGroupFailure(this.error);
}