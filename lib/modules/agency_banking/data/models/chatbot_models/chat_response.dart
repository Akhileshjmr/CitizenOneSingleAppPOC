import 'chat_button.dart';
import 'chat_offers.dart';
import 'chat_order_item_model.dart';

/// Root response model
class ChatbotResponse {
  ///
  ChatbotResponse({required this.responses});

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) =>
      ChatbotResponse(
        responses: (json['responses'] as List)
            .map((e) => ChatbotMessage.fromJson(e))
            .toList(),
      );
  final List<ChatbotMessage> responses;
}

/// Chat response message
class ChatbotMessage {
  ///
  ChatbotMessage({
    required this.text,
    required this.buttons,
    required this.orderItems,
    this.invoice,
    this.isUserMessage = false,
    required this.offers,
  });

  factory ChatbotMessage.fromJson(Map<String, dynamic> json) => ChatbotMessage(
        text: json['text'] ?? '',
        buttons: (json['buttons'] as List)
            .map((e) => ChatButton.fromJson(e))
            .toList(),
        orderItems: (json['orderItems'] as List<dynamic>?)
                ?.map((o) => ChatOrderItemModel.fromJson(o))
                .toList() ??
            [],
        isUserMessage: false,
        offers: (json['offers'] as List<dynamic>? ?? [])
            .map((o) => ChatOffer.fromJson(o))
            .toList(),
        invoice: json['invoice'],
      );

  final String text;
  final List<ChatButton> buttons;
  final List<ChatOrderItemModel> orderItems;
  final bool isUserMessage;
  final String? invoice;
  final List<ChatOffer> offers;
}

// ///
// class ChatButton {
//   ///
//   ChatButton({required this.title, required this.payload});
//
//   factory ChatButton.fromJson(Map<String, dynamic> json) => ChatButton(
//         title: json['title'] ?? '',
//         payload: json['payload'] ?? '',
//       );
//
//   ///
//   final String title;
//
//   ///
//   final String payload;
// }
