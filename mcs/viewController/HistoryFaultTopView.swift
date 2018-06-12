//
//  HistoryFaultTopView.swift
//  mcs
//
//  Created by gener on 2018/6/7.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class HistoryFaultTopView: UIView {

    private var isAll:Bool = false
    
    var buttonActionHandler:((Int , [String:String]?) -> Void)?
    
    @IBOutlet weak var reg: UILabel!
  
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var ata: UITextField!
    
    @IBOutlet weak var component: UITextField!
    
    @IBOutlet weak var desc: UITextField!
    
    @IBOutlet weak var moreBtnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var selectRegBtn: UIButton!
    @IBOutlet weak var selectRegBtnWidth: NSLayoutConstraint!
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1,2:
            var d = [
                "ata":String.isNullOrEmpty(ata.text),
                "scheduleTime":String.isNullOrEmpty(selectDateBtn.currentTitle),
                "component": String.isNullOrEmpty(component.text),
                "description":String.isNullOrEmpty(desc.text)
            ]

            if isAll {
                d["acs"] = String.isNullOrEmpty(selectRegBtn.currentTitle) == "Select" ? "" : String.isNullOrEmpty(selectRegBtn.currentTitle);
            } else {
                d["acs"] = String.isNullOrEmpty(reg.text)
            }
            
            if let handler = buttonActionHandler {
                handler(sender.tag , sender.tag == 2 ? d : nil);
            }
            break
            
        case 3:
            Tools.showDatePicekr { (obj) in
                let obj = obj as! Date
                let str = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
                sender.setTitle(str, for: .normal)
            }
            
            break
        case 4://reg
            Tools.showDataPicekr (dataSource:Tools.acs()){ (obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }
            break
            
        default: break
        }
 
    }
    
    
    func showAll(_ b :Bool)  {
        isAll = b
        
        if b {
            reg.isHidden = true;
            moreBtnWidth.constant = 0
        }else{
            reg.isHidden = false;
            selectRegBtn.isHidden = true
            moreBtnWidth.constant = 50
            selectRegBtnWidth.constant = 0;
            reg.text = kFlightInfoListController_airId
        }
    }

    
    override func awakeFromNib() {
        let currentDateStr = Tools.dateToString(Date(), formatter: "dd/MM/yyyy")
        selectDateBtn.setTitle(currentDateStr, for: .normal)
    }
}

