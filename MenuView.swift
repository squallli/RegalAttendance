//
//  testView.swift
//  RegalAttendance
//
//  Created by Regal System on 2016/3/9.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit

class MenueView: UIViewController,DOPNavbarMenuDelegate {
    var menu = DOPNavbarMenu()
    var numberOfItemsInRow = 0
    var containerViewController:ContainerViewController!
    let menuArray :NSDictionary = ["外出記錄":"outgoingrecordSeque","出勤記錄":"attendanceSeque","外出登記":"outgoingSeque","代碼產生器":"codeSeque","登出":""]

   
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    func didShowMenu(menu: DOPNavbarMenu!) {
        
        rightBarButtonItem.title = "關閉"
        rightBarButtonItem.enabled = true

    }
    
    func didDismissMenu(menu: DOPNavbarMenu!) {
        rightBarButtonItem.enabled = true
        rightBarButtonItem.title = "選單"
    }
    
    func didSelectedMenu(menu: DOPNavbarMenu!, atIndex index: Int) {
        
        if menuArray.allKeys[index] as? String == "登出"{
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setObject("", forKey: "UserName")
            prefs.setObject("", forKey: "Password")
            prefs.setBool(false, forKey: "ISLOGGEDIN")
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else{
            navigationItem.title = menuArray.allKeys[index] as? String
            self.containerViewController.swapViewController((menuArray.objectForKey(menuArray.allKeys[index]) as? String)!)
        }
        
    }
    
    func showMessage(msg:String)
    {
        let quetion = UIAlertController(title: "錯誤!", message: msg, preferredStyle: .Alert);
        
        let okaction = UIAlertAction(title: "OK",style: .Default, handler: nil);
        
        quetion.addAction(okaction);
        self.presentViewController(quetion, animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    self.numberOfItemsInRow = 3
        var menuItem = [DOPNavbarMenuItem]()
        
        for menuString:AnyObject in menuArray.allKeys
        {
            menuItem.append(DOPNavbarMenuItem(title:menuString as! String,icon:UIImage(named: "image")))
        }
        
        menu = DOPNavbarMenu(items: menuItem, width: self.view.dop_width, maximumNumberInRow: self.numberOfItemsInRow)
        
        menu.backgroundColor = UIColor.grayColor()
        menu.separatarColor = UIColor.whiteColor()

        menu.delegate = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.containerViewController = segue.destinationViewController as! ContainerViewController
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.menu.dismissWithAnimation(false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
   
    @IBAction func openMenu(sender: UIBarButtonItem) {
        rightBarButtonItem.enabled = false;
        if self.menu.open {
            self.menu.dismissWithAnimation(true)
        } else {
            self.menu.showInNavigationController(self.navigationController)
        }
    }
}
