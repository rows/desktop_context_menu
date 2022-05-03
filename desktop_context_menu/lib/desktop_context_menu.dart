import 'package:desktop_context_menu_platform_interface/desktop_context_menu_platform_interface.dart';

export 'package:desktop_context_menu_platform_interface/desktop_context_menu_platform_interface.dart'
    show ContextMenuItem, ContextMenuSeparator;

/// Exposes a simple API to show a context menu at the mouse coordinates.
Future<ContextMenuItem?> showContextMenu({
  required Iterable<ContextMenuItemBase> menuItems,
}) {
  final platform = DesktopContextMenuPlatform.instance;

  return platform.showContextMenu(menuItems: menuItems);
}
