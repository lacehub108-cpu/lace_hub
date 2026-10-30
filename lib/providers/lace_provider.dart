import 'package:flutter/material.dart';
import '../models/lace_model.dart';
import '../services/storage_service.dart';

class LaceProvider extends ChangeNotifier {
  final List<LaceModel> _laces = StorageService.getLaces();
  List<LaceModel> get laces => _laces;

  Future<void> addLace(LaceModel lace) async {
    _laces.add(lace);
    await StorageService.saveLaces(_laces);
    notifyListeners();
  }

  Future<void> deleteLace(String id) async {
    _laces.removeWhere((e) => e.id == id);
    await StorageService.saveLaces(_laces);
    notifyListeners();
  }
}