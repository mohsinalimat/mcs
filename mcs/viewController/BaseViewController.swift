//
//  BaseViewController.swift
//  mcs
//
//  Created by gener on 2018/1/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = kTableviewBackgroundColor
        
    }

    
    func displayMsg(_ info:String) {
        let l = UILabel (frame: CGRect (x: 0, y: 100, width: kCurrentScreenWidth, height: 100))
        l.text = info
        l.textColor = kTableviewBackgroundColor
        l.font = UIFont.systemFont(ofSize: 20)
        l.numberOfLines = 0
        l.textAlignment = .center
        l.tag = 1001
        self.view.addSubview(l)
    }
    
    func _setTitleView(_ t :String){
        let _titlev = UILabel (frame: CGRect (x: 0, y: 0, width: 300, height: 30))
        _titlev.textColor = UIColor.white
        _titlev.textAlignment = .center
        _titlev.text = t
        navigationItem.titleView = _titlev
    }
    
    func _addCloseItem() {
        //close
        let closebtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        closebtn.setTitle("取消", for: .normal)
        closebtn.setTitleColor(UIColor.white, for: .normal)
        closebtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: 1)
        closebtn.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        closebtn.tag = 100
        let litem = UIBarButtonItem (customView: closebtn)
        navigationItem.leftBarButtonItem = litem
    }
    
    func closeBtn(){
        self.dismiss(animated: true, completion: nil)
    }

    
    func showMsg( _ msg:String , title:String , handler:@escaping ((Void) -> Void)) {
        
        let vc = UIAlertController.init(title: msg,message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title:"Cancel", style: .default)
        let action2 = UIAlertAction.init(title: title, style: .destructive) { (action) in
            handler();
        }
        
        vc.addAction(action)
        vc.addAction(action2)
        self.navigationController?.present(vc, animated: true, completion: nil);
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
