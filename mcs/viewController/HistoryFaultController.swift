//
//  HistoryFaultController.swift
//  
//
//  Created by gener on 2018/1/22.
//
//

import UIKit

class HistoryFaultController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{

    var tableView:UITableView!
    var _topView:UIView?
    var dataArray = [[String:Any]]()
    var _searchPars:[String:Any]?
    var _pageNum:Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _initSubviews()
        
    }

    
    //MARK: - init
    func _initSubviews()  {
        tableView = UITableView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 50), style: .plain)
        view.addSubview(tableView)
        
        tableView.register(UINib (nibName: "HistoryFaultCell", bundle: nil), forCellReuseIdentifier: "HistoryFaultCellIdentifier")
        tableView.tableFooterView = UIView()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.separatorStyle = .none

        
        let topView = Bundle.main.loadNibNamed("HistoryFaultTopView", owner: nil, options: nil)?.first as? UIView
        let bgview = UIView (frame: CGRect (x: 0, y: 0, width: 1000, height: 40))
        bgview.addSubview(topView!)
        
        topView?.frame = bgview.frame
        _topView = bgview
        
        ///Refresh Data
//        let header = TTRefreshHeader.init {
//            DispatchQueue.main.async {[weak self] in
//                guard let ss = self else {return}
//                ss._pageNum =  1
//                ss.dataArray.removeAll()
//                ss.loadData()
//            }
//        }
//        
//        tableView.mj_header = header
//        
//        let footer = TTRefreshFooter.init{
//            DispatchQueue.main.async {[weak self] in
//                guard let ss = self else {return}
//                ss._pageNum = ss._pageNum + 1
//                ss.loadData()
//            }
//        }
//        
//        tableView.mj_footer = footer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let items = _topView else {return}
        self.tabBarController?.navigationItem.titleView = items
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.titleView = nil
    }
    
    
    func loadData(_ d : [String:Any] = [:])  {
        HUD.show(withStatus: hud_msg_loading)
        
        var pars : [String:Any] = d
        pars["page"] = _pageNum
//        if let status = sts {
//            pars["sts"] = status;
//        }
//        
//        if let areg = acs {
//            pars["acs"] = areg;
//        }
        
//        netHelper_request(withUrl: dd_list_url, method: .post, parameters: pars, encoding: JSONEncoding.default, successHandler: { [weak self](res) in
//            HUD.dismiss()
//            guard let ss = self else {return}
//            if ss._pageNum == 1 {
//                ss.dataArray.removeAll();
//                ss.tableView.mj_footer.resetNoMoreData()
//            }
//            
//            
//            if ss.tableView.mj_header.isRefreshing(){
//                ss.tableView.mj_header.endRefreshing();
//            } else if  ss.tableView.mj_footer.isRefreshing() {
//                ss.tableView.mj_footer.endRefreshing();
//            }
//            
//            guard let arr = res["body"] as? [[String:Any]] else {return};
//            if arr.count > 0 {
//                ss.dataArray = ss.dataArray + arr;
//                
//                if arr.count < 15 {
//                    ss.tableView.mj_footer.state = MJRefreshState.noMoreData;
//                }
//            }
//            
//            ss.tableView.reloadData()
//            
//        }) { (str) in
//            print(str);
//        }
        
    }
    
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryFaultCellIdentifier", for: indexPath) as! HistoryFaultCell
        
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
