//
//  DDInfoCell_R.swift
//  mcs
//
//  Created by gener on 2018/5/17.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDInfoCell_R: UITableViewCell {

    @IBOutlet weak var cell_bg: UIView!
    @IBOutlet weak var day_tf: UITextField!
    @IBOutlet weak var fh_tf: UITextField!
    @IBOutlet weak var fc_tf: UITextField!
    @IBOutlet weak var other_tf: UITextField!
    @IBOutlet weak var deadline_tf: UITextField!
    @IBOutlet weak var recBy_tf: UITextField!
    @IBOutlet weak var recDate_tf: UITextField!
    @IBOutlet weak var wo_tf: UITextField!
    @IBOutlet weak var source_tf: UITextField!
    
    @IBOutlet weak var repBgView: UIView!
    @IBOutlet weak var rep_day: UITextField!
    @IBOutlet weak var rep_fh: UITextField!
    @IBOutlet weak var rep_fc: UITextField!
    @IBOutlet weak var rep_month: UITextField!
    
    
    func fill(_ dic :[String:Any]?) {
        guard let d = dic else {return}
        
        let cat = String.isNullOrEmpty(d["cat"])
        if cat != "" {
            let i = Int.init(cat)
            __selectedBtnWithTag(cat, tag: i!);
        }
        
        let day = String.isNullOrEmpty(d["deferDay"])
        day_tf.text = day
        __selectedBtnWithTag(day, tag: 20)
        
        let fh = String.isNullOrEmpty(d["deferFh"])
        fh_tf.text = fh
        __selectedBtnWithTag(fh, tag: 21)
        
        let fc = String.isNullOrEmpty(d["deferFc"])
        fc_tf.text = fc
        __selectedBtnWithTag(fc, tag: 22)
        
        let other = String.isNullOrEmpty(d["deferOther"])
        other_tf.text = other
        __selectedBtnWithTag(other, tag: 23)

        let _eta = Tools.date(String.stringIsNullOrNil(d["dateLine"]))
        if let d = _eta {
            deadline_tf.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
        let enterInDamageChart = String.isNullOrEmpty(d["enterInDamageChart"])
        __selectedBtnWithTag(enterInDamageChart, tag: enterInDamageChart == "1" ? 26:25)
        
        let repetitiveAction = String.isNullOrEmpty(d["repetitiveAction"])
        __selectedBtnWithTag(repetitiveAction, tag: repetitiveAction == "1" ? 31:30)
        if repetitiveAction == "1" {
            repBgView.isHidden = false;
            rep_day.text = String.isNullOrEmpty(d["repDay"])
            rep_fh.text = String.isNullOrEmpty(d["repFh"])
            rep_fc.text = String.isNullOrEmpty(d["repFc"])
            rep_month.text = String.isNullOrEmpty(d["repMonth"])
        }
        
        let precedureO = String.isNullOrEmpty(d["precedureO"])
        __selectedBtnWithTag(precedureO, tag: 32)
        
        let precedureM = String.isNullOrEmpty(d["precedureM"])
        __selectedBtnWithTag(precedureM, tag: 33)
        
        let enterInDdList = String.isNullOrEmpty(d["enterInDdList"])
        __selectedBtnWithTag(enterInDdList, tag: enterInDdList == "1" ? 35:34)
        
        let repetitiveDefect = String.isNullOrEmpty(d["repetitiveDefect"])
        __selectedBtnWithTag(repetitiveDefect, tag: repetitiveDefect == "1" ? 37:36)
        
        let receiveBy = String.isNullOrEmpty(d["receiveBy"])
        recBy_tf.text = receiveBy
        let rec_date = Tools.date(String.stringIsNullOrNil(d["receiveDate"]))
        if let d = rec_date {
            recDate_tf.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
        let dd_status = String.isNullOrEmpty(d["statusOfDd"])
        let arr = dd_status.components(separatedBy: ",")
        for s in arr {
            if let i = Int.init(s){
                __selectedBtnWithTag(dd_status, tag: i + 40);
            }
        }

        
        wo_tf.text = String.isNullOrEmpty(d["umWo"])
        source_tf.text = String.isNullOrEmpty(d["ddSource"])
        
        //...
        let notice = String.isNullOrEmpty(d["isShowFailure"])
        __selectedBtnWithTag(notice, tag: 47)
        
        
    }
    
    
    
    
    
    
    
    
    func __selectedBtnWithTag(_ s:String , tag:Int)  {
        guard s != "" else {return}
        if let btn = cell_bg.viewWithTag(tag) as? UIButton {
            btn.isSelected = true;
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
