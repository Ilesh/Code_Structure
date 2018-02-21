//  AppDelegate.swift
//  Copyright © 2018 Self. All rights reserved.
//  Ilesh Test

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate,UITabBarDelegate {
    var window: UIWindow?
    var navController:UINavigationController?
    var homeObj : HomeVC?
    var notificationObj : NotificationVC?
    var settingObj: SettingVC?
    var tabBarController: UITabBarCustom!
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        
        //setupLocationManager()
        self.RegistrationForNotification()
        
        // APP IS RUNNING FIRST TIME
        if Singleton.sharedSingleton.isAppLaunchedFirst(){
            
        }        
        self.setnavigation()
        return true
    }

    func setnavigation() {
        let login = LoginVC(nibName: "LoginVC", bundle: nil)
        navController = UINavigationController(rootViewController: login)
        navController?.isNavigationBarHidden = true
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func logoutUser() {
        Singleton.sharedSingleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.User_id)
        Singleton.sharedSingleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.Email)
        Singleton.sharedSingleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.name)
        Singleton.sharedSingleton.saveToUserDefaults(value: "", forKey: Global.kLoggedInUserKey.phone)
        Singleton.sharedSingleton.saveToUserDefaults(value: "false", forKey: Global.kLoggedInUserKey.IsLoggedIn)
        Singleton.sharedSingleton.saveToUserDefaults(value: "false", forKey: Global.kLoggedInUserKey.IsAddAddress)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.User_id)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.DOB)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.Email)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.FB_id)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.FullName)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.Google_id)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.phone)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.user_Image)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.user_type)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.Billing_address)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.is_email_Noti)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.is_email_Subscription)
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.is_push_noti) //
        Singleton.sharedSingleton.saveToUserDefaults(value: "" , forKey: Global.kLoggedInUserKey.is_Registertype)
        
        Singleton.sharedSingleton.is_FromMyAddress = false
        Singleton.sharedSingleton.is_FromSocialLogin = false
    
        self.navController?.popToRootViewController(animated: true)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    //MARK: Cutom tab bar for Agent
    func  ConfigureTabbarAgent(animated:Bool) -> Void {
        self.gotoDetailAppAgent(0)
        //Singleton.sharedSingleton.saveToUserDefaults(value: "true", forKey: Global.kLoggedInUserKey.IsAddAddress)
        self.navController?.pushViewController(self.tabBarController!, animated: animated)
    }
    
    func gotoDetailAppAgent(_ pintTabId: Int) {
        self.setTabBarForAgent()
        self.tabBarController?.delegate = self
        self.tabBarController?.selectedIndex = pintTabId
        self.tabBarController?.selectTab(pintTabId)
    }
    
    func setTabBarForAgent() {
        self.tabBarController = UITabBarCustom()
        // first
        homeObj = HomeVC(nibName: "HomeVC", bundle: nil)
        let navHome = UINavigationController(rootViewController: homeObj!)
        //Thard
        notificationObj = NotificationVC(nibName: "NotificationVC", bundle: nil)
        let navNoti = UINavigationController(rootViewController: notificationObj!)
        //forth
        settingObj = SettingVC(nibName: "SettingVC", bundle: nil)
        let navSetting = UINavigationController(rootViewController: settingObj!)
        
        self.tabBarController?.viewControllers = [navHome,navNoti,navSetting]
        navHome.isNavigationBarHidden = true
        navNoti.isNavigationBarHidden = true
        navSetting.isNavigationBarHidden = true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("open url: URL, sourceApplication")
        return true
    }
    
    
    //MARK:-  PUSH NOTIFICATION REGISTER
    func RegistrationForNotification() -> Void {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                      UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        NSLog("DEVICE TOKEN:- %@",deviceTokenString)
        Singleton.sharedSingleton.saveToUserDefaults(value: deviceTokenString, forKey: Global.g_UserDefaultKey.DeviceToken)        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("ERROR GETING DEVICE TOKEN ")
        Singleton.sharedSingleton.saveToUserDefaults(value:"ERRORGETINGDEVICETOKEN", forKey: Global.g_UserDefaultKey.DeviceToken)
        
    }
    
    //MARK:- NOTIFICATION RECEVED METHODS
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        notificationReceived(notification: userInfo as [NSObject : AnyObject])
        switch application.applicationState {
        case .inactive:
            print("Inactive")
            //Show the view with the content of the push
            
            break
        case .background:
            print("Background")
            //Refresh the local model
            
            break
        case .active:
            print("Active")
            //Show an in-app banner
            break
        }
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String : AnyObject] {
            print(userInfo)
            IPNotificationManager.shared.GetPushProcessDataWhenActive(dictNoti: userInfo as NSDictionary)
        }
        NSLog("Handle push from foreground" )
        completionHandler(.badge)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String : AnyObject] {
            print(userInfo)
            IPNotificationManager.shared.GetPushProcessData(dictNoti: userInfo as NSDictionary)
        }
        NSLog("Handle push from background or closed" )
        completionHandler()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        notificationReceived(notification: userInfo as [NSObject : AnyObject])
        switch application.applicationState {
        case .inactive:
            print("Inactive")
            //Show the view with the content of the push
            completionHandler(.newData)
            
        case .background:
            print("Background")
            //Refresh the local model
            completionHandler(.newData)
            
        case .active:
            print("Active")
            //Show an in-app banner
            completionHandler(.newData)
        }
    }
    
    func notificationReceived(notification: [NSObject:AnyObject]) {
        NSLog("notificationReceived : - %@",notification)
        //IPNotificationManager.shared.GetPushProcessData(dictNoti: notification as NSDictionary)
    }
}
