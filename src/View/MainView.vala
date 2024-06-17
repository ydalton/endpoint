namespace Ep
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/MainView.ui")]
    public class MainView : Gtk.Box
    {
        [GtkChild]
        private unowned Gtk.Button button;
    }
}

