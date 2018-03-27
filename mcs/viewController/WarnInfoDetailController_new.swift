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
    
    var _warnInfoDetail :[String:Any]!
    var _warnInfoLast :[String:Any]!
    var _id:String!
    var _shouldLoad = false
    
    var _warn_detail = [[String:Any]]()
    var _warn_possible = [[String:Any]]()
    var _warn_tsm = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Warn Info"
        
        // Do any additional setup after loading the view.
        _init()
    
        get_warn_detailInfo()
    
    }

    override func awakeFromNib() {
        _tableView.tableFooterView = UIView()
        _tableView.tableHeaderView = UIView()
    }
    
    func _init() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        _tableView.register(UINib (nibName: "WarnDetailTopCell", bundle: nil), forCellReuseIdentifier: "WarnDetailTopCellIdentifier")
        _tableView.register(UINib (nibName: "WarnFaultInfoCell", bundle: nil), forCellReuseIdentifier: "WarnFaultInfoCellIdentifier")
        _tableView.register(UINib (nibName: "WarnDisPoseCell", bundle: nil), forCellReuseIdentifier: "WarnDisPoseCellIdentifier")

        _tableView.separatorStyle = .none
        _tableView.dataSource = self
        _tableView.delegate = self
    }
    
    func get_warn_detailInfo() {

        HUD.show()
        let url = get_warn_info_url.appending("/\(_id!)")
        netHelper_request(withUrl: url, method: .get, parameters: nil, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [String : Any] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf._shouldLoad = true
            strongSelf._warnInfoDetail = body;
            
            if let _detail = body["alarm"] as? [[String:Any]] {
                strongSelf._warn_detail = strongSelf._warn_detail + _detail;
            }
            
            if let _detail = body["possibleCause"] as? [[String:Any]] {
                strongSelf._warn_possible = strongSelf._warn_possible + _detail;
            }
            
            if let _detail = body["tsm"] as? [[String:Any]] {
                strongSelf._warn_tsm = strongSelf._warn_tsm + _detail;
            }
            
            
            strongSelf._tableView.reloadData()
        }) { (error) in
            
        }
        
        
    }
    
    
    
    
    //MARK:- UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard _shouldLoad else {return 0}
        
        if current_selected_btn_index == 0 {
            return _warn_possible.count + 2;
        }
        
        return  3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        }else if section == 1 {
            return _warn_detail.count;
        }
        
        if current_selected_btn_index == 0 {
            if let  d = _warn_possible[section - 2]["pc"] as? [String]{
                return d.count;
            }
            
            return 0
        }else if current_selected_btn_index == 1 {
            return _warn_tsm.count;
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section > 0 else { return 130 }
        guard indexPath.section > 1 else { return 40 }
        
        return 30
    }
    
    private let section1_header_h:CGFloat = 60
    private let section1_footer_h:CGFloat = 100

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return section1_header_h;
        }else if section > 1 && current_selected_btn_index == 0 {
            return 30
        }
        
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {return section1_footer_h}
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        else if section == 1 {
            let v = UIView (frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: section1_header_h))
            let _l = UILabel (frame: CGRect (x: 15, y: section1_header_h - 45, width: 300, height: 45))
            _l.text = "Fault Information"
            //_l.textColor = UIColor.darkGray
            _l.font = UIFont.systemFont(ofSize: 15)
            v.addSubview(_l)
            return v
        }

        guard _warn_possible.count > 0 else {return nil}
        
        let d = _warn_possible[section - 2]
        let _l = UILabel (frame: CGRect (x: 5, y: 0, width: tableView.frame.size.width - 10, height: 30))
        _l.text = String.stringIsNullOrNil(d["taskCode"]) + ":" + String.stringIsNullOrNil(d["taskName"])
        _l.backgroundColor = kTableViewCellbg_hightlightColor
        _l.font = UIFont.boldSystemFont(ofSize: 16)

        let _v = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        _v.addSubview(_l)
        return _v
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let l = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: section1_footer_h))
            l.backgroundColor = current_selected_btn_bgcolor
            let t = ["Probable reason of fault","Fault isolation manual","MEL","Other files"]
            let x = [0,200,400,600]
            for i in 0..<t.count {
                let btn = UIButton (frame: CGRect (x: x[i], y: Int(section1_footer_h - 60), width: 200, height: 50));
                btn.setTitle(t[i], for: .normal)
                btn.tag = i
                btn.setTitleColor(kButtonTitleDefaultColor, for: .normal)
                btn.setTitleColor(UIColor.black, for: .selected)
                btn.setBackgroundImage(UIImage (named: "buttonbg"), for: .selected)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                btn.titleLabel?.textAlignment = .center
                btn.addTarget(self, action: #selector(sectionBtnClicked(_:)), for: .touchUpInside)
                
                if i == current_selected_btn_index {
                    btn.isSelected = true;
                    current_selected_btn = btn
                }
                l.addSubview(btn)
            }
            
            
            return l

        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarnDetailTopCellIdentifier", for: indexPath) as! WarnDetailTopCell
            
            cell.fillCell(_warnInfoDetail , d2: _warnInfoLast)
           
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarnFaultInfoCellIdentifier", for: indexPath) as! WarnFaultInfoCell
            if let d = _warn_detail[indexPath.row]["detail"] as? [[String:Any]] {
                if let f = d.first{
                    cell.fillCell(f)
                }
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WarnDisPoseCellIdentifier", for: indexPath) as! WarnDisPoseCell
            
            if current_selected_btn_index == 0 {
                if let  d = _warn_possible[indexPath.section - 2]["pc"] as? [String]{
                    let s = d[indexPath.row]
                    cell.fillCell(s)
                }
            }else if current_selected_btn_index == 1 {
                let d = _warn_tsm[indexPath.row];
                cell.fillCell(d1: d)
            }
            
            
            return cell
        }
        
 
    }
    
    
    
    //MARK:

    func sectionBtnClicked(_ button:UIButton) {
        guard button.tag != current_selected_btn.tag else { return}
        
        current_selected_btn.isSelected = false
        //current_selected_btn.backgroundColor = current_selected_btn_bgcolor
        
        button.isSelected = true
        //button.backgroundColor = UIColor.white
        
        current_selected_btn = button
        current_selected_btn_index = button.tag
        
        //_tableView.reloadSections([2], animationStyle: .none)
        _tableView.reloadData()
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
