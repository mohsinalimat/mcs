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
    @IBOutlet weak var tempAction_tf: UITextView!
    
    
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
                let obj = obj as! String
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
                            sender.setTitle(obj["fltNo"], for: .normal)
                            ss.fltDate_btn.setTitle(obj["fltDate"], for: .normal)
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
            Tools.showDataPicekr(dataSource:Tools.shift()) {(obj) in
                let _obj = obj as! [String:String]
                sender.setTitle(_obj["value"], for: .normal)
            }
            break
        default:break
        }   
 
    }
    
    
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
                ss.description_tf.text =  (ss.description_tf.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? (ss.description_tf.text + "\n") : ss.description_tf.text) +  _m.taskName
            }else if m is MELModel{
                let _m = m as! MELModel;
                textField.text = _m.code;
                ss.description_tf.text =  (ss.description_tf.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? (ss.description_tf.text + "\n") : ss.description_tf.text) +  _m._description
            }else {
                let _m = m as! TSMModel;
                textField.text = _m.code;
                ss.description_tf.text =  (ss.description_tf.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? (ss.description_tf.text + "\n") : ss.description_tf.text) +  _m.message
            }
        }
        
        Tools.showVC(v, frame: CGRect (x: 0, y: 0, width: 500, height: 600))
        return false
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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
