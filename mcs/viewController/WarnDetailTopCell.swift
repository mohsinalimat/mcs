//
//  WarnDetailTopCell.swift
//  mcs
//
//  Created by gener on 2018/2/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class WarnDetailTopCell: UITableViewCell {
    @IBOutlet weak var tailNo: UILabel!

    @IBOutlet weak var flightNo: UILabel!
    
    @IBOutlet weak var warnLevel: UILabel!
    
    @IBOutlet weak var warnStatus: UIImageView!
    
    @IBOutlet weak var from: UILabel!
    
    @IBOutlet weak var to: UILabel!
    
    @IBOutlet weak var seg: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBAction func creatReportAction(_ sender: UIButton) {
        
        
        
        
    }
    
    
    func fillCell(_ d1:[String:Any] ,d2:[String:Any])  {
        
     tailNo.text = String.stringIsNullOrNil(d1["tailNo"])
     flightNo.text = String.stringIsNullOrNil(d1["flightNumber"])
     from.text = String.stringIsNullOrNil(d1["dep"])
     to.text = String.stringIsNullOrNil(d1["arr"])
     
     ////
        seg.text = String.stringIsNullOrNil(d2["phase"])
        
        if let warn_level = d2["grade"] as? String {
            warnLevel.backgroundColor = kFlightWarnLevelColor["\(warn_level)"];
        }
        
        let _time = Tools.date(String.stringIsNullOrNil(d2["faultOccurrenceDate"]))
        if let d = _time {
            time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd HH:mm")
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        warnLevel.layer.borderWidth = 1
        warnLevel.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
