#include "include/helper_plugin/helper_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "helper_plugin.h"

void HelperPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  helper_plugin::HelperPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
