//
//  TaskHandCell.swift
//  mcs
//
//  Created by gener on 2018/3/2.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskHandCell: UITableViewCell {

    @IBOutlet weak var code: UILabel!
    
    @IBOutlet weak var rec_time: UILabel!
    
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var shift: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var descri: UILabel!
    
    @IBOutlet weak var remark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    
    func fill(_ d:[String:Any]) {
        
        code.text = String.stringIsNullOrNil(d["bizNo"])
        station.text = String.stringIsNullOrNil(d["station"])
        shift.text = String.stringIsNullOrNil(d["taskTo"])
        
        let defectDesc = String.stringIsNullOrNil(d["bizDesc"])
        let defectStr = "Description: " + defectDesc
        let defectAttriStr =  NSMutableAttributedString.init(string: defectStr)
        defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 12))
        descri.attributedText = defectAttriStr
 
        let remarkDesc = String.stringIsNullOrNil(d["remarks"])
        let remarkStr = "Remark: " + remarkDesc
        let remarkAttriStr =  NSMutableAttributedString.init(string: remarkStr)
        remarkAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 7))
        remark.attributedText = remarkAttriStr
        
        
        let creattime = Tools.date(String.stringIsNullOrNil(d["createTime"]))
        if let d = creattime {
            rec_time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd HH:mm")
        }
        
        let scheduletime = Tools.date(String.stringIsNullOrNil(d["scheduleTime"]))
        if let d = scheduletime {
            time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
        
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
