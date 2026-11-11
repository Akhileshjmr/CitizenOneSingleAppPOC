// chatbot_state.dart
import 'package:equatable/equatable.dart';
import '../../../data/models/chatbot_models/chat_response.dart';

abstract class ChatbotState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotSuccess extends ChatbotState {
  final List<ChatbotMessage> messages;
  ChatbotSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatbotFailure extends ChatbotState {
  final String error;
  ChatbotFailure(this.error);

  @override
  List<Object?> get props => [error];
}
