//
//  ReportBaseInfoCell.swift
//  mcs
//
//  Created by gener on 2018/4/25.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ReportBaseInfoCell: UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var transferredBtn: UIButton!
    @IBOutlet weak var transferred_tf: UITextField!
    @IBOutlet weak var release_btn: UIButton!
    @IBOutlet weak var release_tf: UITextField!
    @IBOutlet weak var fltNo_btn: UIButton!
    @IBOutlet weak var fltDate_btn: UIButton!
    @IBOutlet weak var shift_btn: UIButton!
    @IBOutlet weak var shiftDate_btn: UIButton!
    @IBOutlet weak var description_tf: UITextView!
    @IBOutlet weak var tsm_tf: UITextField!
    @IBOutlet weak var mel_tf: UITextField!
    @IBOutlet weak var amm_tf: UITextField!    
    @IBOutlet weak var detail_tf: UITextView!
    @IBOutlet weak var detail_: UILabel!
    @IBOutlet weak var tempAction_tf: UITextView!
    @IBOutlet weak var tempAction_: UILabel!
    
    var shift_id:String?
    let disposeBag = DisposeBag.init()
    var flts = [[String:String]]()
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            Tools.showDataPicekr(dataSource:defect_transferred_key) {(obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }
            break
            
        case 2:
            Tools.showDataPicekr(dataSource:defect_release_ref) {(obj) in
                let obj = obj as? String
                guard obj != sender.currentTitle else {return}
                report_refresh_cat = true
                report_release_ref = obj
                sender.setTitle(obj, for: .normal)
            }
            break
            
        case 3:
            guard report_date != nil else { HUD.show(info: "Select Issue Date!"); return}
            guard report_reg != nil else { HUD.show(info: "Select Reg!"); return};
            guard report_station != nil else { HUD.show(info: "Select Station!"); return}
            if flts.count > 0 {
                Tools.showDataPicekr(dataSource:flts) {[weak self](obj) in
                    let obj = obj as! [String:String]
                    sender.setTitle(obj["fltNo"], for: .normal)
                    guard let ss = self else {return}
                    ss.fltDate_btn.setTitle(obj["fltDate"], for: .normal)
                }
            }else {
                request(defect_flightNo_url, parameters: ["fltDate":Tools.dateToString(report_date!, formatter: "yyyy-MM-dd") , "acId":String.isNullOrEmpty(report_reg) , "station":String.isNullOrEmpty(report_station)], successHandler: {[weak self] (res) in
                    guard let arr = res["body"] as? [[String:String]] else {return};
                    guard let ss = self else {return}
                    if arr.count > 0 {
                        ss.flts = arr
                        Tools.showDataPicekr(dataSource:arr) {(obj) in
                            let obj = obj as! [String:String]
                            let fltno = obj["fltNo"]
                            report_flight_no = fltno
                            sender.setTitle(fltno, for: .normal)
                            
                            let fltDateStr = String.isNullOrEmpty(obj["fltDate"])
                            let date = Tools.stringToDate(fltDateStr, formatter: "dd/MM/yyyy")
                            report_flight_date = date
                            ss.fltDate_btn.setTitle(fltDateStr, for: .normal)
                        }
                    }
                    }, failureHandler: { (str) in
                })
            }
            break
        case 4,6:
            Tools.showDatePicekr { (obj) in
                let obj = obj as! Date
                let str = Tools.dateToString(obj, formatter: "dd/MM/yyyy")
                sender.setTitle(str, for: .normal)
            }

            break
        case 5:
            Tools.showDataPicekr(dataSource:Tools.shift()) {[weak self](obj) in
                let _obj = obj as! [String:String]
                sender.setTitle(_obj["value"], for: .normal)
                
                guard let ss = self else {return}
                ss.shift_id = _obj["key"]
            }
            break
        default:break
        }   
 
    }
    
    
    var _descri_code = [String:String]()
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.tag >= 10 else {return true}
        
        var t:String = "AMM"
        if textField.tag == 10 {
            guard let _t = release_btn.currentTitle , _t == "AMM" || _t == "MEL" else {return true};
            t = _t
        }else {
            if textField.tag == 20 {
                t = "TSM"
            }else if textField.tag == 21 {
                t = "MEL"
            }
        }
        
        
        let v = DefectSearchCodeController()
        v.docType = t
        v.cellSelectedAction = {[weak self] m in
            guard let ss = self else {return}
            
            if m is AMMModel {
                let _m = m as! AMMModel;
                textField.text = _m.taskCode;
                ss._descri_code["\(textField.tag)"] = _m.taskName
                
                //ss.description_tf.text =  (ss.description_tf.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? (ss.description_tf.text + "\n") : ss.description_tf.text) +  _m.taskName
            }else if m is MELModel{
                let _m = m as! MELModel;
                textField.text = _m.code;
                ss._descri_code["\((textField.tag == 10 || textField.tag == 21) ? "10" : "10")"] = _m._description
                if textField.tag == 10 {
                    ss.mel_tf.text = _m.code;
                }else if textField.tag == 21 {
                    if let res = ss.release_btn.currentTitle , res == "MEL"{
                        ss.release_tf.text = _m.code;
                    }
                }
                
            }else {
                let _m = m as! TSMModel;
                textField.text = _m.code;
                ss._descri_code["\(textField.tag)"] = _m.message
            }
            
            var s = "";
            for (_ ,v) in ss._descri_code{ s = (s.lengthOfBytes(using: String.Encoding.utf8) > 0 ? (s + "\n") : "") + v }
            ss.description_tf.text = s
        }
        
        Tools.showVC(v, frame: CGRect (x: 0, y: 0, width: 500, height: 600))
        return false
    }
    
    
    @IBAction func _clear(_ sender: UIButton) {
        let tag = sender.tag
        _descri_code.removeValue(forKey: "\(tag == 21 ? 10 : tag)")
        
        if let tf = bg.viewWithTag(tag) as? UITextField {
            tf.text = nil;
        }
        
        var s = "";
        for (_ ,v) in _descri_code{ s = (s.lengthOfBytes(using: String.Encoding.utf8) > 0 ? (s + "\n") : "") + v }
        description_tf.text = s
        
    }
    
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _init()
    }


    func _init(){
        let today = Tools.dateToString(Date(), formatter: "dd/MM/yyyy");
        fltDate_btn.setTitle(today, for: .normal)
        shiftDate_btn.setTitle(today, for: .normal)
        
        release_btn.rx.controlEvent(UIControlEvents.touchUpInside).subscribe { [weak self](event) in
            guard let ss = self else {return}
            ss.release_tf.text = nil
            ss.release_tf.resignFirstResponder()            
        }.addDisposableTo(disposeBag)
        
    }
    
    func fill(_ d:[String:Any]?) {
        guard let _d = d else {return}
        let _reg = _d["flNo"] as? String
        fltNo_btn.setTitle(_reg, for: .normal)
        
        let _station = _d["flDate"] as? String
        fltDate_btn.setTitle(_station, for: .normal)
        
    }

    
    func isNRR(_ b:Bool) {
        mel_tf.isHidden = b
        amm_tf.isHidden = b
        
        tempAction_tf.isHidden = b
        tempAction_.isHidden = b
        detail_.text = b ? "Remark" : "Defect Detail"
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
