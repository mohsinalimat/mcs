//
//  WarnListCell.swift
//  mcs
//
//  Created by gener on 2018/1/22.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class WarnListCell: UICollectionViewCell {

    @IBOutlet weak var warnNo: UILabel!
    
    @IBOutlet weak var warnLevel: UILabel!
    
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
//        layer.cornerRadius = 10
//        layer.masksToBounds = true
    }

    
    func fillWith(status:[String:Any]? = nil) {
        guard let s = status else { return }
        guard let detail = s["detail"] as? [[String:Any]] else { return }
        guard let first = detail.first else { return }
        
        if let warn = first["code"] {
            warnNo.text = "\(warn)"
        }
        
        if let message = first["message"] {
            msg.text = "\(message)"
        }
        
        if let warn_level = first["grade"] as? String {
            warnLevel.backgroundColor = kFlightWarnLevelColor["\(warn_level)"];
        }
        
        let _time = Tools.date(String.stringIsNullOrNil(first["faultOccurrenceDate"]))
        if let d = _time {
            time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd HH:mm")
        }
        
        
        
    }
    
    
    
}
