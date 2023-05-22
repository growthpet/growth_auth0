#ifndef FLUTTER_PLUGIN_GROWTH_AUTH0_PLUGIN_H_
#define FLUTTER_PLUGIN_GROWTH_AUTH0_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _GrowthAuth0Plugin GrowthAuth0Plugin;
typedef struct {
  GObjectClass parent_class;
} GrowthAuth0PluginClass;

FLUTTER_PLUGIN_EXPORT GType growth_auth0_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void growth_auth0_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_GROWTH_AUTH0_PLUGIN_H_
