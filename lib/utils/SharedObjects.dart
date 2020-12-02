import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietagri/config/Constants.dart';

class SharedObjects {
  static CachedSharedPreferences prefs;
}

class CachedSharedPreferences {
  static SharedPreferences sharedPreferences;
  static CachedSharedPreferences instance;
  static final cachedKeyList = [
    Constants.userLatitude,
    Constants.userLongitude
  ];

  static Map<String, dynamic> map = Map();

  static Future<CachedSharedPreferences> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    for (String key in cachedKeyList) {
      map[key] = sharedPreferences.get(key);
    }
    if (instance == null) instance = CachedSharedPreferences();
    return instance;
  }

  dynamic getValue(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.get(key);
  }

  Future<bool> setValue(String key, dynamic value, String type) async {
    bool result;
    switch (type) {
      case 'string': result = await sharedPreferences.setString(key, value); break;
      case 'bool': result = await sharedPreferences.setBool(key, value); break;
      case 'double': result = await sharedPreferences.setDouble(key, value); break;
    }
    if (result) map[key] = value;
    return result;
  }
}
