import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../method_channel/method_channel_context_menu_plugin.dart';
import '../types/types.dart';

/// The interface that implementations of `context_menu_plugin` must implement.
abstract class ContextMenuPluginPlatform extends PlatformInterface {
  ContextMenuPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ContextMenuPluginPlatform _instance = MethodChannelContextMenuPlugin();

  /// The default instance of [ContextMenuPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelContextMenuPlugin].
  static ContextMenuPluginPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ContextMenuPluginPlatform] when they register
  /// themselves.
  static set instance(ContextMenuPluginPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Shows the context menu with the given [menuItems] at the mouse
  /// coordinates.
  Future<ContextMenuItem?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  });
}
