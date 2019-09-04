import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static void storeUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Store User: ' + userId);

    await prefs.setString('user_id', userId);
  }

  static void deleteUserId() async =>
      await (await SharedPreferences.getInstance()).clear();

  static BehaviorSubject<bool> hasUserId() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    BehaviorSubject<bool> stream = BehaviorSubject<bool>();

    prefs.then((sharedPref) {
      bool isUidPresent = (sharedPref.getString('user_id') != null);
      if (isUidPresent == false) {
        Future.delayed(Duration(milliseconds: 1200), () {
          stream.add(isUidPresent);
        });
      } else {
        stream.add(isUidPresent);
      }
    });

    return stream;
  }

  static Future<String> retrieveUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('user_id');
  }
}
