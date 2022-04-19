import 'dart:async';

import 'package:context_menu_api/context_menu_api.dart';
import 'package:flutter/services.dart';

class ContextMenuMacos extends ContextMenuApi {
  static const MethodChannel _channel = MethodChannel('context_menu_macos');

  static void registerWith() {
    ContextMenuApi.instance = ContextMenuMacos();
  }

  @override
  Future<String?> get platformVersion async {
    final version = await _channel.invokeMethod<String?>('getPlatformVersion');
    return version;
  }
}
