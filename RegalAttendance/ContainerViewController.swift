//
//  ContainerViewController.swift
//  RegalAttendance
//
//  Created by Regal System on 2016/3/28.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    private var currentSegueIdentifier = ""
    private var transitionInProgress:Bool = false
    private var currentViewController :UIViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitionInProgress = false
        self.currentSegueIdentifier = "outgoingrecordSeque"
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        self.currentViewController = segue.destinationViewController
        
        if self.childViewControllers.count > 0 {
            self.swapFromViewController(self.childViewControllers[0], toViewController: self.currentViewController)
        }
        else {
            self.addChildViewController(segue.destinationViewController)
            let destView:UIView = (segue.destinationViewController as UIViewController).view
    
            destView.autoresizingMask  = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            self.view.addSubview(destView)
         
            segue.destinationViewController.didMoveToParentViewController(self)
   
        }
    }
    
    func swapFromViewController(fromViewController:UIViewController,toViewController:UIViewController)
    {
        transitionInProgress = true
        toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        fromViewController.willMoveToParentViewController(nil)
        
        self.addChildViewController(toViewController)
        
        self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: {(finished:Bool) -> Void in
            
            fromViewController.removeFromParentViewController()
            toViewController.didMoveToParentViewController(self)
           
            self.transitionInProgress = false
            })
    }
    
    func swapViewController(toViewSegueIdentifier:String)
    {
        if self.transitionInProgress {
            return
        }
        
        self.performSegueWithIdentifier(toViewSegueIdentifier, sender: nil)
    }

}
