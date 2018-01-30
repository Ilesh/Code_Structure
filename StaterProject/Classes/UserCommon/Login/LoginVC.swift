//  LoginVC.swift
//  Copyright © 2016 Self. All rights reserved.
//

import UIKit
class LoginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnRegistration: UIButton!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var cnst_top: NSLayoutConstraint!
    
    let yourAttributes : [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font : UIFont(name: Global.kFont.Proxima_Semibold, size: Singleton.sharedSingleton.getDeviceSpecificFontSize(10.0)) ?? UIFont.systemFont(ofSize: 10.0),
        NSAttributedStringKey.foregroundColor : UIColor.white,
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    
    
    //MARK - VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            cnst_top.constant = 20
        } else {
            // Fallback on earlier versions
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.lblVersion.text = "V \(version)"
        }
        let attributeString = NSMutableAttributedString(string: "Forgot password?",
                                                        attributes: yourAttributes)
        btnForgot.setAttributedTitle(attributeString, for: .normal)
        
        txtEmail.placeHolderColor = Global.kAppColor.SecondaryWightF1E
        txtPass.placeHolderColor = Global.kAppColor.SecondaryWightF1E
        
        txtEmail.autocorrectionType = .no
        txtPass.autocorrectionType = .no
        txtEmail.delegate = self
        txtPass.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isMovingToParentViewController {
            if (Global.kretriUserData().IsLoggedIn!.toBool()) && (Global.kretriUserData().IsAddedAddress!.toBool())  {
                Global.appDelegate.ConfigureTabbarAgent(animated: false)
            }
        }else{
            print("LogOut")
        }
        setLanguageText()
        if Global.Platform.isSimulator{
            txtEmail.text = "test"
            txtPass.text = "Tops?123"
        }else{
            txtEmail.text = ""
            txtPass.text = ""
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    //MARK - CUSTOM METHODS
    func setLanguageText() -> Void {        
        lblLogin.text = LocalizeHelper().localizedString(forKey: "KeyVLblLogin")
        txtEmail.attributedPlaceholder = NSAttributedString(string:LocalizeHelper().localizedString(forKey: "KeyVEmail"), attributes: [NSAttributedStringKey.foregroundColor: Global.kAppColor.SecondaryWightF1E])
        txtPass.attributedPlaceholder = NSAttributedString(string:LocalizeHelper().localizedString(forKey: "KeyVPass"), attributes: [NSAttributedStringKey.foregroundColor: Global.kAppColor.SecondaryWightF1E])
        btnLogin.setTitle(LocalizeHelper().localizedString(forKey: "KeyVbtnLogin"), for: .normal)
    }
    
    //MARK - BUTTON ACTION METHODS
    @IBAction func btnLoginClick(_ sender: Any) {
        self.view.endEditing(true)
        LoginCall()
    }
    @IBAction func btnForgotClick(_ sender: Any) {
        self.view.endEditing(true)
        let forgot = ForgotVC(nibName: "ForgotVC", bundle: nil)
        forgot.strUEmail = txtEmail.text!
        self.navigationController?.pushViewController(forgot, animated: true)
    }
    
    @IBAction func btnSignUPClick(_ sender: Any) {
        self.view.endEditing(true)
                       
    }
    
    @IBAction func btnTermsClick(_ sender: Any) {
        self.view.endEditing(true)
       
    }
    
    @IBAction func btnSupportClick(_ sender: Any) {
        self.view.endEditing(true)
        /*let addLocationVCObj = FAQVc(nibName: "FAQVc", bundle: nil)
        Global.appDelegate.navController?.pushViewController(addLocationVCObj, animated: true)*/
    }
    
    //MARK:- API CALLER METHODS
    func LoginCall() {
        IPLoginManager().LoginCall(txtEmail.text!, strPass: txtPass.text!, Complete: {
            (response) in
            if let Dict = response as? NSDictionary {
                if let str = Dict.object(forKey:"status") as? String , str.toBool(){
                    Singleton.sharedSingleton.saveToUserDefaults(value: "true", forKey: Global.kLoggedInUserKey.IsLoggedIn)
                    Singleton.sharedSingleton.saveToUserDefaults(value: Dict.object(forKey:"token") as? String ?? "" , forKey: Global.kLoggedInUserKey.AccessToken)
                    if let userData = Dict.object(forKey:"user_details") as? NSDictionary {
                        Singleton.sharedSingleton.saveToUserDefaults(value: userData.object(forKey:"id") as? String ?? "0" , forKey: Global.kLoggedInUserKey.User_id)
                    } else if let arruserData = Dict.object(forKey:"user_details") as? NSArray , arruserData.count > 0{
                        if let userData = arruserData[0] as? NSDictionary {
                            Singleton.sharedSingleton.parseLoginUserData(dic: userData)
                        }
                    }
                    Singleton.sharedSingleton.saveToUserDefaults(value: "true", forKey: Global.kLoggedInUserKey.IsAddAddress)
                    Global.appDelegate.ConfigureTabbarAgent(animated: true)
                }else{
                    Singleton.sharedSingleton.showWarningAlert(withMsg:  Dict.object(forKey: "msg") as? String ?? "")
                }
            }
        }, failure: {
            (is_email:Bool,is_pass:Bool) in
            
        })
    }
}
