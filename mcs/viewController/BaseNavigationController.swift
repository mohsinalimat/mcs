//
//  BaseNavigationController.swift
//  mcs
//
//  Created by gener on 2018/1/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.barTintColor = UIColor.white //UIColor (colorLiteralRed: 0.212, green: 0.188, blue: 0.427, alpha: 1)
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black,
                                             NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16)]
        
    }

    
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            let backbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 50, height: 35))
            backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
            backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 20)
            backbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
            backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
            backbtn.setTitle("返回", for: .normal)
            backbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            backbtn.setTitleColor(UIColor.darkGray, for: .normal)
            let leftitem = UIBarButtonItem.init(customView: backbtn)
            viewController.navigationItem.leftBarButtonItem = leftitem
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        //self.navigationBar.barTintColor = (viewController.value(forKey: "t_barTintColor") as? UIColor ) ?? UIColor.white
        super.pushViewController(viewController, animated: animated)
    }
    
    
    override func popViewController(animated: Bool) -> UIViewController? {

        return super.popViewController(animated: animated)
        
    }
    
    
    func navigationBackButtonAction() {
        _ = self.popViewController(animated: true)
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
