//
//  TaskPoolCell.swift
//  mcs
//
//  Created by gener on 2018/3/2.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskPoolCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setStrokeColor(UIColor.lightGray.cgColor)
        
        ctx?.setLineWidth(1)
        
        ctx?.addLines(between: [CGPoint (x: 15, y: 1),CGPoint (x: self.frame.width - 30, y: 1)])
        
        ctx?.setLineDash(phase: 0, lengths: [10,5])
        
        ctx?.drawPath(using: .stroke)
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
