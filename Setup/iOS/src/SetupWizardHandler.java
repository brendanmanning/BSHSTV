import java.io.*;
import javax.swing.*;
import java.util.Random;
/**
 * Write a description of class SetupWizard here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class SetupWizardHandler
{
    private File baseDir;
    public SetupWizardHandler(File rootFolder)
    {
       this.baseDir = rootFolder;
    }
    public boolean replaceServerURL(String with)
    {
        // Create a file object for AppDelegate.swift
        String appDelegateString = addTrailingSlash(baseDir.getAbsolutePath()) + "BSHSTV-master" + File.separator
        + "Clients" + File.separator + "iOS" + File.separator + "Channel 2" + File.separator + "AppDelegate.swift";
        File appDelegate = new File(appDelegateString);
        
        FileEditor fe = new FileEditor(appDelegate);
        boolean one =  fe.replace("{server_url}",with);
        
        String infoPlistString = addTrailingSlash(baseDir.getAbsolutePath()) + "BSHSTV-master" + File.separator + "Clients" +
        File.separator + "iOS" + File.separator + "Channel 2" + File.separator + "Info.plist";
        File infoPlist = new File(infoPlistString);
        FileEditor fe2 = new FileEditor(infoPlist);
        boolean two = fe2.replace("{server_url}",with);
        
        return (one && two);
    }
    public boolean replaceServerDBConstants(String user, String pass, String name,String uiPass)
    {
        String configFileString = addTrailingSlash(baseDir.getAbsolutePath()) + "BSHSTV-master" + File.separator + 
        "Server" + File.separator + "2.0" + File.separator + "config.php";
        File configFile = new File(configFileString);
        
        FileEditor fe = new FileEditor(configFile);
        
        /* Local host is default */
        boolean host_w = fe.replace("{dbhost}", "localhost");
        
        /* Record whether each operation was sucessful */
        boolean user_w = fe.replace("{dbuser}", user);
        boolean pass_w = fe.replace("{dbpass}", pass);
        boolean name_w = fe.replace("{dbname}", name);
        boolean uipass_w = fe.replace("{admin_pass}", uiPass);
        
        /* If they were all sucessful, return true, else return false */
        return (host_w && user_w && pass_w && name_w && uipass_w);
    }
    public int setupServerSetupCode()
    {
        String setupKeyFileString = addTrailingSlash(baseDir.getAbsolutePath()) + "BSHSTV-master" + File.separator + 
        "Server" + File.separator + "2.0" + File.separator + "__installation" + File.separator + "__setup_key.php";
        
        File setupKeyFile = new File(setupKeyFileString);
        
        FileEditor fe = new FileEditor(setupKeyFile);
        
        Random rand = new Random();
        int code = rand.nextInt((9999999 - 99999) + 1) + 99999;
        fe.replace("{setup_code}", "" + code);
        return code;
    }
    public String[] setupServerAPIKeys()
    {
        String apiKeyFileString = addTrailingSlash(baseDir.getAbsolutePath()) + "BSHSTV-master" + File.separator + 
        "Server" + File.separator + "2.0" + File.separator + "__installation" + File.separator + "__api.php";
        
        File apiKeyFile = new File(apiKeyFileString);
        
        FileEditor fe = new FileEditor(apiKeyFile);
        
        Random r = new Random();
        int code = r.nextInt((999999999 - 9999999) + 9999999) + 9999999;
        fe.replace("{api_key}", "" + code);
        String secret = randomString(15);
        fe.replace("{api_secret}", secret);
        
        return new String[]{"" + code,secret};
    }
    private String randomString(int ofLength)
    {
        String alphabet = "";
        for(int c = 65; c < 90; c++)
        {
            alphabet += Character.toString((char) c);
            alphabet += Character.toString((char) c).toUpperCase();
        }
        String randString = "";
        Random r = new Random();
        for(int i = 0; i < ofLength; i++)
        {
            int code = r.nextInt((26 - 1) + 1) + 1;
            randString += Character.toString(alphabet.charAt(code));
        }
        return randString;
    }
    private String addTrailingSlash(String s)
    {
        if(!s.endsWith(File.separator))
        {
            s += File.separator;
        }
        return s;
    }
}