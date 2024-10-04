namespace Ep
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/StatusLine.ui")]
    public class StatusLine : Gtk.Box {
        [GtkChild]
        private unowned Gtk.Label label;

        public string text { get; private set; }
        public string status { get; private set; }

        public void set_error(string message)
        {
            text = message;
            status = "error";
        }

        public void clear()
        {
            status = "";
            text = "";
        }

        public void set_response_message(uint code, string reason)
        {
            this.text = "%u %s".printf(code, reason);

            switch(code / 100) {
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
