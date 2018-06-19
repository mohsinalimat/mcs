//
//  PNHistoryCell.swift
//  mcs
//
//  Created by gener on 2018/6/19.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class PNHistoryCell: UITableViewCell {

    @IBOutlet weak var pn: UILabel!
    
    @IBOutlet weak var item_num: UILabel!
    
    @IBOutlet weak var operation: UILabel!
    
    @IBOutlet weak var company_code: UILabel!
    
    @IBOutlet weak var doc_type: UILabel!
    @IBOutlet weak var doc_date: UILabel!
    @IBOutlet weak var toc: UILabel!
    @IBOutlet weak var store_code: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var position: UILabel!
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        pn.text = String.isNullOrEmpty(d["pspn"])
        item_num.text = String.isNullOrEmpty(d["itemNum"])
        operation.text = String.isNullOrEmpty(d["operationType"])
        company_code.text = String.isNullOrEmpty(d["companyCode"])
        doc_type.text = String.isNullOrEmpty(d["docType"])
        doc_date.text = String.isNullOrEmpty(d["docDate"])
        toc.text = String.isNullOrEmpty(d["docNo"])
        store_code.text = String.isNullOrEmpty(d["storeCode"])
        place.text = String.isNullOrEmpty(d["place"])
        position.text = String.isNullOrEmpty(d["position"])
    }
    
    
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
