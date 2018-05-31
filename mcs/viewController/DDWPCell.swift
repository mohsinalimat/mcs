//
//  DDWPCell.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDWPCell: UITableViewCell {

    @IBOutlet weak var ata: UILabel!
    @IBOutlet weak var stas: UILabel!
    @IBOutlet weak var ed_advice: UILabel!
    
    @IBOutlet weak var tx_wo: UILabel!
    
    @IBOutlet weak var attach: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        ata.text = String.isNullOrEmpty(d["wpAta"])
        stas.text = String.isNullOrEmpty(d["wpStatus"])
        ed_advice.text = String.isNullOrEmpty(d["wpEdAdvice"])
        tx_wo.text = String.isNullOrEmpty(d["txToWo"])

        ///file
        if let ig = d["file"] as? UIImage {
            attach.image = ig;
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
