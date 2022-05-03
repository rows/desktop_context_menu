import 'package:desktop_context_menu_platform_interface/desktop_context_menu_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('desktop_context_menu_macos');

class DesktopContextMenuMacos extends DesktopContextMenuPlatform {
  @visibleForTesting
  MethodChannel get channel => _channel;

  /// Registers this class as the default instance
  /// of [DesktopContextMenuPlatform].
  static void registerWith() {
    DesktopContextMenuPlatform.instance = DesktopContextMenuMacos();
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
