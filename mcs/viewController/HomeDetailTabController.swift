//
//  HomeDetailTabController.swift
//  mcs
//
//  Created by gener on 2018/1/18.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class HomeDetailTabController: UITabBarController {

    var _maskView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        _init()
        
    }

    func _init() {
        self.tabBar.isHidden = true
        
        let vc1 = FlightInfoListController()
        let vc2 = HistoryFaultController()
        let vc3 = PlaneInfoController()

        viewControllers = [vc1,vc2,vc3];
        
        let bgView = UIView (frame: CGRect (x: 0, y: kCurrentScreenHeight - 49 - 64, width: kCurrentScreenWidth, height: 49))
        bgView.backgroundColor = kViewDefaultBgColor
        view.addSubview(bgView)
        
        let _w = kCurrentScreenWidth / 3.0
        let btn_titles = ["航班告警","历史故障","飞机信息"]
        
        for i in 0..<3 {
            let btn = UIButton (frame: CGRect (x: _w * CGFloat.init(i), y: 0, width: _w, height: 49))
            btn.backgroundColor = UIColor.clear
            bgView.addSubview(btn)
            btn.setTitle(btn_titles[i], for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.tag =  i
            btn.addTarget(self, action: #selector(changeControllerAction(_ :)), for: .touchUpInside)
            //btn.setImage(UIImage (named: "icon_tabbar_notification"), for: .normal)
            //btn.setImage(UIImage (named: "icon_tabbar_notification_active"), for: .selected)
            btn.titleLabel?.font  = UIFont.systemFont(ofSize: 15)
            
        }
        
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


