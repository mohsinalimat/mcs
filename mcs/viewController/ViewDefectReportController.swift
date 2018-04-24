//
//  ViewDefectReportController.swift
//  mcs
//
//  Created by gener on 2018/4/20.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ViewDefectReportController: BaseWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "defect Report"
        

        guard let parent_id = taskPoolSelectedTask["parentId"] as? String , let parent_type = taskPoolSelectedTask["parentType"] as? String else {
            return ;
        }
        
        let d = ["type":parent_type,"id":parent_id]

        req_url = action_detail_viewDefect_url
        req_parms = d
        loadData()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
