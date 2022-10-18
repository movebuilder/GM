import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
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
  var l = jsonDecode(content) as List;
  list = l.map((value) => AccountNftList.fromJson(value)).toList();
  return list;
}

extension SizeExtension on Decimal {
  String get showBalance =>
      Decimal.parse(toDouble().toStringAsFixed(8)).toString();
}
