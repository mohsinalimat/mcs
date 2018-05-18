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
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        if sender.tag == 1{//reset
            _reset();
        }else {//query
            let d:[String:Any] = ["bizNo":String.isNullOrEmpty(defectNo.text),
                     "flNo":String.isNullOrEmpty(fltNo.text),
                     "reportType":_defect_type ?? "",
                     "acs":_reg ?? [],
                     "sts":_defectStatus,
                     "description":String.isNullOrEmpty(descri.text)]
            
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

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = kTableviewBackgroundColor
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        s_pending.rx.controlEvent(UIControlEvents.valueChanged).subscribe {[weak self] (e) in
            guard let ss  = self else {return}
            if ss.s_pending.isOn {
                ss.statuss.text = "initial" //....
                ss._defectStatus = ["offline"];
            }else {
                ss.statuss.text = "" //....
                ss._defectStatus.removeAll()
            }
            
        }.addDisposableTo(disposeBag)

    }

    func _reset() {
        s_pending.isOn = false
        defectNo.text = nil
        fltNo.text = nil
        defectType.text = nil
        reg.text = nil
        statuss.text = nil
        descri.text = nil
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
                let path = Bundle.main.url(forResource: "defectConstants", withExtension: "plist")
                let d = NSDictionary.init(contentsOf: path!)
                if let arr = d?[indexPath.row == 4 ? "defect_type" : "offline"] as? [[String:String]] {//....
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
                    for i in _o {
                            s = s + "\(i["value"]!),";
                        
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

                    
                    /*let _o = obj as! [String:String]
                    if indexPath.row == 4 {
                        ss._defectType = _o
                        ss.defectType.text = _o["value"]
                    }else {
                        ss._defectStatus = _o;
                        ss.statuss.text = _o["value"]
                    }*/
                    
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
