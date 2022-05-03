import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../platform_interface/context_menu_plugin_platform.dart';
import '../types/types.dart';

const MethodChannel _channel = MethodChannel('context_menu_plugin');

/// An implementation of [ContextMenuPluginPlatform] that uses method channels.
class MethodChannelContextMenuPlugin extends ContextMenuPluginPlatform {
  @visibleForTesting
  MethodChannel get channel => _channel;

  @override
  Future<ContextMenuItem?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  }) async {
    throw UnimplementedError(
      'Context menu plugin not implemented in this platform.',
    );
  }
}
