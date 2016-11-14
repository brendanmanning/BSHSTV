
/**
 * Write a description of class EmailValidator here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class EmailValidator
{
    private boolean emailValid = false;
    /**
     * Constructor for objects of class EmailValidator
     */
    public EmailValidator(String email)
    {
        // Validate the email
        String pattern = "[a-zA-Z0-9]+@(gmail|yahoo|verizon|comcast|outlook|aol|hotmail).(com|net|org)";
        if(email.matches(pattern)) {
            this.emailValid = true;
        }
    }

    /**
     * Validation Status Checker - Instances will call this to get the result of validation
     * 
     * @return     A boolean value indicating whether the email is valid
     */
    public boolean valid()
    {
        return this.emailValid;
    }
}
