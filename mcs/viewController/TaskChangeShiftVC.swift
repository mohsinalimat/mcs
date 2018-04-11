//
//  TaskChangeShiftVC.swift
//  mcs
//
//  Created by gener on 2018/4/2.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension UIButton{
    var ex_isEnabled:AnyObserver<Bool>{
        return UIBindingObserver(UIElement: self) { button, valid in
            button.isEnabled = valid
            }.asObserver()
    }
}


class TaskChangeShiftVC: BaseViewController {

    @IBOutlet weak var shift: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var reason: UILabel!
    
    @IBOutlet weak var btn_ok: UIButton!
    

    let disposeBag = DisposeBag()
    var rx_shift: Variable<String> = Variable("")
    var rx_time: Variable<String> = Variable("")
    var rx_reason: Variable<String> = Variable("")

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        _setTitleView("Update Group Info")

        let r1 = rx_shift.asObservable().map({ $0.lengthOfBytes(using: String.Encoding.utf8) > 0 }).shareReplay(1)
        let r2 = rx_time.asObservable().map({ $0.lengthOfBytes(using: String.Encoding.utf8) > 0 }).shareReplay(1)
        let r3 = rx_reason.asObservable().map({ $0.lengthOfBytes(using: String.Encoding.utf8) > 0 }).shareReplay(1)
        
        Observable.combineLatest(r1,r2,r3){$0 && $1 && $2}.bindTo(btn_ok.ex_isEnabled).addDisposableTo(disposeBag)
        
        btn_ok.rx.controlEvent(UIControlEvents.touchUpInside).subscribe {[weak self] event in
            guard let strongSelf = self else {return};
            strongSelf._request()
        }.addDisposableTo(disposeBag)
        
    }

    
    func _request() {
        guard let taskid = taskPoolSelectedTask["taskId"] as? String else {return}
        
        var d:[String:Any] = ["taskId":taskid,
                 "shiftId":rx_shift.value,
                 "scheduleTime":rx_time.value,
                "changeReason":rx_reason.value
        ]
        
        if let type = taskPoolSelectedTask["taskType"] as? String  , let cld = taskPoolSelectedTask["taskType"]{
            if type == "MIS" {
                d["bizClosed"] = "\(cld)"

            }
        }
        
        
        HUD.show()
        request(taskPool_changeShift_url, parameters: d, successHandler: { [weak self](res) in
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
    
    
    @IBAction func selectAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            Tools.showShiftPicekr(self) { [weak self](obj) in
                guard let strongSelf = self else {return}
                
                let obj = obj as! [String:String]
                //kTaskpool_shift = obj
                strongSelf.shift.text = obj["value"]
                strongSelf.rx_shift.value = obj["key"]!
                
            }

            break
            
        case 2:
            Tools.showDatePicekr(self) {[weak self] (obj) in
                let obj = obj as! Date
                //kTaskpool_date = obj
                
                let str = Tools.dateToString(obj, formatter: "yyyy-MM-dd")
                guard let strongSelf = self else {return}
                strongSelf.time.text = str
                strongSelf.rx_time.value = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
            }

            break

        case 3:
            let v = TaskChangeShiftReasonVC()
            
            v.oldStr = reason.text
            
            v.completionHandler = {[weak self] str in
                guard let strongSelf = self else {return}
                strongSelf.reason.text = str
                strongSelf.rx_reason.value = str
            }
            
            self.navigationController?.pushViewController(v, animated: true)
            break

        default:break
        }
        
        
    }


    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okAction(_ sender: AnyObject) {
        ///........
        
        
    }
    
    


}
