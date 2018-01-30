//  LoginManager.swift
//  Copyright © 2016 Self. All rights reserved.
//

import UIKit

class IPLoginManager: NSObject {
    
    func LoginCall(_ strEmail:String, strPass:String ,Complete:@escaping(AnyObject)->Void, failure:@escaping(_ is_email:Bool, _ is_Pass:Bool)->Void) -> Void  {
        
        let strEmail = strEmail.trimmingCharacters(in: .whitespaces)
        let strTempPass = strPass.trimmingCharacters(in: .whitespaces)
        guard strEmail.count > 0 else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "KeyVLEmail"))
            failure(false,false)
            return
        }
        guard strEmail.isEmail else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "KeyVVLEmail"))
            failure(false,false)
            return
        }
        guard strTempPass.count > 0 else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keyVPassword"))
            failure(true,false)
            return
        }
        
        var  paramer: [String: Any] = [:]
        paramer["email"] =  strEmail
        paramer["password"] =  strTempPass
        paramer["panel"] =  "app"
        paramer["device_token"] =  Singleton.sharedSingleton.retriveFromUserDefaults(key: Global.g_UserDefaultKey.DeviceToken)!
        paramer["device_type"] =  Global.g_ws.Device_type
        paramer["device_uuid"] = Global.DeviceUUID
        
        AFAPIMaster.sharedAPIMaster.postLoginCall_Completion(params: paramer, showLoader: true, enableInteraction: false, viewObj: (Global.appDelegate.navController?.view)!) { (result) in
            Complete(result as AnyObject)
        }
        
    }
    
    func ForgotPassCall(_ strEmail:String ,Complete:@escaping(AnyObject)->Void, failure:@escaping(_ is_email:Bool)->Void) -> Void  {
        let strEmail = strEmail.trimmingCharacters(in: .whitespaces)
        guard strEmail.count > 0 else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "KeyVLEmail"))
            failure(false)
            return
        }
        
        guard strEmail.isEmail else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "KeyVVLEmail"))
            failure(false)
            return
        }
        var  paramer: [String: Any] = [:]
        paramer["email"] =  strEmail
        paramer["panel"] =  "app"
        paramer["remember"] =  "0"

        AFAPIMaster.sharedAPIMaster.postForgotPwdWithMobileCall_Completion(params: paramer, showLoader: true, enableInteraction: false, viewObj: (Global.appDelegate.navController?.view)!) { (result) in
            Complete(result as AnyObject)
        }
    }

}
