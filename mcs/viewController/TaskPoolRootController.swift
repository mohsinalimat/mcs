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
    
    var taskpool:TaskPoolBaseController!
    var taskhandle:TaskHandleController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.titleView = navigatoinItemTitleView()
        
        addController()
    }


    func addController(){
        taskhandle = TaskHandleController()
        taskhandle.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height  - 49)
        self.addChildViewController(taskhandle)
        self.view.addSubview(taskhandle.view)
        
        taskpool = TaskPoolBaseController()
        taskpool.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height  - 49)
        self.addChildViewController(taskpool)
        self.view.addSubview(taskpool.view)
    

        
    }
    
    func navigatoinItemTitleView() -> UIView  {
        let seg = UISegmentedControl.init(items: ["Task Pool","HandleOver"])
        seg.frame = CGRect (x: 0, y: 0, width: 400, height: 30)
        seg.addTarget(self, action: #selector(segClicked(_:)), for:.valueChanged )
        seg.selectedSegmentIndex = 0
        seg.tintColor = kViewDefaultBgColor
        
        return seg
    }
    
    
    func segClicked( _ seg:UISegmentedControl)  {
        guard seg.selectedSegmentIndex != current_index else { return }
        current_index = seg.selectedSegmentIndex
        
        self.transition(from: current_index == 0 ? taskhandle : taskpool, to: current_index == 0 ? taskpool : taskhandle, duration: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: nil, completion: nil)

    }
    

    
    
    
    

}
