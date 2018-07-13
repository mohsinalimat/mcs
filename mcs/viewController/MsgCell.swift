//
//  MsgCell.swift
//  mcs
//
//  Created by gener on 2018/7/9.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MsgCell: UITableViewCell {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var shift: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var descri: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        let defectStr = "Description: " + String.isNullOrEmpty(d["description"])
        let defectAttriStr =  NSMutableAttributedString.init(string: defectStr)
        defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 12))
        descri.attributedText = defectAttriStr
        
        let t = String.isNullOrEmpty(d["type"])
        switch t {
            case "0":type.text = "mcc发布班次广播";break
            case "1":type.text = "代办人员变动广播";break
            case "2":type.text = "航班到达广播";break
            default:break
        }
       
        
        shift.text = "Shift: " + String.isNullOrEmpty(d["shiftName"])
        
        let issuetime = Tools.date(String.stringIsNullOrNil(d["date"]))
        if let d = issuetime {
            date.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
    }
    
    
    override func prepareForReuse() {
        type.text = nil
        shift.text = nil
        date.text = nil
        descri.text = nil
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
