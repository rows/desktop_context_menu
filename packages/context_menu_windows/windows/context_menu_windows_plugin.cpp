#include "include/context_menu_windows/context_menu_windows_plugin.h"
#include "include/context_menu_windows/encoding.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace {

class ContextMenuWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ContextMenuWindowsPlugin();

  virtual ~ContextMenuWindowsPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void ContextMenuWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "context_menu_windows",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<ContextMenuWindowsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

ContextMenuWindowsPlugin::ContextMenuWindowsPlugin() {}

ContextMenuWindowsPlugin::~ContextMenuWindowsPlugin() {}

void ContextMenuWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("showContextMenu") == 0) {
    // Gets the flutter app window.
    const auto activeWindow = GetActiveWindow();

    POINT cursorPosition;

    // Gets the cursor position offset and assigns it to `cursorPosition`.
    ::GetCursorPos(&cursorPosition);

    // Creates the context menu.
    const auto contextMenu = CreatePopupMenu();

    // Gets the menu items of the context menu that have been passed through the arguments parameter.
    const auto* items = std::get_if<flutter::EncodableList>(method_call.arguments());

    if (!items) {
      result->Error("Missing required type parameter", "Expected list of items");
      return;
    }

    // Unfortunately, `TrackPopupMenu` returns `0` instead of `-1` when no item is selected. Because of that, 
    // the id of the first element of `items` starts at `1` instead of `0`.
    //
    // See: 
    //  - https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-trackpopupmenu#return-value
    for (int i = 1; i <= (*items).size(); i++) {
      auto item = std::get<flutter::EncodableMap>((*items)[i - 1]);
      auto type = std::get<std::string>(item[flutter::EncodableValue("type")]);

      // No need to get and set the title of the menu item if it's a separator.
      if (type.compare("separator") == 0) {
        AppendMenuW(contextMenu, MF_SEPARATOR, i, NULL);
      } else {
        auto title = Encoding::Utf8ToWide(std::get<std::string>(item[flutter::EncodableValue("title")]));
        auto enabled = std::get<bool>(item[flutter::EncodableValue("enabled")]);

        // AppendMenuW takes a wchar_t[]. Since title is char[], a conversion to wchar_t[] is done.
        std::wstring widestr = std::wstring(title.begin(), title.end());
        const wchar_t* widecstr = widestr.c_str();

        AppendMenuW(contextMenu, enabled ? MF_STRING : MF_GRAYED, i, widecstr);
      }
    }

    SetForegroundWindow(activeWindow);

    int selectedItemId = TrackPopupMenu(contextMenu, TPM_LEFTALIGN | TPM_LEFTBUTTON | TPM_RETURNCMD, cursorPosition.x, cursorPosition.y, 0, activeWindow, nullptr);

    // If no item is selected don't pass any value.
    if (0 == selectedItemId) {
      result->Success();
    } else {
      result->Success(flutter::EncodableValue(selectedItemId - 1));
    }
  } else {
    result->NotImplemented();
  }
}

}  // namespace

void ContextMenuWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ContextMenuWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
