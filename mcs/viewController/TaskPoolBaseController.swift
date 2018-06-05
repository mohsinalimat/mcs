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
    
    private var deleteSectionArr = [Int]()//要删除的
    
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
        
        NotificationCenter.default.rx.notification(NSNotification.Name.init("taskpool_changeShift_completion_notification")).subscribe { [weak self] (event) in
            guard let strongSelf = self else {return}
            strongSelf.getTaskPool();
            }.addDisposableTo(disposeBag)
        
       NotificationCenter.default.rx.notification(NSNotification.Name (rawValue: "addActionSubmintOkNotification")).subscribe { [weak self] (event) in
        guard let strongSelf = self else {return}
        strongSelf.getTaskPool();
        }.addDisposableTo(disposeBag)
        
        
        guard kTaskpool_date != nil ,kTaskpool_shift != nil , kTaskpool_station != nil else {  _pop(); return}
        getTaskPool()
        
    }
    

    //MARK:-
    func getTaskPool()  {
        guard kTaskpool_date != nil ,kTaskpool_shift != nil , kTaskpool_station != nil else {  return}
        
        HUD.show(withStatus: "Loading")
        
        let scheduleTime = Tools.dateToString(kTaskpool_date!, formatter: "dd/MM/yyyy")
        guard let shift = kTaskpool_shift?["key"] else {return}
        
        let d = [
            "shift":shift,
            "scheduleTime":scheduleTime
            
        ]
        
        netHelper_request(withUrl: task_pool_url, method: .post, parameters: d, successHandler: {[weak self] (result) in
            HUD.dismiss()
            
            guard let body = result["body"] as? [String : Any] else {return;}
            guard let recordList = body["recordList"] as? [[String : Any]] else {return;}
            guard let strongSelf = self else{return}
            if strongSelf._tableView.mj_header.isRefreshing(){
                strongSelf._tableView.mj_header.endRefreshing();
            }

            strongSelf.dataArray.removeAll()
            strongSelf.dataArray = strongSelf.dataArray + recordList
            strongSelf._tableView.reloadData()
            strongSelf._tableView.layoutIfNeeded()
            
            if strongSelf.dataArray.count == 0 {
                strongSelf.displayMsg("No Data");
            }else {
                strongSelf.view.viewWithTag(1001)?.removeFromSuperview();
            }
            
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
        
        ///Refresh Data
        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {
                self.dataArray.removeAll()
                self.getTaskPool()
            }
        }
        
        _tableView.mj_header = header
        
        
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
        
        if let list = dataArray[section]["allActions"] as? [[String:Any]], list.count >= 0 {//actionList
            return list.count + 1;
        }
        
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskPoolCellIdentifier", for: indexPath) as! TaskPoolCell
            
            let d = dataArray[indexPath.section]
            
            cell.fill( d)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskActionCellIdentifier", for: indexPath) as! TaskActionCell
            let d = dataArray[indexPath.section]
            if let _actions = d["allActions"] as? [[String:Any]]{
                cell.fill( _actions[indexPath.row - 1], first: indexPath.row == 1);
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 100 : 30;
    }

    

    let _sectinHeight:CGFloat = 40
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return _sectinHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _sectinHeight))
        v.backgroundColor = kTableviewBackgroundColor//UIColor.white
        
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
        let d = dataArray[indexPath.section];
        taskPoolSelectedTask = dataArray[indexPath.section]
        
        if let taskid = d["taskId"]  as? String , let yw = d["taskNo"] as? String, let ywtp = d["taskType"] as? String{
            let vc = TaskPoolDetailController()
            vc.taskId = taskid
            vc.ywNo = yw
            vc.ywType = ywtp
            vc.task_pool_dataArr = dataArray
            let scheduletime = Tools.date(String.stringIsNullOrNil(d["scheduleTime"]))
            if let d = scheduletime {
                vc.schedule_time = Tools.dateToString(d, formatter: "yyyy-MM-dd")
            }

            task_pool_taskno_index = indexPath.section
            
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
        taskPoolSelectedTask = dataArray[indexPath.section]
        
        let taskid = dataArray[indexPath.section]["bizId"] as! String
        let action1 = UITableViewRowAction.init(style: .destructive, title: "Delete") {[weak self] (action, indexPath) in
            tableView.isEditing = false
            
            guard let ss = self else {return}
            ss.showMsg("Delete This Task?", title: "Delete", handler: {
                ss._deleteMisAction([taskid])
            })

        }
        
        let action2 = UITableViewRowAction.init(style: .default, title: "Submit") {[weak self] (action, indexPath) in
            tableView.isEditing = false
            
            guard let ss = self else {return}
            let taskid = ss.dataArray[indexPath.section]["taskId"] as! String
            
            ss.showMsg("Submit This Task?", title: "Submit", handler: {
                ss._submit([taskid])
            })
        }
        action2.backgroundColor = UIColor.init(colorLiteralRed: 0/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1)
        
        
        
        let action3 = UITableViewRowAction.init(style: .default, title: "Change Shift") { (action, indexPath) in
            tableView.isEditing = false
            
            Tools.showAlert("TaskChangeShiftVC" ,withBar: true)
            
        }
        action3.backgroundColor = UIColor.init(colorLiteralRed: 102/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        
        let action4 = UITableViewRowAction.init(style: .default, title: "Add Action") { (action, indexPath) in
            tableView.isEditing = false
            
            DispatchQueue.main.async {
                HUD.show()
                let vc = TaskAddActionVC()

                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
        action4.backgroundColor = UIColor.init(colorLiteralRed: 219/255.0, green: 118/255.0, blue: 51/255.0, alpha: 1)
        
        if let canDelete = dataArray[indexPath.section]["allowDelete"] as? Bool {
            return canDelete ? [action1,action2,action3,action4] : [action2,action3,action4];
        }
        
        return [action2,action3,action4]
    }
    
    
    //MARK:
    
    func _deleteMisAction(_ ids:[String]) {
        HUD.show()
        
        request(taskPool_deleteMis_url, parameters: ["bizIds":ids], successHandler: { [weak self] (res) in
            HUD.show(successInfo: "Delete Success")
            
            guard let ss = self else {return}
            //ss._tableView.deleteSections([0], animationStyle: .top)
            ss.getTaskPool()
            }, failureHandler: { (str) in
               HUD.show(info: str ?? "Delete Error")
        })
  
    }
    
    func _submit(_ ids :[String])  {
        HUD.show()
        
        request(taskPool_submit_url, parameters: ["taskIds":ids], successHandler: { [weak self] (res) in
            HUD.show(successInfo: "Submit Success")
            
            guard let ss = self else {return}
            ss.getTaskPool()
            }, failureHandler: { (str) in
                HUD.show(info: str ?? "Submit Error")
        })
    }
    
    
}
