//
//  AddActionInfoCell_R.swift
//  mcs
//
//  Created by gener on 2018/4/9.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class AddActionInfoCell_R: UITableViewCell {

    @IBOutlet weak var actBy: UILabel!
    
    @IBOutlet weak var reportBy: UILabel!
    
    @IBOutlet weak var shift: UILabel!
    
    @IBOutlet weak var team: UILabel!
    
    @IBOutlet weak var shift_date: UILabel!
    
    
    func fill(_ d :[String:Any])  {
        actBy.text = String.isNullOrEmpty(d["actBy"])
        reportBy.text = String.isNullOrEmpty(d["reportBy"])

        let rec_date = Tools.date(String.stringIsNullOrNil(d["shiftDate"]))
        if let d = rec_date {
            shift_date.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }else {
            shift_date.text = String.stringIsNullOrNil(d["shiftDate"]);
        }

        
        //shift.text = String.isNullOrEmpty(d["shift"])//...
        if let shift_id = d["shift"] as? String, let shifts = Tools.shift() {
            for obj in shifts {
                let _obj = obj as![String:String]
                let key = _obj["key"]
                if key == shift_id {
                    shift.text = _obj["value"]; break;
                }
            }

        }
        
        //team
        if let team_id = d["team"] as? String {
            for obj in Tools.teams()  {
                let _obj = obj as![String:Any]
                let key = _obj["key"] as! String
                if key == team_id {
                    team.text = _obj["value"] as? String; break;
                }
            }
            
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
