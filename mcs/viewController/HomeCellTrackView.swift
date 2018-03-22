//
//  HomeCellTrackView.swift
//  mcs
//
//  Created by gener on 2018/1/15.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class HomeCellTrackView: UIView {
    private var start_station:UILabel!
    private var arrive_station:UILabel!
    private var start_time:UILabel!
    private var arrive_time:UILabel!
    private var planeIcon:UIImageView!
    
    private var p1:CGPoint!
    private var p2:CGPoint!
    private var p3:CGPoint!
    private var p4:CGPoint!
    private var p5:CGPoint!
    private var p6:CGPoint!
    
    private let start_point = CGPoint (x: 45, y: 25)
    private let radius:CGFloat = 2
    
    private var _total_width:CGFloat = 0
    
    //MARK:
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        print(#function)
        
        // Drawing code
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.move(to: start_point)
        ctx?.setStrokeColor(UIColor.lightGray.cgColor)
        ctx?.setFillColor(UIColor.lightGray.cgColor)
        ctx?.setLineWidth(0.8)
        
        //起始点
        ctx?.addArc(center: start_point, radius: radius, startAngle: 0, endAngle:  CGFloat.init(360) , clockwise: false)
        ctx?.fillPath()
        //ctx?.strokePath()

        ctx?.addLines(between: [p1,p2,p3,p4,p5,p6])
        ctx?.strokePath()
        
        ctx?.addArc(center: CGPoint (x: p6.x + radius, y: start_point.y), radius: radius, startAngle: 0, endAngle:  CGFloat.init(360) , clockwise: false)
        ctx?.fillPath()
        ctx?.strokePath()
        
        
        //addPath(plane_location_index);
    }
    
    override func awakeFromNib() {
        print(#function)
        
        super.awakeFromNib()
        
        start_station = UILabel()
        start_time = UILabel()
        arrive_station = UILabel()
        arrive_time = UILabel()
        planeIcon = UIImageView (frame: CGRect (x: 0, y: 0, width: 10, height: 10))
        self.addSubview(start_station);
        self.addSubview(start_time)
        self.addSubview(arrive_station)
        self.addSubview(arrive_time)
        self.addSubview(planeIcon)
    }
    
    
    //MARK: - display
    var plane_location_index:Int = 0
    var scale_x : TimeInterval = 0
    
    func displayMsg(_ dic:[String:Any]) {
        print(#function)
        
        start_station.text =  String.stringIsNullOrNil(dic["depApt"])
        arrive_station.text = String.stringIsNullOrNil(dic["arrApt"])

        scale_x = 0;
        
        ////////
        if let std = dic["std"] , let sta =  dic["sta"] {

            let s1 = TimeInterval.init("\(std)")
            let s2 = TimeInterval.init("\(sta)")
            let interval = s2! - s1!
            
            let _now = Date().timeIntervalSince1970;
            
            let scale = (_now * TimeInterval.init(1000) - s1!) / interval
            
            if scale > 0 {
                scale_x = scale;
            }
            
            print(scale_x)
        }
        
        
        
       //plane_location_index = Int(arc4random_uniform(3))

    }
    

    override func layoutSubviews() {
        print(#function)
        
        let _w = (self.frame.width - 100)/4.0
        p1 = CGPoint (x: start_point.x + radius, y: start_point.y)
        p2 = CGPoint (x: p1.x + _w, y: start_point.y)
        p3 = CGPoint (x: p2.x + _w * 0.5, y: start_point.y - 0)//15
        p4 = CGPoint (x: p3.x + _w , y: start_point.y - 0)
        p5 = CGPoint (x: p4.x + _w * 0.5, y: start_point.y)
        p6 = CGPoint (x: p5.x + _w , y: start_point.y)
        
        _total_width = (self.frame.width - 100)
        
        //START-END
        var s:UILabel
        for i in 0..<2 {
            var _p :CGFloat = 0
            if i == 0 {
                s =  start_station
            }else{
                _p = p6.x + radius;
                s = arrive_station
            }
            
            s.frame = CGRect (x: _p, y: 0, width: 45, height: 20)
            s.textColor = UIColor.darkGray
            s.font = UIFont.systemFont(ofSize: 13)
            s.textAlignment = .center
            s.center.y = start_point.y
        }
        
        //START-END TIME
        for i in 0..<2 {
            var _p :CGFloat = p1.x
            if i == 0 {
                s = start_time
            }else{
                _p = p5.x
                s = arrive_time
            }
            
            s.frame = CGRect (x: _p, y: 0, width: 50, height: 20)
            s.textColor = UIColor.lightGray
            s.font = UIFont.systemFont(ofSize: 12)
            s.textAlignment = .center
            s.center.y = p3.y
        }

        //plane icon
        let igv = planeIcon
        igv?.frame = CGRect (x: 0, y: 0, width: 15, height: 16)
        igv?.image = UIImage (named: "smai_plane_1")
        igv?.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI_2))

        let new = CGFloat.init(scale_x) * _total_width
        igv?.center = CGPoint (x: p1.x + new, y: p1.y)
        
        planeIcon.center = CGPoint (x: p1.x + new, y: p1.y);
        
        /*let i = plane_location_index
        switch i {
            case 0:planeIcon.center = p1;break
            case 1:
                let _x = (p3.x + p4.x) / 2
                planeIcon.center = CGPoint (x: _x, y: p3.y)
                break
            case 2: planeIcon.center = p6;break
            default:break
        }*/
        
        

        

    }
    

    let strole_color = UIColor (colorLiteralRed: 53/255.0, green: 138/255.0, blue: 216/255.0, alpha: 1).cgColor
    
    func addPath(_ loc:Int)  {
        let p = UIBezierPath.init()
        let circle = UIBezierPath.init(arcCenter: start_point, radius: radius, startAngle: 0, endAngle:  CGFloat.init(360), clockwise: true)
        p.append(circle)
        
        p.move(to: p1);
        p.addLine(to: planeIcon.center)
        
        
        let layer = CAShapeLayer.init()
        layer.fillColor = strole_color
        layer.lineWidth = 1

        layer.strokeColor = strole_color
        layer.path = p.cgPath
        layer.fillRule = kCAFillRuleEvenOdd
        
        layer.strokeEnd = 1
        
        self.layer.addSublayer(layer)
        
        
    }
    
    
    
    
//    displayMsg()
//    layoutSubviews()
//    layoutSubviews()
//    draw
    
    
}
