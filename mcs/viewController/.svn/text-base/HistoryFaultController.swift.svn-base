//
//  HistoryFaultController.swift
//  
//
//  Created by gener on 2018/1/22.
//
//

import UIKit
import MJRefresh

class HistoryFaultController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{

    var tableView:UITableView!
    var _topView:UIView?
    var dataArray = [[String:Any]]()
    var _pageNum:Int = 1
    
    var _isAll = false
    var _isSearch = false
    var _searchPars:[String:String]?
    
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
        
        let topView = Bundle.main.loadNibNamed("HistoryFaultTopView", owner: nil, options: nil)?.first as? HistoryFaultTopView
        let bgview = UIView (frame: CGRect (x: 0, y: 0, width: 1000, height: 40))
        bgview.addSubview(topView!)
        topView?.frame = bgview.frame
        topView?.buttonActionHandler = {[weak self] index , pars in
            guard let ss = self else {return}
            switch index {
            case 1:
                let vc = HistoryFaultController()
                vc._isAll = true
                ss.navigationController?.pushViewController(vc, animated: true)
                break
            case 2://search
                ss._isSearch = true
                ss._searchPars = pars
                ss._pageNum =  1
                ss.dataArray.removeAll()
                ss.tableView.reloadData()
                ss.loadData(pars!)
                break
            default: break
            }
        
        }
        
        _topView = bgview
        topView?.showAll(_isAll)
        if _isAll {
            navigationItem.titleView = _topView
            tableView.frame = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64)
        }
        

        ///Refresh Data
        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss._pageNum =  1
                ss.dataArray.removeAll()
                ss.loadData(ss._isSearch ? ss._searchPars ?? [:] : [:])
            }
        }
        tableView.mj_header = header
        
        let footer = TTRefreshFooter.init{
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss._pageNum = ss._pageNum + 1
                ss.loadData(ss._isSearch ? ss._searchPars ?? [:] : [:])
            }
        }
        tableView.mj_footer = footer
        loadData()
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
        
        var pars =  [String:Any]()
        pars["page"] = _pageNum
        //pars["scheduleTime"] = Tools.dateToString(Date(), formatter: "dd/MM/yyyy");
        if !_isAll {
            pars["acs"] = String.isNullOrEmpty(kFlightInfoListController_airId);
        }
        
        
        for (k, v) in d {
            pars[k] = v;
        }
        
        netHelper_request(withUrl: defect_history_url, method: .post, parameters: pars,  successHandler: { [weak self](res) in
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryFaultCellIdentifier", for: indexPath) as! HistoryFaultCell
        cell.backgroundColor = indexPath.row % 2 == 0 ? kTableViewCellbg_whiteColor : kTableViewCellbg_hightlightColor
        let d = dataArray[indexPath.row]
        cell.fill(d ,isAll: _isAll)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = dataArray[indexPath.row]
        guard let defect_id = info["bizId"] as? String , let type = info["bizType"] else {return}
        
        let vc = TTWebViewController(TTWebDataSource(url:history_detail_url,
                                                     pars:["bizType":type,"bizId":defect_id],
                                                     title:"Defect Report View"))
        
        self.navigationController?.pushViewController(vc, animated: true);
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
