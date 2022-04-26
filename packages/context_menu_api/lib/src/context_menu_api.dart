import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The type of the context menu item.
///
/// It can be a standard menu item that has text and an action or a divider
/// between menu items.
enum _ContextMenuItemType {
  standard,
  separator,
}

/// A class that represents each item of the context menu.
abstract class ContextMenuItemBase {
  const ContextMenuItemBase();

  Map<String, dynamic> toJson();
}

/// A class that represents each standard menu item of the context menu.
class ContextMenuItem extends ContextMenuItemBase {
  /// The title of the context menu item.
  final String? title;

  /// Callback invoked when a menu item is tapped.
  final VoidCallback? onTap;

  /// The shortcut that appears on the right of a menu item.
  final SingleActivator? shortcut;

  const ContextMenuItem({
    required this.title,
    this.onTap,
    this.shortcut,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'enabled': onTap != null,
      'shortcut': shortcut?.toJson() ?? <String, dynamic>{},
      'type': _ContextMenuItemType.standard.name,
    };
  }
}

/// A class that represents a separator between menu items in the context menu.
class ContextMenuItemSeparator extends ContextMenuItemBase {
  const ContextMenuItemSeparator();

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': _ContextMenuItemType.separator.name,
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
      'key': trigger.keyLabel,
    };
  }
}

/// The common interface in which all platform implementations of context menu
/// should comply to.
abstract class ContextMenuApi {
  static ContextMenuApi instance = _UnsupportedPlatformContextMenuApi();

  /// Set the name of the channel that the platform will listen to in the native
  /// code.
  MethodChannel get channel;

  /// Shows the context menu with the given [menuItems] at the pointer position.
  Future<ContextMenuItem?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  }) async {
    final selectedItemId = await channel.invokeMethod<int?>(
      'showContextMenu',
      menuItems.map((menuItem) => menuItem.toJson()).toList(),
    );

    if (selectedItemId == null) {
      return null;
    }

    return menuItems.elementAt(selectedItemId) as ContextMenuItem;
  }
}

/// Empty context menu implementation that throws an exception for unsupported
/// platforms.
class _UnsupportedPlatformContextMenuApi extends ContextMenuApi {
  @override
  MethodChannel get channel => throw UnimplementedError();

  @override
  Future<ContextMenuItem?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  }) {
    throw UnimplementedError(
      'Context menu plugin not implemented in this platform.',
    );
  }
}
