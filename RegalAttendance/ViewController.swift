//
//  ViewController.swift
//  CanlendarTest
//
//  Created by Regal System on 2016/1/22.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit
import SwiftSpinner

class ViewController: UIViewController ,CVCalendarViewDelegate,CVCalendarMenuViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!

    
    var outGoingArray:NSMutableArray?
    
    var outGoingData:NSMutableDictionary?
    
    var Year:String?
    var Month:String?
    var selectDay:String?
    

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectDay = GetDateWithFormat(NSDate(),format:"yyyy-MM-dd")
        
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        tableView.dataSource = self
        tableView.delegate = self
        
        outGoingData = NSMutableDictionary()
        
        dataBind(NSDate())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.calendarView.commitCalendarViewUpdate()
        self.menuView.commitMenuViewUpdate()
    }
    
    func GetDateWithFormat(d:NSDate,format:String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
       
        let s = dateFormatter.stringFromDate(d)
        
        
        return s
    }

    func presentationMode() -> CalendarMode
    {
        return CalendarMode.MonthView
    }
    
    func firstWeekday() -> Weekday
    {
        return .Sunday
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool)
    {
    
        if let finalDate = dayView.date {
            let month = String(format: "%02d", finalDate.month)
            let day = String(format: "%02d", finalDate.day)
            
            selectDay = "\(finalDate.year)-\(month)-\(day)"
            tableView.reloadData()
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                               self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }

    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 5.0
        let ringInsetWidth: CGFloat = 5.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 3.0
        let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
 
        ringLayer.frame = newView.layer.bounds
        
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if let currentDay = dayView.date{
            let month = String(format: "%02d", currentDay.month)
            let day = String(format: "%02d", currentDay.day)
            
            let finalDate = "\(currentDay.year)-\(month)-\(day)"
            
            if let _ = outGoingData?.objectForKey(finalDate){
                return true
            }
            else{return false}
        }
        else {return false}
    
    
    }
    
    func refreshCalendar(result:JSON){
        var outData:clsOutgoing?
        //ddddd
        self.outGoingData?.removeAllObjects()
        for (_,subJson):(String, JSON) in result {
            
            if let Data = self.outGoingData?.objectForKey(subJson["OutDate"].string!){
                self.outGoingArray = Data as? NSMutableArray
            }
            else{
                self.outGoingArray = NSMutableArray()
            }
            outData = clsOutgoing()
            outData?.m_outDate = subJson["OutDate"].string
            outData?.m_outTime = subJson["OutTime"].string
            outData?.m_Location = subJson["Location"].string
            outData?.m_customer = subJson["CustomerName"].string
            outData?.m_outId = subJson["OutId"].string
            self.outGoingArray!.addObject(outData!)
            
            self.outGoingData?.setObject(self.outGoingArray!, forKey: subJson["OutDate"].string!)
        }
    }
    
    func dataBind(date: NSDate)
    {
        let SDate = GetDateWithFormat(date,format: "yyyyMM") + "01"
        let EDate = GetDateWithFormat(date,format: "yyyyMM") + "31"
        
        selectDay = SDate
        
        let rest = clsRestful()
        
        rest.getJsonData("\(Global.baseUrl)Outgoing?EmpNo=\(Global.UserId!)&SDATE=\(SDate)&EDATE=\(EDate)",onSuccess:{result -> Void in
            
            self.refreshCalendar(result)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.tableView.reloadData()
                self.calendarView.contentController.refreshPresentedMonth()
            })
            
            },onError:{err -> Void in
                
                dispatch_async(dispatch_get_main_queue(),{
                    let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .Alert);
                    
                    let okaction = UIAlertAction(title: "OK",style: .Default, handler: nil);
                    
                    quetion.addAction(okaction);
                    self.presentViewController(quetion, animated: true, completion: nil);
                })
                
        })

    }
    
    func didShowNextMonthView(date: NSDate)
    {
        dataBind(date)
    }
    
    func didShowPreviousMonthView(date: NSDate){
        dataBind(date)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        if let outData:NSMutableArray = outGoingData?.objectForKey(selectDay!) as? NSMutableArray
        {
            return outData.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCellCanlendarTableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if let outData:NSMutableArray = outGoingData?.objectForKey(selectDay!) as? NSMutableArray
        {
            if let data = outData[indexPath.row] as? clsOutgoing{
                
                cell.setCustomer(data.m_customer!)
                cell.setDate(data.m_outDate!)
                cell.setLocation(data.m_Location!)
            }
            
        }
  
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let selectedDay = dateFormatter.dateFromString(selectDay!)
        
        if selectedDay?.compare(NSDate()) == NSComparisonResult.OrderedDescending{
            return true
        }
        else
        {
            return false
        }
        
    
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            SwiftSpinner.show("資料刪除中")
            if let outData:NSMutableArray = outGoingData?.objectForKey(selectDay!) as? NSMutableArray
            {
                if let data = outData[indexPath.row] as? clsOutgoing{
                    let rest = clsRestful()
                    rest.makeGetRequest("\(Global.baseUrl)DeleteOutgoing?OutId=\(data.m_outId!)&EmpNo=\(Global.UserId!)" ,onSuccess: {result -> Void in
                        
                            SwiftSpinner.hide()
                        
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        
                            let selectedDay = dateFormatter.dateFromString(self.selectDay!)
                        
                            self.dataBind(selectedDay!)
                        
                        }, onError: {err -> Void in
                            dispatch_async(dispatch_get_main_queue(),{
                                
                                SwiftSpinner.hide()
                                
                                let quetion = UIAlertController(title: "錯誤!", message: err, preferredStyle: .Alert);
                                
                                let okaction = UIAlertAction(title: "OK",style: .Default, handler: nil);
                                
                                quetion.addAction(okaction);
                                self.presentViewController(quetion, animated: true, completion: nil);
                            })
                        }
                    )
                }
                
                outData.removeObjectAtIndex(indexPath.row)
                
                
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

extension ViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 3
    }
}





