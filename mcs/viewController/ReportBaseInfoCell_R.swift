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
    @IBOutlet weak var ts2: UILabel!
    
    @IBOutlet weak var release_ref: UILabel!
    @IBOutlet weak var release_ref2: UILabel!
    
    @IBOutlet weak var flt_date: UILabel!
    @IBOutlet weak var flt_date2: UILabel!
    
    @IBOutlet weak var shift_date: UILabel!
    @IBOutlet weak var shift_date2: UILabel!
    
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

    func _ts_type(_ type:String) -> String  {
        var s = ""
        switch type {
            case "0":s =  defect_transferred_key[1];break
            case "1":s =  defect_transferred_key[2];break
            case "2":s =  defect_transferred_key[3];break
            default:break
        }
        
        return s
    }
    
    
    func fill(_ dic :[String:Any]?) {
        guard let d = dic else {return}
        
        let type = String.isNullOrEmpty(d["tsType"])
        ts.text = _ts_type(type)
        ts2.text = String.isNullOrEmpty(d["tsFrom"])
            
        release_ref.text = String.isNullOrEmpty(d["releaseType"])
        release_ref2.text = String.isNullOrEmpty(d["releaseItem"])
        
        let _eta = Tools.date(String.stringIsNullOrNil(d["flDate"]))
        var fltdate:String = ""
        if let d = _eta {
            fltdate = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        flt_date.text =  String.stringIsNullOrNil(d["flNo"])
        flt_date2.text = fltdate
        
        ////
        let _shifteta = Tools.date(String.stringIsNullOrNil(d["flDate"]))
        var shiftdate:String = ""
        if let d = _shifteta {
            shiftdate = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
        if let shift_id = d["issueShift"] as? String, let shifts = Tools.shift() {
            for obj in shifts {
                let _obj = obj as![String:String]
                let key = _obj["key"]
                if key == shift_id {
                    shift_date.text = _obj["value"]; break;
                }
            }            
        }
        
        shift_date.text = shift_date.text ?? ""
        shift_date2.text = shiftdate
        
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
        
        let defect_detailAttriStr = NSAttributedString.init(string: String.isNullOrEmpty(d["detail"]), attributes: attributes_dic)
        defect_detail.attributedText = defect_detailAttriStr

        let descriAttriStr = NSAttributedString.init(string: String.isNullOrEmpty(d["description"]), attributes: attributes_dic)
        descri.attributedText = descriAttriStr
        
        let tempAttriStr = NSAttributedString.init(string: String.isNullOrEmpty(d["temporaryDesc"]), attributes: attributes_dic)
        temp_action.attributedText = tempAttriStr

        tsm.text = String.isNullOrEmpty(d["ata"])
        mel.text = String.isNullOrEmpty(d["melCode"])
        amm.text = String.isNullOrEmpty(d["ammCode"])
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
