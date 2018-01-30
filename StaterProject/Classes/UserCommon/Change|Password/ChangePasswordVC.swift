//
//  ChangePasswordVC.swift
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var lblTitle: IPAutoScalingLabel!
    @IBOutlet weak var lbldiscription: IPAutoScalingLabel!
    @IBOutlet weak var btnDontRemember: IPAutoScalingButton!
    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfimPass: UITextField!
    @IBOutlet weak var btnSubmit: IPAutoScalingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOldPass.placeHolderColor = Global.kAppColor.SecondaryWightF1E
        txtOldPass.autocorrectionType = .no
        txtNewPass.placeHolderColor = Global.kAppColor.SecondaryWightF1E
        txtNewPass.autocorrectionType = .no
        txtConfimPass.placeHolderColor = Global.kAppColor.SecondaryWightF1E
        txtConfimPass.autocorrectionType = .no
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearAll()        
    }
    
    //MARK:- CUSTOM METHODS
    func clearAll() -> Void {
        txtOldPass.text = "" 
        txtNewPass.text = ""
        txtConfimPass.text = ""
    }
    
    //MARK:- UIBUTTON ACTION METHODS
    func callSavePassword() {
        var  paramer: [String: Any] = [:]
        paramer["customer_id"] =  Global.kretriUserData().User_id!
        paramer["old_password"] =  txtOldPass.text!
        paramer["password"] =  txtNewPass.text!
        paramer["confirm"] =  txtConfimPass.text!
        paramer["panel"] =  "app"
        paramer["device_uuid"] = Global.DeviceUUID
        
        AFAPIMaster.sharedAPIMaster.post_ChangePass_Completion(params: paramer, showLoader: true, enableInteraction: false, viewObj: (Global.appDelegate.navController?.view)!) { (result) in
            if let Dict = result as? NSDictionary {
                if let str = Dict.object(forKey:"status") as? String , str.toBool(){
                    Singleton.sharedSingleton.showSuccessAlert(withMsg: Dict.object(forKey: "msg") as? String ?? "")
                    self.clearAll()
                    self.navigationController?.popViewController(animated: true)
                }else{
                    Singleton.sharedSingleton.showWarningAlert(withMsg:  Dict.object(forKey: "msg") as? String ?? "")
                }
            }
        }
    }
    
    @IBAction func btnSubmitClick(_ sender: Any) {
        self.view.endEditing(true)
        let strPass = txtOldPass.text!.trimmingCharacters(in: .whitespaces)
        let strConPass = txtConfimPass.text!.trimmingCharacters(in: .whitespaces)
        let strNewPass = txtNewPass.text!.trimmingCharacters(in: .whitespaces)
        
        guard strPass.count > 0 else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keySUChangePasswordsrcOlD"))
            return
        }
        
        
        guard strNewPass.count > 0 else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keySUChangePasswordsrcNew"))
            return
        }
        
        guard strNewPass.isValidateSocialPassword else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keySUChangePasswordsrcNewVV"))
            return
        }
        
        guard strConPass.count > 0 else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keySUChangePasswordsrcCon"))
            return
        }
        /*guard strConPass.isValidateSocialPassword else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keySUChangePasswordsrcConVV"))
            //Password at least eight characters long, one special characters, one uppercase, one lower case letter and one digit.
            return
        }*/
        
        guard strNewPass == strConPass else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keySUChangePasswordsrcConfirm"))
            return
        }
        callSavePassword()
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
