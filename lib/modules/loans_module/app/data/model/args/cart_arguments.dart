
// Arguments to be passed when opening the quiz
class CartArguments {

  /// Arguments to be passed when opening the quiz
  CartArguments({
    this.orderId,
  });

  /// Either [Sporting] or [Learning]
  final String? orderId;
}

class CgStatusArguments {

  /// Arguments to be passed when opening the quiz
  CgStatusArguments({
    this.orderId,
    this.catType,
    this.refId,
    this.isFinance,
    this.amount,
  });

  /// Either [Sporting] or [Learning]
  final String? orderId;
  final String? catType;
  final String? refId;
  final bool? isFinance;
  final String? amount;
}