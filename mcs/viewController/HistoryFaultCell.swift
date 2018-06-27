//
//  HistoryFaultCell.swift
//  mcs
//
//  Created by gener on 2018/6/7.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class HistoryFaultCell: UITableViewCell {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var shift: UILabel!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var ata: UILabel!
    @IBOutlet weak var defect_descr: UILabel!
    @IBOutlet weak var actions: UILabel!
    
    @IBOutlet weak var reg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func fill(_ d:[String:Any] , isAll:Bool = false) {
        
        type.text = String.isNullOrEmpty(d["bizType"])
        shift.text = "shift: \(String.isNullOrEmpty(d["shiftName"]))"
        station.text = "station: \(String.isNullOrEmpty(d["station"]))"
        
        let issuetime = Tools.date(String.stringIsNullOrNil(d["scheduleTime"]))
        if let d = issuetime {
            time.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }

        ata.text = "ATA: \(String.isNullOrEmpty(d["ata"]))"
        defect_descr.text = String.isNullOrEmpty(d["defect"])
        actions.text = String.isNullOrEmpty(d["action"])
        
        if isAll {
            reg.isHidden = false;
            reg.text = String.isNullOrEmpty(d["acReg"])
        }else {
            reg.isHidden = true;
        }
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
