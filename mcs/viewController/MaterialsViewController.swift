//
//  MaterialsViewController.swift
//  mcs
//
//  Created by gener on 2018/4/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MaterialsViewController:TaskPoolRootController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Aviation Materials"
        view.backgroundColor = UIColor.white
        
        _init()

    }

    func _init()  {
        seg.removeAllSegments()
        seg.insertSegment(withTitle: "Aviation Materials", at: 0, animated: false)
        seg.insertSegment(withTitle: "Orders", at: 1, animated: false)
        seg.selectedSegmentIndex = 0
    }
    
    
    override func addController() {
        vc2 = MaterialOrderController()
        vc2.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.addChildViewController(vc2)
        self.view.addSubview(vc2.view)
        
        vc1 = MaterialSearchController()
        vc1.view.frame = CGRect (x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.addChildViewController(vc1)
        self.view.addSubview(vc1.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
