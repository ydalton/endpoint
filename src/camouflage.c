/*
 * Camouflage the application to look like the platform it's running on
 */

#include <glib.h>
#include <dlfcn.h>

gboolean init_adwaita()
{
	void *adwaita;
	void (*adw_init)();

	adwaita = dlopen("libadwaita-1.so.0", RTLD_NOW);
	if(!adwaita) {
		g_warning("Could not dlopen Libadwaita");
		return FALSE;
	}

	adw_init = dlsym(adwaita, "adw_init");
	if(!adw_init) {
		g_critical("Could not find symbol 'adw_init' in Libadwaita!");
		return FALSE;
	}

	adw_init();

	return TRUE;
}
