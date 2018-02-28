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
    
    @IBOutlet weak var gate: UILabel!
    
    
    @IBOutlet weak var directionLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        layer.borderColor = UIColor.lightGray.cgColor
//        layer.borderWidth = 1
        
        
    }

    
    func fillCell(_ dic:[String:Any] , show:Bool? = false)  {
        flightNo.text = String.stringIsNullOrNil(dic["fltNo"])
        
        let arr = String.stringIsNullOrNil(dic["arrApt"])
        
        if arr == "MFM" {
            directionLab.text = "FRM"
            from.text = String.stringIsNullOrNil(dic["depApt"])
        }else{
            directionLab.text = "TO"
            from.text = arr
        }
            

        
        let _std = Tools.date(String.stringIsNullOrNil(dic["std"]))
        if let d = _std {
            std.text = Tools.dateToString(d, formatter: "HHmm")
        }
        
        let _sta = Tools.date(String.stringIsNullOrNil(dic["sta"]))
        if let d = _sta {
            sta.text = Tools.dateToString(d, formatter: "HHmm")
        }
        
        
        ////
        if let b = show {
            if !b {
                iconImgWidth.constant = 0;
            }
        }
        
    }
    
    
}
