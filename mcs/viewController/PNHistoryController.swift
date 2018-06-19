//
//  PNHistoryController.swift
//  mcs
//
//  Created by gener on 2018/6/19.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import MJRefresh

class PNHistoryController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableview:UITableView!
    var dataArray = [[String:Any]]()
    var _pageNum:Int = 1

    var pn:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "P/N : " + pn + " History"
        
        tableview = UITableView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 120
        tableview.separatorStyle = .none;
        tableview.tableFooterView = UIView()
        view.addSubview(tableview!)
        tableview.register(UINib (nibName: "PNHistoryCell", bundle: nil), forCellReuseIdentifier: "PNHistoryCellIdentifier")

        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss._pageNum =  1
                ss.dataArray.removeAll()
                ss.loadData()
            }
        }
        
        tableview.mj_header = header
        
        let footer = TTRefreshFooter.init{
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss._pageNum = ss._pageNum + 1
                ss.loadData()
            }
        }
        
        tableview.mj_footer = footer
        loadData()
    }

    
    
    func loadData(_ d : [String:Any] = [:])  {
        HUD.show(withStatus: hud_msg_loading)
        
        var pars : [String:Any] = d
        pars["page"] = _pageNum
        pars["pspn"] = pn
        
        netHelper_request(withUrl: pn_history_url, method: .post, parameters: pars, successHandler: { [weak self](res) in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss._pageNum == 1 {
                ss.dataArray.removeAll();
                ss.tableview.mj_footer.resetNoMoreData()
            }
            
            
            if ss.tableview.mj_header.isRefreshing(){
                ss.tableview.mj_header.endRefreshing();
            } else if  ss.tableview.mj_footer.isRefreshing() {
                ss.tableview.mj_footer.endRefreshing();
            }
            
            guard let arr = res["body"] as? [[String:Any]] else {return};
            if arr.count > 0 {
                ss.dataArray = ss.dataArray + arr;
                
                if arr.count < 15 {
                    ss.tableview.mj_footer.state = MJRefreshState.noMoreData;
                }
            }
            
            if ss.dataArray.count == 0 {
                ss.displayMsg("No Data");
                ss.tableview.mj_footer.isHidden = true
            }else {
                ss.view.viewWithTag(1001)?.removeFromSuperview();
                ss.tableview.mj_footer.isHidden = false
            }
            
            ss.tableview.reloadData()
            
        }) { (str) in
            print(str);
        }
        
    }
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PNHistoryCellIdentifier", for: indexPath) as! PNHistoryCell
        let d = dataArray[indexPath.row]
        cell.fill(d)
        
        cell.backgroundColor = indexPath.row % 2 == 0 ? kTableViewCellbg_whiteColor : kTableViewCellbg_hightlightColor
        
        return cell
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
