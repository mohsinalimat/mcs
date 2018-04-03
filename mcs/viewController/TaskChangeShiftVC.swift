//
//  TaskChangeShiftVC.swift
//  mcs
//
//  Created by gener on 2018/4/2.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskChangeShiftVC: BaseViewController {

    @IBOutlet weak var shift: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var reason: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        _setTitleView("Update Group Info")

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
            }

            break
            
        case 2:
            Tools.showDatePicekr(self) {[weak self] (obj) in
                let obj = obj as! Date
                //kTaskpool_date = obj
                
                let str = Tools.dateToString(obj, formatter: "yyyy-MM-dd")
                guard let strongSelf = self else {return}
                strongSelf.time.text = str
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
