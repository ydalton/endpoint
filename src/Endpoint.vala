public class Ep.Application : Gtk.Application
{
    public Application()
    {
        Object(application_id: "io.github.ydalton.Endpoint", 
                flags: ApplicationFlags.DEFAULT_FLAGS);
    }
    public override void activate()
    {
        var window = new Gtk.ApplicationWindow(this) {
            child = new Ep.MainView()
        };
        window.present();
    }

    public static int main(string[] args) 
    {
        return  new Ep.Application().run(args);
    }
}
