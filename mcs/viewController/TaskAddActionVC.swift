//
//  TaskAddActionVC.swift
//  mcs
//
//  Created by gener on 2018/4/4.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskAddActionVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var s_performed: UISwitch!
    
    @IBOutlet weak var s_closed: UISwitch!
    
    @IBOutlet weak var btn_save: UIButton!
    
    @IBOutlet weak var _tableView: UITableView!
    
    var read_only:Bool = false
    
    var section2_selected_index:Int = 1;
    
    
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
        
        if read_only {
            s_performed.isEnabled = false;
            s_closed.isEnabled = false
            s_performed.isOn = false
            s_closed.isOn = false
            
            btn_save.isHidden = true
            title = "Action No.2";
        }
        
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
       let url = taskPool_addAction_url.appending("e6ce72096200441da8b2f2932b143a1a")
        
        let d = [
        "acReg":"B-MCF",
        "perform":"0",
        "closed":"0"
        
        ]
        
        
        request(url, parameters: d, successHandler: { (res) in
            
            }) { (str) in
                
        }
        
        
    }
    
    
    ////MARK: - 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let _identifier = read_only ? "AddActionInfoCell_RIdentifier" : "AddActionInfoCellIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: _identifier, for: indexPath)
            
            return cell
        }
        
        if section2_selected_index == 1 {
            let _identifier = read_only ? "Action_Detail_Cell_RIdentifier" : "Action_Detail_CellIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: _identifier, for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Action_Materal_CellIdentifier", for: indexPath) as! Action_Materal_Cell
        cell.read_only = read_only
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
        
        
        let v = Bundle.main.loadNibNamed("TaskActionDetailView", owner: nil, options: nil)?.first as! TaskActionDetailView
        v.changeActionHandler = {[weak self ] index in
            guard let ss = self else {return}
            ss.section2_selected_index = index
            addAction_Section2_SelectedIndex = index
            tableView.reloadData()
        }
        
        v._selectedBtnAtIndex(section2_selected_index)
        
        return v
        
    }

    
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
