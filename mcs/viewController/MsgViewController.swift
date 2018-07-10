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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _init()
        
        loadData()
    }
    
    func loadData() {
        HUD.show()
        if let arr = Msg {
            dataArray = arr;
            title = "Message(\(arr.count))"
            tableview.reloadData()
        }
        HUD.dismiss()
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
        let exitItem  = UIBarButtonItem (customView: exitBtn)
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 20
        
        //navigationItem.rightBarButtonItems = [fixed, exitItem]
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
        
        //cell.backgroundColor = indexPath.row % 2 == 0 ? kTableViewCellbg_whiteColor : kTableViewCellbg_hightlightColor
        
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

