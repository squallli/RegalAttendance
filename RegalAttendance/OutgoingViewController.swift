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
    @IBOutlet weak var buttonArrivalTime: UIButton!
    
    
    override func viewDidLoad() {
        textCustomer.delegate = self
        textPalce.delegate = self
        
        textCustomer.autocorrectionType = UITextAutocorrectionType.No
        textPalce.autocorrectionType = UITextAutocorrectionType.No
        
        let dateFormatter = NSDateFormatter()
        let date = NSDate()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        
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
        
        var json:JSON = ["OutMan":"","OutManCompany":"","SDate":"","STime":"","Location":"","CustomerName":"","OutDescription":"","GoOutTime":"09:30"]
        
      
        
        json["OutMan"].string = Global.UserId
        json["OutManCompany"].string = Global.Company
        json["SDate"].string = self.buttonDate.currentTitle!
        json["STime"].string = self.buttonArrivalTime.currentTitle!
        json["GoOutTime"].string = self.buttonEstOutDate.currentTitle!
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
            DatePickerDialog().show("選擇跟客戶約定期", doneButtonTitle: "完成", cancelButtonTitle: "取消", datePickerMode: .Date) {
                (date) -> Void in
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                self.buttonDate.setTitle(dateFormatter.stringFromDate(date), forState: UIControlState.Normal)
            }
        }
        else if sender.tag == 1 {
            DatePickerDialog().show("選擇到達時間", doneButtonTitle: "完成", cancelButtonTitle: "取消", datePickerMode: .Time) {
                (date) -> Void in
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "HH:mm"
                
                self.buttonArrivalTime.setTitle(dateFormatter.stringFromDate(date), forState: UIControlState.Normal)
            }
        }
        else if sender.tag == 2 {
            DatePickerDialog().show("選擇預計出發時間", doneButtonTitle: "完成", cancelButtonTitle: "取消", datePickerMode: .Time) {
                (date) -> Void in
                
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "HH:mm"
                
                self.buttonEstOutDate.setTitle(dateFormatter.stringFromDate(date), forState: UIControlState.Normal)
            }
        }
        

    }
    
}
