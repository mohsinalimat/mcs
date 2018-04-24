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
class TaskHandleController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

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

        NotificationCenter.default.rx.notification(NSNotification.Name.init("notification-selected-complete")).subscribe { [weak self] (event) in
            guard let strongSelf = self else {return}
                strongSelf._init_top();
                strongSelf.getTaskPool();
            }.addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name.init("taskpool_changeShift_completion_notification")).subscribe { [weak self] (event) in
            guard let strongSelf = self else {return}
            strongSelf.getTaskPool();
            }.addDisposableTo(disposeBag)

        NotificationCenter.default.rx.notification(NSNotification.Name (rawValue: "addActionSubmintOkNotification")).subscribe {[weak self] (event) in
            guard let strongSelf = self else {return}
            strongSelf.getTaskPool();
            }.addDisposableTo(disposeBag)

        guard kTaskpool_date != nil ,kTaskpool_shift != nil , kTaskpool_station != nil else {  /*_pop();*/ return}
        getTaskPool();
    }
    

    //MARK:-
    func getTaskPool()  {
        //HUD.show(withStatus: "Loading")

        let scheduleTime = Tools.dateToString(kTaskpool_date!, formatter: "dd/MM/yyyy")
        guard let shift = kTaskpool_shift?["key"] else {return}
        
        let d = [
            "shift":shift,
            "scheduleTime":scheduleTime
            
        ]
        
        netHelper_request(withUrl: handle_over_url, method: .post, parameters: d, successHandler: {[weak self] (result) in
            //HUD.dismiss()
            
            guard let body = result["body"] as? [[String : Any]] else {return;}
            guard let strongSelf = self else{return}
            
            if strongSelf._tableView.mj_header.isRefreshing(){
                strongSelf._tableView.mj_header.endRefreshing();
            }

            strongSelf.dataArray.removeAll()
            strongSelf.dataArray = strongSelf.dataArray + body
            strongSelf._tableView.reloadData()
            
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
        
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 85
        //_tableView.separatorStyle = .singleLine

        
        topBgView.layer.borderColor = kTableviewBackgroundColor.cgColor
        topBgView.layer.borderWidth = 1
        search_bgview.isHidden = true
        
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
        let vc = TaskPoolSelectController()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 360)
        vc.view.frame = frame
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
    }

    
    //MARK:
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskHandCellIdentifier", for: indexPath) as! TaskHandCell
        let d = dataArray[indexPath.section];
        cell.fill(d)
        
        return cell

    }

    let _sectinHeight:CGFloat = 40
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return _sectinHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _sectinHeight))
        v.backgroundColor = kTableviewBackgroundColor
        
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
        
        if let taskid = d["taskId"]  as? String , let yw = d["bizNo"] as? String , let ywtp = d["bizType"] as? String{
            let vc = TaskPoolDetailController()
            vc.taskId = taskid
            vc.ywNo = yw
            vc.ywType = ywtp
            
            let scheduletime = Tools.date(String.stringIsNullOrNil(d["scheduleTime"]))
            if let d = scheduletime {
                vc.schedule_time = Tools.dateToString(d, formatter: "yyyy-MM-dd")
            }

            vc.from_taskPool = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        /*let action1 = UITableViewRowAction.init(style: .destructive, title: "Delete") { (action, indexPath) in
            tableView.isEditing = false
            
        }
        
        
        
        let action2 = UITableViewRowAction.init(style: .default, title: "Submit") { (action, indexPath) in
            
            
        }
        action2.backgroundColor = UIColor.init(colorLiteralRed: 0/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1)
        
        
        
        let action3 = UITableViewRowAction.init(style: .default, title: "Change Shift") { (action, indexPath) in
            
            Tools.showAlert("TaskChangeShiftVC" ,withBar: true)
            
        }
        
        action3.backgroundColor = UIColor.init(colorLiteralRed: 102/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        */
        let action4 = UITableViewRowAction.init(style: .default, title: "Add Action") { (action, indexPath) in
            DispatchQueue.main.async {
                HUD.show()
                let vc = TaskAddActionVC()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        action4.backgroundColor = UIColor.init(colorLiteralRed: 219/255.0, green: 118/255.0, blue: 51/255.0, alpha: 1)
        return [/*action1,action2,action3,*/action4]
    }
    
    
    
    

}
