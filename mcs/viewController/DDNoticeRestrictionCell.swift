//
//  DDNoticeRestrictionCell.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDNoticeRestrictionCell: DDNoticeBaseCell {

    
    @IBOutlet weak var notice_type_btn: UIButton!
    


    @IBOutlet weak var sys: UITextField!
    @IBOutlet weak var restriction_detail: UITextField!
    
    
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        _show(sender)
    }
    
    override func fill(_ d: [String : Any]?) {
        guard let dic = d else {return}
        let nt = noticeTypeDic[String.isNullOrEmpty(dic["failureType"])]
        notice_type_btn.setTitle(String.isNullOrEmpty(nt), for: .normal)
        
        sys.text = String.isNullOrEmpty(dic["noticeSys"])
        restriction_detail.text = String.isNullOrEmpty(dic["restrictionDetail"])
    }
    
    
    override func isReadOnly() {
        notice_type_btn.isUserInteractionEnabled = false
        notice_type_btn.setBackgroundImage(UIImage(named:"buttonbg"), for: .normal)
        
        sys.isEnabled = false
        sys.backgroundColor = _disableBgColor
        
        restriction_detail.isEnabled = false
        restriction_detail.backgroundColor = _disableBgColor
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
