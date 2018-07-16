//
//  ReporFormController.swift
//  mcs
//
//  Created by gener on 2018/4/25.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Alamofire

class ReporFormController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{
    var section2_selected_index:Int = 1;
    var read_only:Bool = false
    var reportId:String?
    var _defect_info:[String:Any]?
    var is_from_warn:Bool = false
    var warnInfo:[String:Any]?
    
    var reportInfoCell:ReportInfoCell!
    var baseInfoCell:ReportBaseInfoCell!
    var ddInfoCell:DDInfoCell!
    var nrrCell:NRRCell!
    
    var current_selected_index = SectionHeadButtonIndex (rawValue: 1)!
    var _current_materialArr = [[String:Any]]()
    var _current_componentArr = [[String:String]]()
    
    var _current_defect_type:String?
    var _current_attachmnetArr = [Any]()
    
    
    @IBOutlet weak var save_bg: UIView!
    @IBOutlet weak var read_bg: UIView!
    @IBOutlet weak var printview_btn: UIButton!
    @IBOutlet weak var form_type: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var _tableView: UITableView!
    
    ///DD Info
    var dd_notice_selected:Bool = false
    var dd_ws_selected:Bool = false
    var dd_wp_selected:Bool = false
    var dd_notice_type:String?
    var dd_notice_cell:UITableViewCell!
    var dd_ws_arr = [[String:Any]]()
    var dd_wp_arr = [[String:Any]]()
    
