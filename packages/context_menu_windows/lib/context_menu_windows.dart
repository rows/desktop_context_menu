import 'package:context_menu_api/context_menu_api.dart';
import 'package:flutter/services.dart';

class ContextMenuWindows extends ContextMenuApi {
  @override
  MethodChannel get channel => const MethodChannel('context_menu_windows');

  static void registerWith() {
    ContextMenuApi.instance = ContextMenuWindows();
  }
}
