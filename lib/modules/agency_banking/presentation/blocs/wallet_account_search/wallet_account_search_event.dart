import '../../../data/models/CommWalletAccountRequest.dart';

abstract class WalletSearchEvent {}

class WalletSearchSubmitted extends WalletSearchEvent {
  final CommWalletAccountRequest WalletSearchRequest;
  WalletSearchSubmitted(this.WalletSearchRequest);
}


