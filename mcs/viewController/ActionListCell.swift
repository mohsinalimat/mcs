//
//  ActionListCell.swift
//  mcs
//
//  Created by gener on 2018/4/9.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ActionListCell: UITableViewCell {

    @IBOutlet weak var actionid: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var descir: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d :[String:Any]) {
        actionid.text = String.stringIsNullOrNil(d["id"])
        
        let _eta = Tools.date(String.stringIsNullOrNil(d["actionDate"]))
        if let d = _eta {
            time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }

        let defectDesc = String.stringIsNullOrNil(d["actionDetail"])
        let defectStr = "Description: " + defectDesc
        let defectAttriStr =  NSMutableAttributedString.init(string: defectStr)
        defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 12))
        descir.attributedText = defectAttriStr
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
