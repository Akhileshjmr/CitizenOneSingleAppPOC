// lib/app/modules/bid_chat/controllers/bid_chat_controller.dart
import 'dart:async';

import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/chat/chat_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/provider/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxList<Chat> messages = <Chat>[].obs;
  RxBool isLoading = true.obs;
  Timer? _timer;
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late final String bidId;
  late final String userType;

  @override
  void onInit() async {
    super.onInit();
    bidId = Get.arguments['bid_id'];
    userType = (UserPrefs.user?.role ?? "").toUpperCase();
    await fetchMessages();
    Future.delayed(Duration(milliseconds: 100), () {
      scrollToBottom();
    });
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchMessages();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> fetchMessages() async {
    try {
      dynamic request = {
        "addiParams": [bidId],
        "reqSecureKey": UserPrefs.user?.userId ?? '',
      };

      ChatResponse? response = await ChatService.getChatDet(
        requestBody: request,
      );

      messages.assignAll(response?.chats ?? []);

      isLoading(false);

      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    } catch (e) {
      isLoading(false);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    dynamic request = {
      "bidId": bidId,
      "chats": [
        {"msg": text, "msgByType": userType},
      ],
      "id": UserPrefs.user?.userId ?? '',
    };
    final response = await ChatService.saveChatMessage(requestBody: request);
    print(response);
    await fetchMessages();
  }
}

class MessageModel {
  final String text;
  final bool isMe;
  final String timeString;

  MessageModel({
    required this.text,
    required this.isMe,
    required this.timeString,
  });
}
