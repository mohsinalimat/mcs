//
//  ViewController.swift
//  mcs
//
//  Created by gener on 2018/1/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: BaseWebViewController {

    var igv:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*HUD.show()
    
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        let req = URLRequest.init(url: URL.init(string: "http://smart.imsp.cn/mcs/rest/biz/mobile/data/active")!)
        let task = session.dataTask(with: req)
        
        
        task.resume()*/
        
        /*let ig = UIImage (named: "roll_typebar_details-1")
            
        netHelper_upload(to: "http://192.168.6.54:80/Test/withupload.php", parameters: ["key":"719"], uploadFiles: [ig], successHandler: { (res) in
            print(res);
            }) {
                print("error")
        }*/
        //
        igv = UIImageView (frame: CGRect (x: 100, y: 100, width: 100, height: 100))
        view.addSubview(igv)
        
        let url = "http://192.168.6.54:80/TestDir/201807191550361737.jpg"
        igv.kf.setImage(with: URL.init(string: url))
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
