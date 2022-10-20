class ChatList {
  String address = '';
  String nftImg = '';
  String timestamp = '';
  String content = '';
  bool newMatch = false;

  DateTime get dateTime {
    if (timestamp.isEmpty) return DateTime.now();
    return DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp));
  }

  ChatList({
    this.address = '',
    this.nftImg = '',
    this.timestamp = '',
    this.content = '',
    this.newMatch = false,
  });

  ChatList.fromJson(Map<String, dynamic> json) {
    address = json['address'] ?? "";
    nftImg = json['nftImg'] ?? "";
    timestamp = json['timestamp'] ?? "";
    content = json['content'] ?? "";
    newMatch = json['newMatch'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['nftImg'] = this.nftImg;
    data['timestamp'] = this.timestamp;
    data['content'] = this.content;
    data['newMatch'] = this.newMatch;
    return data;
  }
}
