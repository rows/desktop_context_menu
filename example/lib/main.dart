import 'package:context_menu_api/context_menu_api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Context Menu Plugin Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _openContextMenu = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      /// Listener.onPointerUp cannot check if the clicked mouse button is
      /// the secondary one.
      onPointerDown: (event) {
        _openContextMenu = event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton;
      },
      onPointerUp: (event) {
        if (!_openContextMenu) {
          return;
        }

        _openContextMenu = false;

        _showContextMenu();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(
          child: Text('right click anywhere to open context menu'),
        ),
      ),
    );
  }

  void _showContextMenu() async {
    final selectedItem = await ContextMenuApi.instance.showContextMenu(
      menuItems: [
        ContextMenuItem(
          title: 'Copy',
          onTap: () {},
          shortcut: const SingleActivator(
            LogicalKeyboardKey.keyC,
            meta: true,
          ),
        ),
        ContextMenuItem(
          title: 'Paste',
          onTap: () {},
          shortcut: const SingleActivator(
            LogicalKeyboardKey.keyV,
            meta: true,
          ),
        ),
        ContextMenuItem(
          title: 'Plain paste',
          onTap: () {},
          shortcut: const SingleActivator(
            LogicalKeyboardKey.keyV,
            meta: true,
            shift: true,
          ),
        ),
        const ContextMenuItem.separator(),
        ContextMenuItem(
          title: 'Item number two',
          onTap: () {},
        ),
        const ContextMenuItem(title: 'Disabled item'),
      ],
    );

    if (selectedItem == null) {
      return null;
    }

    print(selectedItem.title);
  }
}
