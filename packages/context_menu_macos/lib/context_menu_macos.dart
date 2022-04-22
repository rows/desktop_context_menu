import 'package:context_menu_api/context_menu_api.dart';
import 'package:flutter/services.dart';

class ContextMenuMacos extends ContextMenuApi {
  @override
  MethodChannel get channel => const MethodChannel('context_menu_macos');

  static void registerWith() {
    ContextMenuApi.instance = ContextMenuMacos();
  }
}
