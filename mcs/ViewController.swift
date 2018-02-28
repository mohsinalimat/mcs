//
//  ViewController.swift
//  mcs
//
//  Created by gener on 2018/1/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: BaseWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // loadData()
        HUD.show()
        
        let req = URLRequest.init(url: URL.init(string: "https://threejs.org/examples/#webgl_loader_pdb")!)
        webview.loadRequest(req);
        
    }

    
    
    override func loadData()  {

        
        
        
        
        /*let d = ["shift":"1fc5dd3670fe4717997d4c122488bd39",
                 "scheduleTime":"22/01/2018",
                 "station":"MFM"]
        
        requestWithUrl(get_task_pool_url, parameters: d)*/
        
//        var header:HTTPHeaders = [:]
//        if let token = user_token as? String {
//            header["Authorization"] = token;
//        }
//        
//        
//        Alamofire.request(BASE_URL + get_task_pool_url, method: .post, parameters: d, encoding: JSONEncoding.default, headers: header).responseJSON { (dataResponse) in
//            
//            
//        }
        
        
        
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

