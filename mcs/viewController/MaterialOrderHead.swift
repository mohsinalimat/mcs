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
    
    var clickedAction:((Bool) -> Void)?
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
        
        if let handler = clickedAction {
            handler(sender.isSelected);
        }

    }
    
    
    func  fill() {
        
        
        
    }
   
    func _setSelected(_ b : Bool)  {
        
    }
    

}
