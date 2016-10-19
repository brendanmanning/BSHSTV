import javax.swing.*;
/**
 * Write a description of class LeaveSetup here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class LeaveSetup
{
    public LeaveSetup()
    {}
    public void show() {
        int answer = JOptionPane.showConfirmDialog(null,"You are about to exit setup. You will have to restart ALL progress later\nAre you sure?", "Confirm Exit", JOptionPane.YES_NO_OPTION);
        if(answer == JOptionPane.YES_OPTION) {
            System.out.println("Goodbye...");
            System.exit(0);
        }
    }
}
