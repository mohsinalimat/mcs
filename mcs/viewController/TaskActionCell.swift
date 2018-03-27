//
//  TaskActionCell.swift
//  mcs
//
//  Created by gener on 2018/3/2.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskActionCell: UITableViewCell {

    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var actions: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(_ d:[String:Any]? , first:Bool = false) {
        
        actions.isHidden = !first
        
        msg.text = String.stringIsNullOrNil(d?["actionDetail"])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
