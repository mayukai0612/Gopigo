//
//  SensorsViewController.swift
//  GoPiGo
//
//  Created by Yukai Ma on 23/10/2016.
//  Copyright © 2016 Monash. All rights reserved.
//

import UIKit
import SwiftMQTT

class SensorsViewController: UIViewController,MQTTSessionDelegate {
    

    @IBOutlet weak var pageControl: UIPageControl!
    
    var upperView: UIView!
    var sensorDataMonitorView = UIView() //show the data value
    var titleLabel = UILabel()
    var dataLabel = UILabel()
   
    
    var temperature:String?
    var gas:String?

    var mqttSession: MQTTSession!

    // create swipe gesture
    let swipeGestureLeft = UISwipeGestureRecognizer()
    let swipeGestureRight = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set gesture direction
        self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.swipeGestureRight.direction = UISwipeGestureRecognizerDirection.Right
        
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
        
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.setNavBar()
            self.setCurrentView()
            self.setLowerView()
        }
      
        
      //  listen to mqtt server
      //  setMqtt()
        
        
      //  dispatch_async(dispatch_get_global_queue(10, 0)) { // 1
           // self.setMqtt()
      //  }
//
        
        
        let backgroundQueue = dispatch_queue_create("com.app.mqtt", nil)
       // dispatch_async(backgroundQueue) {
        
