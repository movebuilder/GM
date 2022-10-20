import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/modal/account_nft_list.dart';
import 'package:intl/intl.dart';

interceptFormat(String? content, {int length = 6}) {
  if (content == null) return '';
  if (content.length > 2 * length) {
    return content.substring(0, length) +
        "..." +
        content.substring(content.length - length, content.length);
  }
  return content;
}

Future<List<AccountNftList>> getAccountNftList() async {
  List<AccountNftList> list = [];
  var content = await rootBundle.loadString("assets/json/nfts.json");
  var address1 = StorageManager.getChatMatchAddress();
  var address2 = StorageManager.getUnChatMatchAddress();
  var l = jsonDecode(content) as List;
  l.forEach((element) {
    var account = AccountNftList.fromJson(element);
    if (!address1.contains(account.address) &&
        !address2.contains(account.address)) {
      list.add(account);
    }
  });
  if (list.isEmpty) {
    l.forEach((element) {
      var account = AccountNftList.fromJson(element);
      if (!address1.contains(account.address)) {
        list.add(account);
      }
    });
  }
  return list;
}

chatShowTime(DateTime createAt, DateTime now) {
  final yesterday = now.subtract(new Duration(days: 1));
  final sevenDaysFromNow = now.subtract(new Duration(days: 7));
  DateFormat dateFormat = DateFormat("HH:mm");
  var time = '';
  if (createAt.isAfter(sevenDaysFromNow)) {
    if (createAt.day == now.day) {
      time = dateFormat.format(createAt);
    } else if (createAt.day == yesterday.day) {
      time = "Yesterday " + dateFormat.format(createAt);
    } else {
      dateFormat = DateFormat("EEEE HH:mm");
      time = dateFormat.format(createAt);
    }
  } else {
    if (createAt.year == now.year) {
      dateFormat = DateFormat("MM/dd HH:mm");
      time = dateFormat.format(createAt);
    } else {
      dateFormat = DateFormat("YYYY/MM/dd HH:mm");
      time = dateFormat.format(createAt);
    }
  }
  return time;
}

extension SizeExtension on Decimal {
  String get showBalance =>
      Decimal.parse(toDouble().toStringAsFixed(8)).toString();
}
