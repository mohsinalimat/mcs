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
        HUD.show()
    
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        let req = URLRequest.init(url: URL.init(string: "http://smart.imsp.cn/mcs/rest/biz/mobile/data/active")!)
        let task = session.dataTask(with: req)
        
        
        task.resume()
        
    }


}

extension ViewController:URLSessionDataDelegate{
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("complete")
        print(Thread.isMainThread)
        
        HUD.dismiss()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do{
            let obj = try JSONSerialization.jsonObject(with: data, options: [])
            print(obj);
        }catch{
            print(error.localizedDescription);
        }
     
        print(Thread.isMainThread)
    }
    
    
    
}