    //MARK:
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://change type [TS , DD , NRR]
            Tools.showDataPicekr (dataSource:["Defect Report","DD","NRR"]){[weak self] (obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
                guard let ss = self else {return}
                //ss.__clearData();
                ss.section2_selected_index = 1
                ss._current_defect_type = kDefectType[String.isNullOrEmpty(obj)]!
                ss._tableView.reloadData()
            }
            break
            
        case 2://save
            _save(); break
        case 3://save next
            
            break
            
        case 4://read only - view report
            guard let info = _defect_info else {return}
            guard let defect_type = info["reportType"] as? String else {return}
            guard let defect_id = info["id"] as? String else {return}
            let vc = ViewDefectReportController()
            vc.type_id = defect_id
            vc.type = defect_type == "DD" ? "defectDetail ":"ts"
            self.navigationController?.pushViewController(vc, animated: true); break
        default:break
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
         _initSubview()
        
        if read_only {
            title = "Defect Detail"
            _getFalutInfo();
        }else {
            title = "Creat Defect Report"
            save_bg.isHidden = false;
            read_bg.isHidden = true
            
            _current_defect_type = kDefectType[String.isNullOrEmpty(typeBtn.currentTitle)]!
            
            _tableView.reloadData()
            
            NotificationCenter.default.addObserver(self, selector: #selector(ddNoticeTypeChanged(_ :)), name: NSNotification.Name.init("ddNoticeTypeChangedNotification"), object: nil)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        __fillData();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.dismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        __saveData();
    }
    

    func ddNoticeTypeChanged(_ noti:Notification) {
        if let info = noti.userInfo as? [String:String] {
            guard let type = info["type"] else {return}
            dd_notice_type = type;
            
            _tableView.reloadData()
        }
    }
    
    
    
    
    //MARK:
    func _getFalutInfo() {
        guard let _reportid = reportId else {return}
        HUD.show(withStatus: hud_msg_loading)

        request(defect_faultDetail_url, parameters: ["id":_reportid], successHandler: { [weak self](res) in
            HUD.dismiss()
            guard let ss = self else {return}
            guard let dic = res["body"] as? [String:Any] else {return};
            ss._defect_info = dic;
            
            if let material = dic["partList"] as? [[String:Any]] {
                ss._current_materialArr = material
                addActionMateralDataArr = material;
            }
            
            if let attachment = dic["attachments"] as? [[String:Any]] {
                ss._current_attachmnetArr = attachment
                kAttachmentDataArr = attachment
            }
            
            if let attachment = dic["components"] as? [[String:Any]] {
                ddComponentArr = attachment
            }
            
            
            if let actionList = dic["actionList"] as? [[String:Any]] {
                defect_added_actions = actionList;
            }
            
            if let defect_type = dic["reportType"] as? String{
                ss.form_type.text = defect_type
                if defect_type == "NRR" {
                    //ss.printview_btn.isHidden = true;
                }
            }
            
            ss.__fillDD(dic)
            
            
            ss._tableView.reloadData()
            
        }) { (str) in
                HUD.show(info: str ?? "Error")
        }
    }
    
    func _initSubview()  {
        view.backgroundColor = UIColor.white
        _tableView.backgroundColor = UIColor.white
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "ReportInfoCell", bundle: nil), forCellReuseIdentifier: "ReportInfoCellIdentifier")
        _tableView.register(UINib (nibName: "ReportBaseInfoCell", bundle: nil), forCellReuseIdentifier: "ReportBaseInfoCellIdentifier")
        _tableView.register(UINib (nibName: "Action_Materal_Cell", bundle: nil), forCellReuseIdentifier: "Action_Materal_CellIdentifier")
        _tableView.register(UINib (nibName: "AddActionInfoCell_R", bundle: nil), forCellReuseIdentifier: "AddActionInfoCell_RIdentifier")
        _tableView.register(UINib (nibName: "Action_Detail_Cell_R", bundle: nil), forCellReuseIdentifier: "Action_Detail_Cell_RIdentifier")
        _tableView.register(UINib (nibName: "DDInfoCell", bundle: nil), forCellReuseIdentifier: "DDInfoCellIdentifier")
        _tableView.register(UINib (nibName: "DDInfoCell_R", bundle: nil), forCellReuseIdentifier: "DDInfoCell_RIdentifier")
        _tableView.register(UINib (nibName: "NRRCell", bundle: nil), forCellReuseIdentifier: "NRRCellIdentifier")
        _tableView.register(UINib (nibName: "NRRCell_R", bundle: nil), forCellReuseIdentifier: "NRRCell_RIdentifier")
        _tableView.register(UINib (nibName: "ReportInfoCell_R", bundle: nil), forCellReuseIdentifier: "ReportInfoCell_RIdentifier")
        _tableView.register(UINib (nibName: "ReportBaseInfoCell_R", bundle: nil), forCellReuseIdentifier: "ReportBaseInfoCell_RIdentifier")
        _tableView.register(UINib (nibName: "DDNoticeDefaultCell", bundle: nil), forCellReuseIdentifier: "DDNoticeDefaultCellIdentifier")
        _tableView.register(UINib (nibName: "DDNoticeStructureCell", bundle: nil), forCellReuseIdentifier: "DDNoticeStructureCelIdentifier")
        _tableView.register(UINib (nibName: "DDNoticeRestrictionCell", bundle: nil), forCellReuseIdentifier: "DDNoticeRestrictionCelIdentifier")
        _tableView.register(UINib (nibName: "DDNoticeCabinCell", bundle: nil), forCellReuseIdentifier: "DDNoticeCabinCelldentifier")
        _tableView.register(UINib (nibName: "DDWPCell", bundle: nil), forCellReuseIdentifier: "DDWPCellIdentifier")
        _tableView.register(UINib (nibName: "DDWSCell", bundle: nil), forCellReuseIdentifier: "DDWSCellIdentifier")
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellIdentifier")
        _tableView.register(BaseCellWithTable.self, forCellReuseIdentifier: "BaseCellWithTableIdentifier")
        
        __clearData();
        _tableView.reloadData()
        _tableView.layoutIfNeeded()
    }

    private func __clearData() {
        addActionMateralDataArr.removeAll()
        addActionComponentDataArr.removeAll()
        defect_added_actions.removeAll()
        kAttachmentDataArr.removeAll()
        ddComponentArr.removeAll()
        
        ///clear data
        report_refresh_cat = false
        report_reg =  nil
        report_station = nil
        report_date = nil
        report_flight_no = nil
        report_flight_date = nil
        report_release_ref = nil
    }
    
