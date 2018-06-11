//
//  DefectSearchController.swift
//  mcs
//
//  Created by gener on 2018/4/27.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DefectSearchController: UITableViewController {

    var searchAction:(([String:Any]) -> Void)?
    
    @IBOutlet weak var s_pending: UISwitch!
    
    @IBOutlet weak var defectNo: UITextField!
    
    @IBOutlet weak var fltNo: UITextField!
    
    @IBOutlet weak var defectType: UILabel!
    
    @IBOutlet weak var reg: UILabel!
    
    @IBOutlet weak var statuss: UILabel!
    
    @IBOutlet weak var descri: UITextField!
    
    var _defect_type:String?
    var hasSelected:[String:Any]?
    
    var _all_status:[[String:String]]!
    var _userRole:String!
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        if sender.tag == 1{//reset
            _reset();
        }else {//query
            let d:[String:Any] = ["bizNo":String.isNullOrEmpty(defectNo.text),
                     "flNo":String.isNullOrEmpty(fltNo.text),
                     "reportType":_defect_type ?? "",
                     "acs":_reg ?? [],
                     "sts":_defectStatus,
                     "description":String.isNullOrEmpty(descri.text),
                     "isOn":s_pending.isOn]
            
            if let search = searchAction{
                search(d);
            }
            
            _dismiss();
        }

    }
    
    
    var _defectType = [String]()//key
    var _defectStatus = [String]()//key
    
    var _reg:[String]?
    
    let disposeBag = DisposeBag.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _userRole = Tools.user_role()
        _all_status = plist_dic[_userRole] as! [[String:String]]
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = kTableviewBackgroundColor
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        s_pending.rx.controlEvent(UIControlEvents.valueChanged).subscribe {[weak self] (e) in
            guard let ss  = self else {return}
            if ss.s_pending.isOn {
                if ss._userRole == "offline" {
                    let first  = ss._all_status[0]
                    ss.statuss.text = first["value"]
                    ss._defectStatus = [first["key"]!];
                }else {
                    let first  = ss._all_status[0]
                    let sec  = ss._all_status[2]
                    
                    ss.statuss.text = first["value"]! + ",\(sec["value"]!)"
                    ss._defectStatus = [first["key"]! , sec["key"]!];
                }
                
            }else {
                ss.statuss.text = ""
                ss._defectStatus.removeAll()
            }
            
        }.addDisposableTo(disposeBag)

        ///
        _fill()
    }

    func _fill() {
        guard let pars = hasSelected else {return}
        if let ison = pars["isOn"] as? Bool {
            s_pending.isOn = ison;
        }
        
        if let defectno = pars["bizNo"] as? String{
            defectNo.text = defectno
        }
        
        if let fltno =  pars["flNo"] as? String {
            fltNo.text = fltno;
        }
        
        if let defect_type = pars["reportType"] as? String {
            _defect_type = defect_type;
            defectType.text = defect_type
        }
        
        
        if let acs = pars["acs"] as? [String] {
            _reg = acs;
            reg.text = acs.joined(separator: ",")
        }
        
        if let status = pars["sts"] as? [String]{
            _defectStatus = status;
            
            //..
            var v = [String]()
            for s in _defectStatus {
                for t in _all_status {
                    if t["key"] == s {
                        v.append(t["value"]!);continue
                    }
                }
            }
            statuss.text = v.joined(separator: ",")
        }
        
        if let des = pars["description"] as? String {
            descri.text = des;
        }

    }
    
    
    func _reset() {
        s_pending.isOn = false
        defectNo.text = nil
        fltNo.text = nil
        defectType.text = nil
        reg.text = nil
        statuss.text = nil
        descri.text = nil
        
        _defectStatus = []
        _defect_type = nil
        _reg = []
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 8 else {
            guard (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6) else {return}
            let v = SearchItemSelectController()
            
            switch indexPath.row {
            case 4 ,6:
                if indexPath.row == 6 && s_pending.isOn && _userRole == "lm_leader" {return}
                if let arr = plist_dic[indexPath.row == 4 ? "defect_type" : _userRole] as? [[String:String]] {
                    v.dataArray = arr
                }
                
                if indexPath.row == 4 {
                    v.selectedObjs = _defectType;
                    v.dataType = .defect
                }else {
                    v.selectedObjs = _defectStatus;
                    v.dataType = .status
                }
                
                v.selectedHandle = {[weak self] obj in
                    guard let ss = self else {return}
                    let _o = obj as! [[String:String]]
                    var s = ""
                    if indexPath.row == 6 { ss._defectStatus.removeAll(); }
                    
                    for _i in 0..<_o.count{
                        let i = _o[_i];
                        s = s + (_i == 0 ? "\(i["value"]!)" : ",\(i["value"]!)");
                        if indexPath.row == 4 {
                            ss._defectType.append("\(i["key"]!)")
                            ss._defect_type = "\(i["key"]!)"
                        }else {
                            ss._defectStatus.append("\(i["key"]!)")
                        }
                    }
                    
                    if indexPath.row == 4 {
                        ss.defectType.text = s
                    }else {
                        ss.statuss.text = s
                    }
 
                }
                
                break
                
            case 5:
                v.dataArray = Tools.acs()
                v.dataType = SelectDataType.ac
                v.selectedHandle = {[weak self] obj in
                    guard let ss = self else {return}
                    let _o = obj as! [String]
                    ss._reg = _o
                    
                    let str = _o.joined(separator: ",");
                    ss.reg.text = str;
                }
                
                if let a = _reg{
                    v.selectedObjs = a;
                }
                
                break
            default:break
            }
            
            
            self.navigationController?.pushViewController(v, animated: true);return
        }
        
        _dismiss();
    }

    func _dismiss() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let ss = self else {return}
            ss.view.frame = CGRect (x:ss.view.frame.maxX, y: 0, width: ss.view.frame.width, height: ss.view.frame.height)
        }) { [weak self](b) in
            guard let ss = self else {return}
            ss.navigationController?.view.removeFromSuperview()
            ss.navigationController?.removeFromParentViewController()

            UIApplication.shared.keyWindow?.viewWithTag(1001)?.removeFromSuperview()
        }

    }
    
}
