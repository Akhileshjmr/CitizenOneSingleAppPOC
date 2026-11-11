import '../../../../data/models/lms_models/term_deposit_models/TdAccOpeningRequest.dart';

abstract class TdAccountOpeningEvent {}

class TdAccountOpeningSubmitted extends TdAccountOpeningEvent {
  final TdAccOpeningRequest tdAccOpeningRequest;
  TdAccountOpeningSubmitted(this.tdAccOpeningRequest);
}
