//
//  MaterialSearchController.swift
//  mcs
//
//  Created by gener on 2018/5/3.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MaterialSearchController: BaseViewController  ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        _initSubviews()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero

//        print("search")
//        print(tableView.frame)
    }
    
    //MARK: - init
    func _initSubviews()  {
        
        /////
        tableView.register(UINib (nibName: "MaterialSearchCell", bundle: nil), forCellReuseIdentifier: "MaterialSearchCellIdentifier")
        tableView.tableFooterView = UIView()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.separatorStyle = .none

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialSearchCellIdentifier", for: indexPath) as! MaterialSearchCell
        
        
        return cell
        
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
