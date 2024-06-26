namespace Ep 
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/StatusLine.ui")]
    public class StatusLine : Gtk.Box {
        [GtkChild]
        private unowned Gtk.Label label;

        public Soup.Message message { get; set; }

        [GtkCallback]
        private void on_message_change_cb()
        {

            label.css_classes = {};

            if(message == null) {
                label.label = "";
                return;
            }

            label.label = "%u %s".printf(message.status_code,
                                         message.reason_phrase);
            switch(message.status_code / 100) {
                case 2:
                case 3:
                    label.add_css_class("success");
                    break;
                case 4:
                case 5:
                    label.add_css_class("error");
                    break;
            }
        }
    }
}
