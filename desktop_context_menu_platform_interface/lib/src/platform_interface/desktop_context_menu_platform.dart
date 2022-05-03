import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../method_channel/method_channel_desktop_context_menu.dart';
import '../types/types.dart';

/// The interface that implementations of `desktop_context_menu` must implement.
abstract class DesktopContextMenuPlatform extends PlatformInterface {
  DesktopContextMenuPlatform() : super(token: _token);

  static final Object _token = Object();

  static DesktopContextMenuPlatform _instance =
      MethodChannelDesktopContextMenu();

  /// The default instance of [DesktopContextMenuPlatform] to use.
  ///
  /// Defaults to [MethodChannelDesktopContextMenu].
  static DesktopContextMenuPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [DesktopContextMenuPlatform] when they register
  /// themselves.
  static set instance(DesktopContextMenuPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Shows the context menu with the given [menuItems] at the mouse
  /// coordinates.
  Future<ContextMenuItem?> showContextMenu({
    required Iterable<ContextMenuItemBase> menuItems,
  });
}
