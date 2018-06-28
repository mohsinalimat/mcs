//
//  TaskEditReasonOlnyController.swift
//  mcs
//
//  Created by gener on 2018/6/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskEditReasonOlnyController: BaseViewController {

    @IBOutlet weak var reason: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        _setTitleView("Update Reason Info")
        reason.text = String.isNullOrEmpty(taskPoolSelectedTask["reason"]);
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {

        case 3:
            let v = TaskChangeShiftReasonVC()
            v.oldStr = reason.text
            v.completionHandler = {[weak self] str in
                guard let strongSelf = self else {return}
                strongSelf.reason.text = str
            }
            
            self.navigationController?.pushViewController(v, animated: true)
            break
            
        case 4:
            self.dismiss(animated: true, completion: nil)
            break
        case 5:
            
            self._request();
            
            break
        default:break
        }

    }

    
    
    
    
    //MARK:-
    func _request() {
        guard String.isNullOrEmpty(reason.text).lengthOfBytes(using: String.Encoding.utf8) > 0 else {HUD.show(info: "Require All Info"); return}
        
        let d:[String:Any] = [
            "planningTime":Tools.dateToString(kTaskpool_date!, formatter: "dd/MM/yyyy"),
            "shiftId":String.isNullOrEmpty(taskPoolSelectedTask["shift"]),
            "id":String.isNullOrEmpty(taskPoolSelectedTask["bizId"]),
            "procDefKey":String.isNullOrEmpty(taskPoolSelectedTask["procDefKey"]),
            "feedbackId":String.isNullOrEmpty(taskPoolSelectedTask["feedbackId"]),
            "ac":String.isNullOrEmpty(taskPoolSelectedTask["ac"]),
            "no":String.isNullOrEmpty(taskPoolSelectedTask["taskNo"]),
            "oldTaskTo":String.isNullOrEmpty(taskPoolSelectedTask["taskTo"]),
            
            "performReason":String.isNullOrEmpty(reason.text),
            "aftFlNo":String.isNullOrEmpty(taskPoolSelectedTask["aftFlNo"]),
            "taskTo":String.isNullOrEmpty(taskPoolSelectedTask["taskTo"])
        ]
        
        
        
        HUD.show()
        request(taskPool_perform_url, parameters: d, successHandler: { [weak self](res) in
            HUD.show(successInfo: "Success");
            guard let strongSelf = self else {return}
            NotificationCenter.default.post(name: NSNotification.Name (rawValue: "taskpool_changeShift_completion_notification"), object: nil)
            
            strongSelf.dismiss(animated: true, completion: nil)
        }) { (str) in
            HUD.show(info: str ?? "Failure")
        }
        
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
