//  ForgotVC.swift
//  Copyright © 2016 Self. All rights reserved.
//

import UIKit

class ForgotVC: UIViewController {

    @IBOutlet weak var lblForgot: IPAutoScalingLabel!
    @IBOutlet weak var lblDiscription: IPAutoScalingLabel!
    @IBOutlet weak var txtEmail: IPAutoScalingTextField!
    @IBOutlet weak var btnForgot: IPAutoScalingButton!
    var strUEmail = ""
    
    //MARK - VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.autocorrectionType = .no        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLanguageText()
        txtEmail.text = strUEmail
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    //MARK - CUSTOM METHODS
    func setLanguageText() -> Void {
        lblForgot.text = LocalizeHelper().localizedString(forKey: "KeyFlblForgot")
        lblDiscription.text = LocalizeHelper().localizedString(forKey: "KeyFlblDisc")
        txtEmail.placeholder = LocalizeHelper().localizedString(forKey: "KeyVEmail")
        btnForgot.setTitle(LocalizeHelper().localizedString(forKey: "KeyFbtnForgot"), for: .normal)
        txtEmail.placeHolderColor = Global.kAppColor.SecondaryWightF1E
    }
    
    //MARK - BUTTON ACTION METHODS
    @IBAction func btnForgotClick(_ sender: Any) {
        self.view.endEditing(true)
        IPLoginManager().ForgotPassCall(txtEmail.text!, Complete:{(response) in
            if let Dict = response as? NSDictionary {
                if let str = Dict.object(forKey:"status") as? String , str.toBool(){
                    Singleton.sharedSingleton.showSuccessAlert(withMsg: Dict.object(forKey: "msg") as? String ?? "")
                    self.txtEmail.text = ""
                    self.strUEmail = ""
                    self.btnBackClick(self)
                }else{
                    Singleton.sharedSingleton.showWarningAlert(withMsg:  Dict.object(forKey: "msg") as? String ?? "")
                }
            }
        } , failure: {
            (is_email:Bool) in
        })
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
       _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnTermsClick(_ sender: Any) {
        self.view.endEditing(true)
       
    }
    
    @IBAction func btnSupportClick(_ sender: Any) {
        self.view.endEditing(true)
        /*let addLocationVCObj = FAQVc(nibName: "FAQVc", bundle: nil)
        Global.appDelegate.navController?.pushViewController(addLocationVCObj, animated: true)*/
    }
    
}
