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

    
    func _setTitleView(_ t :String){
        let _titlev = UILabel (frame: CGRect (x: 0, y: 0, width: 300, height: 30))
        _titlev.textColor = UIColor.white
        _titlev.textAlignment = .center
        _titlev.text = t
        navigationItem.titleView = _titlev
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
