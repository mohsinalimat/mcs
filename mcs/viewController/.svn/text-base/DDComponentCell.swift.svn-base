//
//  DDComponentCell.swift
//  mcs
//
//  Created by gener on 2018/7/13.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDComponentCell: UITableViewCell {
    @IBOutlet weak var pn: UITextField!
    @IBOutlet weak var sn: UITextField!
    @IBOutlet weak var fin: UITextField!
    @IBOutlet weak var pos: UITextField!
    @IBOutlet weak var fh: UITextField!
    @IBOutlet weak var fc: UITextField!
    @IBOutlet weak var reg: UITextField!
    @IBOutlet weak var enable: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        pn.text = String.isNullOrEmpty(d["pn"])
        sn.text = String.isNullOrEmpty(d["sn"])
        fin.text = String.isNullOrEmpty(d["fin"])
        pos.text = String.isNullOrEmpty(d["pos"])
        fh.text = String.isNullOrEmpty(d["fh"])
        fc.text = String.isNullOrEmpty(d["fc"])
        reg.text = String.isNullOrEmpty(d["acReg"])
        enable.isOn =  String.isNullOrEmpty(d["enableMonitoring"]) == "1"
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
