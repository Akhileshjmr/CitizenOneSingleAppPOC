class ChatButton {
  ChatButton({
    required this.title,
    required this.payload,
  });

  factory ChatButton.fromJson(Map<String, dynamic> json) => ChatButton(
        title: json['title'] ?? '',
        payload: json['payload'] ?? '',
      );
  final String title;
  final String payload;
}
