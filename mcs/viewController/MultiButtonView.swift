//
//  MultiButtonView.swift
//  mcs
//
//  Created by gener on 2018/4/25.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MultiButtonView: UIView {
    var buttonTitles:[String]!
    var changeActionHandler:((Int) -> Void)?
    var selectButtonIndex:Int = 1;

    private let msg = UILabel()
    private var _currentBtn:UIButton!
    
    let bgColor = UIColor.init(colorLiteralRed: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
    
    var title:String {
        set {
            msg.text = newValue;
        }
        get {
            return msg.text ?? "";
        }
    }
    

    init(_ frame:CGRect , titles:[String]) {
        super.init(frame: frame)
        backgroundColor = bgColor
        
        msg.frame = CGRect (x: 20, y: 0, width: 100, height: frame.height)
        msg.font = UIFont.systemFont(ofSize: 13)
        msg.textColor = UIColor.lightGray
        self.addSubview(msg)
        
        for i in 0..<titles.count {
            let b = UIButton (frame: CGRect (x: frame.width - CGFloat.init((i + 1) * 110), y: 0, width: 80, height: frame.height));
            b.tag = titles.count - i;
            b.setTitle(titles[i], for: .normal)
            b.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            b.titleLabel?.numberOfLines = 2
            b.setTitleColor(UIColor.darkGray, for: .normal)
            b.setTitleColor(kButtonTitleDefaultColor, for: .selected)
            
            b.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            self.addSubview(b)
            
            if selectButtonIndex == b.tag {
                b.isSelected = true;
                _currentBtn = b
            }
        }
        
    }
    
    
    //MARK:
    func buttonAction(_ button:UIButton) {
        guard _currentBtn.tag != button.tag else {return}
        _currentBtn.isSelected = false
        button.isSelected = true
        _currentBtn = button
        
        if let handle = changeActionHandler {
            handle(button.tag);
        }
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
