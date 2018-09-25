//
//  PlaneCertHistoryCell.swift
//  mcs
//
//  Created by gener on 2018/6/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class PlaneCertHistoryCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var reason: UILabel!
    
    @IBOutlet weak var user: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.backgroundColor = kTableviewBackgroundColor
    }

    
    func fill(_ d:[String:Any]) {
        if let _date = Tools.date(String.isNullOrEmpty(d["updateDatetime"])) {
            let s = Tools.dateToString(_date, formatter: "yyyy-MM-dd");
            date.text = s
        }
        
        reason.text = "Reason: " + String.isNullOrEmpty(d["updateReason"])
        
        user.text = String.isNullOrEmpty(d["updateUser"])
    }
    
    
    
    override func prepareForReuse() {
        date.text = nil
        reason.text = nil
        user.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
