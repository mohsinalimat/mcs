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
        
        
        
        from.text = _stringIsNullOrNil(d["mh"])
        to.text = _stringIsNullOrNil(d["finalAction"])
        
        _line.isHidden = !(from.text != " " && to.text != " ")
            
        fltno.text = _stringIsNullOrNil(d["fltNo"])
        
        to_sb.text = _stringIsNullOrNil(d["taskTo"])
        

        let defectDesc = String.stringIsNullOrNil(d["defectDesc"])
        let defectStr = "Description: " + defectDesc
        let defectAttriStr =  NSMutableAttributedString.init(string: defectStr)
        defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 12))
        descri.attributedText = defectAttriStr
        

        let reasonDesc = String.stringIsNullOrNil(d["reason"])
        let reasonStr = "Reason: " + reasonDesc
        let reasonAttriStr =  NSMutableAttributedString.init(string: reasonStr)
        reasonAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, 7))
        reason.attributedText = reasonAttriStr
        
        let _r = _stringIsNullOrNil(d["repetitive"])
        r_igv.image = UIImage (named: _r == "1" ? "icon_right" : "icon_error")
        
        let _p = _stringIsNullOrNil(d["perform"])
        p_igv.image = UIImage (named: _p == "1" ? "icon_right" : "icon_error")
        
        let _cld = _stringIsNullOrNil(d["closed"])
        cld_igv.image = UIImage (named: _cld == "1" ? "icon_right" : "icon_error")
    }
    
    
    
    
    
     func _stringIsNullOrNil(_ any:Any?) -> String {
        guard  let s = any else { return " "}
        
        if s is  NSNull {
            return " ";
        }
        
        return "\(s)"
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
