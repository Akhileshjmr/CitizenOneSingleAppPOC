///
class PLChatArguments {

  /// Arguments to be passed when opening the quiz
  PLChatArguments({
    this.chatId,
    required this.applicationId,
    required this.loanType,
  });

  /// Either [Sporting] or [Learning]
  final String? chatId;
  ///
  final String applicationId;
  final String loanType;

}