import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:gm/modal/chat_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static late SharedPreferences _sharedPreferences;

  static SharedPreferences get sharedPreferences => _sharedPreferences;

  static const String _address = "_address";

  static const String _first_install = "_first_install";

  static const String _account_balance = "_account_balance";

  static const String _chat_short_list = "_chat_short_list";

  static const String _chat_enable = "_chat_enable";

  static const String _chat_match_address = "_chat_match_address";

  static const String _chat_unMatch_address = "_chat_unMatch_address";

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setAddress(String address) async =>
      await _sharedPreferences.setString(_address, address);

  static String getAddress() => _sharedPreferences.getString(_address) ?? "";

  static Future<bool> setFirstInstall(bool first) async =>
      await _sharedPreferences.setBool(_first_install, first);

  static bool getFirstInstall() =>
      _sharedPreferences.getBool(_first_install) ?? true;

  static Future<bool> setBalance(Decimal balance) async =>
      await _sharedPreferences.setString(_account_balance, balance.toString());

  static Decimal getBalance() =>
      Decimal.parse(_sharedPreferences.getString(_account_balance) ?? "0");

  static Future<bool> setChatShortList(List<ChatList> history) async {
    List<String> jsonList = history.map((e) => jsonEncode(e.toJson())).toList();
    return await _sharedPreferences.setStringList(_chat_short_list, jsonList);
  }

  static List<ChatList> getChatShortList() {
    List<String>? stringList =
        _sharedPreferences.getStringList(_chat_short_list);
    List<ChatList> history = [];
    try {
      if (stringList != null && stringList.length > 0) {
        history =
            stringList.map((e) => ChatList.fromJson(jsonDecode(e))).toList();
      }
    } catch (e) {
      _sharedPreferences.remove(_chat_short_list);
    }
    return history;
  }

  static Future<bool> setChatEnable(Map<String, bool> map) async {
    return await _sharedPreferences.setString(_chat_enable, jsonEncode(map));
  }

  static Map<String, bool> getChatEnable() {
    String content = _sharedPreferences.getString(_chat_enable) ?? "";
    Map<String, bool> map = Map();
    try {
      if (content.isNotEmpty) {
        map = jsonDecode(content);
      }
    } catch (e) {
      _sharedPreferences.remove(_chat_enable);
    }
    return map;
  }

  static Future<bool> addChatMatchAddress(String address) async {
    List<String> addresses = getChatMatchAddress();
    if (!addresses.contains(address)) {
      addresses.add(address);
    }
    return await setChatMatchAddress(addresses);
  }

  static Future<bool> setChatMatchAddress(List<String> list) async {
    return await _sharedPreferences.setStringList(_chat_match_address, list);
  }

  static List<String> getChatMatchAddress() {
    List<String>? stringList =
        _sharedPreferences.getStringList(_chat_match_address);
    if (stringList == null) {
      stringList = [];
    }
    return stringList;
  }

  static Future<bool> addUnChatMatchAddress(String address) async {
    List<String> addresses = getChatMatchAddress();
    if (!addresses.contains(address)) {
      addresses.add(address);
    }
    return await setChatMatchAddress(addresses);
  }

  static Future<bool> setUnChatMatchAddress(List<String> list) async {
    return await _sharedPreferences.setStringList(_chat_unMatch_address, list);
  }

  static List<String> getUnChatMatchAddress() {
    List<String>? stringList =
        _sharedPreferences.getStringList(_chat_unMatch_address);
    if (stringList == null) {
      stringList = [];
    }
    return stringList;
  }

  static Future<bool?> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_address);
    prefs.remove(_account_balance);
  }

  static bool login() => StorageManager.getAddress().isEmpty ? false : true;
}
