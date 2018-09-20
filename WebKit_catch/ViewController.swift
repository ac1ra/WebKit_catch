//
//  ViewController.swift
//  WebKit_catch
//
//  Created by 0I00II on 11/09/2018.
//  Copyright © 2018 0I00II. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webOutput: UIWebView!
    
    let Token_checker = "Coming Soon"
    let OAUTH_URL = "http://82.202.246.197/Account/LoginToken"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let myURL = NSURL(string: OAUTH_URL)
        
        if let checkURL = myURL{
            let myURLRequest: URLRequest = URLRequest(url: myURL as! URL)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: myURLRequest){
                (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async {
                    self.webOutput.loadRequest(myURLRequest)
                    }
                    
                } else {
                    print("ERROR: \(error)")
                }
            }
            task.resume()
        }
    webViewDidFinishLoad(webOutput)

    }
    
    func  webViewDidFinishLoad(_ webView: UIWebView) {
        webView.delegate = self
        let urlString = webView.request?.url?.absoluteString
        
        if urlString == nil {
            print("NIL pizdui otsuda")
        } else {
            let p1 = catcher(url: urlString!, param: "access_token")
            
            let p2 = catcher(url: urlString!, param: "token_type")
            
            let p3 = catcher(url: urlString!, param: "user_id")
            
            if p1 ?? p2 ?? p3 == nil{print(" ")} else {
                localStorage(param: p1!, param1: p2!, param2: p3!)
            nextPage()
            }

        }
    }
    
    //getting parameters from URL
    
    func catcher(url: String, param: String)->String?{
        guard let url = URLComponents(string: url) else { return nil }
        if let parameters = url.queryItems {
            return url.queryItems?.first(where: { $0.name == param })?.value
        } else if let paramPairs = url.fragment?.components(separatedBy: "?").last?.components(separatedBy: "&"){
            for pair in paramPairs where pair.contains(param){
                return pair.components(separatedBy: "=").last
            }
            return nil
        } else{
            return nil
        }
    }
    
    //saving parameters at the local storage
    
    func localStorage(param: String, param1: String, param2:String) -> String{
        let userDefaults = UserDefaults.standard
        
        let dateTokens = [param, param1, param2]
        userDefaults.set(dateTokens, forKey: "keys")
        
        let showTokens = userDefaults.object(forKey: "keys") as? [String] ?? [String]()
        print("access_token: \(showTokens[0])")
        print("token_type: \(showTokens[1])")
        print("user_id: \(showTokens[2])")
        
        return param; param1; param2
    }
    // dismiss catcher to move in TableView
    func nextPage(){
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "Storyboard_next", sender: self)
    }
}
