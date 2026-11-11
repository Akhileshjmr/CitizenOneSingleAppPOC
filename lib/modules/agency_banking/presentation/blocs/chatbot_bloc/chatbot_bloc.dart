// chatbot_bloc.dart
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/chatbot_models/chat_response.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';


class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final AuthService authService;
  final List<ChatbotMessage> _messages = [];
ChatbotBloc(this.authService) : super(ChatbotInitial()) {
    on<SendChatMessage>(_onSendMessage);
  }

  Future<void> _onSendMessage(
      SendChatMessage event, Emitter<ChatbotState> emit) async {
    try {
      emit(ChatbotLoading());

      // User message
      _messages.add(ChatbotMessage(
        text: event.data.title,
        buttons: [],
        isUserMessage: true,
        orderItems: [],
        offers: [],
      ));

      // API call
      final ChatbotResponse? response =
      await authService.postChatbot(event.data.payload);

      if (response != null && response.responses.isNotEmpty) {
        _messages.addAll(response.responses);
      }

      emit(ChatbotSuccess(List.from(_messages)));
    } catch (err) {
      emit(ChatbotFailure("Something went wrong!"));
    }
  }
}
