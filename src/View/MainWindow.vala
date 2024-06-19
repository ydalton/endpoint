namespace Ep
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/MainWindow.ui")]
    public class MainWindow : Gtk.ApplicationWindow
    {
        static construct {
            typeof(Ep.CodeView).ensure();
        }

        public MainWindow(Gtk.Application application) 
        {
            Object(application: application);
        }
    }
}

