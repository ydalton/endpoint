extern bool is_running_on_gnome();
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
    public override void activate()
    {
        var window = new Ep.MainWindow(this);
        window.title = "Endpoint";
        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Ep.Application();

        if(is_running_on_gnome())
            init_adwaita();

        return app.run();
    }
}
