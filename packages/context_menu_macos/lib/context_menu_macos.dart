import 'package:context_menu_api/context_menu_api.dart';
import 'package:flutter/services.dart';

class ContextMenuMacos extends ContextMenuApi {
  @override
  MethodChannel get channel => const MethodChannel('context_menu_macos');

  static void registerWith() {
    ContextMenuApi.instance = ContextMenuMacos();
  }

  @override
  Future<ContextMenuItemBase?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  }) async {
    final selectedItemId = await _channel.invokeMethod<int?>(
      'showContextMenu',
      menuItems.map((menuItem) => menuItem.toJson()).toList(),
    );

    if (selectedItemId == null) {
      return null;
    }

    return menuItems.elementAt(selectedItemId);
  }
}
