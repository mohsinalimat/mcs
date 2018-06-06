//
//  DDViewController.swift
//  mcs
//
//  Created by gener on 2018/4/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import MJRefresh

class DDViewController: BaseTabItemController  ,UITableViewDelegate,UITableViewDataSource{

    let dd_list_status = [
        "determineReceive",
        "perfectReport",
        "createTask",
        "executing",
        "monitoring",
        "closed"
    ]

    let dd_list_status_k = [
        "determineReceive":"1",
        "perfectReport":"2",
        "createTask":"3",
        "executing":"4",
        "monitoring":"7",
        "closed":"8"
    ]
    
    @IBOutlet weak var btn_status: UIButton!
    
    @IBOutlet weak var btn_ac: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = [[String:Any]]()
    var _searchPars:[String:Any]?
    var _pageNum:Int = 1
    
    var sts:[String]?
    var acs:[String]?
    
    @IBAction func buttonAction(_ sender: UIButton) {
        _pageNum = 1
        switch sender.tag {
        case 1:
            Tools.showDataPicekr (dataSource:dd_list_status){ [weak self](obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
                guard let ss = self else {return}
                let k = ss.dd_list_status_k[obj]
                ss.sts = [k!]
                ss.loadData()
            }
            break
            
        case 2://reg
            Tools.showDataPicekr (dataSource:Tools.acs()){ [weak self](obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
                guard let ss = self else {return}
                
                if obj == "ALL"{
                    ss.acs = nil;
                }else {
                    ss.acs = [obj];
                }

                ss.loadData()
            }
            break
            
        default:break
        }

        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "DD List"
        view.backgroundColor = UIColor.white
        
        _initSubviews()
        
        loadData();
        
    }

    func loadData(_ d : [String:Any] = [:])  {
        HUD.show(withStatus: hud_msg_loading)
        
        var pars : [String:Any] = d
        pars["page"] = _pageNum
        if let status = sts {
            pars["sts"] = status;
        }
        
        if let areg = acs {
            pars["acs"] = areg;
        }
        
        netHelper_request(withUrl: dd_list_url, method: .post, parameters: pars, encoding: JSONEncoding.default, successHandler: { [weak self](res) in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss._pageNum == 1 {
                ss.dataArray.removeAll();
                ss.tableView.mj_footer.resetNoMoreData()
            }
            
            
            if ss.tableView.mj_header.isRefreshing(){
                ss.tableView.mj_header.endRefreshing();
            } else if  ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing();
            }
            
            guard let arr = res["body"] as? [[String:Any]] else {return};
            if arr.count > 0 {
                ss.dataArray = ss.dataArray + arr;
                
                if arr.count < 15 {
                    ss.tableView.mj_footer.state = MJRefreshState.noMoreData;
                }
            }
            
            ss.tableView.reloadData()
            
        }) { (str) in
            print(str);
        }
        
    }
    
    
    //MARK: - init
    func _initSubviews()  {
        tableView.register(UINib (nibName: "DDListCell", bundle: nil), forCellReuseIdentifier: "DDListCellIdentifier")
        tableView.tableFooterView = UIView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
        
        ///Refresh Data
        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss._pageNum =  1
                ss.dataArray.removeAll()
                ss.loadData()
            }
        }
        
        tableView.mj_header = header
        
        let footer = TTRefreshFooter.init{
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss._pageNum = ss._pageNum + 1
                ss.loadData()
            }
        }
        
        tableView.mj_footer = footer
    }
    

    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDListCellIdentifier", for: indexPath) as! DDListCell
        let d = dataArray[indexPath.row]
        cell.fill(d)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = dataArray[indexPath.row]
        guard let defect_id = info["id"] as? String else {return}
        let vc = ViewDefectReportController()
        vc.type_id = defect_id
        vc.type = "defectDetail" //defect_type == "DD" ? "defectDetail ":"ts"
        vc.is_dd = true
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
