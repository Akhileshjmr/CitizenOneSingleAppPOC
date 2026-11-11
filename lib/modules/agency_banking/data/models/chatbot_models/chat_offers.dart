class ChatOffer {
  ChatOffer({
    required this.description,
    this.imageUrl,
  });

  factory ChatOffer.fromJson(Map<String, dynamic> json) => ChatOffer(
        description: json['description'] ?? '',
        imageUrl: json['imageUrl'],
      );

  final String description;
  final String? imageUrl;
}
