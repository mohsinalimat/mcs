//
//  BaseTableViewVC.swift
//  mcs
//
//  Created by gener on 2018/4/10.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class BaseTableViewVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var tableview:UITableView?
    var dataArray = [Any]()
    
    var cellSelectedAction:((Int) -> (Void))?
    var cellSelectedIndex : Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        
        // Do any additional setup after loading the view.
        tableview = UITableView (frame: CGRect (x: 0, y: 0, width: 400, height: 360), style: .plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        //tableview?.backgroundColor = kTableviewBackgroundColor
        tableview?.showsVerticalScrollIndicator = false
        tableview?.rowHeight = 50
        tableview?.separatorStyle = .none;
        tableview?.tableFooterView = UIView()
        view.addSubview(tableview!)
        
        //tableview?.register(UITableViewCell.self, forCellReuseIdentifier: "BaseTableViewVCCellIdentifier")
        tableview?.register(UINib (nibName: "BaseTableViewVCCell", bundle: nil), forCellReuseIdentifier: "BaseTableViewVCCellIdentifier")
        tableview?.reloadData()
        tableview?.scrollToRow(at: IndexPath.init(row: task_pool_taskno_index, section: 0), at: .top, animated: false)
    }

    func getTextAt(_ indexPath:Int) -> (len:Int , text: String?)? {
        
        return nil
    }
    
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaseTableViewVCCellIdentifier", for: indexPath) as! BaseTableViewVCCell

        if let cup = getTextAt(indexPath.row) {

            let defectAttriStr =  NSMutableAttributedString.init(string: cup.text ?? "")
            defectAttriStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15),NSForegroundColorAttributeName:UIColor.darkGray], range: NSMakeRange(0, cup.len))
            cell._title.attributedText = defectAttriStr

            cell.accessoryType = task_pool_taskno_index == indexPath.row ? UITableViewCellAccessoryType.checkmark : .none
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tmp = cellSelectedAction {
            tmp(indexPath.row)
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    


}
