import 'package:flutter/material.dart';

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

  /// The shortcut that appears on the right of a menu item.
  final SingleActivator? shortcut;

  final _ContextMenuItemType _type;

  const ContextMenuItem({
    required this.title,
    this.onTap,
    this.shortcut,
  }) : _type = _ContextMenuItemType.standard;

  /// Creates a separator between menu items.
  const ContextMenuItem.separator()
      : title = null,
        onTap = null,
        shortcut = null,
        _type = _ContextMenuItemType.separator;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'enabled': onTap != null,
      'shortcut': shortcut?.toJson(),
      'type': _type.name,
    };
  }
}

extension on SingleActivator {
  /// Map the [SingleActivator] info to json to pass it through
  /// the platform communication channel.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'alt': alt,
      'control': control,
      'command': meta,
      'shift': shift,

      // If `keyEquivalent` is defined with an upper case letter in MacOS, it
      // will automatically add a SHIFT modifier to the shortcut.
      'key': trigger.keyLabel.toLowerCase(),
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
