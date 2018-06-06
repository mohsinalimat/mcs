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

    
    func fillCell(_ d1:[String:Any] )  {
        code.text = String.stringIsNullOrNil(d1["code"])
        msg.text = String.stringIsNullOrNil(d1["message"])
        type.text = String.stringIsNullOrNil(d1["alarmType"]) == "10" ? "FDE" : "MMSG"
        phase.text = String.stringIsNullOrNil(d1["phase"])
    
        let _time = Tools.date(String.stringIsNullOrNil(d1["faultOccurrenceDate"]))
        if let d = _time {
            time.text = Tools.dateToString(d, formatter: "MM-dd HH:mm")
        }
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
