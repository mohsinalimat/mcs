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
    
    
}
