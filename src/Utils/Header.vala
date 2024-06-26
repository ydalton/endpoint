namespace Ep
{
    public class Header : Object
    {
        public string name { get; set; }
        public string value { get; set; }

        public Header(string name, string value) 
        {
            Object(name: name, value: value);
        }
    }
}
