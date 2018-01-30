//
//  SharedLocationData.swift
//  Alcohol
//
//  Created by Tops on 1/10/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class SharedLocation: NSObject {
    var strId :String = ""
    var strFullname :String = ""
    var strPhone :String = ""
    var strState :String = ""
    var strCountry :String = ""
    var strStreetNo: String = ""
    var strStreetName: String = ""
    var strHomeCity: String = ""
    var strZipCode: String = ""
    var strHomeNumberCode: String = ""
    var strFullAddressLocation : String = ""
    var strIsDefaulAddress : String = ""
    var isDefault:Bool = false
    var strFullAddress:String {
        get {
            var arr:[String] = []
            if strStreetNo != "" {
                arr.append(strStreetNo)
            }
            if strStreetName != "" {
                arr.append(strStreetName)
            }
            if strHomeCity != "" {
                arr.append(strHomeCity)
            }
            if strState != "" {
                arr.append(strState)
            }
            if strCountry != "" {
                arr.append(strCountry)
            }
            if strZipCode != "" {
                arr.append(strZipCode)
            }
            return arr.joined(separator: ", ")
        }
    }
}