//        }


        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    //change the orientation of device to potrait progmatically when view is to appear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        //sleep(5)
        self.createLocalNotifications("Fire alarm!")
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
   
    // increase page number on swift left
    func handleSwipeLeft(gesture: UISwipeGestureRecognizer){
        if self.pageControl.currentPage < 1 {
            self.pageControl.currentPage += 1
            self.setCurrentView()
        }
    }
    
    // reduce page number on swift right
    func handleSwipeRight(gesture: UISwipeGestureRecognizer){
        if self.pageControl.currentPage != 0 {
            self.pageControl.currentPage -= 1
            self.setCurrentView()
        }
    
    }
    
    //load view for the current page
    func setCurrentView()
    {
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        
    }
    
    
    func setSensorDataView()
    {
        //init sensorData view
        
        sensorDataMonitorView.frame = CGRect(x:upperView.frame.width/2 - 75,y:upperView.frame.height/2 - 100,width:150,height:150)
        sensorDataMonitorView.alpha = 0.8
        
        //set shadow
        sensorDataMonitorView.layer.shadowColor = UIColor.blackColor().CGColor
        sensorDataMonitorView.layer.shadowOffset =  CGSize(width: 2, height: 2)
        sensorDataMonitorView.layer.shadowOpacity = 0.8
        sensorDataMonitorView.layer.shadowRadius = 4
        
        //make circle
        sensorDataMonitorView.layer.cornerRadius = sensorDataMonitorView.frame.size.width / 2
        sensorDataMonitorView.clipsToBounds = true

        
        //set temp label attributes
        let customFont = UIFont(name:"Arial-BoldMT",size:50)
        dataLabel.font = customFont
        //tempLabel.sizeToFit()
        dataLabel.frame = sensorDataMonitorView.frame
        dataLabel.backgroundColor = UIColor.clearColor()
        dataLabel.textColor = UIColor.whiteColor()
        dataLabel.adjustsFontSizeToFitWidth = true
        dataLabel.textAlignment = NSTextAlignment.Center
        
        //set title label attributes
        let titleFont = UIFont(name:"Menlo-Bold ",size:13)
        titleLabel.font = titleFont
        //tempLabel.sizeToFit()
        titleLabel.frame = CGRect(x:upperView.frame.width/2 - 75,y: 13 ,width:150,height:20)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = NSTextAlignment.Center
        
        
        //add views
        self.upperView.addSubview(sensorDataMonitorView)
        self.upperView.addSubview(dataLabel)
        self.upperView.addSubview(titleLabel)

        
    }
    
    
    func setUpperViewForTemp()
    {
        //set title
        self.titleLabel.text = "Temprature sensor"
        
        //set data
        dataLabel.text = "Loading"
        
        //set data view background color
        sensorDataMonitorView.backgroundColor = UIColor(red: 241,green: 174,blue: 176)
        
        //set gradient
        let color1 = UIColor(red: 241,green: 159,blue: 160)
        let color2  = UIColor(red: 203,green: 117,blue: 117)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = upperView.bounds
        gradient.colors = [color1.CGColor,color2.CGColor]
        
        self.upperView.layer.sublayers?.removeAtIndex(0)
        self.upperView.layer.insertSublayer(gradient, atIndex: 0)
        
        setSensorDataView()
        
    }
    
    
    func setUpperViewForGas()
    {
        //set title
        self.titleLabel.text = "Gas sensor"
        
        //set data
        dataLabel.text = "Safe"
        
        //set data view background color
        sensorDataMonitorView.backgroundColor = UIColor(red: 163,green: 201,blue: 200)
        
        //set gradient
        let color1 = UIColor(red: 163,green: 201,blue: 200)
        let color2  = UIColor(red: 127,green: 171,blue: 170)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = upperView.bounds
        gradient.colors = [color1.CGColor,color2.CGColor]
        
        self.upperView.layer.sublayers?.removeAtIndex(0)
        self.upperView.layer.insertSublayer(gradient, atIndex: 0)
        
        
        setSensorDataView()
        
    }
    
    
    
    //add table
    func setLowerView()
    {
        //init lower view
        let lowerView = UIView(frame: CGRect(x:0.0,y:self.view.frame.height-200,width:self.view.frame.width,height:200))
        lowerView.backgroundColor = UIColor.whiteColor()
        
        //add lower view
        self.view.addSubview(lowerView)
        
        //init font for table
        let customFont = UIFont(name:"Copperplate-Bold",size:15)
        
        //init table title
        let lowerViewTitleLabel = UILabel()
        lowerViewTitleLabel.text = "Reference table"
        lowerViewTitleLabel.font = customFont
        lowerViewTitleLabel.frame = CGRect(x:lowerView.frame.width/2 - 75,y: 5 ,width:150,height:20)
        lowerViewTitleLabel.backgroundColor = UIColor.clearColor()
        lowerViewTitleLabel.adjustsFontSizeToFitWidth = true
        lowerViewTitleLabel.textAlignment = NSTextAlignment.Center
        
        
        //init temp title label
        let tempTitleLabel = UILabel()
        tempTitleLabel.text = "Temprature:"
        tempTitleLabel.font = customFont
        tempTitleLabel.frame = CGRect(x:10,y: 30 ,width:80,height:20)
        tempTitleLabel.backgroundColor = UIColor.clearColor()
        tempTitleLabel.adjustsFontSizeToFitWidth = true
        tempTitleLabel.textAlignment = NSTextAlignment.Left
        
        //init gas title label
        let gasTitleLabel = UILabel()
        gasTitleLabel.text = "Gas density:"
        gasTitleLabel.font = customFont
        gasTitleLabel.frame = CGRect(x:10,y: 90 ,width:80,height:20)
        gasTitleLabel.backgroundColor = UIColor.clearColor()
        gasTitleLabel.adjustsFontSizeToFitWidth = true
        gasTitleLabel.textAlignment = NSTextAlignment.Left
        
        lowerView.addSubview(lowerViewTitleLabel)
        lowerView.addSubview(tempTitleLabel)
        lowerView.addSubview(gasTitleLabel)
        
        
        //init temperature value label
        let tempValueLabel = UILabel()
        tempValueLabel.text =  "27 ℃"
        tempValueLabel.font = customFont
        tempValueLabel.frame = CGRect(x:lowerView.frame.width - 80,y: 30 ,width:80,height:20)
        tempValueLabel.backgroundColor = UIColor.clearColor()
        tempValueLabel.adjustsFontSizeToFitWidth = true
        tempValueLabel.textAlignment = NSTextAlignment.Left
        
        //init gas value label
        let gasValueLabel = UILabel()
        gasValueLabel.text =  "Normal"
        gasValueLabel.font = customFont
        gasValueLabel.frame = CGRect(x:lowerView.frame.width - 80,y: 90 ,width:80,height:20)
        gasValueLabel.backgroundColor = UIColor.clearColor()
        gasValueLabel.adjustsFontSizeToFitWidth = true
        gasValueLabel.textAlignment = NSTextAlignment.Left
        
        //add subviews to lower view
        lowerView.addSubview(lowerViewTitleLabel)
        lowerView.addSubview(tempTitleLabel)
        lowerView.addSubview(gasTitleLabel)
        lowerView.addSubview(tempValueLabel)
        lowerView.addSubview(gasValueLabel)
        
        
        
    }
    
    //set mqtt server address
    func setMqtt()
    {
        //MARK: -change sensor server ip here
        self.mqttSession = MQTTSession(host: "118.138.37.239", port: 8081, clientID: "swift", cleanSession: true, keepAlive: 15, useSSL: false)
        
        mqttSession.delegate = self
        
        //connect to mqtt
        self.mqttSession.connect { (succeeded, error) -> Void in
            if succeeded {
                print("Connected!")
            }
            print(error)

        }
        
        //subscribe to channel "temperature"
        self.mqttSession.subscribe("temperature", qos: .AtLeastOnce) { (succeeded, error) in
            if succeeded {
                print("temprature Subscribed!")
            }
            print(error)

        }

        //subscribe to channel "gas"
        self.mqttSession.subscribe("gas", qos: .AtLeastOnce) { (succeeded, error) in
            if succeeded {
                print("gas Subscribed!")
            }
            print(error)
            
        }
    
    
    }
    

    //call back when recieving massage from mqtt server
    func mqttSession(session: MQTTSession, didReceiveMessage message: NSData, onTopic topic: String)
    {
        
        //show temperature
        if(self.pageControl.currentPage == 0)
        {
            let json = self.DataParseDictionary(message) as NSDictionary
            print(json)
            let string  =  json["temperature"] as! String
            print(string)
            self.dataLabel.text = string + " ℃"
            let temp = Int(string)
            if (temp > 29)
            {
                self.createLocalNotifications("Fire alarm!")
            }
        }
        
        //show gas
        if(self.pageControl.currentPage == 1)
        {
            let json = self.DataParseDictionary(message) as NSDictionary
            print(json)
            var string  =  json["gas"] as! String
            print(string)
            //if the value is not in the safe range
            if(string  == "" ){
            self.dataLabel.text = "Unsafe"
            self.createLocalNotifications("Gas alarm!")
            }
        
        }
      
    }

    
   
    
    func didDisconnectSession(session: MQTTSession)
    {
        print("Session Disconnected.")

    }
    
    func socketErrorOccurred(session: MQTTSession)
    {
        print("Socket Error")

    }
    
    //push notification to user
    func createLocalNotifications(message:String)
    {
        // Show an alert if application is active
        if UIApplication.sharedApplication().applicationState == .Active {
            
                self.showAlert(nil, message: message, viewController: self)

        } else {
            // Otherwise present a local notification
            let notification = UILocalNotification()
            notification.alertBody = message
            notification.soundName = "Default";
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        
        //        let fireNotification = UILocalNotification()
        //       // fireNotification.fireDate = NSDate(timeInterval: 1)
        //        fireNotification.applicationIconBadgeNumber = 1
        //        fireNotification.soundName =  "Default"
        //
        //        fireNotification.userInfo = ["message":"Fire alarm!"]
        //        fireNotification.alertBody = "Fire alarm"
        //        UIApplication.sharedApplication().presentLocalNotificationNow(fireNotification)
        
    }
    
    func showAlert(title: String!,message: String,viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    // json parser
    func DataParseDictionary(data: NSData) -> [String: AnyObject]{
            do{
                if let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject]{
                    return dictionary
                }
            }catch {
                print("error")
            }
        
        return [String: AnyObject]()
    }
    
    
}



