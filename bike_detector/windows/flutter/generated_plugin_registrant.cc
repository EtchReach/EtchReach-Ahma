//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <tflite_flutter_helper/tflite_flutter_helper_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  TfliteFlutterHelperPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TfliteFlutterHelperPlugin"));
}
