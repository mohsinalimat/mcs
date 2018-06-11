//
//  TTWebViewController.swift
//  mcs
//
//  Created by gener on 2018/6/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

struct TTWebDataSource {
    var url: String!
    var pars:[String:Any]?
    var title:String?
}

class TTWebViewController: BaseWebViewController {
    var reqBody:TTWebDataSource!
    
    init(_ body:TTWebDataSource) {
        super.init(nibName: nil, bundle: nil)
        
        reqBody = body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = reqBody.title
        req_url = reqBody.url
        req_parms = reqBody.pars
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
