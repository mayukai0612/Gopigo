//
//  test.swift
//  GoPiGo
//
//  Created by Yukai Ma on 6/11/2016.
//  Copyright © 2016 Monash. All rights reserved.
//

import UIKit

class test: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Webview
        self.webview.delegate = self
        self.loadWebsite()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Helper function to talk to our WebView and load a URL via string
    func loadWebsite() {
        // if let web = self.webview {
        
        // Prepare URL request and pass to web view
        let url = NSURL(string: "http://www.google.com")
        let request = NSURLRequest(URL: url!)
        self.webview.loadRequest(request)
        //  }
    }
    
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        // Indicate that app is using the network
        //UIApplication.sharedApplication().isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Indicate app has finished using network
      //  UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Update title to use page title
        // self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
    

}
