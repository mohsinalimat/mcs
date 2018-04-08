//
//  TaskPoolDetailController.swift
//  mcs
//
//  Created by gener on 2018/3/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskPoolDetailController: BaseWebViewController {

    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var task_no: UIButton!
    
    var taskId:String!
    
    @IBAction func task_no_action(_ sender: UIButton) {
        
        
    }
    
    @IBAction func defectReportAction(_ sender: AnyObject) {
        
    }
    
    
    @IBAction func task_operation_action(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            Tools.showAlert("TaskChangeShiftVC" ,withBar: true)
            
            break
            
        case 2:
            HUD.show()
            let vc = TaskAddActionVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
            
        case 3:

            break
        case 4:
            
            break
            
        default:break
        }
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        
        title = "TaskPool detail"
        
        webview.frame = CGRect (x: 0, y: 45, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 100)
        
        
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
