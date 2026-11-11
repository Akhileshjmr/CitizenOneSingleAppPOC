import '../../../data/models/CommAccountRequest.dart';

abstract class AccountSearchEvent {}

class AccountSearchSubmitted extends AccountSearchEvent {
  final CommAccountRequest accountSearchRequest;
  AccountSearchSubmitted(this.accountSearchRequest);
}
