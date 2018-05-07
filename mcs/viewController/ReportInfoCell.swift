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

    @IBOutlet weak var fltNo: UIButton!
    
    @IBOutlet weak var fltDate: UIButton!
    
    @IBOutlet weak var station: UIButton!
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0://reg
            Tools.showDataPicekr (dataSource:Tools.acs()){ (obj) in
                let obj = obj as! String
                
                sender.setTitle(obj, for: .normal)
            }
            break
            
        case 1://flt no
            Tools.showDataPicekr(dataSource:["285","286"]) {(obj) in
                //guard let strongSelf = self else {return}
                
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }

            break
            
        case 2://date
            Tools.showDatePicekr { (obj) in
                let obj = obj as! Date
                let str = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
                sender.setTitle(str, for: .normal)
            }
            break
            
        case 3://station
            Tools.showDataPicekr (dataSource:Tools.station()){ (obj) in
                let obj = obj as! String
                
                sender.setTitle(obj, for: .normal)
            }
            break
        case 4://查看历史故障
            
            break
        default:break
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
