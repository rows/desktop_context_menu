import 'package:context_menu_api/context_menu_api.dart';
import 'package:context_menu_macos/context_menu_macos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _ContextMenuMacosTester contextMenuMacosTester;

  final menuItems = [
    ContextMenuItem(title: 'Item 1', onTap: () {}),
    const ContextMenuItem.separator(),
    const ContextMenuItem(title: 'Disabled item'),
    const ContextMenuItem(
      title: 'Copy',
      shortcut: SingleActivator(
        LogicalKeyboardKey.keyC,
        meta: true,
      ),
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

      expect(selectedItem, isNotNull);
      expect(selectedItem!.title, isNotNull);
      expect(selectedItem.onTap, isNotNull);
    });

    test('separator', () async {
      final selectedItem = await contextMenuMacosTester.mockSelectedItem(
        selectedItemId: 1,
        menuItems: menuItems,
      );

      expect(selectedItem, isNotNull);
      expect(selectedItem!.title, isNull);
      expect(selectedItem.onTap, isNull);
    });

    test('disabled', () async {
      final selectedItem = await contextMenuMacosTester.mockSelectedItem(
        selectedItemId: 2,
        menuItems: menuItems,
      );

      expect(selectedItem, isNotNull);
      expect(selectedItem!.title, isNotNull);
      expect(selectedItem.onTap, isNull);
    });

    test('shortcut', () async {
      final selectedItem = await contextMenuMacosTester.mockSelectedItem(
        selectedItemId: 3,
        menuItems: menuItems,
      );

      expect(selectedItem, isNotNull);
      expect(selectedItem!.title, isNotNull);
      expect(selectedItem.shortcut!.trigger, LogicalKeyboardKey.keyC);
      expect(selectedItem.shortcut!.meta, isTrue);
      expect(selectedItem.onTap, isNull);
    });
  });
}

class _ContextMenuMacosTester {
  const _ContextMenuMacosTester();

  Future<ContextMenuItem?> mockSelectedItem({
    required int selectedItemId,
    required List<ContextMenuItem> menuItems,
  }) async {
    const channel = MethodChannel('context_menu_macos');

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return selectedItemId;
    });

    final contextMenuMacos = ContextMenuMacos();

    return contextMenuMacos.showContextMenu(menuItems: menuItems);
  }
}
