import java.io.*;
import javax.swing.*;
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
        + "Clients" + File.separator + "iOS" + File.separator + "Channel2" + File.separator + "AppDelegate.swift";
        File appDelegate = new File(appDelegateString);
        
        FileEditor fe = new FileEditor(appDelegate);
        boolean one =  fe.replace("{server_url}",with);
        
        String infoPlistString = addTrailingSlash(baseDir.getAbsolutePath()) + "BSHSTV-master" + File.separator + "Clients" +
        File.separator + "iOS" + File.separator + "Channel2" + File.separator + "Info.plist";
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
    private String addTrailingSlash(String s)
    {
        if(!s.endsWith(File.separator))
        {
            s += File.separator;
        }
        return s;
    }
}
