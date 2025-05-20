import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _uidKey = 'user_uid';

  static Future<void> saveUID(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
  }

  static Future<String?> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }

  static Future<void> clearUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_uidKey);
  }
}
