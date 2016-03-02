//
//  OutgoingViewController.swift
//  RegalAttendance
//
//  Created by Regal System on 2016/3/2.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit

class OutgoingViewController: UITableViewController, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var textCustomer: UITextField!
    @IBOutlet weak var textPalce: UITextField!
    @IBOutlet weak var labelDate: UILabel!
    override func viewDidLoad() {
        textCustomer.delegate = self
        textPalce.delegate = self
    }
    
   
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        labelDate.text = dateFormatter.stringFromDate(sender.date)
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
