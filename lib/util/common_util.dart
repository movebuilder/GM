import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:gm/data/db/storage_manager.dart';
import 'package:gm/modal/account_nft_list.dart';

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

extension SizeExtension on Decimal {
  String get showBalance =>
      Decimal.parse(toDouble().toStringAsFixed(8)).toString();
}
