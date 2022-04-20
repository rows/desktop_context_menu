import 'dart:ui';

/// The type of the context menu item.
///
/// It can be a standard menu item that has text and an action or a divider
/// between menu items.
enum _ContextMenuItemType {
  standard,
  separator,
}

/// A class that represents each menu item of the context menu.
///
/// [ContextMenuItem.separator] is to create a divider between menu items.
class ContextMenuItem {
  /// The title of the context menu item.
  final String? title;

  /// Callback invoked when a menu item is tapped.
  final VoidCallback? onTap;

  final _ContextMenuItemType _type;

  const ContextMenuItem({
    required this.title,
    this.onTap,
  }) : _type = _ContextMenuItemType.standard;

  /// Creates a separator between menu items.
  const ContextMenuItem.separator()
      : title = null,
        onTap = null,
        _type = _ContextMenuItemType.separator;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'enabled': onTap != null,
      'type': _type.name,
    };
  }
}

/// The common interface in which all platform implementations of context menu
/// should comply to.
abstract class ContextMenuApi {
  static ContextMenuApi instance = _UnsupportedPlatformContextMenuApi();

  /// Shows the context menu with the given [menuItems] at the pointer position.
  Future<ContextMenuItem?> showContextMenu({
    required Iterable<ContextMenuItem> menuItems,
  });
}

/// Empty context menu implementation that throws an exception for unsupported
/// platforms.
class _UnsupportedPlatformContextMenuApi extends ContextMenuApi {
  @override
  Future<ContextMenuItem?> showContextMenu({
    required Iterable<ContextMenuItem> menuItems,
  }) {
    throw UnimplementedError(
      'Context menu plugin not implemented in this platform.',
    );
  }
}
