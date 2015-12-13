//
//  ChooseWebViewController.swift
//  stories
//
//  Created by bill donner on 8/20/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
import WebKit

class ChooseWebViewController:UIViewController, //ExCo,
UIGestureRecognizerDelegate{


	//these are properties
	var toptitle:String?
	var startingURL:String?

	// on the way out
	var returnData:String?

	private var web : WKWebView!

	private var activityIndicator: UIActivityIndicatorView?

	override func shouldAutorotate() -> Bool {
		return false
	}

	func donePressed () {
		if self.web.URL != nil {
			self.returnData = "\(self.web.URL!)"
		}
		//print("Done pressed URL is \(web.URL)")
		self.performSegueWithIdentifier("unwindFromChooseURL", sender: self)
	}
	func cancelPressed () {
		self.returnData = ""
		//print("Cancel pressed URL is \(web.URL)")
		self.performSegueWithIdentifier("unwindFromChooseURL", sender: self)
	}

	/// setup browser within current bounds above tabbar

	override func viewDidLoad() {

		super.viewDidLoad()
		view.backgroundColor = Colors.white
		let textField = UITextField(frame:CGRect(x:0,y:0,width:200,height:22))
		textField.backgroundColor = Colors.white
		textField.placeholder = "enter..."
		textField.font = UIFont.boldSystemFontOfSize(14)
		textField.textColor = UIColor.darkGrayColor()
		textField.textAlignment = .Left
		textField.delegate = self

		// absorb title that might have been passed in
		//        if self.toptitle == nil {
		//        textField.text  = "oneword"
		//        }
		//        else {
		//            textField.text = self.toptitle
		//        }
		self.navigationItem.titleView = textField
		if self.startingURL == nil {
			self.startingURL = "http://apple.com"
		}
		//        else
		//            if self.startingURL?.characters.count == 0 {
		//                self.startingURL = textField.text
		//        }
		//
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "donePressed")

		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel ,  target: self, action: "cancelPressed")


		// put a white background behind the status bar
		let topView = UIView  (frame:  CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
		topView.backgroundColor = Colors.mainColor()
		self.view.addSubview(topView)

		// offset this down a bit
		let delta = 64.0 as CGFloat
		let frame = CGRectMake ( 0, delta,
			view.frame.width, view.frame.height-delta)
		web = WKWebView(
			frame:  frame,
			configuration: setupConfig("xyz",
				apikey: "apikey") // see above
		)
		web.backgroundColor = Colors.white
		//web.autoresizingMask = .FlexibleWidth | .FlexibleHeight
		web.navigationDelegate = self
		view.addSubview(web)

		activityIndicator = UIActivityIndicatorView(frame:UIScreen.mainScreen().bounds)
		activityIndicator?.activityIndicatorViewStyle = .WhiteLarge
		activityIndicator?.hidesWhenStopped = true
		// activityIndicator?.center = self.view.center
		activityIndicator?.color = Colors.tileTextColor()
		activityIndicator?.startAnimating()
		view.addSubview(activityIndicator!)

		loadURL(self.startingURL!)

	}


	// the webview is carefully assembled and fed a bunch of custom javascript

	func setupConfig (partnerId:String,apikey:String) -> WKWebViewConfiguration {

		let fullscript = " " //StaticJS.builtins +
		//            " INMARKIT({'retailId': " + partnerId + ",'apiKey': '\(apikey)'});"
		let contentController = WKUserContentController();
		let userScript = WKUserScript(
			source: fullscript,
			injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
			forMainFrameOnly: true
		)
		contentController.addUserScript(userScript)
		contentController.addScriptMessageHandler(
			self,
			name: "callbackHandler"
		)
		let config = WKWebViewConfiguration()
		config.userContentController = contentController

		// config.processPool = Globals.shared.processPool // share cookies
		return config
	}


	func showURL() {
		//      currentURL.text = "\(web.URL!)"
	}

	func loadURL(url:String) {
		print("loading url \(url)")

		web.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
		showURL()

	}


	// toolbar actions
	func goForward() {
		if web.canGoForward    { web.goForward()}
	}
	func goBack() {
		if web.canGoBack    { web.goBack()}
	}

	func refreshWebview(){
		loadURL("\(web.URL!)")
	}


}


extension ChooseWebViewController: WKNavigationDelegate {

    // delegate functions

    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert:UIAlertController = UIAlertController(title: "Error", message: "failed navigation \(error.localizedDescription)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))

        presentViewController(alert, animated: true) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation){
        //let dubl = webView.estimatedProgress
        //let float = Float(dubl)
        //        progressBar.setProgress(float , animated: true)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activityIndicator?.stopAnimating()
    }
    
    func webView(webView: WKWebView, navigation: WKNavigation, withError error: NSError) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activityIndicator?.stopAnimating()
        let alert:UIAlertController = UIAlertController(title: "Error", message: "Could not load webpage", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

}
extension ChooseWebViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField:UITextField) {
        print("chooseweb - did end editing")
        
         self.startingURL = textField.text
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
         self.startingURL = textField.text
        if self.startingURL != nil {
        loadURL(self.startingURL!)
        }
        textField.resignFirstResponder()
            
        return true
    }
    
}
extension ChooseWebViewController: WKScriptMessageHandler{
    /// messages from javascript
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        if(message.name == "callbackHandler") {
            ///// JS Calls to native mode will be presented off the indicated vc
            //JSHandlers.mainDispatch(message.body,vc: self)
        }
    }
}
