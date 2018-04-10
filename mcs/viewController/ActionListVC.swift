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
    
    @IBOutlet weak var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = ywNo
        
        _initSubview()
    }

    
    
    func _initSubview()  {
        _tableView.layer.borderWidth = 1
        _tableView.layer.borderColor = kTableviewBackgroundColor.cgColor
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "ActionListCell", bundle: nil), forCellReuseIdentifier: "ActionListCellIdentifier")

        _tableView.tableFooterView = UIView()
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.estimatedRowHeight = 80
    }
    
    
    
    //MARK:-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//
        let name = "ActionListCellIdentifier"

        let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HUD.show()
        let vc = TaskAddActionVC()
        vc.read_only = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
