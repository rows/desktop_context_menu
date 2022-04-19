import 'dart:async';

import 'package:context_menu_api/context_menu_api.dart';
import 'package:flutter/services.dart';

class ContextMenuWindows extends ContextMenuApi {
  static const MethodChannel _channel = MethodChannel('context_menu_windows');

  static void registerWith() {
    ContextMenuApi.instance = ContextMenuWindows();
  }

  @override
  Future<ContextMenuItem?> showContextMenu({
    required List<ContextMenuItem> menuItems,
  }) {
    throw UnimplementedError();
  }
}
