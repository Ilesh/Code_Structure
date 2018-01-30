//
//  SettingVC.swift
//  Copyright © 2018 Self. All rights reserved.
//  Ilesh Commited :18/07

import UIKit
import Pulsator
import SDWebImage

class SettingVC: UIViewController {
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var lblNotification: UILabel!
    
    @IBOutlet weak var lblChangePassword: UILabel!
    @IBOutlet weak var btnChangePassword: UIButton!
    
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var btnSupport: UIButton!
    
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var btnAbout: UIButton!
    
    @IBOutlet weak var lblUserMail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var viewOR: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    let pulsator = Pulsator() // update location
    
    var isPopController: Bool = false
    
    weak var viewNoti: NotificationView!
    var tapGestureRecognizer : UITapGestureRecognizer?
    
    var viewMenuClick: UIView? {
        didSet {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HidePicker))
            viewMenuClick?.addGestureRecognizer(tapGestureRecognizer!)
        }
    }
    
    func removeGesture() -> Void {
        if viewMenuClick != nil {
            if tapGestureRecognizer != nil {
                viewMenuClick?.removeGestureRecognizer(tapGestureRecognizer!)
            }
        }
    }
    
    var dateviewframe:CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arrNib = Bundle.main.loadNibNamed("NotificationView", owner: self, options: nil)
        viewNoti = arrNib![0] as? NotificationView
        dateviewframe = viewNoti.frame
        dateviewframe.origin.y = UIScreen.main.bounds.size.height + 10
        viewNoti.frame = dateviewframe
        viewNoti.delegate = self
        Global.appDelegate.window?.addSubview(viewNoti)
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.layoutIfNeeded()
        lblUserName.text = Global.kretriUserData().name
        lblUserMail.text = Global.kretriUserData().Email
        let strImageProfile = Global.kretriUserData().strProfile
        if let strUrl = URL(string:strImageProfile!) {
            self.imgUserProfile.sd_setImage(with:strUrl , placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
     
        pulsator.position = self.viewOR.layer.position
        Global().delay(delay: 0.5) {
            self.rippleAnimationMethod()
        }
        self.callGetUserProfileDetailAPI_Call()

        if isPopController == true {
        }
    }
    
    // MARK: -  GetUserProfile Api Methods
    func callGetUserProfileDetailAPI_Call(){
        
        var strURL = ""
        var strUserId = ""
        strUserId =  Global.kretriUserData().User_id!
        strURL = ("rest_api/customer_details?customer_id=\(strUserId)&panel=app&device_uuid=\(Global.DeviceUUID)")
        AFAPIMaster.sharedAPIMaster.getUserProfileDetailApi_Completion(strApiUrl: strURL, params: nil, showLoader: true, enableInteraction: false, viewObj: (Global.appDelegate.navController?.view)!) { (response) in
            print(response)
            if let Dict = response as? [String : AnyObject] {
                if let str = Dict["status"] as? String , str.toBool(){
                    if let userData = Dict["data"] as? [String : AnyObject] {
                        if let arrCategoryListData = userData["customer_details"] as? [AnyObject] , arrCategoryListData.count > 0 {
                            print("ArrayList : \(arrCategoryListData)")
                            self.parseUserDetailResponse(arrCategory: arrCategoryListData)
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: -   Parse Category List Response Method
    func parseUserDetailResponse(arrCategory:[AnyObject]) -> Void {
        for element in arrCategory {
            if let userData = element as? [String:AnyObject] {
                Singleton.sharedSingleton.saveToUserDefaults(value: userData["dob"] as? String ?? "" , forKey: Global.kLoggedInUserKey.DOB)
                Singleton.sharedSingleton.saveToUserDefaults(value: userData["email"] as? String ?? "" , forKey: Global.kLoggedInUserKey.Email)
                Singleton.sharedSingleton.saveToUserDefaults(value: userData["fullname"] as? String ?? "" , forKey: Global.kLoggedInUserKey.FullName)
                Singleton.sharedSingleton.saveToUserDefaults(value: userData["phone"] as? String ?? "" , forKey: Global.kLoggedInUserKey.phone)
                if let image = userData["profile_image"] as? String, image != "" {
                    Singleton.sharedSingleton.saveToUserDefaults(value: userData["profile_image"] as? String ?? "" , forKey: Global.kLoggedInUserKey.user_Image)
                }else if let image = userData["social_images"] as? String {
                    Singleton.sharedSingleton.saveToUserDefaults(value: image , forKey: Global.kLoggedInUserKey.user_Image)
                }
                Singleton.sharedSingleton.saveToUserDefaults(value: userData["register_type"] as? String ?? "", forKey: Global.kLoggedInUserKey.is_Registertype)
                lblUserName.text = Global.kretriUserData().name
                lblUserMail.text = Global.kretriUserData().Email
                let strImageProfile = Global.kretriUserData().strProfile
                if let strUrl = URL(string:strImageProfile!) {
                    print(strUrl)
                    self.imgUserProfile.sd_setImage(with:strUrl , placeholderImage: #imageLiteral(resourceName: "placeholder"))
                    
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        HidePicker()
        super.viewDidDisappear(animated)
    }
    
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        dateviewframe.size.width = UIScreen.main.bounds.size.width
        self.dateviewframe.size.height = 170
        viewNoti.frame = dateviewframe
        self.imgUserProfile.layer.masksToBounds = true
        self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.height / 2
    }
    
    // MARK: -  Ripple Animation Methods
    func rippleAnimationMethod() {
        self.viewOR.layer.superlayer?.insertSublayer(pulsator, below: self.viewOR.layer)
        setInitialPlusatorAnimation()
        pulsator.start()
    }
    
    func setInitialPlusatorAnimation() {
        pulsator.radius = 100.0
        pulsator.numPulse = 4
        pulsator.backgroundColor = UIColor.init(red: 85.0/255, green: 85.0/255, blue: 85.0/255, alpha: 1.0).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingVC {
    
    @IBAction func btnNotificationClick(_ sender: UIButton) {
        self.ShowPicker()
    }
    @IBAction func btnChangePasswordClick(_ sender: UIButton) {
        let strRegistredType = Global.kretriUserData().registered_type
        if strRegistredType != "0" && strRegistredType != "" {
            let changePassObj = ChangePasswordVC(nibName:"ChangePasswordVC", bundle: nil)
            Global.appDelegate.navController?.pushViewController(changePassObj, animated: true)
        } else {
            let alert = UIAlertController(title: nil, message: "you are logged in with social so we can not proceed your request", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSupportClick(_ sender: UIButton) {
       /* let addLocationVCObj = FAQVc(nibName: "FAQVc", bundle: nil)
        Global.appDelegate.navController?.pushViewController(addLocationVCObj, animated: true)*/
    }
    
    @IBAction func btnAboutClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnLogoutClick(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.LogoutCall()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnEditProfileClick(_ sender: Any) {
        isPopController = true
        /*let editProfileVCObj = EditProfileVC(nibName: "EditProfileVC", bundle: nil)
        Global.appDelegate.navController?.pushViewController(editProfileVCObj, animated: true)*/
    }
    
    //MARK: USER LOGOUT APICALL
    func LogoutCall() -> Void {
        var  paramer: [String: Any] = [:]
        paramer["customer_id"] =  Global.kretriUserData().User_id!
        paramer["panel"] =  "app"
        
        AFAPIMaster.sharedAPIMaster.post_LogOutCall_Completion(params: paramer, showLoader: true, enableInteraction: false, viewObj: (Global.appDelegate.navController?.view)!) { (result) in
            if let Dict = result as? NSDictionary {
                if let str = Dict.object(forKey:"status") as? String , str.toBool(){
                    Global.appDelegate.logoutUser()
                }else{
                    Singleton.sharedSingleton.showWarningAlert(withMsg:  Dict.object(forKey: "msg") as? String ?? "")
                }
            }
        }
    }
    
    //MARK: PICKER VIEW HIDE METHODS
    @objc func HidePicker() -> Void {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.dateviewframe.origin.y = UIScreen.main.bounds.size.height + 10
            self.viewNoti.frame = self.dateviewframe
        }, completion: { finished in
            DispatchQueue.main.async {
                if self.viewMenuClick != nil {
                    self.viewMenuClick?.removeFromSuperview()
                    self.viewMenuClick = nil
                }
            }
        })
    }
    
    func ShowPicker() -> Void {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.dateviewframe.origin.y = UIScreen.main.bounds.size.height - 170
            self.viewNoti.frame = self.dateviewframe
            self.viewNoti.setUpValues()
        }, completion: { finished in
            DispatchQueue.main.async {
                if self.viewMenuClick == nil {
                    self.viewMenuClick =  UIView.init(frame:self.view.frame) //self.view.snapshotView(afterScreenUpdates: true)
                    self.viewMenuClick?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    if self.viewMenuClick != nil {
                        self.view.addSubview(self.viewMenuClick!)
                    }
                }
            }
        })
    }
    
}

extension SettingVC : NotificationViewDelete {
    func didHide() {
        HidePicker()
    }
}
