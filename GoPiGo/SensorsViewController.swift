//
//  SensorsViewController.swift
//  GoPiGo
//
//  Created by Yukai Ma on 23/10/2016.
//  Copyright © 2016 Monash. All rights reserved.
//

import UIKit
import SwiftMQTT

class SensorsViewController: UIViewController {
    

    @IBOutlet weak var pageControl: UIPageControl!
    
    var upperView: UIView!
    var sensorDataMonitorView = UIView()
    var titleLabel = UILabel()
    var dataLabel = UILabel()
    
    // create swipe gesture
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set gesture direction
        self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        self.swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        
        // add gesture target
        self.swipeGestureLeft.addTarget(self, action: #selector(self.handleSwipeLeft(_:)))
        self.swipeGestureRight.addTarget(self, action: #selector(self.handleSwipeRight(_:)))
        
        
        // add gesture in to view
        self.view.addGestureRecognizer(self.swipeGestureLeft)
        self.view.addGestureRecognizer(self.swipeGestureRight)
        
        
        //init sensorData view
        self.upperView = UIView(frame: CGRect(x:0.0,y:0.0,width:self.view.frame.width,height:self.view.frame.height-200))
        
        //add upper view
        self.view.addSubview(upperView)
        
        
        
        setNavBar()
        setCurrentView()
        setLowerView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return UIInterfaceOrientation(rawValue: 1)!
        // return landscapeLeft
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
     
        return UIInterfaceOrientationMask.portrait
    }
    
    // increase page number on swift left
    func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        if self.pageControl.currentPage < 1 {
            self.pageControl.currentPage += 1
            self.setCurrentView()
        }
    }
    
    // reduce page number on swift right
    func handleSwipeRight(_ gesture: UISwipeGestureRecognizer){
        if self.pageControl.currentPage != 0 {
            self.pageControl.currentPage -= 1
            self.setCurrentView()
        }
        
        
    }
    
