import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static late SharedPreferences _sharedPreferences;

  static SharedPreferences get sharedPreferences => _sharedPreferences;

  static const String _address = "_address";

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setAddress(String address) async =>
      await _sharedPreferences.setString(_address, address);

  static String getAddress() => _sharedPreferences.getString(_address) ?? "";

  static Future<bool?> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_address);
  }

  static bool login() => StorageManager.getAddress().isEmpty ? false : true;
}
