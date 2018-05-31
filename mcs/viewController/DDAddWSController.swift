//
//  DDAddWSController.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDAddWSController: BasePickerViewController {

    @IBOutlet weak var rq_no: UITextField!
    @IBOutlet weak var pn: UITextField!
    @IBOutlet weak var pn_type: UIButton!
    @IBOutlet weak var pn_des: UITextField!
    @IBOutlet weak var pn_data: UITextField!
    @IBOutlet weak var stas: UIButton!
    @IBOutlet weak var associate_no: UITextField!
    @IBOutlet weak var schedule_date: UIButton!
    @IBOutlet weak var maual: UITextField!
    @IBOutlet weak var part_change: UITextField!
    @IBOutlet weak var po: UITextField!
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var arri_date: UIButton!
    @IBOutlet weak var remark: UITextField!
    var ws_stas:String?
    
    var selectedAction:(([String:String]) -> Void)?
    
    let stas_arr : [[String:String]] = {
        if let arr = plist_dic["dd_ws_status"] as? [[String:String]] {
            return arr
        }
        
        return [];
    }()

    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            Tools.showDataPicekr(self,dataSource:["R","C"]) {(obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }
            break
        case 2:
            Tools.showDataPicekr(self,dataSource:stas_arr) {[weak self] (obj) in
                let obj = obj as! [String:String]
                sender.setTitle(obj["value"], for: .normal)
                
                guard let ss = self else {return}
                ss.ws_stas = obj["key"]
            }
            break
        case 3,4:
            Tools.showDatePicekr(self) { (obj) in
                let obj = obj as! Date
                let str = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
                sender.setTitle(str, for: .normal)
            }
            break
        default: break
        }
        
    }
    
    
    
    override func finishedBtnAction() {
        if let action = selectedAction {
            let d = ["rqNo":String.isNullOrEmpty(rq_no.text),
                     "pnNo":String.isNullOrEmpty(pn.text),
                     "pnType":String.isNullOrEmpty(pn_type.currentTitle),
                     "pnDes":String.isNullOrEmpty(pn_des.text),
                     "pnAta":String.isNullOrEmpty(pn_data.text),
                     "status":String.isNullOrEmpty(stas.currentTitle),//..
                    "associateNo":String.isNullOrEmpty(associate_no.text),
                    "scheduleDate":String.isNullOrEmpty(schedule_date.currentTitle),
                    "manual":String.isNullOrEmpty(maual.text),
                    "partChange":String.isNullOrEmpty(part_change.text),
                    "po":String.isNullOrEmpty(po.text),
                    "qty":String.isNullOrEmpty(qty.text),
                    "arrivalDate":String.isNullOrEmpty(arri_date.currentTitle),
                    "remark":String.isNullOrEmpty(remark.text)
            ];
            
            action(d)
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    
    override func headTitle() -> String? {
        return "Add WS"
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
