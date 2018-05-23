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

    @IBOutlet weak var btn_status: UIButton!
    
    @IBOutlet weak var btn_ac: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    let defect_status : [[String:String]] = {
        if let arr = plist_dic["offline"] as? [[String:String]] {
            return arr
        }
        
        return [];
    }()
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            Tools.showDataPicekr (dataSource:defect_status){ (obj) in
                let obj = obj as! [String:String]
                sender.setTitle(obj["value"], for: .normal)
                
            }
            break
            
        case 2://reg
            Tools.showDataPicekr (dataSource:Tools.acs()){ (obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)

            }
            break
            
            
        default:break
        }

        
    }
    
    var dataArray = [[String:Any]]()
    var _searchPars:[String:Any]?
    var _pageNum:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "DD List"
        view.backgroundColor = UIColor.white
        
        _initSubviews()

    }

    func loadData(_ d : [String:Any] = [:])  {
        HUD.show(withStatus: hud_msg_loading)
        
        var pars : [String:Any] = d
        pars["page"] = _pageNum
        
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
                //ss.loadData(ss._isSearch ? ss._searchPars ?? [:] : [:])
            }
        }
        
        tableView.mj_footer = footer
        
        
    }
    

    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDListCellIdentifier", for: indexPath) as! DDListCell
        
        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
