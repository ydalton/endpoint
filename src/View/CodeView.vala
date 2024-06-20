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

        [GtkCallback]
        private void on_language_change_cb()
        {
            if(language_id == null) 
                return;
            this.manager = GtkSource.LanguageManager.get_default();

            GtkSource.Buffer buffer = this.source_view.buffer as GtkSource.Buffer;
            GtkSource.Language language = this.manager.get_language(language_id);

            if(language == null) {
                warning("Can't find language with language id %s\n", language_id);
            }

            buffer.language = language;
        }

        public CodeView(string language_id, bool editable)
        {
            Object(language_id: language_id, editable: editable);
        }
    }
}