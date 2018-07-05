//
//  Action_Materal_Cell.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import AVFoundation

class Action_Materal_Cell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    var section_index = 0
    var read_only:Bool = false
    var info:[String:Any]!
    
    var didSelectedRowAtIndex:((Int) -> Void)?
    var addAction:((Void) -> Void)?
    
    @IBOutlet weak var addBtn_H: NSLayoutConstraint!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var _tableView: UITableView!
    
    //MARK:
    @IBAction func addAction(_ sender: UIButton) {
        switch kSectionHeadButtonSelectedIndex {
        case .addActoinValue2,.creatReportValue2:
            Tools.showAlert("Add_MateralVC" ,withBar: true,frame:CGRect (x: 0, y: 0, width: 500, height: 500))
            break
            
        case .addActoinValue3:
            Tools.showAlert("Add_ComponentVC" ,withBar: true,frame:CGRect (x: 0, y: 0, width: 500, height: 500))
            break
            
        case .addActoinValue4 , .creatReportValue3:
            
            TTImagePicker().show(inView:nil, sourceView : sender , completion: { (ig) in
                DispatchQueue.main.async {[weak self] in
                    guard let ss = self else {return}
                    kAttachmentDataArr.insert(ig, at: 0)
                    ss.refreshAction()
                }
            })
            
            break
        case .creatReportValue5:
            if let add = addAction {
                add();
            }
            break
        default:break
        }
    }

    
    //MARK:
    override func awakeFromNib() {
        super.awakeFromNib()
        _tableView.layer.borderWidth = 1
        _tableView.layer.borderColor = kTableviewBackgroundColor.cgColor
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "Section_TableViewCell", bundle: nil), forCellReuseIdentifier: "Section_TableViewCellIdentifier")
        _tableView.register(UINib (nibName: "Section_TableViewCell2", bundle: nil), forCellReuseIdentifier: "Section_TableViewCell2Identifier")
        _tableView.register(UINib (nibName: "Section_TableViewCell3", bundle: nil), forCellReuseIdentifier: "Section_TableViewCell3Identifier")
        _tableView.register(UINib (nibName: "ActionListCell", bundle: nil), forCellReuseIdentifier: "ActionListCellIdentifier")
        
        _tableView.tableFooterView = UIView()
        _tableView.rowHeight = 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction), name:  NSNotification.Name.init("add_materialOrComponent_notification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name.init("ipc_selected_ok_notification"), object: nil)
    }
    
    func noti(_ n:Notification) {
        if let arr = n.userInfo?["data"] as? [[String:Any]] {
            for i in arr {
            let d = ["pn":String.isNullOrEmpty(i["pnr"]) , "description":String.isNullOrEmpty(i["lbl"])]
                addActionMateralDataArr.append(d)
            }
           
            materalDataFromIPC = true
            refreshAction()
        }
        
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
        switch kSectionHeadButtonSelectedIndex {
        case .addActoinValue2, .creatReportValue2:
            
            return addActionMateralDataArr.count;
        case .addActoinValue3:
            return addActionComponentDataArr.count;
            
        case .addActoinValue4 , .creatReportValue3://附件
            return kAttachmentDataArr.count
            
        case .creatReportValue4:
            return 0;
            
        case .creatReportValue5: //action
            return defect_added_actions.count;
        default:return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch kSectionHeadButtonSelectedIndex {
        case .addActoinValue2, .creatReportValue2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCellIdentifier", for: indexPath) as! Section_TableViewCell
            let d = addActionMateralDataArr[indexPath.row]
            cell.fill(d)
            return cell
            
        case .addActoinValue3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCell2Identifier", for: indexPath) as! Section_TableViewCell2
            let d = addActionComponentDataArr[indexPath.row]
            cell.fill(d)

            return cell
        case .creatReportValue5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionListCellIdentifier", for: indexPath) as! ActionListCell
            let d = defect_added_actions[indexPath.row]
            
            cell.fill(d , index: indexPath.row + 1)
            return cell
            
        default: break
        }
        
        //附件
        let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCell3Identifier", for: indexPath) as! Section_TableViewCell3 //img
        let ig  = kAttachmentDataArr[indexPath.row];
        cell.fill(ig)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard kSectionHeadButtonSelectedIndex != .creatReportValue5 else {return 80;}
        guard kSectionHeadButtonSelectedIndex != .creatReportValue3 , kSectionHeadButtonSelectedIndex != .addActoinValue4  else {return 280;}
        
        return 60;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch kSectionHeadButtonSelectedIndex {
        case .creatReportValue4, .creatReportValue5, .addActoinValue4 , .creatReportValue3 :
            return 0;
            
        default:return 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var name = "Section_Matera_header"
        switch kSectionHeadButtonSelectedIndex {
        case .addActoinValue3:
            name = "Section_Comp_header"
            
        case .addActoinValue4 , .creatReportValue3:
            name = "Section_Attach_header";
            break
            
        default: name = "Section_Matera_header";
            break
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
            let vc = UIAlertController.init(title: "Delete?",message: nil, preferredStyle: .alert)
            let action = UIAlertAction.init(title:"Cancel", style: .default)
            let action2 = UIAlertAction.init(title: "Delete", style: .destructive) { (action) in
                if (kSectionHeadButtonSelectedIndex == .addActoinValue2) || (kSectionHeadButtonSelectedIndex == .creatReportValue2) {
                    addActionMateralDataArr.remove(at: indexPath.row)
                } else if kSectionHeadButtonSelectedIndex == .addActoinValue3 {
                    addActionComponentDataArr.remove(at: indexPath.row)
                    
                } else if kSectionHeadButtonSelectedIndex == .creatReportValue5 {
                    defect_added_actions.remove(at: indexPath.row);
                } else if (kSectionHeadButtonSelectedIndex == .addActoinValue4) || (kSectionHeadButtonSelectedIndex == .creatReportValue3) {
                    kAttachmentDataArr.remove(at: indexPath.row)
                }
                
                tableView.deleteRows(at: [indexPath], with: .top)

            }
            
            vc.addAction(action)
            vc.addAction(action2)
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil);
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch kSectionHeadButtonSelectedIndex {
        case .addActoinValue2, .creatReportValue2:
            let v = Add_MateralVC()
            v.index = indexPath.row
            
            Tools.showVC(v, withBar: true, frame: CGRect (x: 0, y: 0, width: 500, height: 500))
            break
            
        case .creatReportValue5:
            if let handler = didSelectedRowAtIndex {
                handler(indexPath.row);
            };break
        
        default:break
    }
    }
    
}

