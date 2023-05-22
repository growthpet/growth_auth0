#include "include/growth_auth0/growth_auth0_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "growth_auth0_plugin.h"

void GrowthAuth0PluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  growth_auth0::GrowthAuth0Plugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
