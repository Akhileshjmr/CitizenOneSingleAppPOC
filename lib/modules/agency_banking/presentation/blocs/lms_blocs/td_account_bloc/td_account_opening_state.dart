import '../../../../data/models/lms_models/term_deposit_models/TdAccOpeningResponse.dart';

abstract class TdAccountOpeningState {}

class TdAccountOpeningInitial extends TdAccountOpeningState {}

class TdAccountOpeningLoading extends TdAccountOpeningState {}

class TdAccountOpeningSuccess extends TdAccountOpeningState {

  final TdAccOpeningResponse tdAccOpeningResponse;
  TdAccountOpeningSuccess(this.tdAccOpeningResponse);
}

class TdAccountOpeningFailure extends TdAccountOpeningState {
  final String? error;
  TdAccountOpeningFailure(this.error);
}
