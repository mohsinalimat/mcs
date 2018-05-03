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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
    
        _initSubviews();
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
        //tableView.separatorColor = kTableviewBackgroundColor
        
        
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
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialSearchCellIdentifier", for: indexPath) as! MaterialSearchCell
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = Bundle.main.loadNibNamed("MaterialOrderHead", owner: nil, options: nil)?.first as! MaterialOrderHead
        
        return v
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
