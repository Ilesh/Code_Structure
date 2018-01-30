//
//  ShareUser.swift
//  Alcohol
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class ShareUser: NSObject {
    var strId:String = ""
    var strFBId:String = ""
    var strGoogleId:String = ""
    var strFname:String = ""
    var strPhone:String = ""
    var isAbove18:Bool = false
    var strState:String = ""
    var strHouse:String = ""
    var strStreet:String = ""
    var strCity:String = ""
    var strHomeNo:String = ""
    var strUserName:String = ""
    var strCountry:String = ""
    //var strAddress:String = ""
    var strIsCurrent:String = ""
    var strPostCode:String = ""
    var strGender:String = ""
    var strDob:String = ""
    var strAge:String = ""
    var strIsDefault:String = ""
    var strAgeCalc:String {
        get{
            if strDob != "" {
                if let date = Singleton.sharedSingleton.dateFormatterYYYYMMDD().date(from: strDob){
                    let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
                    let now = Date()
                    let calcAge = calendar.components(.year, from: date, to: now, options: [])
                    return String(calcAge.year!)
                }else{
                    return "0"
                }
            }else{
                return "0"
            }
        }
    }
    var strEmailId:String = ""
    var strContact_no:String = ""
    var strPassword:String = ""
    var strProfileImg:String = ""
    var location:SharedLocation = SharedLocation()
}

/*
 fullname:Meet
 email:mit@topsinfosolutions.com
 password:Tops?123
 confirm:Tops?123
 phone:9876543210
 current_address:1
 conditions:1
 is_eighteen_plus:1
 submitted:submitted
 panel:app
 dob:14-10-1990
 age:27
 fb_id:
 google_id:
 device_token:
 device_type:
 
 */
