//
//  TaskPoolBaseController.swift
//  
//
//  Created by gener on 2018/3/2.
//
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
class TaskPoolBaseController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var topBgView: UIView!
    @IBOutlet weak var search_bgview: UIView!
    @IBOutlet weak var select_date_btn: UIButton!
    @IBOutlet weak var select_shift_btn: UIButton!
    @IBOutlet weak var select_station_btn: UIButton!
    @IBOutlet weak var _tableView: UITableView!
    
    var dataArray = [[String:Any]]()
    let disposeBag =  DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        _initSubviews()
        
        ///..........
        search_bgview.isHidden = true;
        
        NotificationCenter.default.rx.notification(NSNotification.Name.init("notification-selected-complete")).subscribe { [weak self] (event) in
            guard let strongSelf = self else {return}
                strongSelf._init_top();
                strongSelf.getTaskPool();
            }.addDisposableTo(disposeBag)
        

        //guard kTaskpool_date != nil ,kTaskpool_shift != nil , kTaskpool_station != nil else {  _pop(); return}
        getTaskPool()
        
    }
    

    //MARK:-
    func getTaskPool()  {
        HUD.show(withStatus: "Loading")
        
        let d = ["shift":"30b621f4455545828b0b0e2d9e2fb9f3",
                 "scheduleTime":"23/03/2018"
        ]
        
        netHelper_request(withUrl: task_pool_url, method: .post, parameters: d, successHandler: {[weak self] (result) in
            HUD.dismiss()
            
            guard let body = result["body"] as? [String : Any] else {return;}
            guard let recordList = body["recordList"] as? [[String : Any]] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf.dataArray = strongSelf.dataArray + recordList
            strongSelf._tableView.reloadData()
            
            }
        )
        
    }
    
    func _pop() {
        let vc = TaskPoolSelectController()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 360)
        vc.view.frame = frame
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
    }
    
    
    //MARK: - init
    func _initSubviews()  {
        let currentDateStr = Tools.dateToString(Date(), formatter: "yyyy-MM-dd")
        select_date_btn.setTitle(currentDateStr, for: .normal)
        
        _init_top();
        

        /////
        _tableView.register(UINib (nibName: "TaskPoolCell", bundle: nil), forCellReuseIdentifier: "TaskPoolCellIdentifier")
        _tableView.register(UINib (nibName: "TaskActionCell", bundle: nil), forCellReuseIdentifier: "TaskActionCellIdentifier")
        _tableView.register(UINib (nibName: "TaskHandCell", bundle: nil), forCellReuseIdentifier: "TaskHandCellIdentifier")
        _tableView.tableFooterView = UIView()
        //_tableView.separatorStyle = .none
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 80
    
        
        topBgView.layer.borderColor = kTableviewBackgroundColor.cgColor
        topBgView.layer.borderWidth = 1
    }
    
    func _init_top() {
        guard kTaskpool_date != nil ,kTaskpool_shift != nil , kTaskpool_station != nil else {return}
        select_shift_btn.setTitle(kTaskpool_shift?["value"], for: .normal)
        select_date_btn.setTitle(Tools.dateToString(kTaskpool_date!, formatter: "yyyy-MM-dd"), for: .normal)
        select_station_btn.setTitle(kTaskpool_station, for: .normal)
    }
    
    @IBAction func selectData(_ sender: UIButton) {
        _tableView.isEditing = false
        Tools.showAlert("TaskPoolSelectController")
    }

    
    //MARK:
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let list = dataArray[section]["actionList"] as? [[String:Any]], list.count >= 0 {
            return list.count + 1;
        }
        
        
        return 1
    }
    
    
    var type = 0

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.type == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskPoolCellIdentifier", for: indexPath) as! TaskPoolCell
                
                let d = dataArray[indexPath.section]
                
                cell.fill( d)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskActionCellIdentifier", for: indexPath) as! TaskActionCell
                let d = dataArray[indexPath.section]
                if let _actions = d["actionList"] as? [[String:Any]]{
                    cell.fill( _actions[indexPath.row - 1], first: indexPath.row == 1);
                }
                
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskHandCellIdentifier", for: indexPath) as! TaskHandCell
            
            return cell
        }
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == 0 {
            return indexPath.row == 0 ? 90 : 30;
        }else {
            return 80;
        }
        
    }

    

    let _sectinHeight:CGFloat = 40
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return _sectinHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _sectinHeight))
        v.backgroundColor = UIColor.white
        
        let lable = UILabel (frame: CGRect (x: 20, y: _sectinHeight - 30, width: tableView.frame.width - 20, height: 30))
        if let d = dataArray[section]["ac"]  as? String {
            lable.text = d
        }
        
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textColor = UIColor (colorLiteralRed: 220/255.0, green: 180/255.0, blue: 50/255.0, alpha: 1)
        v.addSubview(lable)
        return v
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //return
        
        if let taskid = dataArray[indexPath.section]["taskId"]  as? String {
            let vc = TaskPoolDetailController()
            vc.taskId = taskid
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction.init(style: .destructive, title: "Delete") { (action, indexPath) in
            tableView.isEditing = false
            
        }
        
        

        let action2 = UITableViewRowAction.init(style: .default, title: "Submit") { (action, indexPath) in
            
            
        }
        action2.backgroundColor = UIColor.init(colorLiteralRed: 0/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1)
        
        
        
        let action3 = UITableViewRowAction.init(style: .default, title: "Change Shift") { (action, indexPath) in
            
            Tools.showAlert("TaskChangeShiftVC" ,withBar: true)
            
        }

        action3.backgroundColor = UIColor.init(colorLiteralRed: 102/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        
        let action4 = UITableViewRowAction.init(style: .default, title: "Add Action") { (action, indexPath) in
            DispatchQueue.main.async {
                HUD.show()
                let vc = TaskAddActionVC()

                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
        action4.backgroundColor = UIColor.init(colorLiteralRed: 219/255.0, green: 118/255.0, blue: 51/255.0, alpha: 1)
        return [action1,action2,action3,action4]
    }
    
    
    
}
