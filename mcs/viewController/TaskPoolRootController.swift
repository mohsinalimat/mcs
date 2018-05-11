//
//  TaskPoolRootController.swift
//  mcs
//
//  Created by gener on 2018/3/30.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskPoolRootController: BaseTabItemController {

    var current_index:Int = 0
    
    var vc1:BaseViewController!
    var vc2:BaseViewController!
    var seg:UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        seg = navigatoinItemTitleView()
        seg.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 15)], for: .normal)
        
        navigationItem.titleView = seg
        
        addController()
    }


    func addController(){
        vc2 = TaskHandleController()
        vc2.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height  - 49)
        self.addChildViewController(vc2)
        self.view.addSubview(vc2.view)
        
        vc1 = TaskPoolBaseController()
        vc1.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height  - 49)
        self.addChildViewController(vc1)
        self.view.addSubview(vc1.view)
    
        
    }
    
    func navigatoinItemTitleView() -> UISegmentedControl  {
        let seg = UISegmentedControl.init(items: ["Task Pool","HandOver"])
        seg.frame = CGRect (x: 0, y: 0, width: 500, height: 35)
        seg.addTarget(self, action: #selector(segClicked(_:)), for:.valueChanged )
        seg.selectedSegmentIndex = 0
        seg.tintColor = kViewDefaultBgColor
        
        return seg
    }
    
    
    func segClicked( _ seg:UISegmentedControl)  {
        guard seg.selectedSegmentIndex != current_index else { return }
        current_index = seg.selectedSegmentIndex
        
        self.transition(from: current_index == 0 ? vc2 : vc1, to: current_index == 0 ? vc1 : vc2, duration: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: nil, completion: nil)

    }
    

    
    
    
    

}
