import 'package:context_menu_api/context_menu_api.dart';
import 'package:context_menu_windows/context_menu_windows.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _ContextMenuWindowsTester contextMenuWindowsTester;

  final menuItems = [
    ContextMenuItem(title: 'Item 1', onTap: () {}),
    const ContextMenuSeparator(),
    const ContextMenuItem(title: 'Disabled item'),
    ContextMenuItem(
      title: 'Copy',
      shortcut: const SingleActivator(
        LogicalKeyboardKey.keyC,
        meta: true,
      ),
      onTap: () {},
    ),
  ];

  setUpAll(() {
    contextMenuWindowsTester = const _ContextMenuWindowsTester();
  });

  group('showContextMenu', () {
    test('standard', () async {
      final selectedItem = await contextMenuWindowsTester.mockSelectedItem(
        selectedItemId: 0,
        menuItems: menuItems,
      );

      final contextMenuItem = selectedItem! as ContextMenuItem;

      expect(contextMenuItem.title, 'Item 1');
      expect(contextMenuItem.onTap, isNotNull);
      expect(contextMenuItem.toJson(), {
        'title': 'Item 1',
        'enabled': true,
        'shortcut': <String, dynamic>{},
        'type': 'standard',
      });
    });

    test('separator', () {
      expect(menuItems.elementAt(1).toJson(), {'type': 'separator'});
    });

    test('disabled', () async {
      final selectedItem = await contextMenuWindowsTester.mockSelectedItem(
        selectedItemId: 2,
        menuItems: menuItems,
      );

      final contextMenuItem = selectedItem! as ContextMenuItem;

      expect(contextMenuItem.title, 'Disabled item');
      expect(contextMenuItem.onTap, isNull);
      expect(contextMenuItem.toJson(), {
        'title': 'Disabled item',
        'enabled': false,
        'shortcut': <String, dynamic>{},
        'type': 'standard',
      });
    });

    test('shortcut', () async {
      final selectedItem = await contextMenuWindowsTester.mockSelectedItem(
        selectedItemId: 3,
        menuItems: menuItems,
      );

      final contextMenuItem = selectedItem! as ContextMenuItem;

      expect(contextMenuItem.title, 'Copy');
      expect(contextMenuItem.onTap, isNotNull);
      expect(contextMenuItem.toJson(), {
        'title': 'Copy',
        'enabled': true,
        'shortcut': {
          'alt': false,
          'control': false,
          'command': true,
          'shift': false,
          'key': 'C',
        },
        'type': 'standard',
      });
    });
  });
}

class _ContextMenuWindowsTester {
  const _ContextMenuWindowsTester();

  Future<ContextMenuItemBase?> mockSelectedItem({
    required int selectedItemId,
    required List<ContextMenuItemBase> menuItems,
  }) async {
    final contextMenuWindows = ContextMenuWindows();

    contextMenuWindows.channel.setMockMethodCallHandler((methodCall) async {
      return selectedItemId;
    });

    return contextMenuWindows.showContextMenu(menuItems: menuItems);
  }
}
