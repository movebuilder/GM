import 'package:gm/aptos/transaction/chat_message.dart';
import 'package:gm/data/db/storage_manager.dart';

class ChatUtil {
  static Future<void> updateChatList(
      ChatMessage message, String toAddress) async {
    var list = StorageManager.getChatShortList();
    list.forEach((element) {
      if (element.address == toAddress) {
        if (element.timestamp.compareTo(message.info.timestamp) < 0) {
          element.content = message.content;
          element.timestamp = message.info.timestamp;
          element.newMatch = false;
        }
      }
    });
    await StorageManager.setChatShortList(list);
  }
}
