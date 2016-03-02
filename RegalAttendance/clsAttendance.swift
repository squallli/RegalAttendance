//
//  clsAttendance.swift
//  RegalAttendance
//
//  Created by Regal System on 2016/2/5.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import Foundation


class clsAttendance
{
    var m_EmployeeName:String? = ""
    var m_cardDesc = NSMutableArray()
    init(){
        
    }
    
    init(employeeName:String){
        m_EmployeeName = employeeName
        
    }
    
    func addWithCardDesc(cardDesc:clsCardDesc){
        m_cardDesc.addObject(cardDesc)
    }
}

class clsCardDesc
{
    var m_CardTime:String? = ""
    var m_CardType:String? = ""
    
    init(){}
}