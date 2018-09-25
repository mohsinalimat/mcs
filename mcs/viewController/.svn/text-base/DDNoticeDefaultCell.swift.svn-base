//
//  DDNoticeDefaultCell.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit


class DDNoticeDefaultCell: DDNoticeBaseCell {

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
        
        _show(sender)
  
    }
    

    override func fill(_ d: [String : Any]?) {
        guard let dic = d else {return}
        let nt = noticeTypeDic[String.isNullOrEmpty(dic["failureType"])]
        notice_type_btn.setTitle(String.isNullOrEmpty(nt), for: .normal)
        
        type.text = String.isNullOrEmpty(dic["type"])
        equip.text = String.isNullOrEmpty(dic["noticeEquip"])
        pos.text = String.isNullOrEmpty(dic["pos"])
        x.text = String.isNullOrEmpty(dic["failureX"])
        y.text = String.isNullOrEmpty(dic["failurey"])
        size.text = String.isNullOrEmpty(dic["failureSize"])
        detail.text = String.isNullOrEmpty(dic["failureDetail"])
        sys.text = String.isNullOrEmpty(dic["noticeSys"])
        restriction_detail.text = String.isNullOrEmpty(dic["restrictionDetail"])
    }
    
    
    override func isReadOnly() {
        notice_type_btn.isUserInteractionEnabled = false
        notice_type_btn.setBackgroundImage(UIImage(named:"buttonbg"), for: .normal)
        
        type.isEnabled = false
        type.backgroundColor = _disableBgColor
        
        equip.isEnabled = false
        equip.backgroundColor = _disableBgColor
        
        pos.isEnabled  = false
        pos.backgroundColor = _disableBgColor
        
        x.isEnabled = false
        x.backgroundColor = _disableBgColor
        
        y.isEnabled = false
        y.backgroundColor = _disableBgColor
        
        size.isEnabled = false
        size.backgroundColor = _disableBgColor
        
        detail.isEnabled = false
        detail.backgroundColor = _disableBgColor
        
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
