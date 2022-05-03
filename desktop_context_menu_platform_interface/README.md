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
  <a title="Pub" href="https://pub.dev/packages/desktop_context_menu_platform_interface" ><img src="https://img.shields.io/pub/v/desktop_context_menu_platform_interface.svg?style=popout" /></a>
  <a title="Rows lint" href="https://pub.dev/packages/rows_lint" ><img src="https://img.shields.io/badge/Styled%20by-Rows-754F6C?style=popout" /></a>
  <a title="Melos" href="https://github.com/invertase/melos"><img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg"/></a>
</p>

# desktop_context_menu_platform_interface

A common platform interface for the [`desktop_context_menu`][1] plugin.

## Usage

To implement a new platform-specific implementation of `desktop_context_menu`, extend
[`DesktopContextMenuPlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`DesktopContextMenuPlatform` by calling
`DesktopContextMenuPlatform.instance = MyPlatformContextMenu()`.

[1]: ../desktop_context_menu
[2]: lib/src/platform_interface/desktop_context_menu_platform.dart
