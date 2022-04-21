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

  final _ContextMenuItemType _type;

  ContextMenuItem({
    required this.title,
    this.onTap,
    this.shortcut,
  }) : _type = _ContextMenuItemType.standard;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'enabled': onTap != null,
      'shortcut': shortcut?.toJson(),
      'type': _type.name,
    };
  }
}

/// A class that represents a separator between menu items in the context menu.
class ContextMenuItemSeparator extends ContextMenuItemBase {
  final _ContextMenuItemType _type;

  ContextMenuItemSeparator() : _type = _ContextMenuItemType.separator;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
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

      // In MacOS, a menu is a `NSMenu`. Each item of it is a `NSMenuItem`.
      //
      // When instantiating a `NSMenuItem`, we define a shortcut key with
      // the property `keyEquivalent`. This property takes a character that
      // corresponds to the key triggered in the keyboard. In case this
      // property is defined with an upper case letter, it will automatically
      // add a `SHIFT` modifier to the shortcut. To prevent that, we convert
      // the `keyLabel` to lower case and decide to use `SHIFT` or not with the
      // value of [SingleActivator.shift].
      'key': trigger.keyLabel.toLowerCase(),
    };
  }
}

/// The common interface in which all platform implementations of context menu
/// should comply to.
abstract class ContextMenuApi {
  static ContextMenuApi instance = _UnsupportedPlatformContextMenuApi();

  /// Shows the context menu with the given [menuItems] at the pointer position.
  Future<ContextMenuItemBase?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  });
}

/// Empty context menu implementation that throws an exception for unsupported
/// platforms.
class _UnsupportedPlatformContextMenuApi extends ContextMenuApi {
  @override
  Future<ContextMenuItemBase?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  }) {
    throw UnimplementedError(
      'Context menu plugin not implemented in this platform.',
    );
  }
}
