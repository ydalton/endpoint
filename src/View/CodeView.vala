namespace Ep
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/CodeView.ui")]
    public class CodeView : Gtk.Box 
    {
        private GtkSource.LanguageManager manager;

        [GtkChild]
        private unowned GtkSource.View source_view;

        public string language_id { get; set; }
        public bool editable { get; set; }
        public string text {get; set; default = ""; }
        public string mimetype { get; set; }
        public bool format_text { get; set; }

        [GtkCallback]
        private void on_language_change_cb()
        {
            GtkSource.Language language = null;
            GtkSource.Buffer buffer;

            buffer = this.source_view.buffer as GtkSource.Buffer;

            if(language_id != null) {

                this.manager = GtkSource.LanguageManager.get_default();

                language = this.manager.get_language(language_id);

                if(language == null)
                    warning("Can't find language with language id %s\n",
                            language_id);
            }

            buffer.language = language;
        }

        [GtkCallback]
        private void on_text_change_cb()
        {
            Json.Node node;

            debug("Parsing JSON...");

            if(language_id != "json" || !this.format_text || this.text == "")
                return;

            try {
                node = Json.from_string(text);
            } catch(Error e) {
                warning("Failed to parse JSON: %s", e.message);
                warning("Bailing on JSON pretty printing...");
                return;
            }

            if(node == null) {
                warning("JSON improperly parsed");
                return;
            }

            var str = Json.to_string(node, true);
            text = str;
        }

        private void on_prefer_dark_change_cb(Gtk.Settings settings)
        {
            string theme_name;
            GtkSource.Buffer buffer;
            var style_manager = GtkSource.StyleSchemeManager.get_default();
            bool prefer_dark = settings.gtk_application_prefer_dark_theme;

            buffer = this.source_view.buffer as GtkSource.Buffer;

            /* FIXME: does this work with the Breeze theme? */
            theme_name = prefer_dark ? "Adwaita-dark" : "Adwaita";

            message("Setting theme to %s...", theme_name);

            /* XXX: useless? */
            if(style_manager.scheme_ids == null) {
                warning("GtkSourceStyleSchemeManager.scheme-ids returned null");
                return;
            }

            if(theme_name in style_manager.scheme_ids) {
                buffer.style_scheme = style_manager.get_scheme(theme_name);
            }
        }

        construct {
            var settings = Gtk.Settings.get_default();

            settings.notify["gtk-application-prefer-dark-theme"]
                    .connect(() => on_prefer_dark_change_cb(settings));

            on_prefer_dark_change_cb(settings);
        }

        public CodeView(string language_id, bool editable)
        {
            Object(language_id: language_id, editable: editable);
        }
    }
}
