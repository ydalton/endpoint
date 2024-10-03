namespace Ep
{
    /**
     * Shows the amount in the appropriate unit
     */
    public string show_length(size_t length)
    {
	string ret = "";
	float kilobytes = length / 1024.0f;
	float megabytes = length / (1024.0f * 1024.0f);

	if (megabytes >= 1.0) {
	    ret = "%.1f MB".printf(megabytes);
	} else if(kilobytes >= 1.0) {
	    ret = "%.1f kB".printf(kilobytes);
	} else {
	    ret = "%lu B".printf(length);
	}

	return ret;
    }
}
