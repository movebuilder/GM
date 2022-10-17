import 'package:intl/intl.dart';

class ChatList {
  String address = '';
  String nftImg = '';
  String timestamp = '';
  String content = '';
  bool newMatch = false;

  String get showDate {
    if (timestamp.isEmpty) return '';
    var inputFormat = DateFormat('dd/MM/yyyy');
    var dateTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp));
    return inputFormat.format(dateTime);
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
