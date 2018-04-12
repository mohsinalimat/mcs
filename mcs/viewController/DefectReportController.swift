//
//  DefectReportController.swift
//  mcs
//
//  Created by gener on 2018/4/12.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DefectReportController: BaseTabItemController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var _tableView: UITableView!
    
    @IBOutlet weak var select_bg: UIView!
    
    @IBOutlet weak var delete_bg: UIView!
    
    @IBOutlet weak var select_bg_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var delete_bg_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    
    var _selectedIndexArrr = [Int]()
    
    @IBAction func buttonAction(_ sender: UIButton) {
    
        switch sender.tag {
        case 1:
            select_bg.isHidden = true
            delete_bg.isHidden = false
            _tableView.isEditing = true
            _tableView.reloadData()
            break
            
        case 2:
            
            break
            
        case 3:
            
            break
            
        case 4:
            
            break
            
        case 5:
            
            break
            
        case 6:
            select_bg.isHidden = false
            delete_bg.isHidden = true
            _tableView.isEditing = false
            _tableView.reloadData()
            break
            
        default:break
        }
    
    
    
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //delete_bg_constraint.constant = 0
        view.backgroundColor = UIColor.white
        title = "Defect List"
        
        delete_bg.isHidden = true
        
        _initSubviews()
    }

    
    
    
    //MARK: - init
    func _initSubviews()  {

        /////
        _tableView.register(UINib (nibName: "DefectReportCell", bundle: nil), forCellReuseIdentifier: "DefectReportCellIdentifier")
        _tableView.tableFooterView = UIView()
        
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 90
        //_tableView.separatorStyle = .singleLine
        

        
        ///Refresh Data
        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {
//                self.dataArray.removeAll()
//                self.getTaskPool()
            }
        }
        
        _tableView.mj_header = header
        
    }
    
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefectReportCellIdentifier", for: indexPath) as! DefectReportCell
        
        if tableView.isEditing{
            cell.setSelectInEdit(_selectedIndexArrr.contains(indexPath.row));
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("...");
        
        if _tableView.isEditing {
            if _selectedIndexArrr.contains(indexPath.row){
                _selectedIndexArrr.remove(at: _selectedIndexArrr.index(of: indexPath.row)!);
            }else {
                _selectedIndexArrr.append(indexPath.row);
            }
            
            
            _tableView.reloadData()
        }

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