    func setCurrentView()
    {
        //
        print("current page")
        print(self.pageControl.currentPage)
        if(self.pageControl.currentPage == 0)
        {
            setUpperViewForTemp()
        }
        
        if(self.pageControl.currentPage == 1)
        {
            setUpperViewForGas()
        }
        
    }
    
    
    func setNavBar()
    {
        //set nav bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    
    func setSensorDataView()
    {
        //init sensorData view
        
        sensorDataMonitorView.frame = CGRect(x:upperView.frame.width/2 - 75,y:upperView.frame.height/2 - 100,width:150,height:150)
        sensorDataMonitorView.alpha = 0.8
        
        //set shadow
        sensorDataMonitorView.layer.shadowColor = UIColor.black.cgColor
        sensorDataMonitorView.layer.shadowOffset =  CGSize(width: 2, height: 2)
        sensorDataMonitorView.layer.shadowOpacity = 0.8
        sensorDataMonitorView.layer.shadowRadius = 4
        
        //make circle
        sensorDataMonitorView.layer.cornerRadius = sensorDataMonitorView.frame.size.width / 2
        sensorDataMonitorView.clipsToBounds = true
        
        //set blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = sensorDataMonitorView.frame
        
        blurredEffectView.layer.cornerRadius = blurredEffectView.frame.size.width / 2
        blurredEffectView.clipsToBounds = true
        
        //set temp label attributes
        let customFont = UIFont(name:"Arial-BoldMT",size:50)
        dataLabel.font = customFont
        //tempLabel.sizeToFit()
        dataLabel.frame = sensorDataMonitorView.frame
        dataLabel.backgroundColor = UIColor.clear
        dataLabel.textColor = UIColor.white
        dataLabel.adjustsFontSizeToFitWidth = true
        dataLabel.textAlignment = NSTextAlignment.center
        
        
        //set title label attributes
        let titleFont = UIFont(name:"Menlo-Bold ",size:13)
        titleLabel.font = titleFont
        //tempLabel.sizeToFit()
        titleLabel.frame = CGRect(x:upperView.frame.width/2 - 75,y: 13 ,width:150,height:20)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = NSTextAlignment.center
        
        
        //add views
        self.upperView.addSubview(sensorDataMonitorView)
        self.upperView.addSubview(dataLabel)
        self.upperView.addSubview(titleLabel)
        
        // sensorDataMonitorView.addSubview(blurredEffectView)
        
        
        
    }
    
    
    
    //  func calculateColor(temperature:Double) -> UIColor{
    
    // let  percent = temperature / 100
    //      let  rgb1 = color1.rgb()
    //     let  rgb2 = color2.rgb()
    
    //   let  resultRed = (rgb1?.red)! + percent * ((rgb2?.red)! - (rgb1?.red)!)
    // let  resultGreen = (rgb1?.green)! + percent * ((rgb2?.green)! - (rgb1?.green)!)
    //let  resultBlue = (rgb1?.blue)! + percent * ((rgb2?.blue)! - (rgb1?.blue)!)
    
    //   print("RGB")
    // print(resultRed)
    //  print(resultGreen)
    // print(resultBlue)
    
    //  return UIColor(red: Int(resultRed),green: Int(resultGreen),blue: Int(resultBlue))
    
    // }
    
    func setUpperViewForTemp()
    {
        //set title
        self.titleLabel.text = "Temprature sensor"
        
        //set data
        dataLabel.text = "27 ℃"
        
        //set data view background color
        sensorDataMonitorView.backgroundColor = UIColor(red: 241,green: 174,blue: 176)
        
        //set gradient
        let color1 = UIColor(red: 241,green: 159,blue: 160)
        let color2  = UIColor(red: 203,green: 117,blue: 117)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = upperView.bounds
        gradient.colors = [color1.cgColor,color2.cgColor]
        
        self.upperView.layer.sublayers?.remove(at: 0)
        self.upperView.layer.insertSublayer(gradient, at: 0)
        
        setSensorDataView()
        
    }
    
    
    func setUpperViewForGas()
    {
        //set title
        self.titleLabel.text = "Gas sensor"
        
        //set data
        dataLabel.text = "27 ℃"
        
        //set data view background color
        sensorDataMonitorView.backgroundColor = UIColor(red: 163,green: 201,blue: 200)
        
        //set gradient
        let color1 = UIColor(red: 163,green: 201,blue: 200)
        let color2  = UIColor(red: 127,green: 171,blue: 170)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = upperView.bounds
        gradient.colors = [color1.cgColor,color2.cgColor]
        
        self.upperView.layer.sublayers?.remove(at: 0)
        self.upperView.layer.insertSublayer(gradient, at: 0)
        
        
        setSensorDataView()
        
    }
    
    
    
    //add table
    
    func setLowerView()
    {
        //init lower view
        let lowerView = UIView(frame: CGRect(x:0.0,y:self.view.frame.height-200,width:self.view.frame.width,height:200))
        lowerView.backgroundColor = UIColor.white
        
        //add lower view
        self.view.addSubview(lowerView)
        
        //init font for table
        let customFont = UIFont(name:"Copperplate-Bold",size:15)
        
        //init title
        let lowerViewTitleLabel = UILabel()
        lowerViewTitleLabel.text = "Reference table"
        lowerViewTitleLabel.font = customFont
        lowerViewTitleLabel.frame = CGRect(x:lowerView.frame.width/2 - 75,y: 5 ,width:150,height:20)
        lowerViewTitleLabel.backgroundColor = UIColor.clear
        lowerViewTitleLabel.adjustsFontSizeToFitWidth = true
        lowerViewTitleLabel.textAlignment = NSTextAlignment.center
        
        
        //init temp label
        
        let tempTitleLabel = UILabel()
        tempTitleLabel.text = "Temprature:"
        tempTitleLabel.font = customFont
        tempTitleLabel.frame = CGRect(x:10,y: 30 ,width:80,height:20)
        tempTitleLabel.backgroundColor = UIColor.clear
        tempTitleLabel.adjustsFontSizeToFitWidth = true
        tempTitleLabel.textAlignment = NSTextAlignment.left
        
        //init gas label
        
        let gasTitleLabel = UILabel()
        gasTitleLabel.text = "Gas density:"
        gasTitleLabel.font = customFont
        gasTitleLabel.frame = CGRect(x:10,y: 90 ,width:80,height:20)
        gasTitleLabel.backgroundColor = UIColor.clear
        gasTitleLabel.adjustsFontSizeToFitWidth = true
        gasTitleLabel.textAlignment = NSTextAlignment.left
        
        lowerView.addSubview(lowerViewTitleLabel)
        lowerView.addSubview(tempTitleLabel)
        lowerView.addSubview(gasTitleLabel)
        
        
        //init temp value label
        
        let tempValueLabel = UILabel()
        tempValueLabel.text =  "27 ℃"
        tempValueLabel.font = customFont
        tempValueLabel.frame = CGRect(x:lowerView.frame.width - 80,y: 30 ,width:80,height:20)
        tempValueLabel.backgroundColor = UIColor.clear
        tempValueLabel.adjustsFontSizeToFitWidth = true
        tempValueLabel.textAlignment = NSTextAlignment.left
        
        //init gas value label
        
        let gasValueLabel = UILabel()
        gasValueLabel.text =  "Normal"
        gasValueLabel.font = customFont
        gasValueLabel.frame = CGRect(x:lowerView.frame.width - 80,y: 90 ,width:80,height:20)
        gasValueLabel.backgroundColor = UIColor.clear
        gasValueLabel.adjustsFontSizeToFitWidth = true
        gasValueLabel.textAlignment = NSTextAlignment.left
        
        lowerView.addSubview(lowerViewTitleLabel)
        lowerView.addSubview(tempTitleLabel)
        lowerView.addSubview(gasTitleLabel)
        lowerView.addSubview(tempValueLabel)
        lowerView.addSubview(gasValueLabel)
        
        
        
    }
    
}
