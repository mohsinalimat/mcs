//
//  SearchItemSelectController.swift
//  mcs
//
//  Created by gener on 2018/4/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

enum SelectDataType {
    case defect
    case ac
    case status
}

class SearchItemSelectController: UITableViewController{

    var dataArray = [Any]()
    var dataType = SelectDataType.defect
    var selectedHandle:((Any) -> Void)?
    
    var selectedObjs:Any?
    
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
        tableView.tableFooterView = UIView()
        
        if let last = selectedObjs {
            if dataType == .ac {
                let _arr = last as! [String]
                let ds = dataArray as! [String]
                
                for i in _arr {
                    if let index = ds.index(of: i){
                        _hasSelectedArr.append(index);
                    }
                }
            }else {
                let d = last as! [String:String]
                let key = d["key"]
                let ds = dataArray as! [[String:String]]
                for i in 0..<ds.count {
                    let d = ds[i]
                    let k = d["key"];
                    if k == key{
                        _hasSelectedArr.append(i);
                        break
                    }
                }
            }

        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCellIdentifier", for: indexPath) as! SearchItemCell

        var t :String?
        switch dataType {
            case .ac:
                t = dataArray[indexPath.row] as? String;
                break
            case .defect , .status:
                let d = dataArray[indexPath.row] as! [String:String]
                t = d["value"]
                break
        }
        
        
        cell.title.text = t
        cell.accessoryType =  _hasSelectedArr.contains(indexPath.row) ? UITableViewCellAccessoryType.checkmark : .none;
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataType == .defect || dataType == .status {
            _hasSelectedArr.removeAll();
        }
        
        if _hasSelectedArr.contains(indexPath.row) {
            _hasSelectedArr.remove(at: _hasSelectedArr.index(of: indexPath.row)!);
        }else {
            _hasSelectedArr.append(indexPath.row);
        }
        
        tableView.reloadData()
    }

    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head_v = Bundle.main.loadNibNamed("SearBarView", owner: nil, options: nil)?.first as! SearBarView
        head_v.frame = CGRect (x: 0, y: 0, width: tableView.frame.width, height: 64)
        head_v.backgroundColor = UIColor.white
        head_v.title.text = "Defect Type"
        
        head_v.selectedActionHandler = { [weak self] index in
            guard let  ss  = self else {return}
            
            if index == 2 {
                ss._submit();
            }
            
            _ = ss.navigationController?.popViewController(animated: true)
        }
        
        let bg_v = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 65))
        bg_v.backgroundColor = kTableviewBackgroundColor
        bg_v.addSubview(head_v)

        return bg_v;
    }
    
    
    func _submit()  {
        if dataType == .defect || dataType == .status {
            let d = dataArray[_hasSelectedArr.first!]
            if let handle = selectedHandle {
                handle(d);
            }
        }else {
            var arr = [String]();
            for i in 0..<_hasSelectedArr.count {
                let s = dataArray[_hasSelectedArr[i]];
                arr.append(s as! String)
            }
            
            if let handle = selectedHandle {
                handle(arr);
            }
        }

    }
    
}
