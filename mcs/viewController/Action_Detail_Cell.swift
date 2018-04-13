//
//  Action_Detail_Cell.swift
//  mcs
//
//  Created by gener on 2018/4/4.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Action_Detail_Cell: UITableViewCell {

    @IBOutlet weak var fltNo: UITextField!
    
    @IBOutlet weak var area: UIButton!
    
    @IBOutlet weak var dateTime: UIButton!
    
    @IBOutlet weak var mh: UITextField!
    
    @IBOutlet weak var station: UIButton!
    
    @IBOutlet weak var descri: UITextView!
    
    
    @IBOutlet weak var ref: UITextField!
    
    @IBOutlet weak var page: UITextField!
    
    @IBOutlet weak var item: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            Tools.showDataPicekr(dataSource:["UTC","LOCAL"]) {(obj) in
                //guard let strongSelf = self else {return}
                
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }
            
            break
            
        case 2:
            Tools.showDatePicekr { (obj) in
                let obj = obj as! Date
                let str = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
                sender.setTitle(str, for: .normal)
            }
            
            break
        case 3:
            
            Tools.showDataPicekr (dataSource:Tools.station()){ (obj) in
                let obj = obj as! String
                
                sender.setTitle(obj, for: .normal)
            }
            
            break
            
        default:break
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
