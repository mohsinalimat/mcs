//
//  SearchItemSelectController.swift
//  mcs
//
//  Created by gener on 2018/4/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class SearchItemSelectController: UITableViewController{

    var _hasSelectedArr = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kTableviewBackgroundColor
        _init()
        
    }


    func _init()  {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellIdentifier")
        tableView.register(UINib (nibName: "SearchItemCell", bundle: nil), forCellReuseIdentifier: "SearchItemCellIdentifier")
        tableView.rowHeight = 60
        
        let head_v = Bundle.main.loadNibNamed("SearBarView", owner: nil, options: nil)?.first as! SearBarView
        head_v.frame = CGRect (x: 0, y: 0, width: tableView.frame.width, height: 64)
        head_v.backgroundColor = UIColor.white
        head_v.title.text = "Defect Type"
        
        head_v.selectedActionHandler = { [weak self] index in
            guard let  ss  = self else {return}
            
            if index == 2 {
                
            }
            
            _ = ss.navigationController?.popViewController(animated: true)
        }
        
        let bg_v = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 80))
        bg_v.backgroundColor = kTableviewBackgroundColor
        bg_v.addSubview(head_v)
        
        tableView.tableHeaderView = bg_v
        tableView.tableFooterView = UIView()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCellIdentifier", for: indexPath)

        // Configure the cell...
        //cell.textLabel?.text = "\(indexPath.row)";
        //cell.backgroundColor = UIColor.red
        cell.accessoryType =  _hasSelectedArr.contains(indexPath.row) ? UITableViewCellAccessoryType.checkmark : .none;
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if _hasSelectedArr.contains(indexPath.row) {
            _hasSelectedArr.remove(at: _hasSelectedArr.index(of: indexPath.row)!);
        }else {
            _hasSelectedArr.append(indexPath.row);
        }
        
        tableView.reloadData()
    }

}
