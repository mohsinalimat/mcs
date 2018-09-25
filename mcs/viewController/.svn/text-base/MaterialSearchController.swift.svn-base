//
//  MaterialSearchController.swift
//  mcs
//
//  Created by gener on 2018/5/3.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class MaterialSearchController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var dataArray = [[String:Any]]()
    var _searchPars:[String:Any]?
    var _pageNum:Int = 1
    var _isSearch:Bool = false
    
    @IBOutlet weak var search_bg: UIView!
    @IBOutlet weak var search_bg_h: NSLayoutConstraint!
    @IBOutlet weak var table_to_top_h: NSLayoutConstraint!
    @IBOutlet weak var s_pn: UITextField!
    @IBOutlet weak var s_description: UITextField!
    
    var _orderNumberBtn:UIButton!
    var _hasAddedPN = [String]()
    var _addedArr = [[String:String]]()
    
    //for interchange
    var isInterchange:Bool = false
    var pn:String?
    
    //MARK: -
    @IBAction func searchAction(_ sender: AnyObject) {
        _isSearch = true;
        _pageNum = 1
        
        loadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        
        isInterchange = pn != nil
        
        _initSubviews()
        
        loadData()
        
    }

    func interchangeData(_ noti:NSNotification)  {
        if let d = noti.userInfo as? [String:Any]{
            let des = String.isNullOrEmpty(d["description"])
            let pn = String.isNullOrEmpty(d["stpn"])
            
            if !_hasAddedPN.contains(pn){
                _hasAddedPN.append(pn);
                _addedArr.append(["stpn":pn,"description":des]);
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero

        UIApplication.shared.keyWindow?.addSubview(_orderNumberBtn)

        if _hasAddedPN.count > 0 {
            _orderNumberBtn.isHidden = false;
            _orderNumberBtn.setTitle("\(_hasAddedPN.count)", for: .normal);
        }else {
            _orderNumberBtn.isHidden = true;
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.viewWithTag(2000)?.removeFromSuperview()
    }
    
    
    let orderBtnOriginRect = CGRect (x: kCurrentScreenWidth - 150, y: kCurrentScreenHeight - 150, width: 50, height: 50)
    func addOrderBtn() {
        let btn = UIButton (frame: orderBtnOriginRect)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.layer.borderColor = kTableviewBackgroundColor.cgColor
        btn.layer.borderWidth = 1
        btn.backgroundColor = UIColor.red
        btn.setTitle("0", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.tag = 2000
        btn.addTarget(self, action: #selector(_toMyOrder(_ :)), for: .touchUpInside)
        _orderNumberBtn = btn
        
        UIApplication.shared.keyWindow?.addSubview(btn)
    }
    
    func _toMyOrder(_ btn:UIButton) {
        guard !isInterchange else {return}
        guard _addedArr.count > 0 else {return}
        
        let vc = MyOrderController()
        vc.dataArray = _addedArr
        
        vc.leaveHandler = {[weak self] a in
            guard let ss = self else {return}
            ss._addedArr.removeAll()
            ss._hasAddedPN.removeAll()
            ss._addedArr = a
            
            for d in a {
                if let pn = d["stpn"]{
                    ss._hasAddedPN.append(pn);
                }
            }
            
            ss.tableView.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK: - init
    func _initSubviews()  {
        tableView.register(UINib (nibName: "MaterialSearchCell", bundle: nil), forCellReuseIdentifier: "MaterialSearchCellIdentifier")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
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
        
        addOrderBtn()
        
        if isInterchange{
            search_bg.isHidden = true;
            search_bg_h.constant = 0
            table_to_top_h.constant = 0
            title = "\(pn!) interchange"
            
            //////
            let exitBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
            exitBtn.setImage(UIImage (named: "search_subscibe_titilebar"), for: .normal)
            exitBtn.setImage(UIImage (named: "search_subscibe_titilebar"), for: .highlighted)//icon_exit
            exitBtn.addTarget(self, action: #selector(interchangeSearchAction), for: .touchUpInside)
            let exitItem  = UIBarButtonItem (customView: exitBtn)
            
            let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            fixed.width = 20
            
            navigationItem.rightBarButtonItems = [fixed, exitItem ]

        }else{
            NotificationCenter.default.addObserver(self, selector: #selector(interchangeData(_ :)), name: NSNotification.Name.init("interchangenotification"), object: nil);
        }
    }
    
    func interchangeSearchAction() {
        _pop()
    }

    var interchange_key = [String]()
    func _pop() {
        let maskView = UIView (frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.5;
        maskView.tag = 1001
        UIApplication.shared.keyWindow?.addSubview(maskView)

        /*
         let ds = [["key":"I" , "value":"Totally interchangeable"] ,
         ["key":"J" , "value":"One way alternate"] ,
         ["key":"R" , "value":"Restrictive interchangeability"] ,
         ["key":"S" , "value":"Super restrictive interchangeability, implying A/C modification"] ,
         ["key":"A" , "value":"old reference"] ,
         ["key":"N" , "value":"new reference"] ,
         ["key":"X" , "value":"One way non alternate"] ,
         ["key":"0" , "value":"Not alternate"]]
         */
        let ds = [["key":"I" , "value":"I"] ,
                  ["key":"J" , "value":"J"] ,
                  ["key":"R" , "value":"R"] ,
                  ["key":"S" , "value":"S"] ,
                  ["key":"A" , "value":"A"] ,
                  ["key":"N" , "value":"N"] ,
                  ["key":"X" , "value":"X"] ,
                  ["key":"0" , "value":"0"]]

        let rect = CGRect (x: kCurrentScreenWidth - 480, y: 0, width: 480, height: kCurrentScreenHeight)
        let vc = SearchItemSelectController()
        vc.dataType = .status;
        vc.headTitle = "Status"
        vc.dimissHandler = true
        vc.dataArray = ds
        vc.selectedObjs = interchange_key
        vc.selectedHandle = {[weak self] obj in
            guard let ss = self else {return}
            let _o = obj as! [[String:String]]
            ss.interchange_key.removeAll()
            ss._pageNum = 1
            
            for _i in 0..<_o.count{
                let i = _o[_i];
                ss.interchange_key.append("\(i["key"]!)")
            }
            
            ss.loadData()
        }

        //////
        let nav = BaseNavigationController(rootViewController:vc)
        nav.preferredContentSize = rect.size
        nav.view.frame = CGRect (x: kCurrentScreenWidth, y: 0, width: rect.width, height: rect.height)
        nav.setNavigationBarHidden(true, animated: true)

        UIApplication.shared.keyWindow?.rootViewController?.addChildViewController(nav)
        UIApplication.shared.keyWindow?.addSubview(nav.view)
        UIView.animate(withDuration: 0.3) {
            nav.view.frame = CGRect (x:rect.minX, y: 0, width: rect.width, height: rect.height)
        }
        
    }
    
    func loadData(_ d : [String:Any] = [:])  {
        HUD.show(withStatus: hud_msg_loading)
        
        var pars : [String:Any] = d
        pars["page"] = _pageNum
        if isInterchange {
            pars["stpn"] = pn!;
            pars["interchange"] = interchange_key
        }else {
            if _isSearch {
                pars["stpn"] = String.isNullOrEmpty(s_pn.text);
                pars["description"] = String.isNullOrEmpty(s_description.text);
            }
        }

        
        netHelper_request(withUrl: isInterchange ? pn_interchange_url : pn_list_url, method: .post, parameters: pars,  encoding:isInterchange ? JSONEncoding.default : URLEncoding.default, successHandler: { [weak self](res) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialSearchCellIdentifier", for: indexPath) as! MaterialSearchCell
        let d = dataArray[indexPath.row]
        let pn = String.isNullOrEmpty(d["stpn"])
        cell.fill(d ,added: _hasAddedPN.contains(pn) , isInterchange: isInterchange)
        
        cell.buttonActionHandler = {[weak self] index in
            guard let ss = self else {return}
            if index == 1 {
                let vc = PNHistoryController();
                vc.pn = pn
                ss.navigationController?.pushViewController(vc, animated: true)
            }else if index == 2 {
                ss._add_pn(pn , indexPath.row)
            }else {
                let vc = MaterialSearchController();
                vc.pn = pn
                ss.navigationController?.pushViewController(vc, animated: true)

            }

        }
        
        return cell
        
    }
    

    
    func _add_pn(_ pn:String , _ index:Int) {
        if !_hasAddedPN.contains(pn){
            _hasAddedPN.append(pn);
            _orderNumberBtn.setTitle("\(_hasAddedPN.count)", for: .normal)
            
            let d  = dataArray[index]
            let des = String.isNullOrEmpty(d["description"])
            _addedArr.append(["stpn":pn,"description":des])
            _orderNumberBtn.isHidden = false;
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self._orderNumberBtn.transform = CGAffineTransform.init(scaleX: 3, y: 3)
                }, completion: { (b) in
                    self._orderNumberBtn.transform = CGAffineTransform.identity
            })
            
            tableView.reloadData()
            
            if isInterchange {
            NotificationCenter.default.post(name: NSNotification.Name.init("interchangenotification"), object: nil, userInfo: ["stpn":pn,"description":des])
            }
        }else {
            HUD.show(info: "Added!");
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
