import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  // ડેટા સીધો જ સ્ટોરેજમાંથી લોડ કરો, કન્સ્ટ્રક્ટરમાં કંઈ ના કરો
  bool _isDark = StorageService.isDarkMode;

  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    StorageService.setDarkMode(_isDark);
    notifyListeners(); // આ કૉલ ફક્ત યુઝર ક્લિક કરે ત્યારે જ થાય છે, જે બરાબર છે
  }

  ThemeMode get mode => _isDark ? ThemeMode.dark : ThemeMode.light;
}