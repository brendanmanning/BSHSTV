import javax.swing.*;
import java.io.*;
/**
 * Write a description of class SetupWizard here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class SetupWizard
{
    // instance variables - replace the example below with your own
    private File baseDir;
    private SetupWizardHandler handler;
    private LeaveSetup ls = new LeaveSetup();
    /**
     * Constructor for objects of class SetupWizard
     */
    public SetupWizard(File baseDirectory)
    {
        this.baseDir = baseDirectory;
        handler = new SetupWizardHandler(baseDirectory);
    }
    public void start()
    {
        this.setupIOSServer();
        this.setupServerDBConstants();
    }
    private boolean setupIOSServer()
    {
        boolean ok = false;
        do {
            String input = JOptionPane.showInputDialog(null,"What is the URL of your webserver? Type help for more information", "");
            /* ls is an instance of the LeaveSetup class, which shows a Yes/No dialog
             * asking the user if he/she wants to quit. If yes is chosen, it runs System.Exit(),
             * otherwise we continue with our execution
             */
            if(input == null) {
                ls.show();
            } else {
                /* Help the user if they need it */
                if(input.toLowerCase().equals("help"))
                {
                    JOptionPane.showMessageDialog(null,"The iOS app must connect to an online server (you'll set that up later)\nYou must have a modern webserver with PHP and MySQL to put the server on\nHere all we need is the url where you will install the server");
                } else {
                    /* Sanitze the URL
                     * If there is no URL protocol, add http
                     * If there isn't a trailing slash, add one
                     */
                    if((input.startsWith("http://") == false) && (input.startsWith("https://") == false))
                    {
                        input = "http://" + input;
                    }
                    if(input.endsWith("/") == false)
                        input += "/";
                
                    /* Make sure the user is okay with this */
                    int confirmed = JOptionPane.showConfirmDialog(null,"Is this the correct URL?\n" + input,"Confirm Step 1",JOptionPane.YES_NO_OPTION);
                    if(confirmed == JOptionPane.YES_OPTION)
                    {
                        /* Run the handler which replaces {server_url} in AppDelegate.swift
                         * (part of the iOS App Source) with the user's input
                         * Set okay to the result so if succeeds, we can exit this loop
                         */
                        ok = handler.replaceServerURL(input);
                    }
                }
            }
        } while(!ok);
        
        return true;
    }
    public boolean setupServerDBConstants()
    {
        /* Ask the user for the following information for the PHP Server:
         *  + host
         *  + user
         *  + pass
         *  + db name
         *  + admin password
         */
        
        boolean ok = false;
        do {
            /* Tell the user what they're about to provide */
            JOptionPane.showMessageDialog(null, "The iOS app must connect to an online server you will setup\nHere we are going to be inputting the follwing basic information database information that you must setup on your web host.\nBegin?", "Step 2", JOptionPane.INFORMATION_MESSAGE);
            
            /* Ask the user for the database name */
            String databaseName;
            boolean nameOk = false;
            do {
                databaseName = JOptionPane.showInputDialog(null, "MySQL Database Name", "");
                if(databaseName == null) {
                    ls.show();
                } else {
                    nameOk = true;
                }
            } while(!nameOk);
            /* Ask the user for the database user */
            String databaseUser;
            boolean userOk = false;
            do {
                databaseUser = JOptionPane.showInputDialog(null, "MySQL Databse User", "");
                if(databaseUser == null) {
                    ls.show();
                } else {
                    userOk = true;
                }
            } while(!userOk);
            
            /* Ask the user for the database pass */
            String databasePass;
            boolean databasePassOk = false;
            do {
                databasePass = JOptionPane.showInputDialog(null, "MySQL User Password", "");
                if(databasePass == null) {
                    ls.show();
                } else {
                    databasePassOk = true;
                }
            } while(!databasePassOk); 
            
            /* Ask the user for the admin UI pass */
            String uiPass;
            boolean uiPassOk = false;
            do {
                uiPass = JOptionPane.showInputDialog(null,"Admin UI Password\nYou will use this to login to the admin interface which manages the server","");
                if(uiPass == null) {
                    ls.show();
                } else {
                    /* Use the Password Validator class to make sure the password has 
                     * 1 numeral, 1 uppercase, 1 lowercase, and 1 special,
                     * and is 8 characters or longer */
                     
                     /* Setup Password Validator */
                    PasswordValidator validator = new PasswordValidator();
                    validator.numeral(1);
                    validator.uppercase(1);
                    validator.lowercase(1);
                    validator.special(1);
                    validator.length(8);
                    
                    /* Validate the password */
                    if(!validator.validate(uiPass))
                    {
                        JOptionPane.showMessageDialog(null, "Your password was invalid\n" + validator.description(), "Password invalid", JOptionPane.WARNING_MESSAGE);
                    } else {
                        if(uiPass.contains("\"") || uiPass.contains("'")) {
                            JOptionPane.showMessageDialog(null, "Passwords cannot contain quotes (\" or \')", "Password contains illegal characters", JOptionPane.WARNING_MESSAGE);
                        } else {
                            uiPassOk = true;
                        }
                    }
                }
            } while(!uiPassOk);
            
            /* Now that all the information is ready, write it to the file:
             * BSHSTV-master/Server/2.0/config.php
             */
            ok = handler.replaceServerDBConstants(databaseUser,databasePass,databaseName,uiPass);
            if(!ok)
            {
                JOptionPane.showMessageDialog(null, "The operation failed. Please try again", "Step 2: Failed", JOptionPane.WARNING_MESSAGE);
            }
        } while(!ok);
        
        return true;
    }
}
