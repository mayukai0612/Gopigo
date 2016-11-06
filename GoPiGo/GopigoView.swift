//
//  GopigoView.swift
//  GoPiGo
//
//  Created by Yukai Ma on 24/10/2016.
//  Copyright © 2016 Monash. All rights reserved.
//

import SpriteKit
import UIKit

class GopigoView: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var cameraWebView: UIWebView!
    
    @IBOutlet weak var stickView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes web view adjust websites properly with navigation bar height
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        //Webview
           self.cameraWebView.delegate = self
           self.loadWebsite()
        
            self.addGestures()
        
        // Configure the stick view.
        let scene = GopigoScene(size: self.view.bounds.size)
        scene.backgroundColor = .white
        if let skView = self.stickView as? SKView {
            
            skView.backgroundColor = UIColor.clear
        //    skView.showsFPS = true
        //    skView.showsNodeCount = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
  
        
    }
    
    
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
     
          //  return UIInterfaceOrientationMask.landscape
        
        return [UIInterfaceOrientationMask.landscapeLeft, UIInterfaceOrientationMask.landscapeRight]

    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return UIInterfaceOrientation(rawValue: 4)!
       // return landscapeLeft
    }
    
   // override func UIInterfaceOrientationIsLandscape() ->Bool
   // {
        
   // }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // Helper function to talk to our WebView and load a URL via string
    func loadWebsite() {
        // if let web = self.webview {
        
        // Prepare URL request and pass to web view
        let url = NSURL(string: "http://www.google.com")
        let request = NSURLRequest(url: url! as URL)
         self.cameraWebView.loadRequest(request as URLRequest)
        //  }
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        // Indicate that app is using the network
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Indicate app has finished using network
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Update title to use page title
        // self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
    
    //add gestures to stick view
    func addGestures()
    {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector(("handleSwipes:")))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector(("handleSwipes:")))
        
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        
        self.cameraWebView.addGestureRecognizer(leftSwipe)
        self.cameraWebView.addGestureRecognizer(rightSwipe)
    }
    
    //
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            print("Swipe Left")
          
        }
        
        if (sender.direction == .right) {
            print("Swipe Right")
           
        }
    }
}


