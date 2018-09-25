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
        stas.text = String.isNullOrEmpty(d["wpStatus"])  == "0" ? "Open" : "Closed"
        ed_advice.text = String.isNullOrEmpty(d["wpEdAdvice"])
        tx_wo.text = String.isNullOrEmpty(d["txToWo"])

        ///file
        if let igstr = d["fileStr"] as? String {
            var s = igstr
            s = s.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")
            let data = Data.init(base64Encoded: s)
            if let ig = UIImage.init(data: data!){
                attach.image = ig;
            }
        } else if let attachment = d["attachments"] as? [String:Any]  , let _id = attachment["id"] as? String{
            requestImage(_id, completionHandler: { [weak self] (ig) in
                guard let ss = self else {return}
                ss.attach.image = ig;
                });
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
