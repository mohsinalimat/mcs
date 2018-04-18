//
//  Action_Materal_Cell.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Action_Materal_Cell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    var section_index = 0
    var read_only:Bool = false
    var info:[String:Any]!
    
    
    @IBOutlet weak var addBtn_H: NSLayoutConstraint!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var _tableView: UITableView!
    @IBAction func addAction(_ sender: UIButton) {
        switch addAction_Section2_SelectedIndex {
        case 2:
            Tools.showAlert("Add_MateralVC" ,withBar: true,frame:CGRect (x: 0, y: 0, width: 500, height: 500))
            break
            
        case 3:
            Tools.showAlert("Add_ComponentVC" ,withBar: true,frame:CGRect (x: 0, y: 0, width: 500, height: 500))
            break
            
        case 4:
            let vc = UIAlertController.init(title: nil, message: nil, preferredStyle: .alert)
            let action_1 =  UIAlertAction (title: "取消", style: .cancel, handler: nil)
            let action_2 = UIAlertAction (title: "拍照", style: .default, handler: { (action) in
                
            })
            
            let action_3 = UIAlertAction (title: "视频", style: .default, handler: { (action) in
                
            })
            
            vc.addAction(action_1)
            vc.addAction(action_2)
            vc.addAction(action_3)
            
            
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil);
            
            break
            
        default:break
        }

        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        _tableView.layer.borderWidth = 1
        _tableView.layer.borderColor = kTableviewBackgroundColor.cgColor
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "Section_TableViewCell", bundle: nil), forCellReuseIdentifier: "Section_TableViewCellIdentifier")
        _tableView.register(UINib (nibName: "Section_TableViewCell2", bundle: nil), forCellReuseIdentifier: "Section_TableViewCell2Identifier")
        _tableView.register(UINib (nibName: "Section_TableViewCell3", bundle: nil), forCellReuseIdentifier: "Section_TableViewCell3Identifier")
        
        _tableView.tableFooterView = UIView()
        _tableView.rowHeight = 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction), name:  NSNotification.Name.init("add_materialOrComponent_notification"), object: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if read_only {
            addBtn_H.constant = 0;
            addBtn.isHidden = true
        }
        
    }
    
    func refreshAction()  {
        
        _tableView.reloadData()
        
    }
    
    override func prepareForReuse() {
        _tableView.scrollsToTop = true;
    }
    
    
    
    //MARK:-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addAction_Section2_SelectedIndex == 2 {
            return addActionMateralDataArr.count;
        } else if addAction_Section2_SelectedIndex == 3 {
            return addActionComponentDataArr.count;
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch addAction_Section2_SelectedIndex {
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCellIdentifier", for: indexPath) as! Section_TableViewCell
            let d = addActionMateralDataArr[indexPath.row]
            cell.fill(d)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCell2Identifier", for: indexPath) as! Section_TableViewCell2
            let d = addActionComponentDataArr[indexPath.row]
            cell.fill(d)

            return cell

        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCell3Identifier", for: indexPath)

        return cell
    }


    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var name = "Section_Matera_header"
        if addAction_Section2_SelectedIndex == 3 {
            name = "Section_Comp_header";
        } else if addAction_Section2_SelectedIndex == 4 {
            name = "Section_Attach_header";
        }
        
        
        let v = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as! UIView
        v.frame = CGRect (x: 0, y: 0, width: tableView.frame.width, height: 40)
        
        return v;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !read_only
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if addAction_Section2_SelectedIndex == 2 {
                addActionMateralDataArr.remove(at: indexPath.row)   
            } else if addAction_Section2_SelectedIndex == 3 {
                addActionComponentDataArr.remove(at: indexPath.row)
                
            }
            
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    
    
}
