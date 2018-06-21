//
//  MaterialOrderCell.swift
//  mcs
//
//  Created by gener on 2018/5/3.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MaterialOrderCell: UITableViewCell {

    @IBOutlet weak var num: UILabel!
    
    @IBOutlet weak var pn: UILabel!
    
    @IBOutlet weak var des: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        num.text = String.isNullOrEmpty(d["qty"])
        pn.text = String.isNullOrEmpty(d["pn"])
        des.text = String.isNullOrEmpty(d["description"])
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
