//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <helper_plugin/helper_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) helper_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "HelperPlugin");
  helper_plugin_register_with_registrar(helper_plugin_registrar);
}
