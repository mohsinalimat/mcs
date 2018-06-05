//
//  DDWPHeadView.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDWPHeadView: UIView {
    
    @IBOutlet weak var addBtn: UIButton!
    
    var addAction:((Void) -> Void)?
    
    @IBAction func addAction(_ sender: UIButton) {
        if let add = addAction {
            add();
        }
    }
    
    func _isR()  {
//        addBtn.isHidden = true
        addBtn.isUserInteractionEnabled = false
        addBtn.setImage(nil, for: .normal)

    }
    
    
}
