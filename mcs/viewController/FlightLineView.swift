//
//  FlightLineView.swift
//  mcs
//
//  Created by gener on 2018/1/22.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class FlightLineView: UIView {

    private var planeIcon:UIImageView!

    private let start_point = CGPoint (x: 30, y: 15)
    private let radius:CGFloat = 3
    
    var _points:[CGPoint] = []
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.move(to: start_point)
        ctx?.setStrokeColor(UIColor.lightGray.cgColor)
        ctx?.setFillColor(UIColor.lightGray.cgColor)
        ctx?.setLineWidth(1)
        
        //起始点
        ctx?.addArc(center: start_point, radius: radius, startAngle: 0, endAngle:  CGFloat.init(360) , clockwise: false)
        ctx?.fillPath()
        
        ctx?.addLines(between: _points)
        ctx?.strokePath()
        
        for i in 1..<8 {
            ctx?.addArc(center: CGPoint (x: _points[i].x + radius, y: start_point.y), radius: radius, startAngle: 0, endAngle:  CGFloat.init(360) , clockwise: false)
            ctx?.fillPath()
            ctx?.strokePath()

        }

        
        
    }
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        
        planeIcon = UIImageView (frame: CGRect (x: 0, y: 0, width: 10, height: 10))
        self.addSubview(planeIcon)
        
    }
    
    override func layoutSubviews() {
        let _w = (self.frame.width - 60 - radius * 2 * 8)/7.0
        
        _points.append(start_point)
        for i in 1..<8 {
            let p = CGPoint (x: start_point.x + CGFloat(i) * (_w + radius * 2) , y: start_point.y);
            _points.append(p)
            
        }

        //plane icon
        let igv = planeIcon
        igv?.frame = CGRect (x: 0, y: 0, width: 15, height: 16)
        igv?.image = UIImage (named: "smai_plane_1")
        
        //TEST
        let c = _points[3]
        igv?.center = CGPoint (x: c.x + _w * 0.5, y: c.y)
        
        igv?.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI_2))
        
        
        
    }
    
    
    
}
