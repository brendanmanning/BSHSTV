import java.nio.*;
import java.nio.channels.*;
import java.net.*;
import java.io.*;
/**
 * Write a description of class Download here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Download
{
    private String url;

    /**
     * Constructor for objects of class Download
     */
    public Download(String u)
    {
        this.url = u;
    }
    public boolean download(String to) throws MalformedURLException,IOException
    {
        URL website = new URL("http://www.website.com/information.asp");
        ReadableByteChannel rbc = Channels.newChannel(website.openStream());
        FileOutputStream fos = new FileOutputStream("information.html");
        fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
        
        return false;
    }
}
