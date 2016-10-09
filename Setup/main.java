import java.util.*;
import java.util.zip.*;
import java.io.*;
import java.nio.*;
import java.net.*;
import java.nio.channels.*;
public class main {
    private static String zipPath = System.getProperty("user.home") + File.separator + "BSHS_TV_SETUP" + File.separator + "master.zip";
    private static String zipOutputFolder = System.getProperty("user.home") + File.separator + "BSHS_TV_SETUP" + File.separator + "UNZIPPED";
    public static void main(String[] args)
    {
       System.out.println("Downloading source...");
       downloadSource();
       System.out.println("Unzipping archive...");
       unzip();
       System.out.println("Preparing Setup Wizard...");
       SetupWizard wiz = new SetupWizard(new File(zipOutputFolder));
       wiz.start();
    }
    public static void updateURLS(String url)
    {
        // Read contents of file
        //File appDelegate = System.getProperty("user.dir"
    }
    public static void downloadSource()
    {
        File downloadDest = new File(System.getProperty("user.home") + File.separator + "BSHS_TV_SETUP" + File.separator);
        if(downloadDest.exists() == false)
            downloadDest.mkdirs();
        try {
            URL website = new URL("https://github.com/brendanmanning/BSHSTV/archive/master.zip");
            ReadableByteChannel rbc = Channels.newChannel(website.openStream());
            FileOutputStream fos = new FileOutputStream(zipPath);
            fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
        } catch (Exception e) {
            System.out.println("An exception was thrown");
        }
    }
    public static void unzip()
    {
        try {
            ZipInputStream zis = new ZipInputStream(new FileInputStream(zipPath));
        
            /* Loop through files in zip */
            ZipEntry ze = zis.getNextEntry();
            while(ze != null)
            {
                // Get file name
                String fname = ze.getName();
                
                // Create a file object
                File file = new File(zipOutputFolder + File.separator + fname);
                if(ze.isDirectory()) {
                    file.mkdirs();
                } else {
                    // Recursively make all folders required to store file
                    file.getParentFile().mkdirs();
                
                    // Write the file
                    FileOutputStream fos = new FileOutputStream(file);
                    int len;
                    byte buffer[] = new byte[1024];
                    while((len = zis.read(buffer)) > 0) {
                        fos.write(buffer,0,len);
                    }   
                    fos.close();
                }
                // Recurse
                ze = zis.getNextEntry();
            }
        } catch (Exception e) {
            System.out.println("Error unzipping");
            System.out.println(e.getMessage());
        }
    }
}