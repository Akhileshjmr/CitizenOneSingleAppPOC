import '../../../data/models/CommLanguageLabels.dart';
import '../../../data/models/CommWalletAccountRequest.dart';

abstract class LanguageLabelsEvent {}

class LanguageLabelsSubmitted extends LanguageLabelsEvent {
  final CommLanguageLabels commLanguageLabels;
  LanguageLabelsSubmitted(this.commLanguageLabels);
}


