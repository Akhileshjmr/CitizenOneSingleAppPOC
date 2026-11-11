import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/chat/chat_response.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/chat/controllers/chat_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatView extends GetView<ChatController> {
  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F1ED),
      appBar: AgAppbar(title: 'Chats', showLogout: true),
      body: _body(),
    );
  }

  Widget _body() {
    final messages = controller.messages;
    return Obx(
      () =>
          controller.isLoading.value
              ? Center(child: AgLoader())
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: controller.scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Chat msg = messages[messages.length - 1 - index];
                        final isMe =
                            msg.msgByType?.toUpperCase() == controller.userType;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment:
                                isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.orange,
                                      child: Text(
                                        (msg.msgBy ?? "?")
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      msg.msgBy ?? '',
                                      style: kw300Primary10,
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    isMe
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  if (!isMe) const SizedBox(width: 40),

                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isMe
                                                ? const Color(0xFF6A78E6)
                                                : const Color(0xFF25D366),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(18),
                                          topRight: const Radius.circular(18),
                                          bottomLeft: Radius.circular(
                                            isMe ? 18 : 4,
                                          ),
                                          bottomRight: Radius.circular(
                                            isMe ? 4 : 18,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        msg.msg ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    isMe
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  if (!isMe) const SizedBox(width: 40),
                                  Text(
                                    msg.msgOn?.toString() ?? '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.inputController,
                              decoration: const InputDecoration(
                                hintText: 'Enter message',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final text = controller.inputController.text;
                              controller.inputController.clear();
                              await controller.sendMessage(text);
                            },
                            child: const Text('SEND'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
