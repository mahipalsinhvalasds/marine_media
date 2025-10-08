// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class AppModel with ChangeNotifier {
//   bool isLoading = true;
//   Locale _Locale = const Locale("en");

//   void attach() async {
//     notifyListeners();
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {
   bool isLoading = true;
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  AppModel() {
    _loadSavedLocale();
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language_code', newLocale.toString());
    notifyListeners();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('selected_language_code') ?? 'en';
    _locale = _parseLocale(code);
    notifyListeners();
  }

  Locale _parseLocale(String code) {
    if (code.contains('_')) {
      final parts = code.split('_');
      return Locale.fromSubtags(languageCode: parts[0], countryCode: parts[1]);
    }
    return Locale(code);
  }
}
