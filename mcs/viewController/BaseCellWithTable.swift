//
//  BaseCellWithTable.swift
//  mcs
//
//  Created by gener on 2018/4/26.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class BaseCellWithTable: UITableViewCell ,UITableViewDelegate,UITableViewDataSource{

    var section_index = 0
    var read_only:Bool = false
    var info:[String:Any]!
    
     var addBtn: UIButton!
    
     var _tableView: UITableView!
    
    var dataArray = [[String:String]]()//
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _tableView = UITableView (frame: CGRect (x: 25, y: 50, width: kCurrentScreenWidth - 50, height: kCurrentScreenHeight - 100 - 240 - 50), style: .plain)
        
        self.addSubview(_tableView)
        
        _init()
        
    }
    
    
    func _init()  {
        _tableView.layer.borderWidth = 1
        _tableView.layer.borderColor = kTableviewBackgroundColor.cgColor
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "Section_TableViewCell", bundle: nil), forCellReuseIdentifier: "Section_TableViewCellIdentifier")
        _tableView.register(UINib (nibName: "Section_TableViewCell2", bundle: nil), forCellReuseIdentifier: "Section_TableViewCell2Identifier")
        _tableView.register(UINib (nibName: "Section_TableViewCell3", bundle: nil), forCellReuseIdentifier: "Section_TableViewCell3Identifier")
        
        _tableView.tableFooterView = UIView()
        _tableView.rowHeight = 60
        
        
        _tableView.reloadData()
        _tableView.layoutIfNeeded()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction), name:  NSNotification.Name.init("add_materialOrComponent_notification"), object: nil)
        
        
        let addBtn = UIButton (frame: CGRect (x: _tableView.frame.width - 50, y: 10, width: 50, height: 30))
        addBtn.setImage(UIImage (named: "add_subscribe_video"), for: .normal)
        addBtn.setImage(UIImage (named: "add_subscribe_video"), for: .highlighted)
        addBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 15)
        addBtn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        self.addSubview(addBtn)
        
    }
    
    func addAction()  {
        
    }
    
    
    
    
    func refreshAction()  {
        
        _tableView.reloadData()
        
    }
    
    override func prepareForReuse() {
        _tableView.scrollsToTop = true;
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //MARK:-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*switch kSectionHeadButtonSelectedIndex {
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCellIdentifier", for: indexPath) as! Section_TableViewCell
            //let d = addActionMateralDataArr[indexPath.row]
            //cell.fill(d)
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCell2Identifier", for: indexPath) as! Section_TableViewCell2
            //let d = addActionComponentDataArr[indexPath.row]
            //cell.fill(d)
            
            return cell
            
        default:
            break
        }*/
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Section_TableViewCell3Identifier", for: indexPath)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var name = "Section_Matera_header"
        /*if kSectionHeadButtonSelectedIndex == 3 {
            name = "Section_Comp_header";
        } else if kSectionHeadButtonSelectedIndex == 4 {
            name = "Section_Attach_header";
        }
        */
        
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
            /*if kSectionHeadButtonSelectedIndex == 2 {
                addActionMateralDataArr.remove(at: indexPath.row)
            } else if kSectionHeadButtonSelectedIndex == 3 {
                addActionComponentDataArr.remove(at: indexPath.row)
                
            }*/
            
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
  
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    
    
    
    
    
    
}
