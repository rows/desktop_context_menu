import 'package:context_menu_plugin_platform_interface/context_menu_plugin_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('context_menu_macos');

class ContextMenuMacos extends ContextMenuPluginPlatform {
  @visibleForTesting
  MethodChannel get channel => _channel;

  /// Registers this class as the default instance
  /// of [ContextMenuPluginPlatform].
  static void registerWith() {
    ContextMenuPluginPlatform.instance = ContextMenuMacos();
  }

  @override
  Future<ContextMenuItem?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  }) async {
    final selectedItemId = await _channel.invokeMethod<int?>(
      'showContextMenu',
      menuItems.map((menuItem) => menuItem.toJson()).toList(),
    );

    if (selectedItemId == null) {
      return null;
    }

    return menuItems.elementAt(selectedItemId) as ContextMenuItem;
  }
}
