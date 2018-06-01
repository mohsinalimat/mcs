//
//  DDNoticeDefaultCell.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit


class DDNoticeDefaultCell: UITableViewCell {

    var selectedTypeAction:((String) -> Void)?
    
    @IBOutlet weak var notice_type_btn: UIButton!
    
    @IBOutlet weak var type: UITextField!
    
    @IBOutlet weak var equip: UITextField!
    
    @IBOutlet weak var pos: UITextField!
    
    @IBOutlet weak var x: UITextField!
    
    @IBOutlet weak var y: UITextField!
    
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var detail: UITextField!
    @IBOutlet weak var sys: UITextField!
    @IBOutlet weak var restriction_detail: UITextField!
    
    
    
    
    
    
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
