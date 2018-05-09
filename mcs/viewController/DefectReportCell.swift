//
//  DefectReportCell.swift
//  mcs
//
//  Created by gener on 2018/4/12.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DefectReportCell: UITableViewCell {
    
    @IBOutlet weak var report_type: UILabel!
    @IBOutlet weak var biz_no: UILabel!
    
    @IBOutlet weak var ac_reg: UILabel!
    @IBOutlet weak var performed: UILabel!
    @IBOutlet weak var cld: UILabel!
    
    @IBOutlet weak var fltNo: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var des_detail: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    var selectedInEdit:Bool = false
    var imgv : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        report_type.text = String.stringIsNullOrNilToEmpty(d["reportType"])
        biz_no.text = String.stringIsNullOrNilToEmpty(d["bizNo"])
        ac_reg.text = String.stringIsNullOrNilToEmpty(d["acReg"])
        
        if "1" == String.stringIsNullOrNilToEmpty(d["performed"]) {
            performed.text = "Y"
        }else {
            performed.text = "N"
        }

        if "1" == String.stringIsNullOrNilToEmpty(d["closed"]) {
            cld.text = "Y"
        }else {
            cld.text = "N"
        }
        
        
        fltNo.text = "FLT No." + String.stringIsNullOrNilToEmpty(d["flNo"])

        let creattime = Tools.date(String.stringIsNullOrNil(d["createDatetime"]))
        if let d = creattime {
            time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd HH:mm")
        }
        
        status.text = String.stringIsNullOrNilToEmpty(d["state"])
        
        let defectDesc = String.stringIsNullOrNilToEmpty(d["description"])
        let defectStr = "Description: " + defectDesc
        let defectAttriStr =  NSMutableAttributedString.init(string: defectStr)
        defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 12))
        des_detail.attributedText = defectAttriStr
        

    }
    
    
    
    
    
    
    func setSelectInEdit(_ b : Bool) {
        selectedInEdit = b
        let name = selectedInEdit ? "checked" : "unchecked"
        if let imgv = imgv{
            imgv.image = UIImage (named: name)
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard self.isEditing else {
            let v = self.viewWithTag(500)
            v?.removeFromSuperview()
            return
        }
        
        for _c in self.subviews{
            if _c.isMember(of: NSClassFromString("UITableViewCellEditControl")!)  {//UITableViewCellEditControl
                let v = _c
                v.frame = CGRect (x: 0, y: 0, width: 30, height: v.frame.height)
                v.backgroundColor = UIColor.red
                v.removeFromSuperview()
                
                let new_v = UIView (frame: CGRect(x: 0, y: 0, width: 60, height: v.frame.height))
                //new_v.backgroundColor = UIColor.blue
                new_v.tag = 500
                self.addSubview(new_v)
                let _imgv = UIImageView (frame: CGRect (x: (new_v.frame.width - 30)/2.0, y: (new_v.frame.height - 30)/2.0, width: 30, height: 30))
                imgv = _imgv
                
                new_v.addSubview(_imgv)
            }
            
            if _c.isMember(of: NSClassFromString("UITableViewCellContentView")!)  {
                let v = _c
                v.frame = CGRect (x: 60, y: 0, width: v.frame.width + 120, height: v.frame.height)
            }
            
        }
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
