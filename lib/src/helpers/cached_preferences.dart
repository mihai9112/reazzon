import 'package:reazzon/src/helpers/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedObjects {
  static CachedPreferences prefs;
}

class CachedPreferences {
  static SharedPreferences sharedPreferences;
  static CachedPreferences instace;
  static final cachedKeyList = {
    Constants.sessionUid,
    Constants.sessionUsername
  };

  static Map<String, dynamic> map = Map();

  static Future<CachedPreferences> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if(
      sharedPreferences.getBool(Constants.firstRun) == null 
      || sharedPreferences.get(Constants.firstRun)) {
        await sharedPreferences.setBool(Constants.firstRun, false);
    }

    for (var key in cachedKeyList) {
      map[key] = sharedPreferences.get(key);
    }

    if(instace == null)
      instace = CachedPreferences();
    
    return instace;
  }

  String getString(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getString(key);
  }

  bool getBool(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getBool(key);
  }
  Future<bool> setString(String key, String value) async {
    bool result = await sharedPreferences.setString(key, value);
    if (result)
      map[key] = value;
    return result;
  }
  Future<bool> setBool(String key, bool value) async {
    bool result = await sharedPreferences.setBool(key, value);
    if (result)
      map[key] = value;
    return result;
  }
}