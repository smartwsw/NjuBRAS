//
//  TodayViewController.swift
//  VibrateExtened
//
//  Created by Smartwsw on 16/4/19.
//  Copyright © 2016年 Smartwsw. All rights reserved.
//

import UIKit
import NotificationCenter
import AudioToolbox
class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(0, 100)
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var label: UILabel!
    @IBAction func tapped(sender: AnyObject) {
        let urlString:String = "http://p.nju.edu.cn/portal_io/login"
        var url:NSURL!
        url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL:url)
        let body = "username=131220069&password=-1123581321@"
        let postData = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        var title = ""
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {      
                NSLog("error=\(error)")
                return
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            NSLog("responseString = \(responseString!)")
            var msg = ""
            /* Ayalyse Json */
            if let dataFromString = responseString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                if let stat = json["reply_msg"].string {
                    title = stat
                }
                switch json["reply_code"].int! {
                case 1, 6:
                    msg = ""
                case 3:
                    title = "登录失败"
                default:
                    msg = ""
                }
                self.label.text = title

            }
        }
        task.resume()
        self.label.text = title

    }
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }

    
}
