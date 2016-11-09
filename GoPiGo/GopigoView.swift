//
//  GopigoView.swift
//  GoPiGo
//
//  Created by Yukai Ma on 24/10/2016.
//  Copyright © 2016 Monash. All rights reserved.
//

import SpriteKit
import UIKit
import WSCoachMarksView

class GopigoView: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var cameraWebView: UIWebView!
    
    @IBOutlet weak var stickView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // hide the navigation bar
        self.navigationController?.navigationBarHidden = true

        
         //Makes web view adjust websites properly with navigation bar height
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        //Webview
           self.cameraWebView.delegate = self
           self.loadWebsite()
        
        //add gestures
            self.addGestures()
        
       // force landscape
     //   let value = UIInterfaceOrientation.LandscapeLeft.rawValue
   //     UIDevice.currentDevice().setValue(value, forKey: "orientation")
     //   setStickView()
       
     
        
        print(UIDevice.currentDevice().orientation.isValidInterfaceOrientation)
    }
    
//    
//    override func shouldAutorotate() -> Bool {
//        return true
//    }
  
    

    //change the orientation of device to landscapeleft
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
       
        self.stickView.subviews.forEach({ $0.removeFromSuperview() })
        self.setStickView()
        
        let cgrect = CGRect(x: self.view.frame.maxX - 200, y: 100, width: 190, height: 150)
        let string = "Use this joy stick to Control the detection car "
        var coachMarks = [[String:AnyObject]]()
        coachMarks = [["rect" :  NSValue(CGRect: cgrect), "caption": string]]
        let wSCoachMarksView = WSCoachMarksView(frame: self.view.bounds, coachMarks: coachMarks as [AnyObject])
        self.view.addSubview(wSCoachMarksView)
        wSCoachMarksView.start()
        
    }
    
    func canRotate() -> Void {}

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
   // override var prefersStatusBarHidden : Bool {
//        return true
//    }
    
    func setStickView()
    {
        // Configure the stick view.
        let scene = GopigoScene(size: self.view.bounds.size)
        scene.backgroundColor = UIColor.whiteColor()
        if let skView = self.stickView as? SKView {
            
            skView.backgroundColor = UIColor.clearColor()
            //    skView.showsFPS = true
            //    skView.showsNodeCount = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            skView.presentScene(scene)

    
    }
    }
    
    
   //  Helper function to talk to our WebView and load a URL via string
    func loadWebsite() {
        // if let web = self.webview {
        
        // Prepare URL request and pass to web view
        //MARK: - Change camera video stream Url here
        let url = NSURL(string: "http://118.139.79.44:98")
        let request = NSURLRequest(URL: url!)
        self.cameraWebView.loadRequest(request)
        //  }
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        // Indicate that app is using the network
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // Indicate app has finished using network
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Update title to use page title
        // self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        self.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
    
    //add gestures to stick view
    func addGestures()
    {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GopigoView.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GopigoView.handleSwipes(_:)))
        
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        
        self.stickView.addGestureRecognizer(leftSwipe)
        self.stickView.addGestureRecognizer(rightSwipe)
    }
    
    //Mount control
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        let moveControl =   CarControl()
        //MARK: - change Mount Control Url here
        let url = "http://118.139.79.44:8083/"
        
        if (sender.direction == .Left) {
            print("Swipe Left")
            moveControl.MountControl(url + "leftServo")
            
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
            moveControl.MountControl(url + "rightServo")
           
        }
    }
    
    
}


