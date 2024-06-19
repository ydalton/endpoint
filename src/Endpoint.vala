extern bool init_adwaita();

public class Ep.Application : Gtk.Application
{
    static construct {
        typeof(GtkSource.View).ensure();
    }

    public Application()
    {
        Object(application_id: "io.github.ydalton.Endpoint", 
               flags: ApplicationFlags.FLAGS_NONE);
    }

    /*
     * for some "compatibility" reason, when running in VSCode this variable
     * returns "Unity".
     */
    private string? get_desktop_name()
    {
        return Environment.get_variable("XDG_CURRENT_DESKTOP");;
    }

    public override void activate()
    {
        Gtk.Window window;

        string desktop_name = get_desktop_name();
        debug("Running on: %s\n", desktop_name);

        switch(desktop_name) {
            case "GNOME":
                debug("Initializing Libadwaita...");
                init_adwaita();
                break;
            case "Pantheon":
                debug("FIMXE: do something for pantheon");
                break;
            case null:
                warning("Couldn't detect desktop from querying $XDG_CURRENT_DESKTOP. Perhaps a standalone WM?");
                break;
            default:
                break;
        }

        window = new Ep.MainWindow(this);
        window.title = "Endpoint";
        window.present();
    }


    public static int main(string[] args)
    {
        var app = new Ep.Application();

        return app.run();
    }
}
