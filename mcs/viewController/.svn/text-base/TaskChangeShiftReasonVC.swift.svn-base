//
//  TaskChangeShiftReasonVC.swift
//  mcs
//
//  Created by gener on 2018/4/3.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskChangeShiftReasonVC: BaseViewController ,UITextViewDelegate{

    
    @IBOutlet weak var textView: UITextView!
    
    var msg:UILabel!
    
    var completionHandler:((String) -> Void)?
    
    var oldStr:String?
    
    func textViewDidChange(_ textView: UITextView) {
        msg.isHidden = textView.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? true : false
        
        /*let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        //paragraphStyle.firstLineHeadIndent = 0
        
        let dic:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 16) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            NSKernAttributeName:1
        ]
        
        let attriStr = NSAttributedString.init(string: textView.text, attributes: dic)
        textView.attributedText = attriStr*/

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _setTitleView("Change Reason")
        
        // Do any additional setup after loading the view.
        
        let backbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 50, height: 35))
        backbtn.setImage(UIImage (named: "back_arrow"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
        backbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        backbtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backbtn.setTitleColor(UIColor.darkGray, for: .normal)
        let leftitem = UIBarButtonItem.init(customView: backbtn)
        navigationItem.leftBarButtonItem = leftitem
        
        let finishedbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        finishedbtn.setTitle("OK", for: .normal)
        finishedbtn.setTitleColor(UIColor.white, for: .normal)
        finishedbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: 1)
        finishedbtn.addTarget(self, action: #selector(finishedBtnAction), for: .touchUpInside)
        finishedbtn.tag = 100
        finishedbtn.layer.cornerRadius = 10
        finishedbtn.layer.masksToBounds = true
        let ritem = UIBarButtonItem (customView: finishedbtn)
        navigationItem.rightBarButtonItems = nil
        navigationItem.rightBarButtonItem = ritem
 
        textView.delegate = self
        
        msg = UILabel (frame: CGRect (x: 8, y: 0, width: 200, height: 30))
        msg.text = "Input Reason..."
        msg.font = UIFont.systemFont(ofSize: 15)
        msg.textColor = UIColor.lightGray
        
        textView.addSubview(msg)
        
        textView.text = oldStr
        
        self.textViewDidChange(textView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    
    func finishedBtnAction() {
        if let  handler = completionHandler {
            handler(textView.text);
        }
        
        navigationBackButtonAction()
    }

    func navigationBackButtonAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    


}
