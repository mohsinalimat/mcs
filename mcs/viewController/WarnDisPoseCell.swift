//
//  WarnDisPoseCell.swift
//  mcs
//
//  Created by gener on 2018/2/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class WarnDisPoseCell: UITableViewCell {
    @IBOutlet weak var taskcode: UILabel!
    @IBOutlet weak var headLayout: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fillCell(_ d1:String )  {
        taskcode.text = String.stringIsNullOrNil(d1)
    
    
    }
    
    func fillCell(d1:[String : Any] )  {
        taskcode.text = String.stringIsNullOrNil(d1["taskCode"]) + " " + String.stringIsNullOrNil(d1["docName"])
        
        
    }
    
    func fillCellMel(d1:[String : Any] )  {
        taskcode.text =  String.stringIsNullOrNil(d1["status"]) + " / " + String.stringIsNullOrNil(d1["item"])
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
