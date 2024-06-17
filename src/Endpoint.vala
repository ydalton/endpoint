public class Ep.Application : Gtk.Application
{
    public Application()
    {
        Object(application_id: "io.github.ydalton.Endpoint", 
                flags: ApplicationFlags.FLAGS_NONE);
    }
    public override void activate()
    {
        var window = new Gtk.ApplicationWindow(this) {
            child = new Ep.MainView(),
            width_request = 600,
            height_request = 400
        };

        window.present();
    }

    public static int main(string[] args) 
    {
        return new Ep.Application().run(args);
    }
}
