<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A package that spawns a context menu at the mouse coordinates.

Available for Windows and MacOS.

## Features

- Native like context menu.
- Separators between menu items.
- Specify shortcuts for menu items.

## Usage

To invoke the context menu you can do the following:

```dart
final selectedItem = await ContextMenuApi.instance.showContextMenu(menuItems: [...]);
```

In case an item is selected in the context menu, that item is returned. If no item is selected, `null` is returned.

A context menu item can be of type `standard` or `separator`. 

To define a menu item of type `standard`, you can do the following:

```dart
...
ContextMenuItem(
  title: 'Menu item title',
  onTap: () {
    // do something...
  },
),
...
```

If you do not set the `onTap` callback, the menu item will be disabled.

To add a separator between menu items, you need to add a `ContextMenuItemSeparator` between `ContextMenuItem`s:

```dart
...
menuItems: [
  ContextMenuItem(
    title: 'Menu item title',
    onTap: () {
      // do something...
    },
  ),
  ContextMenuItemSeparator(),
  ContextMenuItem(
    title: 'Disabled menu item',
  ),
],
...
```

To define a shortcut for a menu item, just specify the shortcut property of `ContextMenuItem` that takes a `SingleActivator`:

```dart
...
ContextMenuItem(
  title: 'Copy',
  onTap: () {
    // do something...
  },
  shortcut: SingleActivator(
    LogicalKeyboardKey.keyC,
    meta: Platform.isMacOS,
    control: Platform.isWindows,
  ),
),
...
```
