//
//  OutgoingViewController.swift
//  RegalAttendance
//
//  Created by Regal System on 2016/3/2.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit
import SwiftSpinner

class OutgoingViewController: UITableViewController, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var buttonEstOutDate: UIButton!
    @IBOutlet weak var buttonDate: UIButton!
    @IBOutlet weak var textCustomer: UITextField!
    @IBOutlet weak var textPalce: UITextField!
    
    override func viewDidLoad() {
        textCustomer.delegate = self
        textPalce.delegate = self
        
        textCustomer.autocorrectionType = UITextAutocorrectionType.No
        textPalce.autocorrectionType = UITextAutocorrectionType.No
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd 00:00"
        let date = NSDate()
        
      
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        
        
        buttonDate.setTitle(dateFormatter.stringFromDate(date), forState: UIControlState.Normal)
        
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func showMessage(msg:String)
    {
        let quetion = UIAlertController(title: "錯誤!", message: msg, preferredStyle: .Alert);
        
        let okaction = UIAlertAction(title: "OK",style: .Default, handler: nil);
        
        quetion.addAction(okaction);
        self.presentViewController(quetion, animated: true, completion: nil);
    }

    @IBAction func buttonClickSave(sender: UIButton) {
        
        if textPalce.text == "" {
            showMessage("外出地點不能為空白!")
            return
        }
        
        if textCustomer.text == "" {
            showMessage("客戶不能為空白!")
            return
        }
        
        SwiftSpinner.show("儲存外出中")
        
        var json:JSON = ["OutMan":"","OutManCompany":"","SDate":"","STime":"","Location":"","CustomerName":"","OutDescription":""]
        
        let dateTimeFormatter = NSDateFormatter()
        
        dateTimeFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        let SDate = dateFormater.stringFromDate(dateTimeFormatter.dateFromString(self.buttonDate.currentTitle!)!)
        
        dateFormater.dateFormat = "HH:mm"
        
        let STime = dateFormater.stringFromDate(dateTimeFormatter.dateFromString(self.buttonDate.currentTitle!)!)
        
        json["OutMan"].string = Global.UserId
        json["OutManCompany"].string = Global.Company
        json["SDate"].string = SDate
        json["STime"].string = STime
        json["Location"].string = textPalce.text
        json["CustomerName"].string = textCustomer.text
        
        let rest = clsRestful()
        
        
        rest.makePostRequest("\(Global.baseUrl)InsertOutgoing", postData: json.rawString()!, onSuccess: {result -> Void in
            
            do {
                let j = try NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions()) as? [String: AnyObject]
                if j?["Result"] as! String == "1" {
                    dispatch_async(dispatch_get_main_queue(),{
                        SwiftSpinner.hide()
                        let containerviewController = self.parentViewController as! ContainerViewController
                        containerviewController.swapViewController("outgoingrecordSeque")
                        })
                    }
                } catch {
                    print(error)
                
                }
           
            
            }, onError: {err -> Void in
                dispatch_async(dispatch_get_main_queue(),{
                    
                    SwiftSpinner.hide()
                    
                    let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .Alert);
                    
                    let okaction = UIAlertAction(title: "OK",style: .Default, handler: nil);
                    
                    quetion.addAction(okaction);
                    self.presentViewController(quetion, animated: true, completion: nil);
                })
                
        })
    }
    
    func GetDateWithFormat(d:NSDate,format:String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        
        let s = dateFormatter.stringFromDate(d)
        
        return s
    }
    
    @IBAction func btnOutDateClick(sender: UIButton) {
        
        if sender.tag == 0 {
            DatePickerDialog().show("選擇跟客戶約定時間", doneButtonTitle: "完成", cancelButtonTitle: "取消", datePickerMode: .DateAndTime) {
                (date) -> Void in
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                
                self.buttonDate.setTitle(dateFormatter.stringFromDate(date), forState: UIControlState.Normal)
            }
        }
        else{
            DatePickerDialog().show("選擇預計出發時間", doneButtonTitle: "完成", cancelButtonTitle: "取消", datePickerMode: .DateAndTime) {
                (date) -> Void in
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                
                self.buttonEstOutDate.setTitle(dateFormatter.stringFromDate(date), forState: UIControlState.Normal)
            }
        }

    }
    
}
