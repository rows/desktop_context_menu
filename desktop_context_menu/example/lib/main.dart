import 'dart:io';

import 'package:desktop_context_menu/desktop_context_menu.dart';
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
      home: const MyHomePage(title: 'Desktop Context Menu Example'),
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
    final selectedItem = await showContextMenu(
      menuItems: [
        ContextMenuItem(
          title: 'Copy',
          onTap: () {
            print('Tapped copy');
          },
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyC,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
        ContextMenuItem(
          title: 'Paste',
          onTap: () {
            print('Tapped paste');
          },
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyV,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
        ContextMenuItem(
          title: 'Paste as values',
          onTap: () {
            print('Tapped paste as values');
          },
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyV,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
            shift: true,
          ),
        ),
        const ContextMenuSeparator(),
        ContextMenuItem(
          title: 'Item number two',
          onTap: () {
            print('Tapped item number two');
          },
        ),
        const ContextMenuItem(title: 'Disabled item'),
        const ContextMenuItem(
          title: 'Disabled item with shortcut',
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyV,
            meta: true,
            shift: true,
          ),
        ),
        const ContextMenuSeparator(),
        ContextMenuItem(
          title: 'Zoom in',
          shortcut: const SingleActivator(
            LogicalKeyboardKey.add,
            alt: true,
          ),
          onTap: () {
            print('Tapped zoom in');
          },
        ),
        ContextMenuItem(
          title: 'Zoom out',
          shortcut: const SingleActivator(
            LogicalKeyboardKey.minus,
            alt: true,
          ),
          onTap: () {
            print('Tapped zoom out');
          },
        ),
        const ContextMenuSeparator(),
        ContextMenuItem(
          title: 'Control shortcut',
          shortcut: const SingleActivator(
            LogicalKeyboardKey.keyJ,
            control: true,
          ),
          onTap: () {
            print('Tapped control shortcut');
          },
        ),
      ],
    );

    if (selectedItem == null) {
      return null;
    }

    selectedItem.onTap?.call();
  }
}
