//
//  ViewDefectReportController.swift
//  mcs
//
//  Created by gener on 2018/4/20.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ViewDefectReportController: BaseWebViewController {

    var type:String?
    var type_id:String?
    
    var is_dd:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Defect Report View"

        
        if is_dd {
            guard let parent_id = type_id , let parent_type = type else { return ;}
            let d = ["type":parent_type,"id":parent_id]
            
            req_url = action_detail_viewDefect_url
            req_parms = d
        } else {
            guard let parent_id = type_id else { return ;}
            let d = ["id":parent_id]
            
            req_url = defect_detail_preview_url
            req_parms = d
        }
        
        loadData()

    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
