//
//  TaskPoolCell.swift
//  mcs
//
//  Created by gener on 2018/3/2.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskPoolCell: UITableViewCell {

    @IBOutlet weak var taskNo: UILabel!
    @IBOutlet weak var actions: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    
    @IBOutlet weak var _line: UILabel!
    
    
    @IBOutlet weak var fltno: UILabel!
    
    @IBOutlet weak var descri: UILabel!
    
    @IBOutlet weak var reason: UILabel!
    
    @IBOutlet weak var to_sb: UILabel!
    
    @IBOutlet weak var r_igv: UIImageView!
    @IBOutlet weak var p_igv: UIImageView!
    @IBOutlet weak var cld_igv: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        taskNo.text = String.stringIsNullOrNil(d["taskNo"])
        
        if let _actions = d["actionList"] as? [[String:Any]]{
         actions.text = "(\(_actions.count) actions)";
        }else {
            actions.text = "(0 actions)";
        }
        
        
        
        from.text = String.isNullOrEmpty(d["mh"])
        to.text = String.isNullOrEmpty(d["finalAction"])
        
        _line.isHidden = !(from.text != " " && to.text != " ")
            
        fltno.text = String.isNullOrEmpty(d["fltNo"])
        
        to_sb.text = String.isNullOrEmpty(d["taskTo"])
        

        var defectDesc = String.isNullOrEmpty(d["defectDesc"])
        defectDesc = defectDesc.replacingOccurrences(of: "<br/>", with: "")
        
        var planingDesc = String.isNullOrEmpty(d["planningDes"])
        planingDesc = planingDesc.replacingOccurrences(of: "<br/>", with: "")
        
        let defectStr = "Description: " + defectDesc + "\n" + planingDesc
        let defectAttriStr =  NSMutableAttributedString.init(string: defectStr)
        defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 12))
        //defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(defectStr.lengthOfBytes(using: String.Encoding.utf8) - planingDesc.lengthOfBytes(using: String.Encoding.utf8) - 1, planingDesc.lengthOfBytes(using: String.Encoding.utf8)))
        
        descri.attributedText = defectAttriStr
        

        let reasonDesc = String.isNullOrEmpty(d["reason"])
        let rea_s = "Reason to postpone : "
        let reasonStr =  rea_s + reasonDesc
        let reasonAttriStr =  NSMutableAttributedString.init(string: reasonStr)
        reasonAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, rea_s.lengthOfBytes(using: String.Encoding.utf8)))
        
        reason.attributedText = reasonAttriStr
        
        let _r = String.isNullOrEmpty(d["repetitive"])
        r_igv.image = UIImage (named: _r == "1" ? "icon_right" : "icon_error")
        
        let _p = String.isNullOrEmpty(d["perform"])
        p_igv.image = UIImage (named: _p == "1" ? "icon_right" : "icon_error")
        
        let _cld = String.isNullOrEmpty(d["closed"])
        cld_igv.image = UIImage (named: _cld == "1" ? "icon_right" : "icon_error")
    }
    
    
    
    override func draw(_ rect: CGRect) {
        //画虚线
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setStrokeColor(kTableviewBackgroundColor.cgColor)
        
        ctx?.setLineWidth(1)
        
        ctx?.addLines(between: [CGPoint (x: 15, y: 1),CGPoint (x: self.frame.width - 30, y: 1)])
        
        ctx?.setLineDash(phase: 0, lengths: [10,5])
        
        ctx?.drawPath(using: .stroke)
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
