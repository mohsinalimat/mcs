//
//  DefectSearchController.swift
//  mcs
//
//  Created by gener on 2018/4/27.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DefectSearchController: UITableViewController {


    @IBOutlet weak var s_pending: UISwitch!
    
    @IBOutlet weak var defectNo: UITextField!
    
    @IBOutlet weak var fltNo: UITextField!
    
    @IBOutlet weak var defectType: UILabel!
    
    @IBOutlet weak var reg: UILabel!
    
    @IBOutlet weak var statuss: UILabel!
    
    @IBOutlet weak var descri: UITextField!
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        if sender.tag == 1{//reset
            _reset();
        }else {//query
            _dismiss();
        }

    }
    
    
    var _defectType:[String:String]?
    var _defectStatus:[String:String]?
    var _reg:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = kTableviewBackgroundColor
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
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
                let path = Bundle.main.url(forResource: "defectStatus", withExtension: "plist")
                let d = NSDictionary.init(contentsOf: path!)
                if let arr = d?[indexPath.row == 4 ? "offline" : "defect_type"] as? [[String:String]] {
                    v.dataArray = arr
                }
                
                if indexPath.row == 4 {
                    if let type = _defectType {
                        v.selectedObjs = type;
                        v.dataType = .defect
                    }
                }else {
                    if let type = _defectStatus {
                        v.selectedObjs = type;
                        v.dataType = .status
                    }
                }
                
                v.selectedHandle = {[weak self] obj in
                    guard let ss = self else {return}
                    let _o = obj as! [String:String]
                    if indexPath.row == 4 {
                        ss._defectType = _o
                        ss.defectType.text = _o["value"]
                    }else {
                        ss._defectStatus = _o;
                        ss.statuss.text = _o["value"]
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
    
    
    
    
    deinit {
        print("...")
    }

}
