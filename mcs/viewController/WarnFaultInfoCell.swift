//
//  WarnFaultInfoCell.swift
//  mcs
//
//  Created by gener on 2018/2/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class WarnFaultInfoCell: UITableViewCell {

    @IBOutlet weak var code: UILabel!
    
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var phase: UILabel!
    
    @IBOutlet weak var isactive: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
