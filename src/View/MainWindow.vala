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
        private unowned Gtk.Label time_label;
        [GtkChild]
        private unowned Gtk.Spinner spinner;
        [GtkChild]
        private unowned Ep.CodeView request_body;

        private CodeViewManager view_manager;

        private Soup.Session _session;
        private Soup.Session session {
            get {
                if(_session == null) {
                    _session = new Soup.Session() {
                        user_agent = @"Endpoint/$(Config.VERSION)",
                    };
                }
                return _session;
            }
        }
        private Soup.Message msg;
        private string response;
        private const string[] accepted_methods = {
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
        private void on_send_clicked_cb()
        {
            do_request();
        }

        private Bytes send_request(string url)
        {
            Bytes response_bytes = null;
            var loop = new MainLoop();
            spinner.start();
            spinner.visible = true;

            /* XXX: possibly buggy? */
            session.send_and_read_async.begin(msg, 0, null, (obj, res) => {
                try {
                    response_bytes = session.send_and_read_async.end(res);
                    debug("Send off request with uri %s", url);
                } catch (Error e) {
                    var error_message = e.message.split(":")[1];
                    if(error_message == null)
                        error_message = e.message;
                    status_line.set_error(error_message);
                }
                loop.quit();
            });

            loop.run();

            spinner.stop();
            spinner.visible = false;
            return response_bytes;
        }

        private void setup_request(Soup.Message msg)
        {
            var body_as_bytes = new Bytes.static(request_body.text.data);

            if(body_as_bytes.length != 0) {
                /* FIXME: hardcoded */
                msg.set_request_body_from_bytes("application/json",
                                                body_as_bytes);
            }
        }

        private void do_request()
        {
            Timer timer = null;
            Bytes response_bytes = null;

            var selected = method_dropdown.selected_item as Gtk.StringObject;
            var method = selected.string;
            var url = url_entry.text;

            return_if_fail(is_valid_uri(url));

            this.clear_response_info();

            msg = new Soup.Message(method, url);
            assert(msg != null);

            setup_request(msg);

            timer = new Timer();
            response_bytes = send_request(url);
            timer.stop();

            if(response_bytes == null) {
                return;
            }

            this.response = (string) response_bytes.get_data();

            this.set_response_info(msg, timer.elapsed(null));
        }

        private void set_response_info(Soup.Message msg, double time)
        {
            string content_type;
            string language = null;

            content_type = msg.response_headers.get_content_type(null);
            if(content_type != null) {
                language = content_type.split("/")[1];
                if(language == null) {
                    warning("Malformed mimetype in Content-Type header");
                }
            }

            header_view.headers = msg.response_headers;
            status_line.set_response_message(msg.status_code,
                                             msg.reason_phrase);

            if(!this.is_active) {
                string error;
                var notification = new Notification("Request completed");

                if(status_line.is_error()) {
                    error = "Server returned an error: "
                            + @"'$(status_line.get_response_message())'";
                } else {
                    error = "Request was successful";
                }
                notification.set_body(error);
                this.application.send_notification("request-complete",
                                                   notification);
            }

            view_manager.language_id = language;
            if(response != null) {
                view_manager.text = response;
                size_label.label = show_length(response.length);
            }

            time_label.label = "%u ms".printf((uint) (time * 1000.0));
        }

        private void clear_response_info()
        {
            response = null;
            view_manager.text = "";
            status_line.clear();
            size_label.label = "";
            header_view.headers = null;
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
