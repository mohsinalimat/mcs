//
//  MyOrderCell.swift
//  mcs
//
//  Created by gener on 2018/6/20.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {
    @IBOutlet weak var pn_number: UILabel!
    
    @IBOutlet weak var pn_serial: UILabel!
    
    @IBOutlet weak var code: UILabel!
    
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var descri: UILabel!
    var buttonActionHandler:((Int) -> Void)?
    
    @IBOutlet weak var stepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        stepper.addTarget(self, action: #selector(step(_ :)), for: .valueChanged)
    }

    func step(_ s:UIStepper)  {
        let n = Int.init(s.value)
        pn_number.text = "\(n)"
        
        if let handler = buttonActionHandler {
            handler(n);
        }
    }
    
    
    
    func fill(_ d:[String:Any] , num:Int?) {
        let n = num ?? 1
        pn_number.text = "\(n)"
        stepper.value = Double.init(n)
        
        descri.text = String.isNullOrEmpty(d["description"])
        pn_serial.text = "PN: " +  String.isNullOrEmpty(d["stpn"])
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
