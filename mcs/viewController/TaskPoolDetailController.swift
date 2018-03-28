//
//  TaskPoolDetailController.swift
//  mcs
//
//  Created by gener on 2018/3/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskPoolDetailController: BaseWebViewController {

    var taskId:String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "TaskPool detail"
        
        loadData()
    }

    
    
    
    override func loadData()  {
        let d = [//"shift":"30b621f4455545828b0b0e2d9e2fb9f3",
                 //"scheduleTime":"23/03/2018",
                 "taskId":taskId! //"ab0075d0-2e52-11e8-a41b-00ffb0abeb6d"
        ]
        
        
        
        requestWithUrl(task_pooldetail_url, parameters: d)
    }
    


}
