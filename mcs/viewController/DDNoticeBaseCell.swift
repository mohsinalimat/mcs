//
//  DDNoticeBaseCell.swift
//  mcs
//
//  Created by gener on 2018/6/1.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDNoticeBaseCell: UITableViewCell {

    let noticeTypeDic = ["0":"STRUCTURE","1":"RESTRICTION","2":"CABIN"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func _show(_ sender:UIButton) {
        Tools.showDataPicekr(dataSource:[" ","STRUCTURE","RESTRICTION","CABIN"]) {(obj) in
            let obj = obj as! String
            guard sender.currentTitle != obj else {return}
            //sender.setTitle(obj, for: .normal)
            
            NotificationCenter.default.post(name: NSNotification.Name.init("ddNoticeTypeChangedNotification"), object: nil, userInfo: ["type":obj])
        }

    }
    
    
    
    
    func isReadOnly()  {
        
    }
    
    
    func fill(_ d:[String:Any]? = nil)  {
        
    }
}
