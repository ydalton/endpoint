extern bool init_adwaita();

public class Ep.Application : Gtk.Application
{
    public static string name = "Endpoint";

    public Application()
    {
        Object(application_id: Config.APP_ID,
               flags: ApplicationFlags.DEFAULT_FLAGS);
    }

    private string? get_desktop_name()
    {
        string _desktop_name = Environment.get_variable("XDG_SESSION_DESKTOP");
        string kernel_name;

        if(_desktop_name != null)
            return _desktop_name;

        try {
            Process.spawn_sync(null,
                                {"uname", "-s"},
                                null,
                                SpawnFlags.SEARCH_PATH,
                                null,
                                out kernel_name);
        } catch (SpawnError e) {
            error("%s", e.message);
        }

        kernel_name = kernel_name.split("\n")[0];
        if(kernel_name != null) {
            switch(kernel_name) {
                case "Darwin":
                    return "macOS";
                default:
                    return kernel_name;
            }
        }
        return _desktop_name;
    }

    private void camouflage()
    {
        string desktop_name = get_desktop_name();
        debug("Running on: %s", desktop_name);

        switch(desktop_name) {
            case null:
                debug("Couldn't detect desktop/operating system!");
                break;
            case "gnome":
            case "macOS":
                debug("Initializing Libadwaita...");
                if(!init_adwaita())
                    critical("Couldn't initialize Libadwaita");
                break;
            default:
                break;
        }
    }

    public override void startup()
    {
        base.startup();
        debug("Starting %s...", name);

        camouflage();

        debug("Finished initializing...");
    }

    public override void activate()
    {
        Gtk.Window window;

        window = new Ep.MainWindow(this);
        window.title = name;
        window.present();

    }

    public static int main(string[] args)
    {
        var app = new Ep.Application();

        return app.run();
    }
}
