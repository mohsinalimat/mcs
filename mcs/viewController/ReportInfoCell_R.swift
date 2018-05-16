//
//  ReportInfoCell_R.swift
//  mcs
//
//  Created by gener on 2018/5/14.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ReportInfoCell_R: UITableViewCell {

    @IBOutlet weak var reg: UILabel!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var flt: UILabel!
    @IBOutlet weak var fh: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    
    func fill(_ dic :[String:Any]?) {
        guard let d = dic else {return}
        
        reg.text = String.stringIsNullOrNilToEmpty(d["acReg"])
        station.text = "Station:" + String.stringIsNullOrNilToEmpty(d["station"])

        let _eta = Tools.date(String.stringIsNullOrNil(d["flDate"]))
        var date:String = ""
        
        if let d = _eta {
            date = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }

        flt.text = "Flt No:" + String.stringIsNullOrNil(d["flNo"]) + " \(date)"
        
        
        fh.text = String.stringIsNullOrNilToEmpty(d["actMh"])
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
