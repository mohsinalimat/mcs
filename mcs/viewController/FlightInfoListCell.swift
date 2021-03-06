//
//  FlightInfoListCell.swift
//  mcs
//
//  Created by gener on 2018/1/19.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class FlightInfoListCell: UICollectionViewCell {
    @IBOutlet weak var iconImgWidth: NSLayoutConstraint!

    @IBOutlet weak var flightNo: UILabel!
    
    @IBOutlet weak var from: UILabel!
    
    @IBOutlet weak var std: UILabel!
    @IBOutlet weak var sta: UILabel!
    
    @IBOutlet weak var std2: UILabel!
    @IBOutlet weak var sta2: UILabel!
    
    
    
    @IBOutlet weak var gate: UILabel!
    
    @IBOutlet weak var t1: UILabel!
    @IBOutlet weak var t2: UILabel!
    @IBOutlet weak var t3: UILabel!
    @IBOutlet weak var t4: UILabel!
    
    
    
    
    
    
    
    @IBOutlet weak var directionLab: UILabel!
    
    @IBOutlet weak var warn_tap: UIButton!
    
    @IBOutlet weak var icon_plane: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        warn_tap.layer.borderWidth = 1
        warn_tap.layer.borderColor = UIColor.black.cgColor
        warn_tap.isHidden = true
        iconImgWidth.constant = 0;
    }

    override func prepareForReuse() {
        warn_tap.isHidden = true
        warn_tap.backgroundColor = UIColor.clear
        flightNo.text = nil
        iconImgWidth.constant = 0;
        icon_plane.transform = CGAffineTransform.identity
    }

    
    func fillCell(_ dic:[String:Any] , show:Bool? = false , left:Bool = true , warnStatus:[[String:Any]]? = nil , thisDay:Bool = false )  {
        let fltno = left ? "fromFltNo":"toFltNo"
        flightNo.text = String.stringIsNullOrNil(dic[fltno])
        
        directionLab.text = left ? "FRM":"TO"
        from.text = String.stringIsNullOrNil(dic[left ? "fromApt" :"toApt"])
        t1.text = left ? "STA":"STD"
        t2.text = left ? "ATA":"ATD"
        t3.text = left ? "STD":"STA"
        t4.text = left ? "ATD":"ATA"
        
        ///站位
        let zhanwei = left ? "ac_stop_arr":"ac_stop"
        gate.text = String.stringIsNullOrNil(dic[zhanwei])
        
        std.text = String.stringIsNullOrNil(dic[left ? "sta":"std"])
        sta.text = String.stringIsNullOrNil(dic[left ? "ata":"atd"])
        
        std2.text = String.stringIsNullOrNil(dic[left ? "fromstd":"tosta"])
        sta2.text = String.stringIsNullOrNil(dic[left ? "outTime":"inTime"])
        
        /*let _std = Tools.date(String.stringIsNullOrNil(dic["std"]))
        if let d = _std {
            std.text = Tools.dateToString(d, formatter: "HHmm")
        }
        
        let _sta = Tools.date(String.stringIsNullOrNil(dic["sta"]))
        if let d = _sta {
            sta.text = Tools.dateToString(d, formatter: "HHmm")
        }*/
        

        if thisDay && flightNo.text == kFlightInfoListController_fltNo {
            iconImgWidth.constant = 40;
        }else {
            iconImgWidth.constant = 0;
        }
        
        if let arr = warnStatus {
            let b = _flight_has_warn(arr, fltno: String.stringIsNullOrNil(dic[fltno]), airid: String.stringIsNullOrNil(dic["acReg"]))
            warn_tap.isHidden = !(b.exist)
            if b.exist {
                warn_tap.backgroundColor = kFlightWarnLevelColor["\(b.grade)"];
            }
        }

        
        icon_plane.image = UIImage (named: left ? "icon_plane_arri":"icon_plane")
    }
    
    
    func _flight_has_warn(_ arr :[[String:Any]] , fltno:String, airid:String) -> (exist:Bool ,grade:String) {
        guard arr.count > 0 else {return (false,"")}
        
        for i in 0..<arr.count {
            let obj = arr[i]
            
            if let tail = obj["tailNo"] as? String ,let flt = obj["flightNumber"] as? String {
                if tail == airid && flt == "NX\(fltno)" {
                    guard obj["grade"] != nil else {return (false,"")}
                    
                    return (true,String.isNullOrEmpty(obj["grade"]))
                }
            }
        }
        
        return (false,"")
    }
    
    
    
}
