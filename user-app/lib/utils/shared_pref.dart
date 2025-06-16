import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late final SharedPreferences instance;

  //getter String
  static String? getString(String key) => instance.getString(key);

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();
}
