//
//  ReporFormController.swift
//  mcs
//
//  Created by gener on 2018/4/25.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ReporFormController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var _tableView: UITableView!
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            break
            
        case 2:
            
            break
            
        case 3:
            
            break

        default:
            break
        }
    
    
    
    }
    

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
        
        addActionMateralDataArr.removeAll()
        addActionComponentDataArr.removeAll()
        

        
        _tableView.reloadData()
        _tableView.layoutIfNeeded()
        

        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.dismiss()
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
                
                return cell
            }else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "AddActionInfoCellIdentifier", for: indexPath) as! AddActionInfoCell
//                
//                reportInfoCell = cell
//                
//                return cell
            }
            
        }
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportBaseInfoCellIdentifier", for: indexPath) as! ReportBaseInfoCell
//        cell.read_only = read_only
//        cell.info = action_detail_info_r
//        cell._tableView.reloadData()
        
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
        
        return indexPath.row != 0 ? 0 : kCurrentScreenHeight - 100 - 240
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
        
        
        //let v = Bundle.main.loadNibNamed("DefectReportBtnView", owner: nil, options: nil)?.first as! DefectReportBtnView
//        v.changeActionHandler = {[weak self ] index in
//            guard let ss = self else {return}
//            ss.section2_selected_index = index
//            addAction_Section2_SelectedIndex = index
//            tableView.reloadData()
//        }
        
        //v._selectedBtnAtIndex(section2_selected_index)
        
        let bg = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 50))
        let v = MultiButtonView.init(CGRect (x: 15, y: 0, width: bg.frame.width - 30, height: bg.frame.height), titles: ["Basic Info & Detail","Materal&Tools ","Attachment","DD","Action"].reversed())
        
        v.title = "Defect Detail"
        print(bg.frame.width)
        
        bg.addSubview(v)
        
        return bg
        
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
