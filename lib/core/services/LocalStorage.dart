import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  static final LocalStorage _singleton = LocalStorage._internal();
  SharedPreferences? prefs;

  factory LocalStorage()  {
    return _singleton;
  }

  loadPreferences()  async {
    this.prefs = await SharedPreferences.getInstance();
  }

  storageValueJSON(String key, Object value) {
    this.prefs!.setString(key, jsonEncode(value));
  }

  removeKeyJSON(String key) {
    this.prefs!.remove(key);
  }

  Map<String, dynamic> getValueJSON(String key) {
    final value = this.prefs!.getString(key);
    if (value != null) {
      return jsonDecode(value);
    }

    return {};
  }

  LocalStorage._internal();


}