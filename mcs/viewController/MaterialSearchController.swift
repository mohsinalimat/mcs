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
    
    @IBOutlet weak var s_pn: UITextField!
    @IBOutlet weak var s_description: UITextField!
    var _orderNumberBtn:UIButton!
    
    var _hasAddedPN = [String]()
    var _addedArr = [[String:String]]()
    
    @IBAction func searchAction(_ sender: AnyObject) {
        _isSearch = true;
        
        loadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        
        _initSubviews()
        
        loadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero

        UIApplication.shared.keyWindow?.addSubview(_orderNumberBtn)

        if _hasAddedPN.count > 0 {
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
//        btn.setImage(UIImage (named: "icon_mine_topic_gray"), for: .normal)
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
    }
    
    
    
    func loadData(_ d : [String:Any] = [:])  {
        HUD.show(withStatus: hud_msg_loading)
        
        var pars : [String:Any] = d
        pars["page"] = _pageNum

        if _isSearch {
            pars["stpn"] = String.isNullOrEmpty(s_pn.text);
        }
        
        netHelper_request(withUrl: pn_list_url, method: .post, parameters: pars, successHandler: { [weak self](res) in
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
    
    
    
    

    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialSearchCellIdentifier", for: indexPath) as! MaterialSearchCell
        let d = dataArray[indexPath.row]
        let pn = String.isNullOrEmpty(d["stpn"])
        cell.fill(d ,added: _hasAddedPN.contains(pn))
        
        cell.buttonActionHandler = {[weak self] index in
            guard let ss = self else {return}
            if index == 1 {
                let vc = PNHistoryController();
                vc.pn = pn
                ss.navigationController?.pushViewController(vc, animated: true)
            }else {
                ss._add_pn(pn , indexPath.row)
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
        }else {
            HUD.show(info: "Added!");
        }
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
