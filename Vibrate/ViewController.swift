//
//  ViewController.swift
//  Vibrate
//
//  Created by Smartwsw on 16/4/19.
//  Copyright © 2016年 Smartwsw. All rights reserved.
//

import UIKit
import AudioToolbox


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        let urlString:String = "http://p.nju.edu.cn/portal_io/getinfo"
        var url:NSURL!
        url = NSURL(string: urlString)
        var request = NSMutableURLRequest(URL:url)
        var body = ""
        var postData = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {      
                NSLog("error=\(error)")
                self.ipString.text = "No Login"
                self.balanceString.text = "No Login"
                return
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            NSLog("responseString = \(responseString!)")
            /* Ayalyse Json */
            if let dataFromString = responseString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString) 
                let ip = self.IntToIP(json["userinfo"]["useripv4"].int!)
                self.ipString.text = "\(ip)"
                self.balanceString.text = "\(json["userinfo"]["balance"].double! / 100)"
            }
        }
        task.resume()   
 */
    }
    @IBOutlet weak var userString: UITextField!
    
    @IBOutlet weak var passwdString: UITextField!
    @IBOutlet weak var ipString: UILabel!
    @IBOutlet weak var balanceString: UILabel!

    
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func save(sender: AnyObject) {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var docDir = NSURL(fileURLWithPath: NSHomeDirectory()).URLByAppendingPathComponent("Documents")
        var fileManager  = NSFileManager.defaultManager()
        var userFile : NSURL = docDir.URLByAppendingPathComponent("user.txt")
        var passwdFile : NSURL = docDir.URLByAppendingPathComponent("passwd.txt")
        
        //test
        var result = fileManager.createFileAtPath(userFile.absoluteString, contents: nil, attributes: nil)
        NSLog("\(result)")
        result = fileManager.createFileAtPath(passwdFile.absoluteString, contents: nil, attributes: nil)
        NSLog("\(result)")     
        //test over
        
        do {
            try self.userString.text!.writeToFile(userFile.absoluteString, atomically: true, encoding: NSUTF8StringEncoding)
            try self.passwdString.text!.writeToFile(passwdFile.absoluteString, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch {
            self.Alert("保存失败", msg: "∠( ᐛ 」∠)＿")
        }
        do {
            let userid = try NSString(contentsOfFile: userFile.absoluteString, encoding: NSUTF8StringEncoding)
            NSLog(userid as String)
        }
        catch {/* error handling here */}
    }
    
    
    @IBAction func login(sender: AnyObject) {
        let urlString:String = "http://p.nju.edu.cn/portal_io/login"
        var url:NSURL!
        url = NSURL(string: urlString)
        var request = NSMutableURLRequest(URL:url)
        var body = "username=\(self.userString.text!)&password=\(self.passwdString.text!)"
        var postData = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {      
                NSLog("error=\(error)")
                self.Alert("你确定你连到校园网了么", msg: "∠( ᐛ 」∠)＿")
                return
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            NSLog("responseString = \(responseString!)")
            var title = ""
            var msg = ""
            /* Ayalyse Json */
            if let dataFromString = responseString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                if let stat = json["reply_msg"].string {
                    title = stat
                }
                switch json["reply_code"].int! {
                case 1, 6:
                    let ip = self.IntToIP(json["userinfo"]["useripv4"].int!)
                    msg = "用户名：\(json["userinfo"]["username"].string!)\n余额：\(json["userinfo"]["balance"].double! / 100)\nip：\(ip)"
                    self.ipString.text = "\(ip)"
                    self.balanceString.text = "\(json["userinfo"]["balance"].double! / 100)"
                case 3:
                    title = "登录失败"
                    msg = json["reply_msg"].string!
                    self.ipString.text = "No Login"
                    self.balanceString.text = "No Login"
                default:
                    msg = ""
                }

            }
            self.viewDidLoad()
            self.reloadInputViews()
            self.Alert("\(title)", msg: "\(msg)")
        }
        task.resume()        
    }
    
    @IBAction func logout(sender: AnyObject) {
        let urlString:String = "http://p.nju.edu.cn/portal_io/logout"
        var url:NSURL!
        url = NSURL(string: urlString)
        var request = NSMutableURLRequest(URL:url)
        var body = ""
        var postData = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {      
                NSLog("error=\(error)")
                self.Alert("你确定你连到校园网了么", msg: "∠( ᐛ 」∠)＿")
                return
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            NSLog("responseString = \(responseString!)")
            var msg = ""
            /* Ayalyse Json */
            if let dataFromString = responseString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                if let stat = json["reply_msg"].string {
                    msg = stat
                }
                
            }

            /* Create an alert*/
            self.Alert("\(msg)", msg: "")
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func IntToIP(val: Int) -> String {
        var tmp = val
        let ip1 = tmp & 0xFF
        tmp = tmp >> 8
        let ip2 = tmp & 0xFF
        tmp = tmp >> 8
        let ip3 = tmp & 0xFF
        tmp = tmp >> 8
        let ip4 = tmp & 0xFF
        return "\(ip1).\(ip2).\(ip3).\(ip4)"
    }

    func Alert(title: String, msg: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(msg)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}

