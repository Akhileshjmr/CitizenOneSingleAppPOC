// chatbot_event.dart
import 'package:equatable/equatable.dart';

import '../../../data/models/chatbot_models/chat_button.dart';

abstract class ChatbotEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendChatMessage extends ChatbotEvent {
  final ChatButton data;
  SendChatMessage(this.data);

  @override
  List<Object?> get props => [data];
}
