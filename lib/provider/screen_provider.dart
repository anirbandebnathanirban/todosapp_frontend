import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  bool isLoading = false;

  ScreenProvider() {
    _init();
  }

  void _init() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
    notifyListeners();
  }
}