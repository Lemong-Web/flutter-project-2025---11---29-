import 'package:flutter/material.dart';

class ControllerManager extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();

  void setText(String text) {
    if (controller.text != text) {
      controller.text = text;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}