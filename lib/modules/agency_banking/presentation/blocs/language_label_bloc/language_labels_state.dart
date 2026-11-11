import 'package:citizenone_app/modules/agency_banking/data/models/CommLanguageLabels.dart';

abstract class LanguageLabelsState {}

class LanguageLabelsInitial extends LanguageLabelsState {}

class LanguageLabelsLoading extends LanguageLabelsState {}

class LanguageLabelsSuccess extends LanguageLabelsState {
  final String message;
  final CommLanguageLabels commLanguageLabels;
  LanguageLabelsSuccess(this.message, this.commLanguageLabels);
}

class LanguageLabelsFailure extends LanguageLabelsState {
  final String error;
  LanguageLabelsFailure(this.error);
}
