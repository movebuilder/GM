class MessageInfo {
  final String sender;
  final String timestamp;

  MessageInfo(this.sender, this.timestamp);

  factory MessageInfo.fromJson(Map<String, dynamic> data) {
    return MessageInfo(data["sender"], data["timestamp"]);
  }

  Map<String, String> toJson() {
    return {"sender": sender, "timestamp": timestamp};
  }
}

class ChatMessage {
  final String content;
  String hash = '';
  final MessageInfo info;

  // 1: pending, 2: done
  int status;
  String transferNum;

  ChatMessage(
    this.content,
    this.info, {
    this.status = 0,
    this.hash = '',
    this.transferNum = '',
  });

  factory ChatMessage.fromJson(Map<String, dynamic> data) {
    return ChatMessage(
      data["content"],
      MessageInfo.fromJson(data["info"]),
      status: int.parse(data["status"] ?? "0"),
      hash: data["hash"] ?? '',
      transferNum: data["transferNum"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "hash": hash,
      "transferNum": transferNum,
      "status": status,
      "info": info.toJson()
    };
  }
}
