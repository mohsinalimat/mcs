//
//  DDNoticeCabinCell.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDNoticeCabinCell: UITableViewCell {

    
    @IBOutlet weak var notice_type_btn: UIButton!
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        Tools.showDataPicekr(dataSource:[" ","STRUCTURE","RESTRICTION","CABIN"]) {(obj) in
            let obj = obj as! String
            guard sender.currentTitle != obj else {return}
            //sender.setTitle(obj, for: .normal)
            
            NotificationCenter.default.post(name: NSNotification.Name.init("ddNoticeTypeChangedNotification"), object: nil, userInfo: ["type":obj])
        }
        
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
