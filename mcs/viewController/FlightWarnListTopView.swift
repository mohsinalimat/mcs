//
//  FlightWarnListTopView.swift
//  mcs
//
//  Created by gener on 2018/3/7.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class FlightWarnListTopView: UIView {

    @IBOutlet weak var airId: UILabel!
    
    @IBOutlet weak var arr_dep: UILabel!
    
    @IBOutlet weak var from_to: UILabel!
    
    @IBOutlet weak var from_to_value: UILabel!
    
    @IBOutlet weak var flt_no: UILabel!
    
    @IBOutlet weak var flt_date: UILabel!
    
    var selectBuuttonClickHandler:((Bool) -> Void)?
    
    
    @IBAction func selectedBtnAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        reportBtn.isHidden = !sender.isSelected
        
        if let handle = selectBuuttonClickHandler {
            handle(sender.isSelected);
        }
        
    }

    @IBOutlet weak var reportBtn: UIButton!
    
    @IBAction func creatRepostActin(_ sender: UIButton) {
        
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let v = Bundle.main.loadNibNamed("FlightWarnListTopView", owner: self, options: nil)?.last as! UIView
        v.frame  = self.bounds
        self.addSubview(v)
    }
    
    
    
    func fillData(_ dic:[String:Any]) {
        airId.text = String.stringIsNullOrNil(dic["acId"])
        flt_no.text = String.stringIsNullOrNil(dic["fltNo"])
        
        let arr = String.stringIsNullOrNil(dic["arrApt"])
        if arr == "MFM" {
            from_to.text = "FRM:"
            from_to_value.text = String.stringIsNullOrNil(dic["depApt"])
            arr_dep.text = "ARRIVALS"
        }else{
            from_to.text = "To:"
            from_to_value.text = arr
            arr_dep.text = "DEPARTURES"
        }
        
        flt_date.text = String.stringIsNullOrNil(dic["fltDate"])
        
        
    }
    
}
