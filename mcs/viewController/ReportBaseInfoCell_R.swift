//
//  ReportBaseInfoCell_R.swift
//  mcs
//
//  Created by gener on 2018/5/14.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ReportBaseInfoCell_R: UITableViewCell {

    
    @IBOutlet weak var ts: UILabel!
    
    @IBOutlet weak var release_ref: UILabel!
    
    @IBOutlet weak var flt_date: UILabel!
    
    @IBOutlet weak var shift_date: UILabel!
    
    @IBOutlet weak var defect_detail: UITextView!
    
    @IBOutlet weak var tsm: UILabel!
    @IBOutlet weak var mel: UILabel!
    @IBOutlet weak var amm: UILabel!
    
    @IBOutlet weak var descri: UITextView!
    
    @IBOutlet weak var temp_action: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ dic :[String:Any]?) {
        guard let d = dic else {return}
        
        ts.text = String.stringIsNullOrNilToEmpty(d["tsType"]) + String.stringIsNullOrNilToEmpty(d["tsFrom"])
        release_ref.text = String.stringIsNullOrNilToEmpty(d["releaseType"]) + String.stringIsNullOrNilToEmpty(d["releaseItem"])
        
        let _eta = Tools.date(String.stringIsNullOrNil(d["flDate"]))
        var fltdate:String = ""
        
        if let d = _eta {
            fltdate = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        flt_date.text =  String.stringIsNullOrNil(d["flNo"]) + " \(fltdate)"
        
        ////
        let _shifteta = Tools.date(String.stringIsNullOrNil(d["flDate"]))
        var shiftdate:String = ""
        
        if let d = _shifteta {
            shiftdate = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
        if let shift_id = d["shift"] as? String, let shifts = Tools.shift() {
            for obj in shifts {
                let _obj = obj as![String:String]
                let key = _obj["key"]
                if key == shift_id {
                    shift_date.text = _obj["value"]; break;
                }
            }            
        }
        
        shift_date.text = shift_date.text ?? "" + " \(shiftdate)"
        
        ///
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        //paragraphStyle.firstLineHeadIndent = 0
        let attributes_dic:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 16) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            NSForegroundColorAttributeName:UIColor.darkGray,
            NSKernAttributeName:1 ]
        
        let defect_detailAttriStr = NSAttributedString.init(string: String.stringIsNullOrNilToEmpty(d["detail"]), attributes: attributes_dic)
        defect_detail.attributedText = defect_detailAttriStr

        let descriAttriStr = NSAttributedString.init(string: String.stringIsNullOrNilToEmpty(d["description"]), attributes: attributes_dic)
        descri.attributedText = descriAttriStr
        
        let tempAttriStr = NSAttributedString.init(string: String.stringIsNullOrNilToEmpty(d["temporaryDesc"]), attributes: attributes_dic)
        temp_action.attributedText = tempAttriStr

        tsm.text = String.stringIsNullOrNilToEmpty(d["ata"])
        mel.text = String.stringIsNullOrNilToEmpty(d["melCode"])
        amm.text = String.stringIsNullOrNilToEmpty(d["ammCode"])
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
