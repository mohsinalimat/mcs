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
        
        var str:String = ""
        let _eta = Tools.date(String.stringIsNullOrNil(d?["createDatetime"]))
        if let d = _eta {
            str = Tools.dateToString(d, formatter: "yyyy-MM-dd") + " "
        }

        if let detail = d?["actionDetail"] as? String , detail != "" {
            str = str + " Detail :\(detail)";
        }else {
            str = str + "No detail"
        }
        

        let defectAttriStr =  NSMutableAttributedString.init(string: str)
        defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 10))
        
        msg.attributedText = defectAttriStr
 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
