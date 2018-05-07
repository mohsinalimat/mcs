//
//  MaterialOrderController.swift
//  mcs
//
//  Created by gener on 2018/5/3.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MaterialOrderController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var openedIndex:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        self.automaticallyAdjustsScrollViewInsets = false;
        
        _initSubviews();
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        
//        print("order")
//        print(tableView.frame)
    }

    //MARK: - init
    func _initSubviews()  {
        tableView.register(UINib (nibName: "MaterialOrderCell", bundle: nil), forCellReuseIdentifier: "MaterialOrderCellIdentifier")
        tableView.tableFooterView = UIView()
        
        let v = UIView (frame: CGRect (x: 0, y: 0, width: 0.0001, height:0.001))
        tableView.tableHeaderView = v

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.backgroundColor = UIColor.white;
        
        ///Refresh Data
        //        let header = TTRefreshHeader.init {
        //            DispatchQueue.main.async {
        //                //                self.dataArray.removeAll()
        //                //                self.getTaskPool()
        //            }
        //        }
        //
        //        tableView.mj_header = header
        
    }
    
    
    //MARK:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedIndex >= 0 && openedIndex == section {
            return 5;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialOrderCellIdentifier", for: indexPath) as! MaterialOrderCell
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = Bundle.main.loadNibNamed("MaterialOrderHead", owner: nil, options: nil)?.first as! MaterialOrderHead
        v.clickedAction = { [weak self] b in
            guard let ss = self else {return}
            ss.openedIndex = b ? section : -1
            ss.tableView.reloadData()
        }
        
        v.arrow_btn.isSelected = openedIndex == section
        
        return v
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
