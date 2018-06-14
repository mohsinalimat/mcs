//
//  AppDelegate.swift
//  mcs
//
//  Created by gener on 2018/1/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let loginvc = LoginViewController()
        window?.rootViewController = loginvc
        
        window?.makeKeyAndVisible()
        
        application.applicationIconBadgeNumber = 0;
        
        
        _init()
        
        return true
    }

    func _init() {
       HUD.config()
       
       AMMModel.isExistTable()
       IQKeyboardManager.sharedManager().enable = true
       //IQKeyboardManager.sharedManager().enableAutoToolbar = false
       
        _initNotification()
        
        let d = UIDevice.current
        
        print(d.name + "/" + (d.identifierForVendor?.uuidString)! )
    }
    
    
    //MARK:-
    func _initNotification() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings.init(types: [.alert,.sound,.badge], categories: nil))
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print(#function)
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(#function)
        //AEFD81A8308B15169F992900A85C9CBCA29BF8E8549A154955765A94BE947E99
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print(token)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("didReceiveRemoteNotification: \(userInfo)")
        application.applicationIconBadgeNumber = 0;
        HUD.show(info:"收到通知！")
    
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function)
    }
    

    
    func _submintDevicesInfo()  {
        let d = UIDevice.current
        let pars = ["name" : d.name,
                    "uuid":String.isNullOrEmpty(d.identifierForVendor?.uuidString)]
        
        request("", parameters: pars, successHandler: { (res) in
            
            }) { (str) in
                
        }
        
        print(d)
        
    }
    
    //MARK:
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        //// Supported orientations has no common orientation with the application, and [PUUIAlbumListViewController shouldAutorotate] is returning YES
        return .allButUpsideDown
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

