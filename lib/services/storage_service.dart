import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/lace_model.dart';
import '../models/inquiry_model.dart';
import '../models/order_model.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static const _kLaces = 'laces';
  static const _kInquiries = 'inquiries';
  static const _kOrders = 'orders';
  static const _kAdminLoggedIn = 'admin_logged_in';
  static const _kAdminEmail = 'admin_email';
  static const _kAdminPassword = 'admin_password';
  static const _kDarkMode = 'dark_mode';
  static const _kWhatsAppNumber = 'whatsapp_number'; // નવું ઉમેર્યું

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ADMIN CREDENTIALS
  static String get adminEmail => _prefs.getString(_kAdminEmail) ?? 'lacehub108@gmail.com';
  static String get adminPassword => _prefs.getString(_kAdminPassword) ?? 'kakadiya108';

  static Future<void> setAdminCredentials(String email, String password) async {
    await _prefs.setString(_kAdminEmail, email);
    await _prefs.setString(_kAdminPassword, password);
  }

  static bool get isAdminLoggedIn => _prefs.getBool(_kAdminLoggedIn) ?? false;
  static Future<void> setAdminLoggedIn(bool value) async {
    await _prefs.setBool(_kAdminLoggedIn, value);
  }

  // WHATSAPP NUMBER (નવું ઉમેર્યું)
  static String get whatsappNumber => _prefs.getString(_kWhatsAppNumber) ?? '+919999999999';
  static Future<void> setWhatsAppNumber(String number) async {
    await _prefs.setString(_kWhatsAppNumber, number);
  }

  // THEME
  static bool get isDarkMode => _prefs.getBool(_kDarkMode) ?? true;
  static Future<void> setDarkMode(bool v) async {
    await _prefs.setBool(_kDarkMode, v);
  }

  // LACES
  static List<LaceModel> getLaces() {
    final raw = _prefs.getString(_kLaces);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => LaceModel.fromJson(e)).toList();
  }

  static Future<void> saveLaces(List<LaceModel> laces) async {
    await _prefs.setString(_kLaces, jsonEncode(laces.map((e) => e.toJson()).toList()));
  }

  // INQUIRIES
  static List<InquiryModel> getInquiries() {
    final raw = _prefs.getString(_kInquiries);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => InquiryModel.fromJson(e)).toList();
  }

  static Future<void> saveInquiries(List<InquiryModel> list) async {
    await _prefs.setString(_kInquiries, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  // ORDERS
  static List<OrderModel> getOrders() {
    final raw = _prefs.getString(_kOrders);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => OrderModel.fromJson(e)).toList();
  }

  static Future<void> saveOrders(List<OrderModel> list) async {
    await _prefs.setString(_kOrders, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  // IMAGE PERSIST
  static Future<String> persistImage(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final laceDir = Directory('${dir.path}/lace_images');
    if (!await laceDir.exists()) await laceDir.create(recursive: true);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${sourcePath.split('/').last}';
    final newPath = '${laceDir.path}/$fileName';
    await File(sourcePath).copy(newPath);
    return newPath;
  }
}