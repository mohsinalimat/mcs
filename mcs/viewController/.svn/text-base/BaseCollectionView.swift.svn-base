//
//  BaseCollectionView.swift
//  mcs
//
//  Created by gener on 2018/1/19.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
let kUICollectionViewLeftColor = UIColor (colorLiteralRed: 237/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
let kUICollectionViewRightColor = UIColor (colorLiteralRed: 248/255.0, green: 248/255.0, blue: 198/255.0, alpha: 1)

class BaseCollectionView: UICollectionView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let rect1 = CGRect (x: 0, y: 0, width: (rect.width - 2)/2.0, height: rect.height)
        let rect2 = CGRect (x: rect1.maxX + 2, y: 0, width: rect1.width, height: rect1.height)
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(2)
        ctx?.setFillColor(kUICollectionViewLeftColor.cgColor)
        ctx?.setStrokeColor(UIColor.red.cgColor)
        ctx?.fill(rect1)

        ////right
        ctx?.setFillColor(kUICollectionViewRightColor.cgColor)
        ctx?.fill(rect2)
        
        ///Add line
        ctx?.setStrokeColor(UIColor.lightGray.cgColor)
        ctx?.addLines(between: [CGPoint (x: rect1.maxX + 1, y: 0) , CGPoint.init(x: rect1.maxX + 1, y: rect1.height)])
        ctx?.strokePath()
    }
    

}
