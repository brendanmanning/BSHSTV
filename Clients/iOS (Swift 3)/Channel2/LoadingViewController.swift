//
//  LoadingViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/25/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    var label:UILabel!;
    var dots = 0;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let labelFrame = CGRectMake(8, (self.view.frame.height / 2), (self.view.frame.width - 8), 50)
        label = UILabel(frame: labelFrame)
        label.font = UIFont(name: "Helvetica", size: 24)
        label.textColor = UIColor.whiteColor();
        label.text = "Loading"
        self.view.addSubview(label)
        self.view.backgroundColor = UIColor.greenColor();
        self.startAnimating();
    }

    func startAnimating() {
        Async.background {
            while(true)
            {
                Async.background {
                    if(self.dots < 3) {
                        Async.main {
                            self.label.text = "Loading" + self.makeDots(self.dots);
                            self.dots += 1;
                        }
                    } else {
                        Async.main {self.label.text = "Loading"; self.dots=0;}
                    }
                    
                }.wait(seconds: 2)
                
                
            }
        }
    }
    
    func makeDots(d:Int) -> String
    {
        var str = "";
        for(var i = 0; i < d; i += 1) {
            str += "."
        }
        
        return str;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
