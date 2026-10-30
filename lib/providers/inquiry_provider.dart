import 'package:flutter/material.dart';
import '../models/inquiry_model.dart';
import '../services/storage_service.dart';

class InquiryProvider extends ChangeNotifier {
  final List<InquiryModel> _items = StorageService.getInquiries();
  List<InquiryModel> get items => _items;

  int get unreadCount => _items.where((e) => !e.isRead).length;

  Future<void> add(InquiryModel item) async {
    _items.insert(0, item);
    await StorageService.saveInquiries(_items);
    notifyListeners();
  }

  Future<void> markRead(String id) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i != -1 && !_items[i].isRead) {
      _items[i] = _items[i].copyWith(isRead: true);
      await StorageService.saveInquiries(_items);
      notifyListeners();
    }
  }

  Future<void> updateStatus(String id, String status) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i != -1) {
      _items[i] = _items[i].copyWith(status: status);
      await StorageService.saveInquiries(_items);
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
    await StorageService.saveInquiries(_items);
    notifyListeners();
  }
}