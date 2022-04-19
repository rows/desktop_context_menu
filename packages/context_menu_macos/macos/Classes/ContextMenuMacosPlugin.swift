import Cocoa
import FlutterMacOS

public class ContextMenuMacosPlugin: NSObject, FlutterPlugin {
  /// Used to get the flutter app window.
  let registrar: FlutterPluginRegistrar

  init(_ registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
  }

  /// Gets the flutter app window.
  lazy var currentWindow:NSWindow? = {
    return registrar.view?.window ?? NSApplication.shared.keyWindow ?? NSApplication.shared.mainWindow;
  }()

  /// Used to communicate back the context menu selected item id.
  var result: FlutterResult?

  /// Sends back through the method channel the selected item id.
  @objc func emitSelectedItemId(_ sender: NSMenuItem) {
    guard let result = self.result else {
      return;
    }

    result(sender.tag)
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "context_menu_macos", binaryMessenger: registrar.messenger)
    let instance = ContextMenuMacosPlugin(registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "showContextMenu":
        self.result = result

        guard let activeWindow = currentWindow else {
          return;
        }

        // Get the mouse coordinates to define where to show the context menu.
        let mouseLocation = activeWindow.mouseLocationOutsideOfEventStream

        // Get the menu items passed through the method channel.
        let arguments = call.arguments as! NSArray
        
        // Creates the context menu with the given arguments.
        let menu = createContextMenu(arguments)

        // Shows the context menu at the mouse coordinates in the flutter app window.
        let popUpMenuResult = menu.popUp(
          positioning: nil,
          at: NSPoint(x: mouseLocation.x, y: mouseLocation.y),
          in: activeWindow.contentView
        )

        // The `popUp` function returns `true`` if an item was selected and `false` if the menu was dismissed.
        //
        // The follow condition alerts the method channel that the menu was dismissed.
        if !popUpMenuResult {
          result(nil)
        }
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  /// Creats the context menu for the given items.
  func createContextMenu(_ items: NSArray) -> NSMenu {
    let menu = NSMenu()

    var menuItem: NSMenuItem

    for index in 0...items.count - 1 {
      let item = items[index] as! NSDictionary
      let type = item["type"] as! String

      // If the menu is separator, it does not have a title or an action.
      if type == "separator" {
        menuItem = .separator()
      } else {
        menuItem = NSMenuItem(
          title: item["title"] as! String,
          action: #selector(emitSelectedItemId(_:)),
          keyEquivalent: ""
        )

        menuItem.isEnabled = item["enabled"] as! Bool == true
      }

      menuItem.target = self

      // Sets the index of the current menu item.
      menuItem.tag = index

      menu.addItem(menuItem)
    }

    // Let the dev decide if a menu item should be enabled or not.
    menu.autoenablesItems = false

    return menu
  }
}
