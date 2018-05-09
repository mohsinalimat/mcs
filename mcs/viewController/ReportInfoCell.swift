//
//  ReportInfoCell.swift
//  mcs
//
//  Created by gener on 2018/4/25.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ReportInfoCell: UITableViewCell {

    @IBOutlet weak var reg: UIButton!
    @IBOutlet weak var issueBy: UIButton!
    @IBOutlet weak var issueDate: UIButton!
    @IBOutlet weak var station: UIButton!
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0://reg
            Tools.showDataPicekr (dataSource:Tools.acs()){ (obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
                report_reg = obj
            }
            break
        case 1://station
            Tools.showDataPicekr (dataSource:Tools.station()){ (obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
                report_station = obj
            }
            break
    
        case 2:
            Tools.showDataPicekr(dataSource:g_staffs) {(obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }

            break
            
        case 3://date
            Tools.showDatePicekr { (obj) in
                let obj = obj as! Date
                let str = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
                sender.setTitle(str, for: .normal)
                report_date = obj
            }
            break
        default:break
        }
        
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let today = Tools.dateToString(Date(), formatter: "dd/MM/yyyy");
        issueDate.setTitle(today, for: .normal)
        report_date = Date()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
