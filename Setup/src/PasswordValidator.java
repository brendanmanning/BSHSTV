
/**
 * Write a description of class PasswordValidator here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class PasswordValidator
{
    private int requiredUpper = 0;
    private int requiredSpecial = 0;
    private int requiredNumeral = 0;
    private int requiredLower = 0;
    private int requiredLength = 0;
    private String passwordToValidate;
    public PasswordValidator(){}
    public void uppercase(int u)
    {
        this.requiredUpper = u;
    }
    public void special(int s)
    {
        this.requiredSpecial = s;
    }
    public void numeral(int n)
    {
        this.requiredNumeral = n;
    }
    public void lowercase(int l)
    {
        this.requiredLower = l;
    }
    public void length(int len)
    {
        this.requiredLength = len;
    }
    public boolean validate(String password)
    {
        passwordToValidate = password;
        if(countUpper() >= requiredUpper)
            if(countSpecial() >= requiredSpecial)
                if(countNumeral() >= requiredNumeral)
                    if(countLower() >= requiredLower)
                        if(passwordToValidate.length() >= requiredLength)
                            return true;
        return false;
    }
    public String description()
    {
        String desc = "Passwords must contain";
        if(requiredUpper > 0)
            desc += "\n" + requiredUpper + " uppercase letter(s)";
        if(requiredSpecial > 0)
            desc += "\n" + requiredSpecial + " special character(s)";
        if(requiredNumeral > 0)
            desc += "\n" + requiredNumeral + " number(s)";
        if(requiredLower > 0)
            desc += "\n" + requiredLower + " lowercase letter(s)";
        desc += "\nPasswords must be " + requiredLength + " characters or longer";
        return desc;
    }
    private int countUpper()
    {
        return countInRange(65,90);
    }
    private int countSpecial()
    {
        int special = countInRange(33,47);
        special += countInRange(58,64);
        special += countInRange(91,96);
        special += countInRange(123,126);
        return special;
    }
    private int countNumeral()
    {
        return countInRange(48,57);
    }
    private int countLower()
    {
        return countInRange(97,122);
    }
    private int countInRange(int lower,int upper)
    {
        int inrange = 0;
        for(int c = 0; c < (passwordToValidate.length() - 1); c++)
        {
            int ascii = (int) passwordToValidate.charAt(c);
            if((ascii >= lower) && (ascii <= upper))
               inrange++;
        }
        return inrange;
    }
}
