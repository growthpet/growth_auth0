#ifndef FLUTTER_PLUGIN_GROWTH_AUTH0_PLUGIN_H_
#define FLUTTER_PLUGIN_GROWTH_AUTH0_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace growth_auth0 {

class GrowthAuth0Plugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  GrowthAuth0Plugin();

  virtual ~GrowthAuth0Plugin();

  // Disallow copy and assign.
  GrowthAuth0Plugin(const GrowthAuth0Plugin&) = delete;
  GrowthAuth0Plugin& operator=(const GrowthAuth0Plugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace growth_auth0

#endif  // FLUTTER_PLUGIN_GROWTH_AUTH0_PLUGIN_H_
