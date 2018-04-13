//
//  AddActionInfoCell.swift
//  mcs
//
//  Created by gener on 2018/4/4.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class AddActionInfoCell: UITableViewCell {

    @IBOutlet weak var actBy: UITextField!
    
    @IBOutlet weak var reportBy: UITextField!
    
    @IBOutlet weak var shift: UIButton!
    
    @IBOutlet weak var team: UIButton!
    
    @IBOutlet weak var shiftDate: UIButton!
    
    var shift_id:String!
    var team_id:String!
    

    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            
            Tools.showDataPicekr(dataSource:Tools.shift()) { [weak self](obj) in
                guard let strongSelf = self else {return}
                
                let obj = obj as! [String:String]
                //kTaskpool_shift = obj
                strongSelf.shift.setTitle(obj["value"], for: .normal)
                strongSelf.shift_id = obj["key"]!
            }
            
            break
            
        case 2:
            Tools.showDatePicekr {[weak self] (obj) in
                let obj = obj as! Date
                //kTaskpool_date = obj
                
                let str = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
                guard let strongSelf = self else {return}
                strongSelf.shiftDate.setTitle(str, for: .normal)
            }
            
            break
        case 3:
            
            Tools.showDataPicekr (dataSource:Tools.teams()){ [weak self](obj) in
                guard let strongSelf = self else {return}
                
                let obj = obj as! [String:Any]
                
                strongSelf.team.setTitle(obj["value"] as! String?, for: .normal)
                strongSelf.team_id = obj["key"] as! String
            }
            
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
