extern bool init_adwaita();

public class Ep.Application : Gtk.Application
{
    public string name = "Endpoint";

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

    public override void startup()
    {
        base.startup();
        debug("Starting %s...", name);
    }

    public override void activate()
    {
        Gtk.Window window;

        string desktop_name = get_desktop_name();
        debug("Running on: %s", desktop_name);

        switch(desktop_name) {
            case null:
                debug("Couldn't detect desktop from querying $XDG_CURRENT_DESKTOP. Perhaps a standalone WM?");
                break;
            case "GNOME":
                debug("Initializing Libadwaita...");
                init_adwaita();
                break;
            case "Pantheon":
                debug("FIMXE: do something for pantheon");
                break;
            default:
                break;
        }

        window = new Ep.MainWindow(this);
        window.title = name;
        window.present();
        debug("Finished initializing...");
    }


    public static int main(string[] args)
    {
        var app = new Ep.Application();

        return app.run();
    }
}
