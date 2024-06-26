extern bool init_adwaita();

public class Ep.Application : Gtk.Application
{
    public string name = "Endpoint";
    public string application_id = "io.github.ydalton.Endpoint";
    public ApplicationFlags flags = ApplicationFlags.FLAGS_NONE;

    static construct {
        typeof(GtkSource.View).ensure();
    }

    public Application()
    {
        Object();
    }

    /*
     * for some "compatibility" reason, when running in VSCode this variable
     * returns "Unity".
     */
    private string? get_desktop_name()
    {
        string _desktop_name = Environment.get_variable("XDG_CURRENT_DESKTOP");
        string kernel_name;
        if(_desktop_name == null) {
            Process.spawn_sync(null,
                               {"uname", "-s"},
                               null,
                               SpawnFlags.SEARCH_PATH,
                               null,
                               out kernel_name);

            kernel_name = kernel_name.split("\n")[0];
            if(kernel_name != null) {
                switch(kernel_name) {
                    case "Darwin":
                        return "macOS";
                    default:
                        return kernel_name;
                }
            }
        }
        return _desktop_name;
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
                debug("Couldn't detect desktop/operating system!");
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
