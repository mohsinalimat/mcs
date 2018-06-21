//
//  MaterialOrderHead.swift
//  mcs
//
//  Created by gener on 2018/5/3.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MaterialOrderHead: UIView {

    @IBOutlet weak var pn_total: UILabel!
    
    @IBOutlet weak var qty_total: UILabel!
    
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var descri: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var shift: UILabel!
    @IBOutlet weak var orderBy: UILabel!
    
    @IBOutlet weak var arrow_btn: UIButton!
    
    @IBOutlet weak var stas: UILabel!
    
    
    var clickedAction:((Bool) -> Void)?
    
    let sts  = ["0":"initial","1":"confirmed","2":"prepared"]
    
    @IBAction func buttonAction(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
        
        if let handler = clickedAction {
            handler(sender.isSelected);
        }

    }
    
    
    func  fill(_ d:[String:Any]) {
        pn_total.text = String.isNullOrEmpty(d["pnTotal"])
        qty_total.text = String.isNullOrEmpty(d["qtyTotal"])
        orderNum.text = String.isNullOrEmpty(d["orderNo"]) + "(\(String.isNullOrEmpty(d["ac"])))"
        
        //descri.text = String.isNullOrEmpty(d["qtyTotal"])
        shift.text = "Shift: " +  String.isNullOrEmpty(d["shift"])
        orderBy.text = "OrderBy: " + String.isNullOrEmpty(d["orderBy"])
        stas.text = sts[String.isNullOrEmpty(d["status"])]
        

        let issuetime = Tools.date(String.stringIsNullOrNil(d["orderDate"]))
        if let d = issuetime {
            time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
    }
   
    func _setSelected(_ b : Bool)  {
        
    }
    

}
