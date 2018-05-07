//
//  ReporFormController.swift
//  mcs
//
//  Created by gener on 2018/4/25.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ReporFormController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{

    var section2_selected_index:Int = 1;
    var read_only:Bool = false
    
    let defectType = ["Defect Report":"TS" ,"DD":"DD" , "NRR":"NRR"]
    
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var _tableView: UITableView!
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://change type [TS , DD , NRR]
            Tools.showDataPicekr (dataSource:["Defect Report","DD","NRR"]){ (obj) in
                let obj = obj as! String
                
                sender.setTitle(obj, for: .normal)
            }
            break
            
        case 2://save
            _save();
            
            break
        case 3://save next
            
            break

        default:break
        }

    }
    

    
    var reportInfoCell:ReportInfoCell!
    var baseInfoCell:ReportBaseInfoCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        _tableView.backgroundColor = UIColor.white

        title = "Creat Defect Report"
         _initSubview()

        
    }

    
    func _initSubview()  {
        _tableView.delegate = self
        _tableView.dataSource = self
        
        _tableView.register(UINib (nibName: "ReportInfoCell", bundle: nil), forCellReuseIdentifier: "ReportInfoCellIdentifier")
        _tableView.register(UINib (nibName: "ReportBaseInfoCell", bundle: nil), forCellReuseIdentifier: "ReportBaseInfoCellIdentifier")
        _tableView.register(UINib (nibName: "Action_Materal_Cell", bundle: nil), forCellReuseIdentifier: "Action_Materal_CellIdentifier")
        _tableView.register(UINib (nibName: "AddActionInfoCell_R", bundle: nil), forCellReuseIdentifier: "AddActionInfoCell_RIdentifier")
        _tableView.register(UINib (nibName: "Action_Detail_Cell_R", bundle: nil), forCellReuseIdentifier: "Action_Detail_Cell_RIdentifier")
        
        _tableView.register(UINib (nibName: "DDInfoCell", bundle: nil), forCellReuseIdentifier: "DDInfoCellIdentifier")
        _tableView.register(BaseCellWithTable.self, forCellReuseIdentifier: "BaseCellWithTableIdentifier")
        
        addActionMateralDataArr.removeAll()
        addActionComponentDataArr.removeAll()
        

        
        _tableView.reloadData()
        _tableView.layoutIfNeeded()
        

        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.dismiss()
    }
    
    func _save() {
        
        let params : [String:String] = [
            "reportType":defectType[String.stringIsNullOrNilToEmpty(typeBtn.currentTitle)]!,
            "acReg":String.stringIsNullOrNilToEmpty(reportInfoCell.reg.currentTitle),
            "flDate":String.stringIsNullOrNilToEmpty(reportInfoCell.fltDate.currentTitle),
            "flNo":String.stringIsNullOrNilToEmpty(reportInfoCell.fltNo.currentTitle),
            "station":String.stringIsNullOrNilToEmpty(reportInfoCell.station.currentTitle)

            
            /*reaport info*/
//            "actBy" : String.stringIsNullOrNil(reportInfoCell.actBy.text) ,
//            "reportBy": String.stringIsNullOrNil(reportInfoCell.reportBy.text),
//            "shift": String.stringIsNullOrNil(reportInfoCell.shift_id),
//            "shiftDate": String.stringIsNullOrNil(reportInfoCell.shiftDate.currentTitle),
//            "team": String.stringIsNullOrNil(reportInfoCell.team_id),
            
            /*action basic info*/
//            "flNo":String.stringIsNullOrNil(actionBaseInfoCell.fltNo.text),
//            "dateType":String.stringIsNullOrNil(actionBaseInfoCell.area.currentTitle?.lowercased()),
//            "actionDate":String.stringIsNullOrNil(actionBaseInfoCell.dateTime.currentTitle),
//            "mainHour": String.stringIsNullOrNil(actionBaseInfoCell.mh.text),
//            "station": String.stringIsNullOrNil(actionBaseInfoCell.station.currentTitle),
//            "actionDetail": String.stringIsNullOrNil(actionBaseInfoCell.descri.text),
//            "actionRef":String.stringIsNullOrNil(actionBaseInfoCell.ref.text),
//            "page":String.stringIsNullOrNil(actionBaseInfoCell.page.text),
//            "item":String.stringIsNullOrNil(actionBaseInfoCell.item.text)
        ]
        
        /*material-tools*/
//        for (key,value) in encodingParameters(addActionMateralDataArr, key: "bizPartList") {
//            params[key] = value;
//        }
//        
//        for (key,value) in encodingParameters(addActionComponentDataArr, key: "partList") {
//            params[key] = value;
//        }
        
        HUD.show()
        netHelper_request(withUrl: defect_save_fault_url, method: .post, parameters: params, successHandler: {[weak self] (res) in
            HUD.show(successInfo: "Add success")
            
            guard let ss = self else {return}
//            NotificationCenter.default.post(name: NSNotification.Name (rawValue: "addActionSubmintOkNotification"), object: nil)
//            
//            _ = ss.navigationController?.popViewController(animated: true)
        }) { (str) in
            HUD.show(info: str ?? "Request Error")
            
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
            if true {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportInfoCellIdentifier", for: indexPath) as! ReportInfoCell
                //cell.fill(action_detail_info_r)
                reportInfoCell = cell
                
                return cell
            }else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "AddActionInfoCellIdentifier", for: indexPath) as! AddActionInfoCell
//                
//                reportInfoCell = cell
//                
//                return cell
            }
            
        }
        
        
/////////////////
        if section2_selected_index == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportBaseInfoCellIdentifier", for: indexPath) as! ReportBaseInfoCell;
            baseInfoCell = cell
            
            return cell
        } else if section2_selected_index == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DDInfoCellIdentifier", for: indexPath) as! ReportBaseInfoCell;
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Action_Materal_CellIdentifier", for: indexPath) as! Action_Materal_Cell;
        //let cell = tableView.dequeueReusableCell(withIdentifier: "BaseCellWithTableIdentifier", for: indexPath) as! BaseCellWithTable
        cell.read_only = read_only
        //cell.info = action_detail_info_r
        cell._tableView.reloadData()
        
        if section2_selected_index == 5 {
            cell.didSelectedRowAtIndex = { index in
                //let d = dataArray[indexPath.row]
                
                HUD.show()
                let vc = TaskAddActionVC()
                vc.read_only = true
                //vc.action_detail_info_r = d;
                
                //self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
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
        
        let v = MultiButtonView.init(CGRect (x: 15, y: 0, width: bg.frame.width - 30, height: bg.frame.height), titles: ["Basic Info & Detail","Materal&Tools ","Attachment","DD","Action"] , selectedIndex : section2_selected_index)
        v.title = "Defect Detail"
        v.selectedActionHandler = { index in
            DispatchQueue.main.async {[weak self ] in
                guard let ss = self else {return}
                ss.section2_selected_index = index
                kSectionHeadButtonSelectedIndex = SectionHeadButtonIndex(rawValue: index + 4)!
                tableView.reloadData()

            }

        }


        bg.addSubview(v)
        return bg
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
