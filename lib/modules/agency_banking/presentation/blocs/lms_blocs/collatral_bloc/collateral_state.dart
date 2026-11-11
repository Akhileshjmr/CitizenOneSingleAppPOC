

import '../../../../data/models/lms_models/loan_product_models/CollateralDetailsReqRes.dart';

abstract class CollateralState {}

class CollateralInitial extends CollateralState {}

class CollateralLoading extends CollateralState {}

class CollateralSuccess extends CollateralState {
  final String? message;
  final CollateralDetailsReqRes collateralDetailsReqRes;
  CollateralSuccess(this.message,this.collateralDetailsReqRes);
}

class CollateralFailure extends CollateralState {
  final String? error;
  CollateralFailure(this.error);
}