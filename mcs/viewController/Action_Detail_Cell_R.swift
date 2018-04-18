//
//  Action_Detail_Cell_R.swift
//  mcs
//
//  Created by gener on 2018/4/9.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Action_Detail_Cell_R: UITableViewCell {

    @IBOutlet weak var flt_no: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var mh: UILabel!
    
    @IBOutlet weak var station: UILabel!
    
    @IBOutlet weak var descri: UITextView!
    
    @IBOutlet weak var ref: UILabel!
    
    @IBOutlet weak var page: UILabel!
   
    @IBOutlet weak var item: UILabel!
    
    
    func fill(_ d :[String:Any])  {
        flt_no.text = String.stringIsNullOrNilToEmpty(d["flNo"])
        
        let _eta = Tools.date(String.stringIsNullOrNil(d["createDatetime"]))
        if let d = _eta {
            date.text = Tools.dateToString(d, formatter: "yyyy-MM-dd")
        }

        mh.text = String.stringIsNullOrNilToEmpty(d["mainHour"])
        station.text = String.stringIsNullOrNilToEmpty(d["station"])
        descri.text = String.stringIsNullOrNilToEmpty(d["actionDetail"])
        ref.text = String.stringIsNullOrNilToEmpty(d["actionRef"])
        page.text = String.stringIsNullOrNilToEmpty(d["page"])
        item.text = String.stringIsNullOrNilToEmpty(d["item"])
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
