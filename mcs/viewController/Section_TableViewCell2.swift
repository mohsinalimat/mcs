//
//  Section_TableViewCell2.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Section_TableViewCell2: UITableViewCell {

    @IBOutlet weak var pn_off: UILabel!
    
    @IBOutlet weak var sn_off: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var fin: UILabel!
    
    @IBOutlet weak var pn_on: UILabel!
    
    @IBOutlet weak var sn_on: UILabel!
    
    @IBOutlet weak var pos: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    
    func fill(_ d : [String:String]) {
        pn_off.text = d["pnOff"]
        sn_off.text = d["snOff"]
        pn_on.text = d["pnOn"]
        sn_on.text =  d["snOn"]
        fin.text = d["fin"]
        type.text = d["partType"]
        pos.text = d["pos"]
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
