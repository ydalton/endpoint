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
        private unowned Ep.CodeView raw;
        [GtkChild]
        private unowned Ep.StatusLine status_line;
        [GtkChild]
        private unowned Ep.HeaderView header_view;
        [GtkChild]
        private unowned Gtk.Label size_label;
        [GtkChild]
        private unowned Gtk.Spinner spinner;
        [GtkChild]
        private unowned Ep.CodeView request_body;

        private CodeViewManager view_manager;

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
            Bytes response_bytes = null;
            string content_type;
            string language = null;

            var selected = method_dropdown.selected_item as Gtk.StringObject;
            var method = selected.string;
            var url = url_entry.text;

            if(session == null)
                session = new Soup.Session();

            return_if_fail(is_valid_uri(url));

            response = null;
            /* FIXME: add a controller to clear and fill these all in one
             * function call? */
            view_manager.text = "";
            status_line.message = null;
            status_line.text = "";
            size_label.label = "";
            header_view.headers = null;

            msg = new Soup.Message(method, url);
            assert(msg != null);

            var body_as_bytes = new Bytes.static(request_body.text.data);

            msg.set_request_body_from_bytes("application/json",
                                            body_as_bytes);

            var loop = new MainLoop();
            spinner.start();

            /* XXX: possibly buggy? */
            session.send_and_read_async.begin(msg, 0, null, (obj, res) => {
                try {
                    response_bytes = session.send_and_read_async.end(res);
                    debug("Send off request with uri %s", url);
                } catch (Error e) {
                    status_line.text = e.message;
                    status_line.status = "error";
                }
                loop.quit();
            });

            loop.run();

            spinner.stop();

            if(response_bytes == null) {
                return;
            }

            this.response = (string) response_bytes.get_data();
            content_type = msg.response_headers.get_content_type(null);
            /* HACK: well, I don't think we're gonna get any other formats
             * than these
             */
            if(content_type != null) {
                language = content_type.split("/")[1];
                if(language == null) {
                    warning("Malformed mimetype in Content-Type header");
                }
            }

            header_view.headers = msg.response_headers;
            status_line.message = msg;

            view_manager.language_id = language;
            view_manager.text = response;
            size_label.label = show_length(response.length);
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
            view_manager = new CodeViewManager();
            view_manager.add(formatted);
            view_manager.add(raw);
        }

        public MainWindow(Gtk.Application application)
        {
            Object(application: application);
        }
    }
}
