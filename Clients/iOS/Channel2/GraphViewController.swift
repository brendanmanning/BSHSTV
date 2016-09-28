//
//  GraphViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/24/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//
/*
import UIKit
import Charts

class GraphViewController: UIViewController, UIGestureRecognizerDelegate {

    // Boring programming stuff
    internal var datalabels = [String]();
    internal var datavals = [Double]();
    private var colorsHaveBeenChosen = false;
    internal var pollprompt = "a poll without a prompt";
    
    // UI Elements
    internal let piechart = PieChartView();
    private let label = UILabel();
    private let titlelabel = UILabel();
    private var closeButton = UIButton();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Chart setup
        setupChart();
        view.addSubview(piechart)
       
        // Label setup
        setupLabels();
        view.addSubview(label)
        view.addSubview(titlelabel)

        // Exit gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(GraphViewController.handleTap(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
    }

    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        // Refresh the locations of the UI Elements so they stay centered
        setupChart();
        setupLabels();
        
    }
    
    private func setupLabels()
    {
        label.frame = CGRectMake(self.view.center.x, 60, self.view.frame.width, 40)
        label.center.x = self.view.center.x
        label.text = getLabelText();
        label.textAlignment = .Center;
        
        titlelabel.frame = CGRectMake(self.view.center.x, 30, self.view.frame.width, 30)
        titlelabel.font = titlelabel.font.fontWithSize(29.0)
        titlelabel.center.x = self.view.center.x
        titlelabel.textAlignment = .Center
        titlelabel.minimumScaleFactor = 0.5;
        titlelabel.text = "Poll Results - Tap anywhere to close"
    }
    
    private func setupExitButton()
    {
        let ximage = UIImage(named: "close");
        closeButton = UIButton(type: UIButtonType.Custom);
        closeButton.frame = CGRectMake(10, 10, 90, 90);
        closeButton.setImage(ximage, forState: .Normal);
    }
    
    @objc private func exitPressed()
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    private func setupChart()
    {
        var choices = [String]();
        var values = [Double]();
        
        // Remove options that had 0 votes
        for i in 0..<self.datavals.count
        {
            if(self.datavals[i] != 0)
            {
                values.append(self.datavals[i]);
                choices.append(self.datalabels[i]);
            }
        }
        
        
        // Pick colors
        var colors = [NSUIColor]()
        let coloroptions = [UIColor(red:0.00, green:0.52, blue:0.03, alpha:1.0), UIColor(red:0.15, green:0.81, blue:0.18, alpha:1.0), UIColor(red:0.33, green:1.00, blue:0.35, alpha:1.0), UIColor(red:0.03, green:0.30, blue:0.03, alpha:1.0)];
        for x in 0..<values.count
        {
            colors.append(coloroptions[x])
        }
        
        var datavalues = [ChartDataEntry]();
        for i in 0..<values.count
        {
            let entry = ChartDataEntry(value: values[i],xIndex: i);
            datavalues.append(entry);
        }
        print(choices)
        let pcdataset = PieChartDataSet(yVals: datavalues, label: "");
        let pcdata = PieChartData(xVals: choices,dataSet: pcdataset);
        pcdataset.colors = colors;
        piechart.data = pcdata;
        piechart.centerText = "Poll results (% of votes)";
        piechart.centerTextRadiusPercent = 90;
        piechart.descriptionText = "Shanahan's thoughts on " + self.pollprompt;
        
        piechart.frame = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: view.frame.width * 0.5, height: view.frame.height * 0.5)
        piechart.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2)
        
        view.backgroundColor = UIColor.grayColor();
    }
  
    func getLabelText() -> String {
        var labeltext = "";
        if(self.datavals.count > 0)
        {
            var topval:Double = -1;
            for i in 0..<self.datavals.count
            {
                if(self.datavals[i] > topval)
                {
                    topval = self.datavals[i];
                    labeltext = self.datalabels[i] + " won!";
                } else if(self.datavals[i] == topval)
                {
                    var txt = "";
                    for x in 0..<self.datalabels.count
                    {
                        if(self.datavals[x] == topval)
                        {
                            txt += self.datalabels[x] + " & ";
                        }
                    }
                    labeltext = String(String(txt.characters.dropLast()).characters.dropLast()) + "tied.";
                }
            }
        }
        
        return labeltext;
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

}*/
