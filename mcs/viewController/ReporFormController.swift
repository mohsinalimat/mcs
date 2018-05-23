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
    
    var reportInfoCell:ReportInfoCell!
    var baseInfoCell:ReportBaseInfoCell!
    var ddInfoCell:DDInfoCell!
    var nrrCell:NRRCell!
    
    var current_selected_index = SectionHeadButtonIndex (rawValue: 1)!
    var _current_materialArr = [[String:Any]]()
    var _current_defect_type:String?
    var _current_attachmnetArr = [UIImage]()
    
    
    @IBOutlet weak var save_bg: UIView!
    @IBOutlet weak var read_bg: UIView!
    @IBOutlet weak var printview_btn: UIButton!
    @IBOutlet weak var form_type: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var _tableView: UITableView!
    
    //MARK:
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://change type [TS , DD , NRR]
            Tools.showDataPicekr (dataSource:["Defect Report","DD","NRR"]){[weak self] (obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
                guard let ss = self else {return}
                ss.__clearData();
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
    

    //MARK:
    func _getFalutInfo() {
        guard let _reportid = reportId else {return}
        HUD.show(withStatus: hud_msg_loading)

        request(defect_faultDetail_url, parameters: ["id":_reportid], successHandler: { [weak self](res) in
            HUD.dismiss()
            guard let ss = self else {return}
            guard let arr = res["body"] as? [String:Any] else {return};
            ss._defect_info = arr;
            
            if let material = arr["partList"] as? [[String:Any]] {
                ss._current_materialArr = material
                addActionMateralDataArr = material;
            }
            
            if let actionList = arr["actionList"] as? [[String:Any]] {
                defect_added_actions = actionList;
            }
            
            if let defect_type = arr["reportType"] as? String{
                ss.form_type.text = defect_type
                if defect_type == "NRR" {
                    ss.printview_btn.isHidden = true;
                }
            }
            
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
    }
    
    private func __fillData() {
        kSectionHeadButtonSelectedIndex = current_selected_index
        addActionMateralDataArr = _current_materialArr
        
        guard kSectionHeadButtonSelectedIndex == .creatReportValue5 else {return}
        kAttachmentDataArr = _current_attachmnetArr
    }

    private func __saveData() {
        _current_materialArr = addActionMateralDataArr
        
        guard kSectionHeadButtonSelectedIndex == .creatReportValue5 else {return}
        _current_attachmnetArr = kAttachmentDataArr
    }
    
    
    
    func _save() {
        guard reportInfoCell.reg.currentTitle != nil else { HUD.show(info: "Select Reg!"); return}
        guard reportInfoCell.station.currentTitle != nil else { HUD.show(info: "Select Station!"); return}
        guard reportInfoCell.issueBy.currentTitle != nil else { HUD.show(info: "Select Issue!"); return}
        guard baseInfoCell.release_btn.currentTitle != nil else { HUD.show(info: "Select Release Ref!"); return}
        guard baseInfoCell.fltNo_btn.currentTitle != nil else { HUD.show(info: "Select Flt No!"); return}
        guard baseInfoCell.detail_tf.text != nil else { HUD.show(info: "Input Detail!"); return}
        var params  = [
            "reportType":kDefectType[String.isNullOrEmpty(typeBtn.currentTitle)]!,
            "acReg"     :   String.isNullOrEmpty(reportInfoCell.reg.currentTitle),
            "issueBy"   :   String.isNullOrEmpty(reportInfoCell.issueBy.currentTitle),
            "issueDate" :   String.isNullOrEmpty(reportInfoCell.issueDate.currentTitle),
            "station"   :   String.isNullOrEmpty(reportInfoCell.station.currentTitle),
            /*basic info*/
            "tsType"    :   String.isNullOrEmpty(baseInfoCell.transferredBtn.currentTitle) ,
            "tsFrom"    :   String.isNullOrEmpty(baseInfoCell.transferred_tf.text),
            "releaseType":  String.isNullOrEmpty(baseInfoCell.release_btn.currentTitle),
            "releaseItem":  String.isNullOrEmpty(baseInfoCell.release_tf.text),
            "flNo"      :   String.isNullOrEmpty(baseInfoCell.fltNo_btn.currentTitle),
            "flDate"    :   String.isNullOrEmpty(baseInfoCell.fltDate_btn.currentTitle),
            "issueShift":   String.isNullOrEmpty(baseInfoCell.shift_btn.currentTitle),
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
        case "TS": break
        case "DD":
            let ddstatus        =   ddInfoCell.dd_status.count > 0 ? ddInfoCell.dd_status.joined(separator: ",") : ""
            params["cat"]       =   String.isNullOrEmpty(ddInfoCell.ddCat_selected ?? "")
            params["deferDay"]  =   String.isNullOrEmpty(ddInfoCell.day_tf.text)
            params["deferFh"]   =   String.isNullOrEmpty(ddInfoCell.fh_tf.text)
            params["deferFc"]   =   String.isNullOrEmpty(ddInfoCell.fc_tf.text)
            params["deferOther"] =  String.isNullOrEmpty(ddInfoCell.other_tf.text)
            params["dateLine"]  =   String.isNullOrEmpty(ddInfoCell.deadline_btn.currentTitle)
            params["enterInDamageChart"] = String.isNullOrEmpty(ddInfoCell.in_chart)
            params["repetitiveAction"] = String.isNullOrEmpty(ddInfoCell.need_repetitive)
            params["precedureO"] =  String.isNullOrEmpty(ddInfoCell.produce_o)
            params["precedureM"] =  String.isNullOrEmpty(ddInfoCell.produce_m)
            params["enterInDdList"] = String.isNullOrEmpty(ddInfoCell.enterInDdList)
            params["repetitiveDefect"] = String.isNullOrEmpty(ddInfoCell.repetitive_defect)
            params["receiveBy"] =   String.isNullOrEmpty(ddInfoCell.rec_by.currentTitle)
            params["receiveDate"] = String.isNullOrEmpty(ddInfoCell.rec_date.currentTitle)
            params["statusOfDd"] =  ddstatus
            params["umWo"]      =   String.isNullOrEmpty(ddInfoCell.um_tf.text)
            params["ddSource"]  =   String.isNullOrEmpty(ddInfoCell.dd_source.currentTitle)
            break;
        case "NRR":
            params["formNo"] = String.isNullOrEmpty(nrrCell.formNo.text)
            params["inspType"] = String.isNullOrEmpty(nrrCell.insp)
            params["skill"] = String.isNullOrEmpty(nrrCell.skil)
            params["nrrStatus"] = String.isNullOrEmpty(nrrCell.status)
            break
        default:break
        }

        HUD.show()
        var header:HTTPHeaders = [:]
        if let token = user_token as? String {
            header["Authorization"] = token;
            header["content-type"] = "multipart/form-data"
        }
        
        Alamofire.upload(multipartFormData: { (multipartData) in
            for ig in kAttachmentDataArr {
                let data  = UIImageJPEGRepresentation(ig, 0.5);
                if let d = data {
                    let name = Tools.dateToString(Date(), formatter: "yyyyMMddHHmmss").appending("\(arc4random()%10000)")
                    multipartData.append(d, withName: "files", fileName: "\(name).jpg", mimeType: "image/jpeg");//image/jpeg ，image/png
                }
            }
            
            for (k , v) in params {
                var data:Data?
                if v is String {
                    let s = v as! String
                    data = s.data(using: String.Encoding.utf8)
                }else if v is [Any] {
                    let arr = v as! [Any];
                    if arr.count > 0 {
                        do {
                            data =  try JSONSerialization.data(withJSONObject: arr, options: []);
                        }catch{
                            print(error.localizedDescription);
                        }
                    }
                }
                
                if let d = data {
                    multipartData.append(d, withName: k)
                }
            }
        }, to:  BASE_URL + defect_save_fault_url, headers: header) { (encodingResult) in
            switch encodingResult {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL:_):
                    upload.responseJSON(completionHandler: {  (res) in
                        DispatchQueue.main.async {[weak self] in
                            print(res.result.value)
                            HUD.dismiss()
                            
                            guard let ss = self else {return}
                            ss.__clearData()
                            
                            NotificationCenter.default.post(name: NSNotification.Name (rawValue: "creatDefectReportSubmintOkNotification"), object: nil)
                            
                            _ = ss.navigationController?.popViewController(animated: true)
                        }
                    })
                case .failure(let error):
                    print(error);
                    break
            }
        }
        
        
        
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscape;
        }
    }
    
    //MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if !read_only {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportInfoCellIdentifier", for: indexPath) as! ReportInfoCell
                reportInfoCell = cell
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
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportBaseInfoCell_RIdentifier", for: indexPath) as! ReportBaseInfoCell_R;
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
                }
                break
            case "DD":
                if section2_selected_index == 4 {
                    if !read_only {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DDInfoCellIdentifier", for: indexPath) as! DDInfoCell;
                        ddInfoCell = cell
                        return cell
                    }
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DDInfoCell_RIdentifier", for: indexPath) as! DDInfoCell_R;
                    cell.fill(_defect_info)
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
            //cell.info = action_detail_info_r
            cell._tableView.reloadData()
            
            current_selected_index = kSectionHeadButtonSelectedIndex;
            
            cell.didSelectedRowAtIndex = { index in
                let d = defect_added_actions[index]
                
                HUD.show()
                let vc = TaskAddActionVC()
                vc.read_only = true
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section > 0  else {return 100}
        return indexPath.row != 0 ? 0 : kCurrentScreenHeight - 100 - 240 //420
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let v = Bundle.main.loadNibNamed("TaskActionTopView", owner: nil, options: nil)?.first as! UIView
            for s in (v.viewWithTag(100)?.subviews)! {
                if s is UILabel {
                    let _s = s as! UILabel;
                    _s.text = "AirCraft Info"
                }
            }
            return v
        }
        
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
                        }
                        
                        break
                        

                    default:break
                }
                
                tableView.reloadData()

            }

        }


        bg.addSubview(v)
        return bg
    }
    
    func _sectionBtnTitle() -> [String] {
        let type = __defect_type()
        
        switch  type {
        case "TS":return ["Basic Info & Detail","Materal&Tools ","Attachment","Action"]
            
        case "DD":return ["Basic Info & Detail","Materal&Tools ","Attachment","DD","Action"]

        case "NRR":return ["Basic Info & Detail","Materal&Tools ","Attachment","NRR","Action"]
        default:break
        }
        
       return []
    }

    ///Defect Type
    func __defect_type() -> String {
        if read_only {
            return form_type.text ?? ""
        }
        
        return _current_defect_type ?? ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
