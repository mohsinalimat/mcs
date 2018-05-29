//
//  DDWSHeadView.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDWSHeadView: UIView {

    @IBAction func addAction(_ sender: UIButton) {
       let v = DDAddWSController()
        
       Tools.showVC(v)
        
    }


}
