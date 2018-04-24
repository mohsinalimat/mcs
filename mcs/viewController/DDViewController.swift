//
//  DDViewController.swift
//  mcs
//
//  Created by gener on 2018/4/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDViewController: BaseTabItemController  ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var btn_status: UIButton!
    
    @IBOutlet weak var btn_ac: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "DD List"
        view.backgroundColor = UIColor.white
        
        _initSubviews()

    }

    
    
    //MARK: - init
    func _initSubviews()  {
        
        /////
        tableView.register(UINib (nibName: "DefectReportCell", bundle: nil), forCellReuseIdentifier: "DefectReportCellIdentifier")
        tableView.tableFooterView = UIView()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        //_tableView.separatorStyle = .singleLine
        
        
        
        ///Refresh Data
        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {
                //                self.dataArray.removeAll()
                //                self.getTaskPool()
            }
        }
        
        tableView.mj_header = header
        
    }
    
    
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefectReportCellIdentifier", for: indexPath) as! DefectReportCell
        
        
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
