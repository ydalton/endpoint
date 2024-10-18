namespace Ep
{
    [GtkTemplate(ui="/io/github/ydalton/Endpoint/ui/View/HeaderView.ui")]
    public class HeaderView : Gtk.Widget
    {
        [GtkChild]
        private unowned Gtk.ColumnView column_view;
        [GtkChild]
        private unowned Gtk.ColumnViewColumn value_column;
        [GtkChild]
        private unowned Gtk.ColumnViewColumn header_column;

        public Soup.MessageHeaders headers { get; set; }
        private ListStore header_models = null;

        static construct {
            set_layout_manager_type(typeof(Gtk.BinLayout));
        }

        [GtkCallback]
        private void on_header_change_cb()
        {
            Gtk.SelectionModel selection_model;

            header_models = new ListStore(typeof(Header));

            if(headers != null) {
                headers.foreach((name, value) => {
                    header_models.append(new Header(name, value));
                });
            }

            selection_model = new Gtk.SingleSelection(header_models);
            column_view.model = selection_model;

            setup_column_view();
        }

        private void factory_setup_cb(Gtk.SignalListItemFactory factory,
                                      Object item)
        {
            var label = new Gtk.Label(null);
            var list_item = (item as Gtk.ListItem);
            label.halign = Gtk.Align.START;
            label.selectable = true;
            list_item.child = label;
        }

        private void setup_column_view()
        {
            Gtk.SignalListItemFactory factory;

            factory = new Gtk.SignalListItemFactory();

            /* header name */
            factory.setup.connect(factory_setup_cb);
            factory.bind.connect((factory, item) => {
                var list_item = item as Gtk.ListItem;
                var label = list_item.child as Gtk.Label;
                var header = list_item.item as Header;

                label.label = header.name;
            });
            header_column.factory = factory;

            /* header value */
            factory = new Gtk.SignalListItemFactory();
            factory.setup.connect(factory_setup_cb);
            factory.bind.connect((factory, item) => {
                var list_item = item as Gtk.ListItem;
                var header = list_item.item as Header;
                var label = (list_item.child as Gtk.Label);
                label.label = header.value;
            });
            value_column.factory = factory;
        }

        ~HeaderView()
        {
            while(get_first_child() != null) {
                get_first_child().unparent();
            }
        }
    }
}
