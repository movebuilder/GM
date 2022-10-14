
class MessageInfo {
  final String sender;
  final String timestamp;

  MessageInfo(this.sender, this.timestamp);

  factory MessageInfo.fromJson(Map<String, dynamic> data) {
    return MessageInfo(data["sender"], data["timestamp"]);
  }

  Map<String, String> toJson() {
    return { "sender": sender, "timestamp": timestamp };
  }
}

class ChatMessage {

  final String content;
  final MessageInfo info;

  ChatMessage(this.content, this.info);

  factory ChatMessage.fromJson(Map<String, dynamic> data) {
    return ChatMessage(data["content"], MessageInfo.fromJson(data["info"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "info": info.toJson()
    };
  }

}