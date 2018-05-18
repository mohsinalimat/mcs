//
//  DDInfoCell.swift
//  mcs
//
//  Created by gener on 2018/4/27.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDInfoCell: UITableViewCell {
    var ddCat_selected:Int?
    
    @IBOutlet weak var day_tf: UITextField!
    @IBOutlet weak var fh_tf: UITextField!
    @IBOutlet weak var fc_tf: UITextField!
    @IBOutlet weak var other_tf: UITextField!
    @IBOutlet weak var deadline_btn: UIButton!
    
    var in_chart:Int = 0
    var need_repetitive:Int = 0
    
    var produce_o:Int?
    var produce_m:Int?
    var enterInDdList:Int?
    var repetitive_defect:Int?
    @IBOutlet weak var rec_by: UIButton!
    @IBOutlet weak var rec_date: UIButton!
    
    var dd_status = [String]()
    
    @IBOutlet weak var um_tf: UITextField!
    @IBOutlet weak var dd_source: UIButton!
    
    
    ///PRIVATE
    var ddCat_selected_btn:UIButton?

    
    @IBOutlet weak var in_chart_btn: UIButton!
    @IBOutlet weak var in_chart_btn_y: UIButton!
    
    @IBOutlet weak var need_actoin_n: UIButton!
    @IBOutlet weak var need_action_y: UIButton!
    
    @IBOutlet weak var dd_record_pink: UIButton!
    @IBOutlet weak var dd_record_white: UIButton!
    
    @IBOutlet weak var defect_n: UIButton!
    @IBOutlet weak var defect_y: UIButton!
    

    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0,1,2,3,4,5,6,7,8:
            if let selected = ddCat_selected_btn {
                guard selected.tag != sender.tag else {return}
                selected.isSelected = false
            }
            
            sender.isSelected = true;
            ddCat_selected_btn = sender
            ddCat_selected = sender.tag;
            break
        
        case 20:
            sender.isSelected = !sender.isSelected
            _enable_textfield(day_tf, b: sender.isSelected)
            break
        case 21:
            sender.isSelected = !sender.isSelected
            _enable_textfield(fh_tf, b: sender.isSelected)
            break
        case 22:
            sender.isSelected = !sender.isSelected
            _enable_textfield(fc_tf, b: sender.isSelected)
            break
        case 23:
            sender.isSelected = !sender.isSelected
            _enable_textfield(other_tf, b: sender.isSelected)
            break
        case 24,39:
            Tools.showDatePicekr { (obj) in
                let obj = obj as! Date
                let str = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
                sender.setTitle(str, for: .normal)
                report_date = obj
            }
            break
            
        case 25:
            sender.isSelected = true
            in_chart_btn_y.isSelected = false
            in_chart = 0
            break
        case 26:
            sender.isSelected = true
            in_chart_btn.isSelected = false
            in_chart = 1
            break
            
        case 30:
            sender.isSelected = true
            need_action_y.isSelected = false
            need_repetitive = 0
            break
        case 31:
            sender.isSelected = true
            need_actoin_n.isSelected = false
            need_repetitive = 1
            break
            
        case 32:
            sender.isSelected = !sender.isSelected
            produce_o = sender.isSelected ? 1 : 0
            break
        case 33:
            sender.isSelected = !sender.isSelected
            produce_m = sender.isSelected ? 1 : 0
            break
            
        case 34:
            sender.isSelected = true
            dd_record_white.isSelected = false
            enterInDdList = 0
            break
        case 35:
            sender.isSelected = true
            dd_record_pink.isSelected = false
            enterInDdList = 1
            break
            
        case 36:
            sender.isSelected = true
            defect_y.isSelected = false
            repetitive_defect = 0
            break
        case 37:
            sender.isSelected = true
            defect_n.isSelected = false
            repetitive_defect = 1
            break
            
        case 38:
            Tools.showDataPicekr(dataSource:g_staffs) {(obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }
            break
            
        case 40,41,42,43,44,45:
            sender.isSelected = !sender.isSelected;
            
            let t = sender.tag - 40;
            if dd_status.contains("\(t)"){
            dd_status.remove(at: dd_status.index(of: "\(t)")!)
            }else {
                dd_status.append("\(t)");
            }
            
            if sender.tag == 43 {
                _enable_textfield(um_tf, b: sender.isSelected);
            }
            
            break
            
        case 46:
            Tools.showDataPicekr(dataSource:["MCS","AHM","D2"]) {(obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }
            break
            
        default:break
        }
        
        
    }
    
  
    
    
    
    
    
    
    
    
    
    func _enable_textfield(_ textfield:UITextField , b:Bool) {
        textfield.isEnabled = b
        textfield.backgroundColor = b ? UIColor.white : UIColor.lightGray
        if !b {
            textfield.text = nil;
        }
    }
    

    func _init()  {
        in_chart_btn.isSelected = true
        need_actoin_n.isSelected = true
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _init()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
