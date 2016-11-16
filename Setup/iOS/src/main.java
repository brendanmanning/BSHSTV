import java.util.*;
import java.util.zip.*;
import java.io.*;
import java.nio.*;
import java.net.*;
import java.nio.channels.*;
import javax.swing.*;
public class main {
    private static String zipPath = System.getProperty("user.home") + File.separator + "BSHS_TV_SETUP" + File.separator + "master.zip";
    private static String zipOutputFolder = System.getProperty("user.home") + File.separator + "BSHS_TV_SETUP" + File.separator + "UNZIPPED";
    public static void main(String[] args)
    {
       /* Check if the source folder already exists */
       if(new File(System.getProperty("user.home") + File.separator + "BSHS_TV_SETUP" + File.separator).exists())
       {
           deleteExisting();
       }
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
    private static void deleteExisting()
    {
        int response = JOptionPane.showConfirmDialog(null, "Data has already been downloaded\nWould you like to remove it and start fresh?", "Reset Data?",JOptionPane.YES_NO_OPTION);
        if(response == JOptionPane.YES_OPTION) {
            String setupFolderString = System.getProperty("user.home") + File.separator + "BSHS_TV_SETUP" + File.separator;
            File setupFolder = new File(setupFolderString);
            System.out.println("Removing existing setup data...");
            removeFolder(setupFolder);
        }
    }
    private static void removeFolder(File folder)
    {
        if(folder.exists())
        {
            if(folder.isDirectory())
            {
                File[] files = folder.listFiles();
                if(files != null && files.length > 0)
                {
                    for(File f : files)
                    {
                        removeFolder(f);
                    }
                }
                folder.delete();
            } else {
                folder.delete();
            }
        }
    }
}