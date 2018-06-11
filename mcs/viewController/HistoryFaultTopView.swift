//
//  HistoryFaultTopView.swift
//  mcs
//
//  Created by gener on 2018/6/7.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class HistoryFaultTopView: UIView {

    var buttonActionHandler:((Int) -> Void)?
    
    @IBOutlet weak var reg: UILabel!
  
    @IBOutlet weak var ata: UITextField!
    
    @IBOutlet weak var component: UITextField!
    
    @IBOutlet weak var desc: UITextField!
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let handler = buttonActionHandler {
            handler(sender.tag);
        }
        
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
