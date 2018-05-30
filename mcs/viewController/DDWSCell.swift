//
//  DDWSCell.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDWSCell: UITableViewCell {

    @IBOutlet weak var rq_no: UILabel!
    @IBOutlet weak var pn: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var pn_type: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var pn_data: UILabel!
    
    
    
    func fill(_ d:[String:String]) {
        rq_no.text = d["rqNo"]
        pn.text = d["pnNo"]
        qty.text = d["qty"]
        pn_type.text = d["pnType"]
        des.text = d["pnDes"]
        pn_data.text = d["pnAta"]
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
