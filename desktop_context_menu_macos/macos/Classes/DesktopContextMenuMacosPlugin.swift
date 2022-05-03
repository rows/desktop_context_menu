import Cocoa
import FlutterMacOS

public class ContextMenuMacosPlugin: NSObject, FlutterPlugin {
  /// Used to save the flutter app window.
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

  /// Defines the available menu items types.
  enum menuItemType: String {
    case standard = "standard"
    case separator = "separator"
  }

  /// Defines the possible modifiers of a shortcut.
  enum shortcutModifier: String, CaseIterable {
    case command = "command"
    case shift = "shift"
    case alt = "alt"
    case control = "control"
  }

  /// Maps a `shortcutModifier` to a `NSEvent.ModifierFlags` struct.
  ///
  /// Used to define the `keyEquivalentModifierMask` property of a `NSMenuItem`.
  let shortcutModifiersFlags: [shortcutModifier: NSEvent.ModifierFlags] = [
    shortcutModifier.command: NSEvent.ModifierFlags.command,
    shortcutModifier.shift: NSEvent.ModifierFlags.shift,
    shortcutModifier.alt: NSEvent.ModifierFlags.option,
    shortcutModifier.control: NSEvent.ModifierFlags.control
  ]

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "desktop_context_menu_macos", binaryMessenger: registrar.messenger)
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

        // The `popUp` function returns `true` if an item was selected and `false` if the menu was dismissed.
        //
        // The follow condition alerts the method channel that the menu was dismissed.
        if !popUpMenuResult {
          result(nil)
        }
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  /// Creates the context menu for the given items.
  func createContextMenu(_ items: NSArray) -> NSMenu {
    let menu = NSMenu()

    var menuItem: NSMenuItem

    for index in 0...items.count - 1 {
      let item = items[index] as! NSDictionary
      let type = item["type"] as! String

      // If the menu is separator, it does not have a title or an action.
      if type == menuItemType.separator.rawValue {
        menuItem = .separator()
      } else {
        let shortcut = item["shortcut"] as? NSDictionary
        let key = shortcut?["key"] as? String

        menuItem = NSMenuItem(
          title: item["title"] as! String,
          action: #selector(emitSelectedItemId(_:)),   
          // `keyEquivalent` takes a character that corresponds to the key triggered in the keyboard. 
          // In case this property is defined with an upper case letter, it will automatically
          // add a `SHIFT` modifier to the shortcut. To prevent that, we convert
          // the `key` to lower case and decide to use `SHIFT` or not with the
          // value of `shortcut[shortcutModifier.shift.rawValue]`.
          keyEquivalent: key?.lowercased() ?? ""
        )

        let modifiers = getShortcutModifiers(shortcut)

        // Sets the current menu item modifiers if they are not null.
        if modifiers != nil {
          menuItem.keyEquivalentModifierMask = modifiers!
        }

        menuItem.isEnabled = item["enabled"] as! Bool == true
      }

      menuItem.target = self

      // Sets the id of the current menu item.
      menuItem.tag = index

      menu.addItem(menuItem)
    }

    // Let the dev decide if a menu item should be enabled or not.
    menu.autoenablesItems = false

    return menu
  }

  /// Gets the current shortcut modifiers.
  ///
  /// See:
  /// - `shortcutModifier` enum and `shortcutModifiersFlags` map.
  func getShortcutModifiers(_ shortcut: NSDictionary?) -> NSEvent.ModifierFlags? {
    guard let currentShortcut = shortcut else {
      return nil
    }

    var modifiers: NSEvent.ModifierFlags = []

    for modifier in shortcutModifier.allCases {
      let isEnabled = currentShortcut[modifier.rawValue] as? Bool == true

      if isEnabled {
        modifiers.insert(shortcutModifiersFlags[modifier]!)
      }    
    }

    return modifiers
  }
}
