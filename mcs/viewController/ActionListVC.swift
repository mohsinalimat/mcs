//
//  ActionListVC.swift
//  mcs
//
//  Created by gener on 2018/4/9.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ActionListVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    var ywNo:String?
    
    var dataArray = [[String:Any]]()
    let disposeBag =  DisposeBag()
    
    @IBOutlet weak var _tableView: UITableView!
    var bizPartList_r:[[String:Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = ywNo
        view.backgroundColor = UIColor.white
        
        _initSubview()
        
        get_action_list()
        
        NotificationCenter.default.rx.notification(NSNotification.Name (rawValue: "addActionSubmintOkNotification")).subscribe { [weak self] (event) in
            guard let strongSelf = self else {return}
            strongSelf.get_action_list();
            }.addDisposableTo(disposeBag)
        
        
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
            
            strongSelf.bizPartList_r = body["partList"] as? [[String : Any]]
            
            strongSelf.dataArray.removeAll()
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
        
        cell.fill(d , index: indexPath.row + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        
        HUD.show()
        let vc = TaskAddActionVC()
        vc.r_index = indexPath.row + 1
        vc.read_only = true
        vc.action_detail_info_r = d;
        vc.bizPartList_r =  bizPartList_r
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let action_id = dataArray[indexPath.row]["id"] as? String else {return}
            
            let url = action_delete_url.appending("/\(action_id)")
            
            netHelper_request(withUrl: url, method: .delete, parameters: nil, successHandler: {[weak self] (res) in
                    HUD.show(successInfo: "Delete Success");
                    
                    guard let ss = self else {return}
                    
                    ss.dataArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic);
                    NotificationCenter.default.post(name: NSNotification.Name (rawValue: "addActionSubmintOkNotification"), object: nil)
                }, failureHandler: { (str) in
                 HUD.show(successInfo: "Delete Failure")
            })
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
