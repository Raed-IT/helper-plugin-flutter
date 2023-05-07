#ifndef FLUTTER_PLUGIN_HELPER_PLUGIN_H_
#define FLUTTER_PLUGIN_HELPER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace helper_plugin {

class HelperPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  HelperPlugin();

  virtual ~HelperPlugin();

  // Disallow copy and assign.
  HelperPlugin(const HelperPlugin&) = delete;
  HelperPlugin& operator=(const HelperPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace helper_plugin

#endif  // FLUTTER_PLUGIN_HELPER_PLUGIN_H_
