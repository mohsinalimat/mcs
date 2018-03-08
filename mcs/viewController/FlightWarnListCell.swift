//
//  FlightWarnListCell.swift
//  mcs
//
//  Created by gener on 2018/3/7.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class FlightWarnListCell: UITableViewCell {

    @IBOutlet weak var warn_code: UILabel!
    
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fillWith(status:[String:Any]? = nil) {
        guard let first = status else { return }
        
        if let warn = first["code"] {
            warn_code.text = "\(warn)"
        }
        
        if let message = first["message"] {
            msg.text = "\(message)"
        }
        
        
        let _time = Tools.date(String.stringIsNullOrNil(first["faultOccurrenceDate"]))
        if let d = _time {
            time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd HH:mm")
        }
        
        
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
