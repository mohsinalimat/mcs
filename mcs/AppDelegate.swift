//
//  AppDelegate.swift
//  mcs
//
//  Created by gener on 2018/1/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var _getMsgTimer:Timer!
    var _networkReachabilityManager:NetworkReachabilityManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.applicationIconBadgeNumber = 0;
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white

        _networkReachabilityManager = NetworkReachabilityManager(host: "www.baidu.com")
        _networkReachabilityManager.listener = { status in
            print("Network Status Changed: \(status)")
        }
        
        _networkReachabilityManager.startListening()
        
        let loginvc = LoginViewController()
        
        window?.rootViewController = loginvc
        
        window?.makeKeyAndVisible()
        
        _init()
        
        return true
    }

    func _init() {
       HUD.config()
       
       AMMModel.isExistTable()
       IQKeyboardManager.sharedManager().enable = true
       
        _initNotification()
        _getMsgTimer = Timer.scheduledTimer(timeInterval: TimeInterval(APP_TIMER_INTERVAL), target: self, selector: #selector(getMsg), userInfo: nil, repeats: true)

        //let d = UIDevice.current
        //print(d.name + "/" + (d.identifierForVendor?.uuidString)! )

    }
    
    func getMsg() {
        guard userIsLogin else {return}
        app_timer_cnt = app_timer_cnt + 1;
        guard app_timer_cnt > APP_TIMER_LOOP_INTERVAL / APP_TIMER_INTERVAL else {return}
        app_timer_cnt = 0;

        let d = ["date":Tools.dateToString(Date(), formatter: "dd/MM/yyyy")]
        netHelper_request(withUrl: noti_msg_url, method: .post, parameters:d, successHandler: {[unowned self] (res) in
            guard let arr = res["body"] as? [[String:Any]] else {return}
            if arr.count > 0 {
                if let old = Msg {
                    guard arr.count > old.count else {return}
                    new_msg_cnt = arr.count - old.count;
                }else {
                    new_msg_cnt = arr.count;
                }
                
                Msg = arr
                NotificationCenter.default.post(name: NSNotification.Name.init("new_msg_notification"), object: nil, userInfo: ["cnt":new_msg_cnt])
                
                guard !now_is_msgController else {return}
                self.showMsg("New Message Notification", title: "Open", handler: {
                    let v = MsgViewController();
                    v.isOpened = true
                    let nav = BaseNavigationController(rootViewController:v)
                    UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
                })
            }
            
            })
        
    }
    
    func showMsg( _ msg:String , title:String , handler:@escaping ((Void) -> Void)) {
        let vc = UIAlertController.init(title: msg,message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title:"Cancel", style: .default)
        let action2 = UIAlertAction.init(title: title, style: .destructive) { (action) in
            handler();
        }
        
        vc.addAction(action)
        vc.addAction(action2)
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil);
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
    

    //NO USE
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
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        //// Supported orientations has no common orientation with the application, and [PUUIAlbumListViewController shouldAutorotate] is returning YES
//        return .allButUpsideDown
//    }


}

