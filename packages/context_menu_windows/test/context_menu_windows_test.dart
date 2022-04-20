import 'package:context_menu_api/context_menu_api.dart';
import 'package:context_menu_windows/context_menu_windows.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _ContextMenuWindowsTester contextMenuWindowsTester;

  final menuItems = [
    ContextMenuItem(title: 'Item 1', onTap: () {}),
    const ContextMenuItem.separator(),
    const ContextMenuItem(title: 'Disabled item'),
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

      expect(selectedItem, isNotNull);
      expect(selectedItem!.title, isNotNull);
      expect(selectedItem.onTap, isNotNull);
    });

    test('separator', () async {
      final selectedItem = await contextMenuWindowsTester.mockSelectedItem(
        selectedItemId: 1,
        menuItems: menuItems,
      );

      expect(selectedItem, isNotNull);
      expect(selectedItem!.title, isNull);
      expect(selectedItem.onTap, isNull);
    });

    test('disabled', () async {
      final selectedItem = await contextMenuWindowsTester.mockSelectedItem(
        selectedItemId: 2,
        menuItems: menuItems,
      );

      expect(selectedItem, isNotNull);
      expect(selectedItem!.title, isNotNull);
      expect(selectedItem.onTap, isNull);
    });
  });
}

class _ContextMenuWindowsTester {
  const _ContextMenuWindowsTester();

  Future<ContextMenuItem?> mockSelectedItem({
    required int selectedItemId,
    required List<ContextMenuItem> menuItems,
  }) async {
    final contextMenuWindows = ContextMenuWindows();

    contextMenuWindows.channel.setMockMethodCallHandler((methodCall) async {
      return selectedItemId;
    });

    return contextMenuWindows.showContextMenu(menuItems: menuItems);
  }
}