    private func __fillData() {
        kSectionHeadButtonSelectedIndex = current_selected_index
        if !materalDataFromIPC  {
            addActionMateralDataArr = _current_materialArr;
        } else {
            materalDataFromIPC = false;
        }
        
        addActionComponentDataArr = _current_componentArr
        
        guard kSectionHeadButtonSelectedIndex == .creatReportValue5 else {return}
        kAttachmentDataArr = _current_attachmnetArr
        
        _tableView.reloadData()
    }

    private func __saveData() {
        _current_materialArr = addActionMateralDataArr
        _current_componentArr = addActionComponentDataArr
        
        guard kSectionHeadButtonSelectedIndex == .creatReportValue5 else {return}
        _current_attachmnetArr = kAttachmentDataArr
    }
    
    
    func _save() {
        let _is_nrr = (__defect_type() == "NRR")
        
        guard reportInfoCell.reg.currentTitle != nil else { HUD.show(info: "Select Reg!"); return}
        guard reportInfoCell.station.currentTitle != nil else { HUD.show(info: "Select Station!"); return}
        guard reportInfoCell.issueBy.currentTitle != nil else { HUD.show(info: "Select Issue!"); return}
        //guard baseInfoCell.release_btn.currentTitle != nil else { HUD.show(info: "Select Release Ref!"); return}
        guard baseInfoCell.fltNo_btn.currentTitle != nil else { HUD.show(info: "Select Flt No!"); return}
        guard baseInfoCell.detail_tf.text.lengthOfBytes(using: String.Encoding.utf8) > 0 else { HUD.show(info: _is_nrr ? "Input Remark" : "Input Detail!"); return}
        var params  = [
            "reportType":kDefectType[String.isNullOrEmpty(typeBtn.currentTitle)]!,
            "acReg"     :   String.isNullOrEmpty(reportInfoCell.reg.currentTitle),
            "issueBy"   :   String.isNullOrEmpty(reportInfoCell.issueBy.currentTitle),
            "issueDate" :   String.isNullOrEmpty(reportInfoCell.issueDate.currentTitle),
            "station"   :   String.isNullOrEmpty(reportInfoCell.station.currentTitle),
            /*basic info*/
            "tsType"    :   String.isNullOrEmpty(defect_transferred_form[baseInfoCell.transferredBtn.currentTitle ?? " "]) ,
            "tsFrom"    :   String.isNullOrEmpty(baseInfoCell.transferred_tf.text),
            "releaseType":  String.isNullOrEmpty(baseInfoCell.release_btn.currentTitle),
            "releaseItem":  String.isNullOrEmpty(baseInfoCell.release_tf.text),
            "flNo"      :   String.isNullOrEmpty(baseInfoCell.fltNo_btn.currentTitle),
            "flDate"    :   String.isNullOrEmpty(baseInfoCell.fltDate_btn.currentTitle),
            "issueShift":   String.isNullOrEmpty(baseInfoCell.shift_id),
            "issueShiftDate":String.isNullOrEmpty(baseInfoCell.shiftDate_btn.currentTitle),
            "description":  String.isNullOrEmpty(baseInfoCell.description_tf.text),
            "detail"    :   String.isNullOrEmpty(baseInfoCell.detail_tf.text),
            "temporaryDesc":String.isNullOrEmpty(baseInfoCell.tempAction_tf.text),
            "ata"       :   String.isNullOrEmpty(baseInfoCell.tsm_tf.text),
            "melCode"   :   String.isNullOrEmpty(baseInfoCell.mel_tf.text),
            "ammCode"   :   String.isNullOrEmpty(baseInfoCell.amm_tf.text),
            /*material-tools*/
            "pts": addActionMateralDataArr,
            "actionListStr":defect_added_actions
        ] as [String : Any]
        
        
        
        switch __defect_type() {
        case "TS":break
        case "DD":
            ///components
            if ddComponentArr.count > 0 {
                params["componentsListStr"] = ddComponentArr;
            }
           
            
            if ddInfoCell != nil {
                var arr = ddInfoCell.dd_status
                
                //ws
                if dd_ws_arr.count > 0 {
                    params["wsListStr"] = dd_ws_arr;
                }else {
                    if arr.contains("1"){
                        arr.remove(at: arr.index(of: "1")!);
                    }
                }
                
                
                //wp
                if dd_wp_arr.count > 0 {
                    params["wpListStr"] = dd_wp_arr;
                }else {
                    if arr.contains("2"){
                        arr.remove(at: arr.index(of: "2")!);
                    }
                }
                
                let ddstatus        =   arr.count > 0 ? arr.joined(separator: ",") : ""
                params["cat"]       =   String.isNullOrEmpty(ddInfoCell.ddCat_selected ?? "")
                params["deferDay"]  =   String.isNullOrEmpty(ddInfoCell.day_tf.text)
                params["deferFh"]   =   String.isNullOrEmpty(ddInfoCell.fh_tf.text)
                params["deferFc"]   =   String.isNullOrEmpty(ddInfoCell.fc_tf.text)
                params["deferOther"] =  String.isNullOrEmpty(ddInfoCell.other_tf.text)
                params["dateLine"]  =   String.isNullOrEmpty(ddInfoCell.deadline_btn.currentTitle)
                params["enterInDamageChart"] = String.isNullOrEmpty(ddInfoCell.in_chart)
                params["repetitiveAction"] = String.isNullOrEmpty(ddInfoCell.need_repetitive)
                params["repDay"] = String.isNullOrEmpty(ddInfoCell.rep_day.text)
                params["repFh"] = String.isNullOrEmpty(ddInfoCell.rep_fh.text)
                params["repFc"] = String.isNullOrEmpty(ddInfoCell.rep_fc.text)
                params["repMonth"] = String.isNullOrEmpty(ddInfoCell.rep_month.text)
                params["precedureO"] =  String.isNullOrEmpty(ddInfoCell.produce_o)
                params["precedureM"] =  String.isNullOrEmpty(ddInfoCell.produce_m)
                params["enterInDdList"] = String.isNullOrEmpty(ddInfoCell.enterInDdList)
                params["repetitiveDefect"] = String.isNullOrEmpty(ddInfoCell.repetitive_defect)
                params["receiveBy"] =   String.isNullOrEmpty(ddInfoCell.rec_by.currentTitle)
                params["receiveDate"] = String.isNullOrEmpty(ddInfoCell.rec_date.currentTitle)
                params["statusOfDd"] =  ddstatus
                params["umWo"]      =   String.isNullOrEmpty(ddInfoCell.um_tf.text)
                params["ddSource"]  =   String.isNullOrEmpty(ddInfoCell.dd_source.currentTitle)

                //Notice
                params["isShowFailure"] = dd_notice_selected ? "1" : ""
                if dd_notice_selected {
                    let type = dd_notice_type ?? " "
                    switch type {
                    case " ":
                        let cell = dd_notice_cell as! DDNoticeDefaultCell
                        params["type"] = String.isNullOrEmpty(cell.type.text);
                        params["noticeEquip"] = String.isNullOrEmpty(cell.equip.text);
                        params["pos"] = String.isNullOrEmpty(cell.pos.text);
                        params["failureX"] = String.isNullOrEmpty(cell.x.text);
                        params["failurey"] = String.isNullOrEmpty(cell.y.text);
                        params["failureSize"] = String.isNullOrEmpty(cell.size.text);
                        params["failureDetail"] = String.isNullOrEmpty(cell.detail.text);
                        params["noticeSys"] = String.isNullOrEmpty(cell.sys.text);
                        params["restrictionDetail"] = String.isNullOrEmpty(cell.restriction_detail.text);
                        break
                    case "STRUCTURE":
                        let cell = dd_notice_cell as! DDNoticeStructureCell
                        params["failureType"] = "0"
                        params["type"] = String.isNullOrEmpty(cell.type.text);
                        params["pos"] = String.isNullOrEmpty(cell.pos.text);
                        params["failureX"] = String.isNullOrEmpty(cell.x.text);
                        params["failurey"] = String.isNullOrEmpty(cell.y.text);
                        params["failureSize"] = String.isNullOrEmpty(cell.size.text);
                        params["failureDetail"] = String.isNullOrEmpty(cell.detail.text);
                        break
                    case "RESTRICTION":
                        let cell = dd_notice_cell as! DDNoticeRestrictionCell
                        params["failureType"] = "1"
                        params["noticeSys"] = String.isNullOrEmpty(cell.sys.text);
                        params["restrictionDetail"] = String.isNullOrEmpty(cell.restriction_detail.text);
                        break
                    case "CABIN":
                        let cell = dd_notice_cell as! DDNoticeCabinCell
                        params["failureType"] = "2"
                        params["noticeEquip"] = String.isNullOrEmpty(cell.equip.text);
                        params["pos"] = String.isNullOrEmpty(cell.pos.text);
                        params["failureDetail"] = String.isNullOrEmpty(cell.detail.text);
                        break
                    default: break
                    }
                }
            };break;
            
        case "NRR":
            params["detail"] = ""
            params["temporaryDesc"] = ""
            params["melCode"] = ""
            params["ammCode"] = ""            
            params["remark"] = String.isNullOrEmpty(baseInfoCell.detail_tf.text)
            if  nrrCell != nil {
                params["formNo"] = String.isNullOrEmpty(nrrCell.formNo.text)
                params["inspType"] = String.isNullOrEmpty(nrrCell.insp)
                params["skill"] = String.isNullOrEmpty(nrrCell.skil)
                params["nrrStatus"] = String.isNullOrEmpty(nrrCell.status)
            }

            break
        default:break
        }

        HUD.show()
        netHelper_upload(to: BASE_URL + defect_save_fault_url, parameters: params, uploadFiles: kAttachmentDataArr, successHandler: { (res) in
            DispatchQueue.main.async {[weak self] in
                HUD.dismiss()
                
                guard let ss = self else {return}
                ss.__clearData()
                
                NotificationCenter.default.post(name: NSNotification.Name (rawValue: "creatDefectReportSubmintOkNotification"), object: nil)
                
                _ = ss.navigationController?.popViewController(animated: true)
            }
            }) {
                
              HUD.show(info: "Request Error!")
        }
        
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscape;
        }
    }
    
    //MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return (__defect_type() == "DD" && section2_selected_index == 5) ? 4 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != 0 else {return 1}
        guard section != 1 else {return dd_notice_selected && section2_selected_index == 5 ? 2 : 1}
        guard section != 2 else {return dd_ws_selected ? (dd_ws_arr.count > 0 ? dd_ws_arr.count:1) : 0}
        guard section != 3 else {return dd_wp_selected ? (dd_wp_arr.count > 0 ? dd_wp_arr.count:1) : 0}
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if !read_only {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportInfoCellIdentifier", for: indexPath) as! ReportInfoCell
                reportInfoCell = cell
                if is_from_warn {
                    cell.fill(warnInfo);
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportInfoCell_RIdentifier", for: indexPath) as! ReportInfoCell_R
                cell.fill(_defect_info)
                return cell
            }
        }
        

        //section2
        if section2_selected_index == 1 {
            if !read_only {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportBaseInfoCellIdentifier", for: indexPath) as! ReportBaseInfoCell;
                baseInfoCell = cell
                cell.isNRR(__defect_type() == "NRR")
                
                if is_from_warn {
                    cell.fill(warnInfo);
                }
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportBaseInfoCell_RIdentifier", for: indexPath) as! ReportBaseInfoCell_R;
            cell.isNRR(__defect_type() == "NRR")
            cell.fill(_defect_info)
            return cell
        } else if section2_selected_index == 2 || section2_selected_index == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Action_Materal_CellIdentifier", for: indexPath) as! Action_Materal_Cell;
            cell.read_only = read_only
            cell._tableView.reloadData()
            return cell
        }else {
            switch  __defect_type() {
            case "TS":
                if section2_selected_index == 3 {
                    //print("....");
                };break
            case "DD":
                if section2_selected_index == 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Action_Materal_CellIdentifier", for: indexPath) as! Action_Materal_Cell;
                    cell.read_only = read_only
                    cell._tableView.reloadData()
                    return cell
                }
                
                //MARK:DD Cell
                if section2_selected_index == 5 {//DD
                    if read_only && indexPath.section == 1 && indexPath.row == 0 {////R
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DDInfoCell_RIdentifier", for: indexPath) as! DDInfoCell_R;
                        cell.fill(_defect_info)
                        return cell
                    }
                    
                    if indexPath.section == 1 {
                        guard indexPath.row == 0 else {
                            let _id = __ddNoticeTypeCellWithId(dd_notice_type ?? "DDNoticeDefaultCellIdentifier")
                            
                            let cell = tableView.dequeueReusableCell(withIdentifier: _id, for: indexPath) as! DDNoticeBaseCell;
                            if read_only {
                                cell.fill(_defect_info)
                                cell.isReadOnly();
                            }else{
                                dd_notice_cell = cell
                            }

                            return cell
                        }
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DDInfoCellIdentifier", for: indexPath) as! DDInfoCell;
                        ddInfoCell = cell
                        cell.buttonClickedWithIndex = {[weak self] index , selected in
                            guard let ss = self else {return}
                            ss.__ddButtonAction(index, selected: selected)
                        }

                        return cell
                    }else if indexPath.section == 2 {
                        guard dd_ws_arr.count > 0 else { return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellIdentifier", for: indexPath); }
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DDWSCellIdentifier", for: indexPath) as! DDWSCell;
                        let d = dd_ws_arr[indexPath.row]
                        cell.fill(d)
                        
                        return cell
                    }
                    
                    guard dd_wp_arr.count > 0 else { return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellIdentifier", for: indexPath); }
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DDWPCellIdentifier", for: indexPath) as! DDWPCell;
                    let d = dd_wp_arr[indexPath.row]
                    cell.fill(d)
                    return cell
                };break
                
            case "NRR":
                if section2_selected_index == 4 {
                    if !read_only{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NRRCellIdentifier", for: indexPath) as! NRRCell;
                        nrrCell = cell
                        return cell
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NRRCell_RIdentifier", for: indexPath) as! NRRCell_R;
                    cell.fill(_defect_info);
                    return cell
                };break;
            default:break
            }
            
            ///add action
            let cell = tableView.dequeueReusableCell(withIdentifier: "Action_Materal_CellIdentifier", for: indexPath) as! Action_Materal_Cell;
            cell.read_only = read_only
            cell._tableView.reloadData()
            current_selected_index = kSectionHeadButtonSelectedIndex;
            cell.didSelectedRowAtIndex = { index in
                let d = defect_added_actions[index]
                
                HUD.show()
                let vc = TaskAddActionVC()
                vc.read_only = true
                vc.from_defect_report = true
                vc.r_index = index + 1
                vc.action_detail_info_r = d;
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.addAction = {
                HUD.show()
                let vc = TaskAddActionVC()
                vc.from_defect_report = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell;
            
        }

    }
    

    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section > 1 else {return 50}
        guard section != 2 else {return dd_ws_selected ? 50 : 0}
        guard section != 3 else {return dd_wp_selected ? 50 : 0}
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section != 0 else {return 100}
        guard indexPath.section != 1 else {return indexPath.row != 0 ? 180 : kCurrentScreenHeight - 100 - 240}
        guard indexPath.section != 2 else {return 60}
        guard indexPath.section != 3 else {return 50}
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else {
            let v = Bundle.main.loadNibNamed("TaskActionTopView", owner: nil, options: nil)?.first as! UIView
            for s in (v.viewWithTag(100)?.subviews)! {
                if s is UILabel {
                    let _s = s as! UILabel;
                    _s.text = "AirCraft Info"
                }
            }
            return v
        }
        
        guard section != 1 else {
            let bg = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 50))
            let t = _sectionBtnTitle()
            let v = MultiButtonView.init(CGRect (x: 15, y: 0, width: bg.frame.width - 30, height: bg.frame.height), titles: t , selectedIndex : section2_selected_index)
            v.title = "Defect Detail"
            v.selectedActionHandler = { index in
                DispatchQueue.main.async {[weak self ] in
                    guard let ss = self else {return}
                    ss.section2_selected_index = index
                    kSectionHeadButtonSelectedIndex = SectionHeadButtonIndex(rawValue: index + 4)!
                    ss.current_selected_index = kSectionHeadButtonSelectedIndex
                    switch  ss.__defect_type() {
                    case "TS":
                        switch index {
                        case 4:kSectionHeadButtonSelectedIndex = SectionHeadButtonIndex(rawValue: 4 + 5)!;break
                        default:break
                        };break
                        
                    case "DD":
                        switch index {
                        case 4:kSectionHeadButtonSelectedIndex = SectionHeadButtonIndex(rawValue: 10)!;break
                        case 5:kSectionHeadButtonSelectedIndex = SectionHeadButtonIndex(rawValue: 4 + 4)!;break
                        case 6:kSectionHeadButtonSelectedIndex = SectionHeadButtonIndex(rawValue: 4 + 5)!;break
                        default:break
                        };break
                    default:break
                    }
                    
                    tableView.reloadData()
                }
            }
            
            bg.addSubview(v);return bg
        }
        
        guard section != 2 else {
            if !dd_ws_selected {return nil }
            let  v = Bundle.main.loadNibNamed("DDWSHeadView", owner: nil, options: nil)?.first as! DDWSHeadView;
            v.addAction = {
                let v = DDAddWSController()
                v.selectedAction = {[weak self] d in
                    guard let ss = self else {return}
                    ss.dd_ws_arr.append(d)
                    ss._tableView.reloadSections([2], animationStyle: .none)
                    ss._tableView.scrollToRow(at: IndexPath.init(row: ss.dd_ws_arr.count - 1, section: 2), at: .bottom, animated: true)
                }
                
                Tools.showVC(v,frame:CGRect(x: 0, y: 0, width: 800, height: 400))
            }
            
            if read_only {v._isR();}
            
            return v;
        }
        
        guard section != 3 else {
            if !dd_wp_selected {return nil }
            let  v = Bundle.main.loadNibNamed("DDWPHeadView", owner: nil, options: nil)?.first as! DDWPHeadView;
            v.addAction = {
                let v = DDAddWPController()
                v.selectedAction = {[weak self] d in
                    guard let ss = self else {return}
                    ss.dd_wp_arr.append(d)
                    ss._tableView.reloadSections([3], animationStyle: .none)
                    ss._tableView.scrollToRow(at: IndexPath.init(row: ss.dd_wp_arr.count - 1, section: 3), at: .bottom, animated: true)
                }
                
                Tools.showVC(v,frame:CGRect(x: 0, y: 0, width: 600, height: 400))
            }

            if read_only {v._isR();}
            return v;
        }

        
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section > 1 else {return}
        if indexPath.section == 2 {
            guard dd_ws_arr.count > 0 else {return}
            let v = DDAddWSController()
            //if read_only {
                v.isR = read_only;
                let d = dd_ws_arr[indexPath.row]
                v.dic = d
            
            v.selectedAction = { [weak self] dic in
                guard let ss = self else {return}
                ss.dd_ws_arr.remove(at: indexPath.row)
                ss.dd_ws_arr.insert(dic, at: indexPath.row - 1 < 0 ? 0 : indexPath.row)
                tableView.reloadData()
            }
            
            //}
            
            Tools.showVC(v,frame:CGRect(x: 0, y: 0, width: 800, height: 400))
        }else if indexPath.section == 3 {
            guard dd_wp_arr.count > 0 else {return}
            let v = DDAddWPController()
            //if read_only {
                v.isR = read_only;
                let d = dd_wp_arr[indexPath.row]
                v.dic = d
            //}
            v.selectedAction = { [weak self] dic in
                guard let ss = self else {return}
                ss.dd_wp_arr.remove(at: indexPath.row)
                ss.dd_wp_arr.insert(dic, at: indexPath.row - 1 < 0 ? 0 : indexPath.row)
                tableView.reloadData()
            }
            
            
            Tools.showVC(v,frame:CGRect(x: 0, y: 0, width: 600, height: 400))
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard !read_only else {return false}
        guard indexPath.section > 1 else {return false}
        if indexPath.section == 2 {
            return dd_ws_arr.count > 0 ? true:false
        }else if indexPath.section == 3 {
            return dd_wp_arr.count > 0 ? true:false
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 2 {
                dd_ws_arr.remove(at: indexPath.row);
                
            }else if indexPath.section == 3 {
                dd_wp_arr.remove(at: indexPath.row);
            }
            

            tableView.reloadSections([indexPath.section], animationStyle: .none)
        }
    }
    
    
    //MARK: - Private
    func _sectionBtnTitle() -> [String] {
        let type = __defect_type()
        
        switch  type {
        case "TS":return ["Basic Info & Detail","Materal&Tools ","Attachment","Action"]
            
        case "DD":return ["Basic Info & Detail","Materal&Tools ","Attachment","Component", "DD", "Action"]

        case "NRR":return ["Basic Info & Detail","Materal&Tools ","Attachment","NRR","Action"]
        default:break
        }
        
       return []
    }


    ///Defect Type
    func __defect_type() -> String {
        if read_only {return form_type.text ?? ""}
        
        return _current_defect_type ?? ""
    }
    
    func __ddNoticeTypeCellWithId(_ id:String) -> String {
        var s = "DDNoticeDefaultCellIdentifier"
        switch id {
            case "STRUCTURE": s = "DDNoticeStructureCelIdentifier"; break
            case "RESTRICTION": s = "DDNoticeRestrictionCelIdentifier";break
            case "CABIN": s = "DDNoticeCabinCelldentifier";break
            default: break
        }
        
        return s
    }
    
    
    func __ddButtonAction(_ tag:Int , selected:Bool) {
        if tag == 41 {
            dd_ws_selected = selected;
            _tableView.reloadData()
            guard selected else {return}
            _tableView.scrollToRow(at: IndexPath.init(row: 0, section: 2), at: .none, animated: true)
        }else if tag == 42 {
            dd_wp_selected = selected;
            _tableView.reloadData()
            guard selected else {return}
            _tableView.scrollToRow(at: IndexPath.init(row: 0, section: 3), at: .none, animated: true)
        }else if tag == 47 {
            dd_notice_selected = selected;
            _tableView.reloadData()
            _tableView.scrollToRow(at: IndexPath.init(row: selected ? 1 : 0, section: 1), at: .none, animated: true)
        }

    }
    
    
    //MARK: - ReadOnly
    func __fillDD(_ dic:[String:Any]){
        if let ddnotice = dic["isShowFailure"] as? String {
            if ddnotice == "1" {
                dd_notice_selected = true;
            }
        }
        
        if let failureType = dic["failureType"] as? String {
            switch failureType {
            case "0": dd_notice_type = "STRUCTURE";break
            case "1": dd_notice_type = "RESTRICTION";break
            case "2": dd_notice_type = "CABIN";break
            default:break
            }
        }
        
        //ws,wp
        if let ws = dic["wsList"] as? [[String:Any]]{
            dd_ws_arr = ws;
        }
        
        if let wp = dic["wpList"] as? [[String:Any]]{
            dd_wp_arr = wp;
        }
        
        if let dd_status = dic["statusOfDd"] as? String {
            dd_ws_selected =  dd_status.contains("1");
            dd_wp_selected = dd_status.contains("2");
        }
        
    }
    

    //MARK:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
