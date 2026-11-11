import 'package:citizenone_app/modules/agency_banking/utils/UICleanupHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../data/models/chatbot_models/chat_button.dart';
import '../../../utils/CommSuccessDialogues.dart';
import '../../../utils/Loader.dart';
import '../../blocs/chatbot_bloc/chatbot_bloc.dart';
import '../../blocs/chatbot_bloc/chatbot_event.dart';
import '../../blocs/chatbot_bloc/chatbot_state.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Chatbot",
        showBack: true,
        showLogout: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocListener<ChatbotBloc, ChatbotState>(
              listener: (context, state) {
                if (state is ChatbotLoading) {
                  context.read<LoadingCubit>().show();
                } else {
                  context.read<LoadingCubit>().hide();
                }

                if (state is ChatbotFailure) {
                  showCustomBottomPopup(context, state.error);
                }
              },
              child: BlocBuilder<ChatbotBloc, ChatbotState>(
                builder: (context, state) {
                  if (state is ChatbotFailure) {
                    return Center(child: Text(state.error));
                  } else if (state is ChatbotSuccess) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        return Column(
                          crossAxisAlignment: msg.isUserMessage
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: msg.isUserMessage
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: msg.isUserMessage
                                      ? Colors.blue[100]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(msg.text),
                              ),
                            ),

                            if (!msg.isUserMessage)
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: msg.buttons.map((button) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[50],
                                      foregroundColor: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {
                                      final cleanedPayload = button.payload.startsWith("/")
                                          ? button.payload.substring(1)
                                          : button.payload;

                                      final chatButton = ChatButton(
                                        title: button.title,
                                        payload: cleanedPayload,
                                      );

                                      context.read<ChatbotBloc>().add(SendChatMessage(chatButton));
                                    },
                                    child: Text(button.title),
                                  );
                                }).toList(),
                              ),
                          ],
                        );
                      },
                    );
                  }
                  return const Center(child: Text("Start a conversation..."));
                },
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        final chatButton = ChatButton(
                          title: text,
                          payload: text,
                        );

                        context.read<ChatbotBloc>().add(SendChatMessage(chatButton));
                        _controller.clear();
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

// Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: const CustomAppBar(title: "Chatbot",
  //       showBack: true,
  //       showLogout: true,),
  //     body: Column(
  //       children: [
  //         // Messages list
  //         Expanded(
  //           child: BlocBuilder<ChatbotBloc, ChatbotState>(
  //             builder: (context, state) {
  //               if (state is ChatbotLoading) {
  //                  context.read<LoadingCubit>().show();
  //               } else if (state is ChatbotFailure) {
  //                 return Center(child: Text(state.error));
  //               } else if (state is ChatbotSuccess) {
  //                 return ListView.builder(
  //                   padding: const EdgeInsets.all(8),
  //                   itemCount: state.messages.length,
  //                   itemBuilder: (context, index) {
  //                     final msg = state.messages[index];
  //                     return Column(
  //                       crossAxisAlignment: msg.isUserMessage
  //                           ? CrossAxisAlignment.end
  //                           : CrossAxisAlignment.start,
  //                       children: [
  //                         // Message bubble
  //                         Align(
  //                           alignment: msg.isUserMessage
  //                               ? Alignment.centerRight
  //                               : Alignment.centerLeft,
  //                           child: Container(
  //                             margin: const EdgeInsets.symmetric(vertical: 4),
  //                             padding: const EdgeInsets.all(12),
  //                             decoration: BoxDecoration(
  //                               color: msg.isUserMessage
  //                                   ? Colors.blue[100]
  //                                   : Colors.grey[300],
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             child: Text(msg.text),
  //                           ),
  //                         ),
  //
  //                         // 👇 Show buttons if available
  //                         if (!msg.isUserMessage)
  //                           Wrap(
  //                             spacing: 8,
  //                             runSpacing: 4,
  //                             children: msg.buttons.map((button) {
  //                               return ElevatedButton(
  //                                 style: ElevatedButton.styleFrom(
  //                                   backgroundColor: Colors.blue[50],
  //                                   foregroundColor: Colors.blue[900],
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(20),
  //                                   ),
  //                                 ),
  //                                   onPressed: () {
  //                                     final cleanedPayload = button.payload.startsWith("/")
  //                                         ? button.payload.substring(1)
  //                                         : button.payload;
  //
  //                                     final chatButton = ChatButton(
  //                                       title: button.title,
  //                                       payload: cleanedPayload,
  //                                     );
  //
  //                                     context.read<ChatbotBloc>().add(SendChatMessage(chatButton));
  //
  //                                 },
  //                                 child: Text(button.title),
  //                               );
  //                             }).toList(),
  //                           ),
  //                       ],
  //                     );
  //                   },
  //                 );
  //
  //               }
  //               return const Center(child: Text("Start a conversation..."));
  //             },
  //           ),
  //         ),
  //
  //         // Input field
  //         SafeArea(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: TextField(
  //                     controller: _controller,
  //                     decoration: const InputDecoration(
  //                       hintText: "Type your message...",
  //                       border: OutlineInputBorder(),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 IconButton(
  //                   icon: const Icon(Icons.send),
  //                   onPressed: () {
  //                     final text = _controller.text.trim();
  //                     if (text.isNotEmpty) {
  //                       // Create dummy ChatButton (title + payload)
  //                       final chatButton = ChatButton(
  //                         title: text,
  //                         payload: text,
  //                       );
  //
  //                       context.read<ChatbotBloc>().add(SendChatMessage(chatButton));
  //                       _controller.clear();
  //                     }
  //                   },
  //                 )
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
