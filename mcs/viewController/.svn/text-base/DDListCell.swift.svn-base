//
//  DDListCell.swift
//  mcs
//
//  Created by gener on 2018/4/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDListCell: UITableViewCell {

    @IBOutlet weak var dd_no: UILabel!
    @IBOutlet weak var descri: UILabel!
    @IBOutlet weak var final_action: UILabel!
    @IBOutlet weak var fault_code: UILabel!    
    @IBOutlet weak var m: UILabel!
    @IBOutlet weak var o: UILabel!
    @IBOutlet weak var cat: UILabel!
    @IBOutlet weak var r: UILabel!
    @IBOutlet weak var close_date: UILabel!
    @IBOutlet weak var dead_line: UILabel!
    @IBOutlet weak var stas: UILabel!
    
    @IBOutlet weak var issue_date: UILabel!
    @IBOutlet weak var mark: UILabel!
    
    let dd_list_status = [
        "1":"determineReceive",
        "2":"perfectReport",
        "3":"createTask",
        "4":"executing",
        "7":"monitoring",
        "8":"closed"
    ]
    
    let dd_cat = [
    "0":"A",
    "1":"B",
    "2":"C",
    "3":"D",
    "4":"E",
    "5":"F",
    "6":"G",
    "7":"H",
    "8":"I"]
    
    func fill(_ d:[String:Any]) {
        dd_no.text = String.isNullOrEmpty(d["bizNo"]) + (String.isNullOrEmpty(d["acReg"]).lengthOfBytes(using: String.Encoding.utf8) > 0 ? "(\(String.isNullOrEmpty(d["acReg"])))" : "")
        descri.text = String.isNullOrEmpty(d["detail"]) + (String.isNullOrEmpty(d["temporaryDesc"]).lengthOfBytes(using: String.Encoding.utf8) > 0 ? "(\(String.isNullOrEmpty(d["temporaryDesc"])))" : "")
        final_action.text = String.isNullOrEmpty(d["finalAction"])
        
        let tsm = String.isNullOrEmpty(d["ata"])
        let amm = String.isNullOrEmpty(d["ammCode"])
        let mel = String.isNullOrEmpty(d["melCode"])
        var code = tsm
        code = code.lengthOfBytes(using: String.Encoding.utf8) > 0 ? (code + "\n" + amm) : amm
        code = code.lengthOfBytes(using: String.Encoding.utf8) > 0 ? (code + "\n" + mel) : mel
        fault_code.text = code
        
        
        let issuetime = Tools.date(String.stringIsNullOrNil(d["issueDate"]))
        if let d = issuetime {
            issue_date.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
        let closetime = Tools.date(String.stringIsNullOrNil(d["closeDate"]))
        if let d = closetime {
            close_date.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
        
        let deadlinetime = Tools.date(String.stringIsNullOrNil(d["dateLine"]))
        if let d = deadlinetime {
            dead_line.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }
        
        mark.text = "Remark: " + String.isNullOrEmpty(d["remark"])
        stas.text = dd_list_status[String.isNullOrEmpty(d["state"])] ?? "init"
        m.text = String.isNullOrEmpty(d["precedureM"]) == "1" ? "Y" : "N"
        o.text = String.isNullOrEmpty(d["precedureO"]) == "1" ? "Y" : "N"
        r.text = String.isNullOrEmpty(d["repetitiveAction"]) == "1" ? "Y" : "N"
        cat.text = dd_cat[String.isNullOrEmpty(d["cat"])]
    }
    
    
    
    override func prepareForReuse() {
        _init()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _init();
        
    }

    func _init() {
        dd_no.text = nil
        descri.text = nil
        final_action.text = nil
        fault_code.text = nil
        m.text = nil
        o.text = nil
        cat.text = nil
        r.text = nil
        close_date.text = nil
        dead_line.text = nil
        issue_date.text = nil
        mark.text = nil
        stas.text = nil
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
