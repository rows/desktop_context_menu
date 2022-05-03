import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../platform_interface/desktop_context_menu_platform.dart';
import '../types/types.dart';

const MethodChannel _channel = MethodChannel('desktop_context_menu');

/// An implementation of [DesktopContextMenuPlatform] that uses method channels.
class MethodChannelDesktopContextMenu extends DesktopContextMenuPlatform {
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
