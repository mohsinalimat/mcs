//
//  TaskPoolCell.swift
//  mcs
//
//  Created by gener on 2018/3/2.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskPoolCell: UITableViewCell {

    @IBOutlet weak var taskNo: UILabel!
    @IBOutlet weak var actions: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    
    @IBOutlet weak var fltno: UILabel!
    
    @IBOutlet weak var descri: UILabel!
    
    @IBOutlet weak var reason: UILabel!
    
    @IBOutlet weak var to_sb: UILabel!
    
    @IBOutlet weak var r_igv: UIImageView!
    @IBOutlet weak var p_igv: UIImageView!
    @IBOutlet weak var cld_igv: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        taskNo.text = String.stringIsNullOrNil(d["taskNo"])
        
        from.text = String.stringIsNullOrNil(d["mh"])
        to.text = String.stringIsNullOrNil(d["finalAction"])
        
        fltno.text = String.stringIsNullOrNil(d["fltNo"])
        
        
        
        
        
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
        //画虚线
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
