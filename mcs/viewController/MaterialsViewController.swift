//
//  MaterialsViewController.swift
//  mcs
//
//  Created by gener on 2018/4/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MaterialsViewController:BaseTabItemController /* ,UITableViewDelegate,UITableViewDataSource*/ {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Aviation Materials"
        view.backgroundColor = UIColor.white
        
//        _initSubviews()
        
    }

    //MARK: - init
//    func _initSubviews()  {
//        
//        /////
//        _tableView.register(UINib (nibName: "DefectReportCell", bundle: nil), forCellReuseIdentifier: "DefectReportCellIdentifier")
//        _tableView.tableFooterView = UIView()
//        
//        
//        _tableView.delegate = self
//        _tableView.dataSource = self
//        _tableView.rowHeight = 90
//        //_tableView.separatorStyle = .singleLine
//        
//        
//        
//        ///Refresh Data
//        let header = TTRefreshHeader.init {
//            DispatchQueue.main.async {
//                //                self.dataArray.removeAll()
//                //                self.getTaskPool()
//            }
//        }
//        
//        _tableView.mj_header = header
//        
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return 30;
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DefectReportCellIdentifier", for: indexPath) as! DefectReportCell
//        
//        if tableView.isEditing{
//            cell.setSelectInEdit(_selectedIndexArrr.contains(indexPath.row));
//        }
//        
//        
//        return cell
//        
//    }
    
    

}
