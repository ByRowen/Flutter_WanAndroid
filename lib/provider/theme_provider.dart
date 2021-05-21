import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider with ChangeNotifier{
  String _themeColor;

  String get themeColor =>_themeColor;

  getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var _themeKey = pref.getString("theme_color");
    setTheme(_themeKey==null?"defalut":_themeKey);
  }

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }

}