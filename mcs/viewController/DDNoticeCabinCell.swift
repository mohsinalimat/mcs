//
//  DDNoticeCabinCell.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDNoticeCabinCell: DDNoticeBaseCell {

    
    @IBOutlet weak var notice_type_btn: UIButton!
    
    @IBOutlet weak var equip: UITextField!
    @IBOutlet weak var pos: UITextField!
    @IBOutlet weak var detail: UITextField!

    
    
    
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        _show(sender)
    }
    
    
    
    override func fill(_ d: [String : Any]?) {
        guard let dic = d else {return}
        let nt = noticeTypeDic[String.isNullOrEmpty(dic["failureType"])]
        notice_type_btn.setTitle(String.isNullOrEmpty(nt), for: .normal)
        
        equip.text = String.isNullOrEmpty(dic["noticeEquip"])
        pos.text = String.isNullOrEmpty(dic["pos"])
        detail.text = String.isNullOrEmpty(dic["failureDetail"])

    }
    
    
    override func isReadOnly() {
        notice_type_btn.isUserInteractionEnabled = false
        notice_type_btn.setBackgroundImage(UIImage(named:"buttonbg"), for: .normal)

        equip.isEnabled = false
        equip.backgroundColor = _disableBgColor
        
        pos.isEnabled  = false
        pos.backgroundColor = _disableBgColor
        
        
        detail.isEnabled = false
        detail.backgroundColor = _disableBgColor
        
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
