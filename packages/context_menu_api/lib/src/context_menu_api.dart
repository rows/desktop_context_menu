/// The common interface in which all platform implementations of context menu
/// should comply to.
abstract class ContextMenuApi {
  static ContextMenuApi instance = _UnsupportedPlatformContextMenuApi();

  Future<String?> get platformVersion;
}

/// Empty context menu implementation that throws an exception for unsupported
/// platforms.
class _UnsupportedPlatformContextMenuApi extends ContextMenuApi {
  @override
  Future<String?> get platformVersion {
    throw UnimplementedError(
      'Context menu plugin not implemented in this platform.',
    );
  }
}
