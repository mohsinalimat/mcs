//
//  PlaneCertImageCell.swift
//  mcs
//
//  Created by gener on 2018/6/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class PlaneCertImageCell: UICollectionViewCell {

    @IBOutlet weak var ig: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
    }

    
    func fill(_ d:[String:Any]) {
        guard let igid = d["id"] as? String else {return}
        
        requestImage(igid) {[weak self] (ig) in
            guard let ss = self else {return}
            ss.ig.image = ig
        }
        
    }
    
    
    
    
}
