namespace Ep
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/HeaderView.ui")]
    public class HeaderView : Gtk.Box 
    {
        public Soup.MessageHeaders headers { get; set; }
    }
}
