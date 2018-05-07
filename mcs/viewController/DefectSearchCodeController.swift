//
//  DefectSearchCodeController.swift
//  mcs
//
//  Created by gener on 2018/5/7.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DefectSearchCodeController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var _searchBar:UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        
        // Do any additional setup after loading the view.
        _init()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _searchBar.becomeFirstResponder()
    }
    
    
    func _init() {
        let closebtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        closebtn.setTitle("Cancel", for: .normal)
        closebtn.setTitleColor(UIColor.white, for: .normal)
        closebtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        closebtn.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        closebtn.tag = 100
        let litem = UIBarButtonItem (customView: closebtn)
        navigationItem.rightBarButtonItem = litem

        let searchBar = UISearchBar.init(frame: CGRect (x: 0, y: 0, width: 380, height: 25))
        searchBar.placeholder = "Search"
        _searchBar = searchBar
        
        let litem1 = UIBarButtonItem (customView: searchBar)
        navigationItem.leftBarButtonItem = litem1

        
        /////
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaseTableViewVCCellIdentifier", for: indexPath) as! BaseTableViewVCCell
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let tmp = cellSelectedAction {
//            tmp(indexPath.row)
//            
//            self.dismiss(animated: false, completion: nil)
//        }
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
