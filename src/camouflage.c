/*
 * Camouflage the application to look like the platform it's running on
 */

#include <glib.h>
#include <dlfcn.h>

/* FIXME: find a way to detect whether we're on GNOME */
gboolean is_running_on_gnome()
{
    return FALSE;
}

gboolean init_adwaita()
{
    void *adwaita;
    void (*adw_init)();

    adwaita = dlopen("libadwaita-1.so", RTLD_NOW);
    if(!adwaita)
        return FALSE;

    adw_init = dlsym(adwaita, "adw_init");
    if(!adw_init)
        return FALSE;

    adw_init();

    return TRUE;
}