import 'package:context_menu_plugin_platform_interface/context_menu_plugin_platform_interface.dart';

export 'package:context_menu_plugin_platform_interface/context_menu_plugin_platform_interface.dart'
    show ContextMenuItem, ContextMenuSeparator;

/// Exposes a simple API to show a context menu at the mouse coordinates.
Future<ContextMenuItem?> showContextMenu({
  required Iterable<ContextMenuItemBase> menuItems,
}) {
  final platform = ContextMenuPluginPlatform.instance;

  return platform.showContextMenu(menuItems: menuItems);
}
