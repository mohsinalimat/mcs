//
//  TaskEditReasonController.swift
//  mcs
//
//  Created by gener on 2018/6/27.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskEditReasonController: BaseViewController {

    @IBOutlet weak var taskTo: UILabel!

    @IBOutlet weak var flNo: UILabel!
    
    @IBOutlet weak var reason: UILabel!
    
    var _selectedUser:[String]?
    var _flts:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        _setTitleView("Update Reason Info")
        _initSubview()
        
        // Do any additional setup after loading the view.
        
        __get_fltNo()
    }

    
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let v = SearchItemSelectController()
            v.dataArray = g_staffs
            v.dataType = SelectDataType.ac
            v.hasBar = true
            
            v.selectedHandle = {[weak self] obj in
                guard let ss = self else {return}
                let _o = obj as! [String]
                ss._selectedUser = _o
                
                let str = _o.joined(separator: ",");
                ss.taskTo.text = str;
            }
            
            if let a = _selectedUser{
                v.selectedObjs = a;
            }

            self.navigationController?.pushViewController(v, animated: true);
            break
            
        case 2:
            guard _flts != nil else {
                __get_fltNo(); return
            }
            
            Tools.showDataPicekr(self, dataSource: _flts) {[weak self](obj) in
                let obj = obj as! String
                guard let ss = self else {return}
                ss.flNo.text = obj
            }

            break
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
    
    func _initSubview() {
        reason.text = String.isNullOrEmpty(taskPoolSelectedTask["reason"])
        flNo.text = String.isNullOrEmpty(taskPoolSelectedTask["aftFlNo"]);
        taskTo.text = String.isNullOrEmpty(taskPoolSelectedTask["taskTo"])
    }
    
    
    
    
    
    //MARK:-
    func _request() {
        guard String.isNullOrEmpty(taskTo.text).lengthOfBytes(using: String.Encoding.utf8) > 0 || String.isNullOrEmpty(flNo.text).lengthOfBytes(using: String.Encoding.utf8) > 0 || String.isNullOrEmpty(reason.text).lengthOfBytes(using: String.Encoding.utf8) > 0 else {HUD.show(info: "至少选择一个数据!"); return}
        
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
                              "aftFlNo":String.isNullOrEmpty(flNo.text),
                              "taskTo":String.isNullOrEmpty(taskTo.text)
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
    
    
    func __get_fltNo() {
        guard let taskid = taskPoolSelectedTask["ac"] as? String else {return}
        
        let d:[String:Any] = ["acId":taskid,
                              "fltDate" : Tools.dateToString(kTaskpool_date!, formatter: "yyyy-MM-dd")
                              ]
        
        HUD.show()
        request(taskPool_getFltNo_url, parameters: d, successHandler: { [weak self](res) in
            HUD.dismiss()
            guard let strongSelf = self else {return}
            if let arr = res["body"] as? [String] {
                strongSelf._flts = arr;
            }
        }) 
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
