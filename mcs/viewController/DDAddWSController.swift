//
//  DDAddWSController.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDAddWSController: BasePickerViewController {

    var isR:Bool = false
    var dic:[String:Any]!
    
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
    
    
    let status_key = ["Initial":"0",
                      "Pending":"1",
                      "Sourcing":"2",
                      "RO":"3",
                      "PO":"4",
                      "LO":"5",
                      "LM":"6",
                      "Part Arrived":"7",
                      "Available":"8",
                      "Cancelled":"9"]
    
    override func finishedBtnAction() {
        if !isR {
            if let action = selectedAction {
                let d = ["rqNo":String.isNullOrEmpty(rq_no.text),
                         "pnNo":String.isNullOrEmpty(pn.text),
                         "pnType":String.isNullOrEmpty(pn_type.currentTitle),
                         "pnDes":String.isNullOrEmpty(pn_des.text),
                         "pnAta":String.isNullOrEmpty(pn_data.text),
                         "status":String.isNullOrEmpty(status_key[stas.currentTitle!]),
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

        }

        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isR{
            _fillData(dic);
        }
    }

    
    func _fillData(_ d:[String:Any]) {
        rq_no.text = String.isNullOrEmpty(d["rqNo"])
        pn.text = String.isNullOrEmpty(d["pnNo"])
        pn_type.setTitle(String.isNullOrEmpty(d["pnType"]), for: .normal)
        pn_des.text = String.isNullOrEmpty(d["pnDes"])
        pn_data.text = String.isNullOrEmpty(d["pnAta"])
        
        ///status
        let status = String.isNullOrEmpty(d["status"])
        for (k ,v) in status_key {
            if status == v {
                stas.setTitle(k, for: .normal)
                break;
            }
        }
        
        associate_no.text = String.isNullOrEmpty(d["associateNo"])
        
        let _eta = Tools.date(String.stringIsNullOrNil(d["scheduleDate"]))
        if let d = _eta {
            schedule_date.setTitle(Tools.dateToString(d, formatter: "dd/MM/yyyy"), for: .normal)
        }

        maual.text = String.isNullOrEmpty(d["manual"])
        part_change.text = String.isNullOrEmpty(d["partChange"])
        po.text = String.isNullOrEmpty(d["po"])
        qty.text = String.isNullOrEmpty(d["qty"])
        
        let arri = Tools.date(String.stringIsNullOrNil(d["arrivalDate"]))
        if let d = arri {
            arri_date.setTitle(Tools.dateToString(d, formatter: "dd/MM/yyyy"), for: .normal)
        }

        remark.text = String.isNullOrEmpty(d["remark"])

        ///
        let v = UIView (frame: self.view.frame)
        self.view.addSubview(v)
        self.navigationItem.rightBarButtonItem = nil
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
