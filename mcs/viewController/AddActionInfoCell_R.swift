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
        actBy.text = String.stringIsNullOrNilToEmpty(d["actBy"])
        reportBy.text = String.stringIsNullOrNilToEmpty(d["reportBy"])
        shift.text = String.stringIsNullOrNilToEmpty(d["shift"])
        team.text = String.stringIsNullOrNilToEmpty(d["team"])
        shift_date.text = String.stringIsNullOrNilToEmpty(d["shiftDate"])
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
