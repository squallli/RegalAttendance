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
    var m_EmployeeName:String?
    var m_EmployeeENName:String?
    var m_CardTime:String?
    var m_CardType:String?
    var m_Desc:String?
    
    init(){
        
    }
    
    init(employeeName:String,employeeEnName:String,cardTime:String,cardType:String,Desc:String){
        m_EmployeeName = employeeName
        m_EmployeeENName = employeeEnName
        m_CardTime = cardTime
        m_CardType = cardType
        m_Desc = Desc
    }
}