//
//  TaskAddActionVC.swift
//  mcs
//
//  Created by gener on 2018/4/4.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class TaskAddActionVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var s_performed: UISwitch!
    
    @IBOutlet weak var s_closed: UISwitch!
    
    @IBOutlet weak var btn_save: UIButton!
    
    @IBOutlet weak var _tableView: UITableView!

    var read_only:Bool = false
    var r_index:Int = 0
    
    var from_defect_report:Bool = false
    
    var action_detail_info_r = [String:Any]()
    var bizPartList_r:[[String:Any]]?
    
    
    var section2_selected_index:Int = 1;
    var reportInfoCell:AddActionInfoCell!
    var actionBaseInfoCell:Action_Detail_Cell!
    
    let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Action";
        view.backgroundColor = UIColor.white
        
        _tableView.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        _initSubview()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.dismiss()
    }
    
    func _initSubview()  {
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "AddActionInfoCell", bundle: nil), forCellReuseIdentifier: "AddActionInfoCellIdentifier")
        _tableView.register(UINib (nibName: "Action_Detail_Cell", bundle: nil), forCellReuseIdentifier: "Action_Detail_CellIdentifier")
        _tableView.register(UINib (nibName: "Action_Materal_Cell", bundle: nil), forCellReuseIdentifier: "Action_Materal_CellIdentifier")
        _tableView.register(UINib (nibName: "AddActionInfoCell_R", bundle: nil), forCellReuseIdentifier: "AddActionInfoCell_RIdentifier")
        _tableView.register(UINib (nibName: "Action_Detail_Cell_R", bundle: nil), forCellReuseIdentifier: "Action_Detail_Cell_RIdentifier")
        
        addActionMateralDataArr.removeAll()
        addActionComponentDataArr.removeAll()
        
        if read_only {
            s_performed.isUserInteractionEnabled = false;
            s_closed.isUserInteractionEnabled = false
            s_performed.isOn = false
            s_closed.isOn = false
            
            btn_save.isHidden = true
            title = "Action \(r_index)"
            s_performed.isOn = String.isNullOrEmpty(action_detail_info_r["perform"]) == "1" ? true : false
            s_closed.isOn = String.isNullOrEmpty(action_detail_info_r["closed"]) == "1" ? true : false
            
            if let partlist = action_detail_info_r["partList"] as? [[String:String]] {
                addActionComponentDataArr = partlist;
            }
            
//            if let bizlist = action_detail_info_r["bizPartList"] as? [[String:String]] {
//                addActionMateralDataArr = bizlist;
//            }
            if let bizlist = bizPartList_r {
                addActionMateralDataArr = bizlist;
            }

        }
        
        _tableView.reloadData()
        _tableView.layoutIfNeeded()
        
        _fillCell()
    }
    
    func _fillCell()  {
        if !read_only {//Add Action
            reportInfoCell.actBy.text = Tools.loginUserName()
            reportInfoCell.reportBy.text = Tools.loginUserName()
            
            if kTaskpool_date != nil && kTaskpool_shift != nil && kTaskpool_station != nil {
                reportInfoCell.shift.setTitle(kTaskpool_shift?["value"], for: .normal)
                reportInfoCell.shiftDate.setTitle(Tools.dateToString(kTaskpool_date!, formatter: "dd/MM/yyyy"), for: .normal)
                
                actionBaseInfoCell.dateTime.setTitle(Tools.dateToString(Date(), formatter: "dd/MM/yyyy"), for: .normal)
                actionBaseInfoCell.station.setTitle(kTaskpool_station, for: .normal)
            }

            
            //操作绑定
            let observable = actionBaseInfoCell.descri.rx.text.orEmpty.map({$0.lengthOfBytes(using: String.Encoding.utf8) > 0 }).shareReplay(1)
            observable.bindTo(s_performed.rx.value).addDisposableTo(disposeBag)
            observable.bindTo(s_closed.rx.isEnabled).addDisposableTo(disposeBag)
            observable.filter{!$0}.bindTo(s_closed.rx.value).addDisposableTo(disposeBag)
            
            s_performed.rx.value.asObservable().bindTo(s_closed.rx.isEnabled).addDisposableTo(disposeBag)
            s_performed.rx.value.asObservable().filter{!$0}.bindTo(s_closed.rx.value).addDisposableTo(disposeBag)
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        showMsg("Save This Action?", title: "Save", handler: {[weak self] in
            guard let ss = self else {return}
            ss._save()
        })

    }

    func _save() {
        guard String.stringIsNullOrNil(actionBaseInfoCell.descri.text).lengthOfBytes(using: String.Encoding.utf8) > 0 else { HUD.show(info: "Action Description Required!");return}
        
        var params : [String:Any] = [
            "perform":"\(s_performed.isOn ? 1 : 0)",
            "closed":"\(s_closed.isOn ? 1 : 0)",
            
            /*reaport info*/
            "actBy" : String.stringIsNullOrNil(reportInfoCell.actBy.text) ,
            "reportBy": String.stringIsNullOrNil(reportInfoCell.reportBy.text),
            "shift": String.stringIsNullOrNil(reportInfoCell.shift_id),
            "shiftDate": String.stringIsNullOrNil(reportInfoCell.shiftDate.currentTitle),
            "team": String.stringIsNullOrNil(reportInfoCell.team_id),
            
            /*action basic info*/
            "flNo":String.stringIsNullOrNil(actionBaseInfoCell.fltNo.text),
            "dateType":String.stringIsNullOrNil(actionBaseInfoCell.area.currentTitle?.lowercased()),
            "actionDate":String.stringIsNullOrNil(actionBaseInfoCell.dateTime.currentTitle),
            "mainHour": String.stringIsNullOrNil(actionBaseInfoCell.mh.text),
            "station": String.stringIsNullOrNil(actionBaseInfoCell.station.currentTitle),
            "actionDetail": String.stringIsNullOrNil(actionBaseInfoCell.descri.text),
            "actionRef":String.stringIsNullOrNil(actionBaseInfoCell.ref.text),
            "page":String.stringIsNullOrNil(actionBaseInfoCell.page.text),
            "item":String.stringIsNullOrNil(actionBaseInfoCell.item.text),
        ]
        
        guard !from_defect_report else {//From Report
            params["bizPartList"] = addActionMateralDataArr;
            params["partList"] = addActionComponentDataArr;
            defect_added_actions.append(params)
            
            NotificationCenter.default.post(name: NSNotification.Name (rawValue: "add_materialOrComponent_notification"), object: nil)
            _ = self.navigationController?.popViewController(animated: true)
            return
        }

        guard let bzid = taskPoolSelectedTask["bizId"] as? String else {return}
        guard let acreg = taskPoolSelectedTask["ac"] as? String else {return}
        let url = taskPool_addAction_url.appending(bzid)
        
        params["acReg"] = acreg
        
        /*material-tools*/
        for (key,value) in encodingParameters(addActionMateralDataArr, key: "bizPartList") {
            params[key] = value;
        }
        
        for (key,value) in encodingParameters(addActionComponentDataArr, key: "partList") {
            params[key] = value;
        }
        
        HUD.show()
        netHelper_request(withUrl: url, method: .post, parameters: params, successHandler: {[weak self] (res) in
            HUD.show(successInfo: "Add success")
            
            guard let ss = self else {return}
            NotificationCenter.default.post(name: NSNotification.Name (rawValue: "addActionSubmintOkNotification"), object: nil)
            
            _ = ss.navigationController?.popViewController(animated: true)
        }) { (str) in
            HUD.show(info: str ?? "Request Error")
            
        }

    }
    
    
    
    
//    func encodingParameters(_ arr :[[String:String]], key:String) -> [String:String] {
//        var _new = [String:String]()
//        
//        for index in 0..<arr.count {
//            let d = arr[index];
//            for (_key,value) in d {
//                _new["\(key)[\(index)].\(_key)"] = value;
//            }
//            
//        }
//        
//        return _new;
//    }
    
    //MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if read_only {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddActionInfoCell_RIdentifier", for: indexPath) as! AddActionInfoCell_R
                cell.fill(action_detail_info_r)

                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddActionInfoCellIdentifier", for: indexPath) as! AddActionInfoCell
                
                reportInfoCell = cell
                
                return cell
            }

        }
        
        if section2_selected_index == 1 {
            if read_only {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Action_Detail_Cell_RIdentifier", for: indexPath) as! Action_Detail_Cell_R
                cell.fill(action_detail_info_r)

                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Action_Detail_CellIdentifier", for: indexPath) as! Action_Detail_Cell
                actionBaseInfoCell = cell
                return cell
            }

        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Action_Materal_CellIdentifier", for: indexPath) as! Action_Materal_Cell
        cell.read_only = read_only
        cell.info = action_detail_info_r
        cell._tableView.reloadData()
        
        return cell
    }
    
    
    
    // MARK: - Table view data source
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section > 0  else {return 180}
        
        return indexPath.row != 0 ? 0 : kCurrentScreenHeight - 180 - 220
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let v = Bundle.main.loadNibNamed("TaskActionTopView", owner: nil, options: nil)?.first as! UIView
            return v
        }
        
        let bg = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 50))

        let t = __sectionTitle()
        let v = MultiButtonView.init(CGRect (x: 15, y: 0, width: bg.frame.width - 30, height: bg.frame.height), titles: t , selectedIndex : section2_selected_index, width:(bg.frame.width - 240) / CGFloat.init(t.count))
        
        v.title = "Action Detail"
        v.selectedActionHandler = { index in
            DispatchQueue.main.async {[weak self ] in
                guard let ss = self else {return}
                ss.section2_selected_index = index

                kSectionHeadButtonSelectedIndex = SectionHeadButtonIndex(rawValue: (ss.from_defect_report && index == 2) ? index + 1 : index)!
                tableView.reloadData()
            }
        }
        
        bg.addSubview(v);return bg
        
//        let v = Bundle.main.loadNibNamed("TaskActionDetailView", owner: nil, options: nil)?.first as! TaskActionDetailView
//        v.changeActionHandler = {[weak self ] index in
//            guard let ss = self else {return}
//            ss.section2_selected_index = index
//            kSectionHeadButtonSelectedIndex = SectionHeadButtonIndex(rawValue: index)!
//            tableView.reloadData()
//        }
//        
//        v._selectedBtnAtIndex(section2_selected_index)
        
//        return v
        
    }

    
    func __sectionTitle() -> [String] {
        if from_defect_report {
            return ["Basic Info & Detail","Component Change"];
        }
        
        return ["Basic Info & Detail","Materal&Tools","Component Change"]
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
