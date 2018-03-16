//
//  WarnInfoDetailController_new.swift
//  mcs
//
//  Created by gener on 2018/3/16.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class WarnInfoDetailController_new: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var _tableView: UITableView!
    var current_selected_btn:UIButton!
    var current_selected_btn_index = 0
    let current_selected_btn_bgcolor = UIColor.init(colorLiteralRed: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Warn Info"
        
        // Do any additional setup after loading the view.
        _init()
    
    
    }

    
    
    func _init() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        _tableView.register(UINib (nibName: "WarnDetailTopCell", bundle: nil), forCellReuseIdentifier: "WarnDetailTopCellIdentifier")
        _tableView.register(UINib (nibName: "WarnFaultInfoCell", bundle: nil), forCellReuseIdentifier: "WarnFaultInfoCellIdentifier")
        _tableView.register(UINib (nibName: "WarnDisPoseCell", bundle: nil), forCellReuseIdentifier: "WarnDisPoseCellIdentifier")
        
        _tableView.tableFooterView = UIView()
        _tableView.separatorStyle = .none
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        _tableView.dataSource = self
        _tableView.delegate = self
        

    }
    
    
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section > 0 else { return 130 }
        guard indexPath.section > 1 else { return 40 }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 50;
        }
        
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {return 15}
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        else if section == 1 {
            let v = UIView (frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            let _l = UILabel (frame: CGRect (x: 15, y: 10, width: 300, height: 40))
            _l.text = "Fault Information"
            _l.textColor = UIColor.darkGray
            _l.font = UIFont.systemFont(ofSize: 16)
            v.addSubview(_l)
            
            return v
        }

        
        let l = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 50))
        l.backgroundColor = UIColor.white
        
        let t = ["Probable reason of fault","Fault isolation manual","MEL","Other files"]
        let x = [0,230,430,530]
        for i in 0..<t.count {
            let btn = UIButton (frame: CGRect (x: x[i], y: 0, width: i > 1 ? 150:200, height: 50));
            btn.setTitle(t[i], for: .normal)
            btn.tag = 100 + i
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.setTitleColor(UIColor.black, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.titleLabel?.textAlignment = .center
            btn.addTarget(self, action: #selector(sectionBtnClicked(_:)), for: .touchUpInside)
            
            if i == 0{
                btn.isSelected = i == 0;
                btn.backgroundColor = current_selected_btn_bgcolor
                current_selected_btn = btn
            }
            
            
            l.addSubview(btn)
        }
        
        
        return l
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        }else if section == 1 {
            return 2;
        }
        
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier =  "WarnDetailTopCellIdentifier"
        if indexPath.section == 1 {
            identifier = "WarnFaultInfoCellIdentifier";
        }else if indexPath.section == 2 {
            identifier = "WarnDisPoseCellIdentifier";
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    //MARK:
    func get_warn_list() {
        let d = ["":""]
        
        netHelper_request(withUrl: get_warn_list_url, method: .post, parameters: d, successHandler: { (res) in
            
        }) { (error) in
            
        }
        
        
    }
    
    
    func sectionBtnClicked(_ button:UIButton) {
        guard button.tag != current_selected_btn.tag else { return}
        
        current_selected_btn.isSelected = false
        current_selected_btn.backgroundColor = UIColor.white
        
        button.isSelected = true
        button.backgroundColor = current_selected_btn_bgcolor
        
        current_selected_btn = button
        
        _tableView.reloadSections([2], animationStyle: .none)
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
