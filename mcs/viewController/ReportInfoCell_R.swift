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
        
        reg.text = String.isNullOrEmpty(d["acReg"])
        station.text = "Station: " + String.isNullOrEmpty(d["station"])

        let _eta = Tools.date(String.stringIsNullOrNil(d["issueDate"]))
        var date:String = ""
        
        if let d = _eta {
            date = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }

        flt.text = String.stringIsNullOrNil(d["issueBy"]) + " / \(date)"
        fh.text = String.isNullOrEmpty(d["actMh"])
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
