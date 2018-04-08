//
//  Tools.swift
//  mcs
//
//  Created by gener on 2018/1/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Tools: NSObject {

    static let `default` = Tools()
    
   //MARK:-
   static func stringToDate(_ dateStr:String, formatter:String = "yyyy") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.date(from: dateStr)!
    }
    
    static func dateToString(_ date:Date, formatter:String = "yyyy") -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.string(from: date)
    }
    

    //时间戳 -> Date
    static func date(_ s:String) -> Date? {
        guard let sec = TimeInterval.init(s)  else {
            return nil
        }
        
        let date = Date.init(timeIntervalSince1970: sec / 1000.0)
        
        return date
        
    }
    
   
    
    
    
    
    
    
    
    //MARK: - show
    static func showAlert(_ vcname:String , withBar:Bool = true , frame:CGRect = CGRect(x: 0, y: 0, width: 500, height: 360)) {
        let appname = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let cls  =  NSClassFromString(appname + "." + vcname) as! BaseViewController.Type
        let vc = cls.init()
        vc.view.frame = frame
        
        if withBar {
            let nav = BaseNavigationController(rootViewController:vc)
            nav.navigationBar.barTintColor = kPop_navigationBar_color
            nav.modalPresentationStyle = .formSheet
            nav.preferredContentSize = frame.size
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        } else {
            vc.modalPresentationStyle = .formSheet;
            vc.preferredContentSize = frame.size
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }

    }
    
    
    static func showDatePicekr(_ s:UIViewController , handler:((Any) -> Void)? = nil){
        let vc = DatePickerController.init()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        vc.view.frame = frame
        
        vc.pickerDidSelectedHandler = handler
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        s.present(nav, animated: true, completion: nil)
    }
    
    
    static func showShiftPicekr(_ s:UIViewController , handler:((Any) -> Void)? = nil){
        let vc = DataPickerController.init()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        if let station = kTaskPool_BASE_DATA["shifts"] as? [Any] {
            vc.dataArray = station;
        }
        
        vc.view.frame = frame
        vc.dataType = .obj
        vc.pickerDidSelectedHandler = handler
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        s.present(nav, animated: true, completion: nil)
    }

    
    
    
}
