//
//  TaskActionDetailView.swift
//  mcs
//
//  Created by gener on 2018/4/4.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskActionDetailView: UIView {

    var changeActionHandler:((Int) -> Void)?
    
    @IBOutlet weak var bg_v: UIView!

    @IBAction func actionDetailSelect(_ sender: UIButton) {

        if let handle = changeActionHandler {
            handle(sender.tag);
        }

    }
    
    
    
    func _selectedBtnAtIndex(_ index:Int) {
        for _v in self.bg_v.subviews{
            if _v.tag == index {
                let b = _v as! UIButton;
                b.setTitleColor(kButtonTitleDefaultColor, for: .normal);return
            }
        }
    }
    
    
    
}
