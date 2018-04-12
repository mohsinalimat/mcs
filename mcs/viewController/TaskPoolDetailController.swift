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
    
    var taskId:String!//任务ID
    var ywNo:String! //业务编号
    var ywType:String! //业务类型
    var schedule_time:String!
    
    var task_pool_dataArr = [Any]()
    
    var from_taskPool:Bool = true
    
    @IBOutlet weak var btn_defect: UIButton!
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var btn_change: UIButton!
    
    private var current_taskId :String!
    
    
    //ONLY TaskPool
    @IBAction func task_no_action(_ sender: UIButton) {
        let frame  = CGRect(x: 0, y: 0, width: 400, height: 360)
        let vc = TaskNumberListVC()
        vc.dataArray = task_pool_dataArr
        vc.view.frame = frame
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = sender
        vc.popoverPresentationController?.sourceRect = CGRect (x: 0, y: 0, width: 160, height: 30)
        vc.preferredContentSize = frame.size
        vc.cellSelectedAction = {[weak self] index in
            guard let ss = self else {return}
            guard let d = ss.task_pool_dataArr[index] as? [String:Any] else {return}
            
            if let taskid = d["taskId"]  as? String , let yw = d["taskNo"] as? String, let ywtp = d["taskType"] as? String{
                guard taskid != ss.current_taskId else { return}
                
                let vc = TaskPoolDetailController()
                vc.taskId = taskid
                vc.ywNo = yw
                vc.ywType = ywtp
                vc.task_pool_dataArr = ss.task_pool_dataArr
                let scheduletime = Tools.date(String.stringIsNullOrNil(d["scheduleTime"]))
                if let d = scheduletime {
                    vc.schedule_time = Tools.dateToString(d, formatter: "yyyy-MM-dd")
                }
                
                task_pool_taskno_index = index
                
                ss.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    //Defect Report
    @IBAction func defectReportAction(_ sender: AnyObject) {
        let vc = DefectReportController()
        self.navigationController?.pushViewController(vc, animated: true)
        
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
            let vc = ActionListVC()
            vc.ywNo = ywNo
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            
            break
            
        default:break
        }
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        
        _initSubview();
        
        current_taskId = taskPoolSelectedTask["taskId"] as! String
        
        loadData()
    }

    //MARK: -
    func _initSubview()  {
        title = ywNo
        
        webview.frame = CGRect (x: 0, y: 45, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 100)
        
        if !from_taskPool {
            task_no.isHidden = true
            btn_defect.isHidden = true;
            btn_change.isHidden = true;
            btn_save.isHidden = true
        }else {
            task_no.setTitle("Task(\(task_pool_dataArr.count))", for: .normal);
        }
        
        
        
        taskName.text = ywType
        time.text = schedule_time
        
        
    }
    
    override func loadData()  {
        let d = [//"shift":"30b621f4455545828b0b0e2d9e2fb9f3",
                 //"scheduleTime":"23/03/2018",
                 "taskId":taskId! //"ab0075d0-2e52-11e8-a41b-00ffb0abeb6d"
        ]
        
        
        
        requestWithUrl(task_pooldetail_url, parameters: d)
    }
    


}
