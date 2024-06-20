namespace Ep
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/MainWindow.ui")]
    public class MainWindow : Gtk.ApplicationWindow
    {
        [GtkChild]
        private unowned Gtk.DropDown method_dropdown;
        [GtkChild]
        private unowned Gtk.Entry url_entry;
        [GtkChild]
        private unowned Gtk.Button send_button;
        [GtkChild]
        private unowned Ep.CodeView formatted;
        [GtkChild]
        private unowned Ep.StatusLine status_line;

        private Soup.Session session;
        private Soup.Message msg;
        private string response;
        private string[] accepted_methods = {
            "GET",
            "POST",
            "PUT",
            "DELETE"
        };

        private bool is_valid_uri(string str)
        {
            Uri uri;
            try {
                uri = Uri.parse(str, UriFlags.NONE);
            } catch(UriError e) {
                return false;
            }
            return uri.get_host() != null && uri.get_host()[0] != '\0';
        }

        [GtkCallback]
        private void send_action()
        {
            Bytes response_bytes;
            string content_type;
            string language = "plain";

            var selected = method_dropdown.selected_item as Gtk.StringObject;
            var method = selected.string;
            var url = url_entry.text;

            return_if_fail(is_valid_uri(url));

            response = null;

            msg = new Soup.Message(method, url);
            assert(msg != null);

            /* FIXME: turn into async */
            try {
                response_bytes = session.send_and_read(msg, null);
                debug("Send off request with uri %s", url);
            } catch (Error e) {
                /* FIXME: show error message to notify user */
                warning("Failed to send request: %s", e.message);
                return;
            }

            assert(response_bytes != null);

            this.response = (string) response_bytes.get_data();
            content_type = msg.response_headers.get_content_type(null);
            /* HACK: well, I don't think we're gonna get any other formats than these */
            if(content_type != null) {
                if(content_type.contains("html")) {
                    language = "html";
                } else if(content_type.contains("json")) {
                    language = "json";
                } else if(content_type.contains("xml")) {
                    language = "xml";
                }
            }

            status_line.message = msg;

            formatted.language_id = language;
            formatted.text = response;
        }

        static construct {
            typeof(Ep.CodeView).ensure();
        }

        [GtkCallback]
        private void on_text_changed_cb()
        {
            send_button.sensitive = is_valid_uri(url_entry.text);
        }

        construct {
            method_dropdown.model = new Gtk.StringList(accepted_methods);
            session = new Soup.Session();
        }

        public MainWindow(Gtk.Application application) 
        {
            Object(application: application);
        }
    }
}

