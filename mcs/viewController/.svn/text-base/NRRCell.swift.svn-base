//
//  NRRCell.swift
//  mcs
//
//  Created by gener on 2018/5/10.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class NRRCell: UITableViewCell {

    @IBOutlet weak var formNo: UITextField!
    
    @IBOutlet weak var skilBtn: UIButton!
    
    @IBOutlet weak var typeBtn: UIButton!
    
    @IBOutlet weak var statusBtn: UIButton!
    
    let defect_nrr_insp : [[String:String]] = {
        if let arr = plist_dic["nrr_insp"] as? [[String:String]] {
            return arr
        }
        
        return [];
    }()
    
    let defect_nrr_skill  : [[String:String]] = {
        if let arr = plist_dic["nrr_skill"] as? [[String:String]] {
            return arr
        }
        
        return [];
    }()
    
    
    let defect_nrr_status  : [[String:String]] = {
        if let arr = plist_dic["nrr_status"] as? [[String:String]] {
            return arr
        }
        
        return [];
    }()
    

    var skil:String?
    var insp:String?
    var status:String?
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 1://station
            Tools.showDataPicekr (dataSource:defect_nrr_skill){ [weak self](obj) in
                let obj = obj as! [String:String]
                sender.setTitle(obj["value"], for: .normal)
                
                guard let ss = self else {return}
                ss.skil = obj["key"]
            }
            break
            
        case 2:
            Tools.showDataPicekr(dataSource:defect_nrr_insp
            ) {[weak self] (obj) in
                let obj = obj as! [String:String]
                sender.setTitle(obj["value"], for: .normal)
                
                guard let ss = self else {return}
                ss.insp = obj["key"]
            }
            
            break
            
        case 3:
            Tools.showDataPicekr(dataSource:defect_nrr_status
            ) {[weak self] (obj) in
                let obj = obj as! [String:String]
                sender.setTitle(obj["value"], for: .normal)
                
                guard let ss = self else {return}
                ss.status = obj["key"]
            }
            break
        default:break
        }

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
