import 'package:context_menu_api/context_menu_api.dart';
import 'package:context_menu_macos/context_menu_macos.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _ContextMenuMacosTester contextMenuMacosTester;

  final menuItems = [
    ContextMenuItem(title: 'Item 1', onTap: () {}),
    const ContextMenuItemSeparator(),
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
    contextMenuMacosTester = const _ContextMenuMacosTester();
  });

  group('showContextMenu', () {
    test('standard', () async {
      final selectedItem = await contextMenuMacosTester.mockSelectedItem(
        selectedItemId: 0,
        menuItems: menuItems,
      );

      final contextMenuItem = selectedItem! as ContextMenuItem;

      expect(contextMenuItem.title, 'Item 1');
      expect(contextMenuItem.onTap, isNotNull);
      expect(contextMenuItem.toJson(), {
        'title': 'Item 1',
        'enabled': true,
        'shortcut': null,
        'type': 'standard',
      });
    });

    test('separator', () async {
      final selectedItem = await contextMenuMacosTester.mockSelectedItem(
        selectedItemId: 1,
        menuItems: menuItems,
      );

      final contextMenuItem = selectedItem! as ContextMenuItemSeparator;

      expect(contextMenuItem.toJson(), {'type': 'separator'});
    });

    test('disabled', () async {
      final selectedItem = await contextMenuMacosTester.mockSelectedItem(
        selectedItemId: 2,
        menuItems: menuItems,
      );

      final contextMenuItem = selectedItem! as ContextMenuItem;

      expect(contextMenuItem.title, 'Disabled item');
      expect(contextMenuItem.onTap, isNull);
      expect(contextMenuItem.toJson(), {
        'title': 'Disabled item',
        'enabled': false,
        'shortcut': null,
        'type': 'standard',
      });
    });

    test('shortcut', () async {
      final selectedItem = await contextMenuMacosTester.mockSelectedItem(
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
          'key': 'c',
        },
        'type': 'standard',
      });
    });
  });
}

class _ContextMenuMacosTester {
  const _ContextMenuMacosTester();

  Future<ContextMenuItemBase?> mockSelectedItem({
    required int selectedItemId,
    required List<ContextMenuItemBase> menuItems,
  }) async {
    final contextMenuMacos = ContextMenuMacos();

    contextMenuMacos.channel.setMockMethodCallHandler((methodCall) async {
      return selectedItemId;
    });

    return contextMenuMacos.showContextMenu(menuItems: menuItems);
  }
}
