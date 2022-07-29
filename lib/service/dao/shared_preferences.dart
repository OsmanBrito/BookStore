import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static insert(String books) {
    _prefs.setString(keySharedPreferences, books);
  }

  static String getFavoriteBooks() {
    return _prefs.getString(keySharedPreferences) ?? "";
  }
}

const String keySharedPreferences = "favorite_books";
