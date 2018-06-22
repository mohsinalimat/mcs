//
//  PlaneInfoController.swift
//  mcs
//
//  Created by gener on 2018/1/22.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import SwiftWebViewBridge

class PlaneInfoController: BaseWebViewController {

    var _item:[UIBarButtonItem]?
    var _btn:UIButton!
    
    var _bridge:SwiftWebViewBridge!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let msgBtn = UIButton (frame: CGRect (x: kCurrentScreenWidth - 60, y: 20, width: 50, height: 40))
        msgBtn.addTarget(self, action: #selector(_refreshAction), for: .touchUpInside)
        msgBtn.setImage(UIImage (named: "refreshicon_dynamic_titlebar"), for: .normal);
        msgBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 18, 13, 18)
        _btn = msgBtn
        
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 15
        let msgItem  = UIBarButtonItem (customView: msgBtn)
        let items = [fixed,msgItem]
        _item = items
        
        _bridge = SwiftWebViewBridge.bridge(webview, defaultHandler: { (data, responseBack) in
            print("Swift received message from JS: \(data)")
        })
        
        
        
//
        _bridge.registerHandlerForJS(handlerName: "printReceivedParmas", handler: { [unowned self] jsonData, responseCallback in
            // if you used self in any bridge handler/callback closure, remember to declare weak or unowned self, preventing from retaining cycle!
            // Because VC owned bridge, brige owned this closure, and this cloure captured self!
            
            responseCallback([
                "msg": "Swift has already finished its handler",
                "returnValue": [1, 2, 3]
                ])
            })
        
        
        
        // Do any additional setup after loading the view.
        let d = ["id":"\(kFlightInfoListController_airId!)"]
        req_url = plane_info_url
        req_parms = d
        loadData()
    }

//    LOGGING_RCVD: (
//    {
//    data = "id=e208c7af360f46fdb75d1f730d4c1708";
//    }
//    )
//    Swift received message from JS: id=e208c7af360f46fdb75d1f730d4c1708
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.addSubview(_btn)
        
//        guard let items = _item else {return}
//        self.tabBarController?.navigationItem.rightBarButtonItems = items
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _btn.removeFromSuperview()
        //self.tabBarController?.navigationItem.rightBarButtonItems = []//清除后占据大小???
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
