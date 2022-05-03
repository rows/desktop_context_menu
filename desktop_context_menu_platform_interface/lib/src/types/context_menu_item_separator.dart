import 'context_menu_item_base.dart';
import 'context_menu_item_type.dart';

/// A class that represents a separator between menu items in the context menu.
class ContextMenuSeparator extends ContextMenuItemBase {
  const ContextMenuSeparator();

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': ContextMenuItemType.separator.name,
    };
  }
}
