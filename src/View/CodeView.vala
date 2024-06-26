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

        public CodeView(string language_id, bool editable)
        {
            Object(language_id: language_id, editable: editable);
        }
    }
}
