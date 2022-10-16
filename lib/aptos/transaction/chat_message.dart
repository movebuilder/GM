
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
  // 1: pending, 2: done
  final int status;

  ChatMessage(this.content, this.info, this.status);

  factory ChatMessage.fromJson(Map<String, dynamic> data) {
    return ChatMessage(
      data["content"],
      MessageInfo.fromJson(data["info"]),
      int.parse(data["status"] ?? "0"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "info": info.toJson()
    };
  }

}