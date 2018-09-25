//
//  FlightWarnHeaderView1.swift
//  mcs
//
//  Created by gener on 2018/1/22.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class FlightWarnHeaderView: UICollectionReusableView {

    @IBOutlet weak var airId: UILabel!
    
    @IBOutlet weak var arr_dep: UILabel!
    
    @IBOutlet weak var from_to: UILabel!
    
    @IBOutlet weak var from_to_value: UILabel!
    
    @IBOutlet weak var flt_no: UILabel!
    
    @IBOutlet weak var flt_date: UILabel!
    
    @IBOutlet weak var lineView: FlightLineView!
    
    @IBOutlet weak var std: UILabel!
    
    @IBOutlet weak var sta: UILabel!
    
    @IBOutlet weak var etd: UILabel!
    
    @IBOutlet weak var eta: UILabel!
    
    @IBOutlet weak var atd: UILabel!
    
    @IBOutlet weak var ata: UILabel!
    
    @IBOutlet weak var gate: UILabel!
    
    @IBOutlet weak var plane_oil: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func fillData(_ dic:[String:Any]) {
        airId.text = String.stringIsNullOrNil(dic["acId"])
        flt_no.text = String.stringIsNullOrNil(dic["fltNo"])
        
        let arr = String.stringIsNullOrNil(dic["arrApt"])
        if arr == "MFM" {
            from_to.text = "FRM"
            from_to_value.text = String.stringIsNullOrNil(dic["depApt"])
            arr_dep.text = "ARRIVALS"
        }else{
            from_to.text = "To"
            from_to_value.text = arr
            arr_dep.text = "DEPARTURES"
        }
        
        flt_date.text = String.stringIsNullOrNil(dic["fltDate"])
        
        let _std = Tools.date(String.stringIsNullOrNil(dic["std"]))
        if let d = _std {
            std.text = Tools.dateToString(d, formatter: "HHmm")
        }
        
        let _sta = Tools.date(String.stringIsNullOrNil(dic["sta"]))
        if let d = _sta {
            sta.text = Tools.dateToString(d, formatter: "HHmm")
        }
        
        
    }
    
    
    
    
    
    
    
}
