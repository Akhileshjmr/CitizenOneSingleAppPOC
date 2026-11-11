import 'package:citizenone_app/modules/agrinet/app/data/model/chat/chat_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';

import '../../components/ui/ag_snackbar.dart';

class ChatService {
  static Future<ChatResponse?> getChatDet({required requestBody}) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.bitChat,
        data: requestBody,
      );
      if (response != null &&
          response.data != null &&
          response.statusCode == 200) {
        return ChatResponse.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
  }

  static Future<dynamic> saveChatMessage({required requestBody}) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.bitChatSave,
        data: requestBody,
      );
      if (response != null &&
          response.data != null &&
          response.statusCode == 200) {
        return response.data!;
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return false;
    }
  }
}
