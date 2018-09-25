//
//  SearBarView.swift
//  mcs
//
//  Created by gener on 2018/4/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class SearBarView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var selectedActionHandler:((Int) -> Void)?
    
    @IBOutlet weak var title: UILabel!
    
    
    @IBAction func okAction(_ sender: UIButton) {

        if let handler = selectedActionHandler {
            handler(sender.tag);
        }
    
    
    
    }
    
    
    
    
    
}
