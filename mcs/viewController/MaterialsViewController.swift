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

        _init()

    }

    func _init()  {
        seg.removeAllSegments()
        seg.insertSegment(withTitle: "Aviation Materials", at: 0, animated: false)
        seg.insertSegment(withTitle: "Orders", at: 1, animated: false)
        seg.selectedSegmentIndex = 0
    }
    
    
    override func addController() {
        let rect = CGRect (x: 0, y: 0, width: self.view.frame.width, height: kCurrentScreenHeight - 50)
        print("rect : \(rect)")
        
        vc1 = MaterialSearchController()
        vc1.view.frame = rect
        self.addChildViewController(vc1)
        self.view.addSubview(vc1.view)

        vc2 = MaterialOrderController()
        vc2.view.frame = rect
        self.addChildViewController(vc2)
        self.view.addSubview(vc2.view)

        self.view.bringSubview(toFront: vc1.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
