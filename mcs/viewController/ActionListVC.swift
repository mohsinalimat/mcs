//
//  ActionListVC.swift
//  mcs
//
//  Created by gener on 2018/4/9.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class ActionListVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    var ywNo:String?
    
    var dataArray = [[String:Any]]()
    
    @IBOutlet weak var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = ywNo
        view.backgroundColor = UIColor.white
        
        _initSubview()
        
        get_action_list()
    }

    
    @IBAction func addAction(_ sender: AnyObject) {
        HUD.show()
        let vc = TaskAddActionVC()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func _initSubview()  {
        _tableView.layer.borderWidth = 1
        _tableView.layer.borderColor = kTableviewBackgroundColor.cgColor
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "ActionListCell", bundle: nil), forCellReuseIdentifier: "ActionListCellIdentifier")

        _tableView.tableFooterView = UIView()
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.estimatedRowHeight = 88
        _tableView.separatorColor = kTableviewBackgroundColor
    }
    
    func get_action_list() {
        guard let bzid = taskPoolSelectedTask["bizId"] as? String else {return}
        let d = [ "bizId":bzid ]

        HUD.show(withStatus: "Loading")
        netHelper_request(withUrl: action_list_url, method: .post, parameters: d, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [String : Any] else {return;}
            guard let actionlist = body["actionList"] as? [[String : Any]] else {return}
            guard let strongSelf = self else{return}
            
            strongSelf.dataArray = strongSelf.dataArray + actionlist
            strongSelf._tableView.reloadData()
        }) { (error) in
            HUD.show(info: error ?? "Error")
        }
        
        
    }
    
    
    
    
    //MARK:-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//
        let name = "ActionListCellIdentifier"

        let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as! ActionListCell
        let d = dataArray[indexPath.row]
        
        cell.fill(d)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        
        HUD.show()
        let vc = TaskAddActionVC()
        vc.read_only = true
        vc.action_detail_info_r = d;
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
