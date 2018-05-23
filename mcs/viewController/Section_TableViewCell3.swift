//
//  Section_TableViewCell3.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Section_TableViewCell3: UITableViewCell {

    @IBOutlet weak var pre_image: UIImageView!
    
    
    
    
    
    
    func fill(_ image:UIImage) {
        
        pre_image.image = image
        
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
