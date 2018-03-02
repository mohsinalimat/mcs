//
//  TaskPoolBaseController.swift
//  
//
//  Created by gener on 2018/3/2.
//
//

import UIKit

class TaskPoolBaseController: BaseTabItemController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _init()
        
        navigationItem.titleView = navigatoinItemTitleView()
        
    }

    
    func _init()  {
        let vc = TaskPoolViewController()
        vc.view.frame = CGRect (x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height  - 49 - 50)
        
        self.addChildViewController(vc)
        
        self.view.addSubview(vc.view)

    
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
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "TaskPoolChangedNotificationName"), object: nil, userInfo: nil)
    
    
    
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
