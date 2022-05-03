import 'package:flutter/widgets.dart';

import 'context_menu_item_base.dart';
import 'context_menu_item_type.dart';

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
      'shortcut': shortcut?.toJson(),
      'type': ContextMenuItemType.standard.name,
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
