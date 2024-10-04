namespace Ep
{
    internal class CodeViewManager : Object
    {
        private List<CodeView> view_list;
        public string text { get; set; }
        public string language_id { get; set; }

        construct {
            view_list = new List<CodeView>();
            this.notify["text"].connect(this.on_text_changed_cb);
            this.notify["language-id"].connect(this.on_language_id_change_cb);
        }

        private void on_text_changed_cb()
        {
            foreach (var view in view_list) {
                view.text = text;
            }
        }

        private void on_language_id_change_cb()
        {
            foreach (var view in view_list) {
                view.language_id = language_id;
            }
        }

        public CodeViewManager()
        {
            Object();
        }

        public void add(CodeView view)
        {
            view_list.append(view);
        }
    }
}
