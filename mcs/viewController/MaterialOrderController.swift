//
//  MaterialOrderController.swift
//  mcs
//
//  Created by gener on 2018/5/3.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import MJRefresh

class MaterialOrderController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var dataArray = [[String:Any]]()
    var _searchPars:[String:Any]?
    var _pageNum:Int = 1

    var openedIndex:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        self.automaticallyAdjustsScrollViewInsets = false;
        
        _initSubviews();
        
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    //MARK: - init
    func _initSubviews()  {
        tableView.register(UINib (nibName: "MaterialOrderCell", bundle: nil), forCellReuseIdentifier: "MaterialOrderCellIdentifier")
        tableView.tableFooterView = UIView()
        
        let v = UIView (frame: CGRect (x: 0, y: 0, width: 0.0001, height:0.001))
        tableView.tableHeaderView = v

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = UIColor.white;
        
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
    
    
    
    func loadData(_ d : [String:Any] = [:])  {
        HUD.show(withStatus: hud_msg_loading)
        netHelper_request(withUrl: order_list_url, method: .post,  successHandler: { [weak self](res) in
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
            }else {
                ss.tableView.mj_footer.state = MJRefreshState.noMoreData;
            }
            
            ss.tableView.reloadData()
            
        }) { (str) in
            print(str);
        }
        
    }
    
    
    
    //MARK:
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedIndex >= 0 && openedIndex == section {
            let d = dataArray[section]
            if let arr = d["orderDetails"] as? [[String:Any]]{
                return arr.count;
            }

            return 0;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialOrderCellIdentifier", for: indexPath) as! MaterialOrderCell
        let d = dataArray[indexPath.section]
        if let pns = d["orderDetails"] as? [[String:Any]]{
            let pn = pns[indexPath.row]
            cell.fill(pn)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = Bundle.main.loadNibNamed("MaterialOrderHead", owner: nil, options: nil)?.first as! MaterialOrderHead
        v.clickedAction = { [weak self] b in
            guard let ss = self else {return}
            ss.openedIndex = b ? section : -1
            ss.tableView.reloadData()
        }
        
        v.arrow_btn.isSelected = openedIndex == section
        let d = dataArray[section]
        v.fill(d)
        
        return v
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
