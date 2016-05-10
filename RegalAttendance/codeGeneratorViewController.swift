//
//  codeGeneratorViewController.swift
//  RegalAttendance
//
//  Created by Regal System on 2016/4/18.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit

class codeGeneratorViewController: UIViewController {

    @IBOutlet weak var labelCode: UILabel!
    var progress: KDCircularProgress!
    var label:UILabel!
    var count :Int = 0
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCode.font = UIFont(name: "HelveticaNeue-Bold", size:80)
        
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        progress.startAngle = 270
        progress.progressThickness = 0.2
        progress.trackThickness = 0.4
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .Forward
        progress.glowAmount = 0.9
        progress.backgroundColor = UIColor.clearColor()
        progress.trackColor = UIColor.grayColor()
        
        progress.setColors(UIColor.whiteColor() ,UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor())
        
       
        progress.center = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(progress)
        
        label = UILabel(frame: CGRectMake(0, 0, 200, 200))
        label.center = CGPointMake(view.center.x, view.center.y)
        label.textAlignment = NSTextAlignment.Center
        label.text = "30"
        label.textColor = UIColor.brownColor()
        label.font = UIFont(name: "HelveticaNeue-Bold", size:80)
        
        view.addSubview(label)

        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(codeGeneratorViewController.tick), userInfo: nil, repeats: false)
        
    }
    
    func Refresh()
    {
        let rest = clsRestful()
        rest.getJsonData("http://192.168.0.12:81/app/GetTempLogin?EmpNo=\(Global.UserId!)", onSuccess: onSuccess, onError: onError)
    }
    
    func onSuccess(result:JSON) -> Void{
        
        if result["Result"].string! == "1" {
            dispatch_async(dispatch_get_main_queue(), {
                
                self.labelCode.numberOfLines = 0
                self.labelCode.sizeToFit()
                self.labelCode.text = result["Query"]["Rid"].string!
                self.label.text = String(result["Query"]["CountDown"].int!)
                self.progress.angle = Double((30 - result["Query"]["CountDown"].int!) * 12)
                
            })
           
            Refresh()
        }
        else{
            
        }
    }
    
    func tick()
    {
        
        Refresh()
        
    }
    
    func onError(err:String) -> Void{
        self.timer?.invalidate()
        self.timer = nil
        
        dispatch_async(dispatch_get_main_queue(),{
            let quetion = UIAlertController(title: "錯誤!", message: "此功能只能在內網執行!", preferredStyle: .Alert);
            
            let okaction = UIAlertAction(title: "OK",style: .Default, handler: nil);
            
            quetion.addAction(okaction);
            self.presentViewController(quetion, animated: true, completion: nil);
        })
    }
    
    func DateDiff(startDate:NSDate,endDate:NSDate,unit:NSCalendarUnit) -> NSDateComponents?
    {
        let cal = NSCalendar.currentCalendar()
        
        let components = cal.components(unit, fromDate: endDate, toDate:startDate , options: [])
        
        return components
    }
    
    func string2Date(dateString:String,format:String) ->NSDate?
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = format
        let date = dateFormatter.dateFromString(dateString)
        
        return date

    }
}


