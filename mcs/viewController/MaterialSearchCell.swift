//
//  MaterialSearchCell.swift
//  mcs
//
//  Created by gener on 2018/5/3.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MaterialSearchCell: UITableViewCell {

    @IBOutlet weak var pn_number: UILabel!
    
    @IBOutlet weak var pn_serial: UILabel!
    
    @IBOutlet weak var code: UILabel!
    
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var descri: UILabel!
    var buttonActionHandler:((Int) -> Void)?
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let hander = buttonActionHandler {
            hander(sender.tag);
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        pn_number.text = String.isNullOrEmpty(d["stqtstk"])
        descri.text = String.isNullOrEmpty(d["description"])
        pn_serial.text = "PN: " +  String.isNullOrEmpty(d["stpn"])
        code.text = String.isNullOrEmpty(d["companyCode"])
        station.text = String.isNullOrEmpty(d["stcodmag"])
        location.text = String.isNullOrEmpty(d["location"])
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
