//
//  BaseTabBarController.swift
//  mcs
//
//  Created by gener on 2018/3/1.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {


    private var _maskView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white

        
        initTabar()
        
    }
    
    /*func _init() {

        
        let _t = ["Home","Task Pool","Defect Report"]//,"DD Mgt","T/S Mgt","Cabin Layout"

        let vc = [HomeViewController(),WarnInfoDetailController(),FIBViewController()]

        var arr = [UIViewController]()
        
        
        let bgView = UIView (frame: CGRect (x: 0, y: kCurrentScreenHeight - 49, width: kCurrentScreenWidth, height: 49))
        bgView.backgroundColor = UIColor (colorLiteralRed: 105/255.0, green: 124/255.0, blue: 142/255.0, alpha: 1)
        view.addSubview(bgView)
        
        let _w = kCurrentScreenWidth / CGFloat(_t.count)

        for i in 0..<_t.count {
            let btn = UIButton (frame: CGRect (x: _w * CGFloat.init(i), y: 0, width: _w, height: 49))
            btn.backgroundColor = UIColor.clear
            bgView.addSubview(btn)
            btn.setTitle(_t[i], for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.tag =  i
            btn.addTarget(self, action: #selector(changeControllerAction(_ :)), for: .touchUpInside)
            //btn.setImage(UIImage (named: "icon_tabbar_notification"), for: .normal)
            //btn.setImage(UIImage (named: "icon_tabbar_notification_active"), for: .selected)
            btn.titleLabel?.font  = UIFont.systemFont(ofSize: 15)
            
            ////
            let v = vc[i];
            let nav = BaseNavigationController(rootViewController:v)

            arr.append(nav)
            
        }
        
        viewControllers = arr

        let maskView = UIView (frame: CGRect (x: 0, y: 0, width: _w, height: 49));
        maskView.backgroundColor = UIColor.white
        maskView.alpha = 0.5
        _maskView = maskView
        bgView.addSubview(maskView)
        
    }
    
    
    func changeControllerAction(_ button :UIButton)  {
        guard button.tag != self.selectedIndex else {
            return
        }
        
        self.selectedIndex  = button.tag
        
        _maskView.frame.origin.x = CGFloat.init(button.tag) * button.frame.width
    }*/
    
    
    func initTabar() {
        tabBar.barTintColor = UIColor.white //kBartintColor
        
        let itemtitleArr = ["Flight Info","Task Pool","Defect Report","DD Mgt","T/S Mgt"]
        
        let itemimg = [
            "tabicon_airplane_selector",
            "tabicon_publications",
            "tabicon_toc",
            "tabicon_viewer",
            "tabicon_history",
            "tabicon_bookmarks",
            "tabicon_manager"]
        
        let vcname =
            [
                "HomeViewController",
                "TaskPoolBaseController",
                "BaseViewController",
                "BaseViewController",
                "BaseViewController"]
        
        var viewControllerArr:Array = [UIViewController]()
        
        for i in 0..<itemtitleArr.count{
            let appname = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let cls  =  NSClassFromString(appname + "." + vcname[i]) as! BaseViewController.Type
            let vc = cls.init()
            
            vc.tabBarItem = UITabBarItem (title: itemtitleArr[i], image: UIImage (named: itemimg[i]), tag: 0)
            let navigationvc = BaseNavigationController(rootViewController:vc)
            viewControllerArr.append(navigationvc)
        }
        
        
        viewControllers = viewControllerArr
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
