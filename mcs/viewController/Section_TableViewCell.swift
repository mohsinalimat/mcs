//
//  Section_TableViewCell.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Section_TableViewCell: UITableViewCell {

    @IBOutlet weak var pin: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var qty: UILabel!
    
    @IBOutlet weak var fin: UILabel!
    
    @IBOutlet weak var store_in: UILabel!
    
    @IBOutlet weak var descri: UILabel!
    
    @IBOutlet weak var remark: UILabel!
    
    
    
    func fill(_ d : [String:String]) {
        pin.text = d["pn"]
        type.text = d["partType"]
        qty.text = d["qty"]
        fin.text =  d["fin"]
        store_in.text = d["storeInAmasis"]
        descri.text = d["description"]
        remark.text = d["remark"]
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
