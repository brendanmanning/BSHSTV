import java.io.*;
/**
 * Write a description of class FileEditor here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class FileEditor
{
    private File f;
    public FileEditor(File file)
    {
        this.f = file;
    }
    public boolean replace(String string, String with)
    {
        try {
            String original = fileContents(f);
            String replaced = original.replace(string,with);
            try {
                writeToFile(f,replaced);
            } catch (IOException e) {
                return false;
            }
            return true;
        } catch (IOException ioe) {
            return false;
        }
    }
    private String fileContents(File file) throws IOException
    {
        String fileContents = "";
        
        /* Read the file line by line */
        try(BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while((line = br.readLine()) != null) {
                fileContents += line + "\n";
            }
        }
        
        /* Remove leading and trailing whitespaces */
        fileContents.trim();
        
        /* Return out string*/
        return fileContents;
    }
    private void writeToFile(File f, String s) throws IOException
    {
        FileWriter fw = new FileWriter(f,false);
        fw.write(s);
        fw.flush();
        fw.close();
    }
}
