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
    
    
    
    func fill(_ d:[String:Any]) {
        rq_no.text = String.isNullOrEmpty(d["rqNo"])
        pn.text = String.isNullOrEmpty(d["pnNo"])
        qty.text = String.isNullOrEmpty(d["qty"])
        pn_type.text = String.isNullOrEmpty(d["pnType"])
        des.text = String.isNullOrEmpty(d["pnDes"])
        pn_data.text = String.isNullOrEmpty(d["pnAta"])
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
