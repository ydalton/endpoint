namespace Ep
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/StatusLine.ui")]
    public class StatusLine : Gtk.Box {
        [GtkChild]
        private unowned Gtk.Label label;

        public Soup.Message message { get; set; }
        public string text { get; set; }
        public string status { get; set; }

        [GtkCallback]
        private void on_message_change_cb()
        {
            status = "";

            if(message == null) {
                text = "";
                return;
            }

            text = "%u %s".printf(message.status_code,
                                  message.reason_phrase);

            switch(message.status_code / 100) {
                case 2:
                case 3:
                    status = "success";
                    break;
                case 4:
                case 5:
                    status = "error";
                    break;
            }
        }

        [GtkCallback]
        private void on_status_change_cb()
        {
            label.css_classes = {};

            switch(status) {
                case "success":
                    label.add_css_class("success");
                    break;
                case "warning":
                    label.add_css_class("warning");
                    break;
                case "error":
                    label.add_css_class("error");
                    break;
                case "":
                    break;
                default:
                    assert_not_reached();
            }
        }
    }
}
