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
