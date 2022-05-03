import 'package:desktop_context_menu_platform_interface/desktop_context_menu_platform_interface.dart';
import 'package:desktop_context_menu_windows/desktop_context_menu_windows.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _DesktopContextMenuWindowsTester contextMenuWindowsTester;

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
    contextMenuWindowsTester = const _DesktopContextMenuWindowsTester();
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
        'shortcut': null,
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
        'shortcut': null,
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

class _DesktopContextMenuWindowsTester {
  const _DesktopContextMenuWindowsTester();

  Future<ContextMenuItemBase?> mockSelectedItem({
    required int selectedItemId,
    required List<ContextMenuItemBase> menuItems,
  }) async {
    final contextMenuWindows = DesktopContextMenuWindows();

    contextMenuWindows.channel.setMockMethodCallHandler((methodCall) async {
      return selectedItemId;
    });

    return contextMenuWindows.showContextMenu(menuItems: menuItems);
  }
}
