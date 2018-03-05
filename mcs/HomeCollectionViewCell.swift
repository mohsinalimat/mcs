//
//  HomeCollectionViewCell.swift
//  mcs
//
//  Created by gener on 2018/1/15.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var warnLevel: UILabel!
    @IBOutlet weak var flightNo: UILabel!
    @IBOutlet weak var taskNo: UILabel!
    @IBOutlet weak var warnNo: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var arri_dep: UILabel!
    @IBOutlet weak var std: UILabel!
    @IBOutlet weak var sta: UILabel!
    @IBOutlet weak var atd: UILabel!
    @IBOutlet weak var ata: UILabel!
    @IBOutlet weak var etd: UILabel!
    @IBOutlet weak var eta: UILabel!
    
    @IBOutlet weak var hangbanNo: UILabel!
    @IBOutlet weak var zhanweiNo: UILabel!
    @IBOutlet weak var trackView: HomeCellTrackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        icon.layer.cornerRadius = 15
//        icon.layer.masksToBounds = true
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(colorLiteralRed: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1).cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
    
    }

    
    func fillCell(_ dic:[String:Any] ,taskNumber:Int = 0 ,status:[String:Any]? = nil)  {
        flightNo.text = String.stringIsNullOrNil(dic["acId"])
        
        let s = String.stringIsNullOrNil(dic["arrApt"])
        
        icon.image = UIImage (named: s == "MFM" ? "icon_arrival":"icon_departure")
    
        
        /*arri_dep.text = {
            let s = String.stringIsNullOrNil(dic["arrApt"])
            if s == " " { return "";}
            return s == "MFM" ? "ARRIVALS":"DEPARTURES"
        }()*/
        
        taskNo.text = "\(taskNumber)"//任务数
        
        if let status_info = status {//告警数
            if let warn = status_info["count"] {
                warnNo.text = "\(warn)"
            }
            
            if let warn_level = status_info["grade"] as? Int {
                warnLevel.backgroundColor = kFlightWarnLevelColor["\(warn_level)"];
            }
        }
        
        ///sta-std
        let _std = Tools.date(String.stringIsNullOrNil(dic["std"]))
        if let d = _std {
            std.text = Tools.dateToString(d, formatter: "HHmm")
        }
        
        let _sta = Tools.date(String.stringIsNullOrNil(dic["sta"]))
        if let d = _sta {
            sta.text = Tools.dateToString(d, formatter: "HHmm")
        }
        
        
        ///track line
        trackView.displayMsg(dic)
    }
    
    
    

    
    
    
}





