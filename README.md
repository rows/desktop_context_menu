<p align="center">
  <a href="https://rows.com">
  <br />
  <img src="https://rows.com/media/logo.svg" alt="Rows" width="150"/>
  <br />
    <sub><strong>Spreadsheet with superpowers!</strong></sub>
  <br />
  <br />
  </a>
</p>

<p align="center">
  <a title="Pub" href="https://pub.dev/packages/context_menu_plugin" ><img src="https://img.shields.io/pub/v/context_menu_plugin.svg?style=popout" /></a>
  <a title="Rows lint" href="https://pub.dev/packages/rows_lint" ><img src="https://img.shields.io/badge/Styled%20by-Rows-754F6C?style=popout" /></a>
</p>

# Context Menu Plugin

A package that spawns a context menu at the mouse coordinates.

Available for Windows and MacOS.

| MacOS  |  Windows  |
| ------------------- | ------------------- |
| <img width="299" alt="image" src="https://user-images.githubusercontent.com/36768712/165944808-d44c05b9-f968-4994-8fc7-b2c10f82cb7f.png"> |  ![windows](https://user-images.githubusercontent.com/36768712/165944543-70700de7-b911-45ad-b47f-9565de7472e5.jpg) |

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
