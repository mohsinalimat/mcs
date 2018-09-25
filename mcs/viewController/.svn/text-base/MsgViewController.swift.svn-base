//
//  MsgViewController.swift
//  mcs
//
//  Created by gener on 2018/7/9.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Then

class MsgViewController: BaseViewController {
    var tableview:UITableView!
    var dataArray = [[String:Any]]()
    var isOpened = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _init()
        
        loadData()
    }
    
    func loadData() {
        if let arr = Msg {
            dataArray = arr;
            title = "Message(\(arr.count))"
            tableview.reloadData()
        }else {
            getMsg();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        new_msg_cnt = 0
        now_is_msgController = false
    }
    
    func _init()  {
        view.backgroundColor = UIColor.white;
        title = "Message"

        // Do any additional setup after loading the view.
        tableview = UITableView (frame: CGRect(x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64), style: .plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        //tableview?.showsVerticalScrollIndicator = false
        tableview?.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 80
        tableview?.separatorStyle = .none;
        tableview?.tableFooterView = UIView()
        view.addSubview(tableview!)
        tableview?.register(UINib (nibName: "MsgCell", bundle: nil), forCellReuseIdentifier: "MsgCellIdentifier")
        
        let exitBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
        exitBtn.setImage(UIImage (named: "delete"), for: .normal)
        exitBtn.setImage(UIImage (named: "delete"), for: .highlighted)
        exitBtn.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        //let exitItem  = UIBarButtonItem (customView: exitBtn)
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 20
        
        //navigationItem.rightBarButtonItems = [fixed, exitItem]
        
        ///Refresh Data
        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss.dataArray.removeAll()
                ss.getMsg()
            }
        }
        
        tableview.mj_header = header
        now_is_msgController = true;
        if isOpened{
            let backbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 50, height: 35))
            backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
            backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
            backbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
            backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
            backbtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            backbtn.setTitleColor(UIColor.darkGray, for: .normal)
            let leftitem = UIBarButtonItem.init(customView: backbtn)
            self.navigationItem.leftBarButtonItem = leftitem

        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init("new_msg_read_notification"), object: nil)
    }
    
    func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }

    func getMsg() {
        let date = Tools.dateToString(Date(), formatter: "dd/MM/yyyy")
        let d = ["date":date]
        app_timer_cnt = 0
        
        HUD.show()
        netHelper_request(withUrl: noti_msg_url, method: .post, parameters:d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            
            guard let ss = self else {return}
            if ss.tableview.mj_header.isRefreshing(){
                ss.tableview.mj_header.endRefreshing();
            }
            
            guard let arr = res["body"] as? [[String:Any]] else {return}
            if arr.count > 0 {
                Msg = arr
                ss.title = "Message(\(arr.count))"
                ss.dataArray = arr
                ss.tableview.reloadData()
            }
            
            })
        
    }
    
    deinit {
        print("msg controller")
    }
    
    func exitAction(){
        showMsg("Delete All Message?", title: "Delete") {
    
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MsgViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MsgCellIdentifier", for: indexPath) as! MsgCell
        let d = dataArray[indexPath.row]
        
        cell.fill(d)
        
        cell.backgroundColor = indexPath.row < new_msg_cnt ? kTableViewCellbg_hightlightColor : kTableViewCellbg_whiteColor
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
        
        }
    }
    
}

