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
  <a title="Melos" href="https://github.com/invertase/melos"><img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg"/></a>
</p>

# context_menu_plugin_platform_interface

A common platform interface for the [`context_menu_plugin`][1] plugin.

## Usage

To implement a new platform-specific implementation of `context_menu_plugin`, extend
[`ContextMenuPluginPlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`ContextMenuPluginPlatform` by calling
`ContextMenuPluginPlatform.instance = MyPlatformContextMenu()`.

[1]: ../context_menu_plugin
[2]: lib/src/platform_interface/context_menu_plugin_platform.dart
