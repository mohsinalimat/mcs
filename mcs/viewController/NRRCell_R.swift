//
//  NRRCell_R.swift
//  mcs
//
//  Created by gener on 2018/5/17.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class NRRCell_R: UITableViewCell {

    @IBOutlet weak var formNo_tf: UITextField!
    @IBOutlet weak var skil_tf: UITextField!
    @IBOutlet weak var insp_tf: UITextField!
    @IBOutlet weak var status_tf: UITextField!
    
    let defect_nrr_insp : [String] = {
        if let arr = plist_dic["nrr_insp_value"] as? [String] {
            return arr
        }
        
        return [];
    }()
    
    let defect_nrr_skill  : [String] = {
        if let arr = plist_dic["nrr_skill_value"] as? [String] {
            return arr
        }
        
        return [];
    }()
    
    
    func fill(_ dic :[String:Any]?) {
        guard let d = dic else {return}
        
        formNo_tf.text = String.isNullOrEmpty(d["formNo"])

        let skil = String.isNullOrEmpty(d["skill"])
        if let skil_i = Int.init(skil) {
            skil_tf.text = defect_nrr_skill[skil_i];
        }
        
        let insp = String.isNullOrEmpty(d["inspType"])
        if let skil_i = Int.init(insp) {
            insp_tf.text = defect_nrr_skill[skil_i];
        }
        
        status_tf.text = String.isNullOrEmpty(d["nrrStatus"]) == "1" ? "Closed" : "Open"
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
