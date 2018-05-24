//
//  DefectReportController.swift
//  mcs
//
//  Created by gener on 2018/4/12.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import MJRefresh

class DefectReportController: BaseTabItemController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var _tableView: UITableView!
    
    @IBOutlet weak var select_bg: UIView!
    
    @IBOutlet weak var delete_bg: UIView!
    
    @IBOutlet weak var select_bg_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var delete_bg_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    
    var dataArray = [[String:Any]]()
    var _selectedIndexArrr = [Int]()
    
    let disposeBag = DisposeBag.init()
    let rx_selected: Variable<[Int]> = Variable.init([])
    
    var _pageNum:Int = 1
    var _isSearch:Bool = false
    var _searchPars:[String:Any]?
    
    //MARK:
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            _selectedIndexArrr.removeAll()
            select_bg.isHidden = true
            delete_bg.isHidden = false
            _tableView.isEditing = true
            _tableView.reloadData()
            break
            
        case 2: _pop();break
        case 3:
            HUD.show()
            let v = ReporFormController()
            self.navigationController?.pushViewController(v, animated: true); break
        case 4:
            let taskid = _getSelectedId()
            guard taskid.count > 0 else {return}
            self.showMsg("Delete This Task?", title: "Delete", handler: {[weak self] in
                guard let ss = self else {return}
                ss._delete(taskid)
                })
            break
        case 5://submit
            let taskid = _getSelectedId()
            guard taskid.count > 0 else {return}
            
            self.showMsg("Submit This Task?", title: "Submit", handler: {[weak self] in
                guard let ss = self else {return}
                ss._submit(taskid)
            })
            
            break
        case 6:_initStatus();break
        default:break
        }
    }

    func _initStatus()  {
        select_bg.isHidden = false
        delete_bg.isHidden = true
        _tableView.isEditing = false
        _tableView.reloadData()
    }
    
    
    func _getSelectedId() -> [String]{
        guard _selectedIndexArrr.count > 0 else {return []}
        var taskids = [String]()
        for index in _selectedIndexArrr {
            let d = dataArray[index];
            if let taskno = d["id"] as? String {
                taskids.append(taskno);
            }
        }
        
        return taskids
    }

    func _submit(_ ids :[String])  {
        HUD.show()
        
        request(defect_submit_url, parameters: ["bizIds":ids], successHandler: { [weak self] (res) in
            HUD.show(successInfo: "Submit Success")
            
            guard let ss = self else {return}
            ss._initStatus()
            ss.loadData()
            }, failureHandler: { (str) in
                HUD.show(info: str ?? "Submit Error")
        })
    }

    func _delete(_ ids :[String])  {
        HUD.show()
        
        netHelper_request(withUrl: defect_delete_url, method: .delete, parameters: ["bizIds":ids], successHandler: { [weak self] (res) in
            HUD.show(successInfo: "Delete Success")
            
            guard let ss = self else {return}
            ss._initStatus()
            ss.loadData()
            }, failureHandler: { (str) in
                HUD.show(info: str ?? "Error")
        })

    }
    
    
    
    func _pop() {
        let maskView = UIView (frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.5;
        maskView.tag = 1001
        UIApplication.shared.keyWindow?.addSubview(maskView)
        
        let rect = CGRect (x: kCurrentScreenWidth - 480, y: 0, width: 480, height: kCurrentScreenHeight)
        let vc = UIStoryboard.init(name: "SearchAction", bundle: nil).instantiateViewController(withIdentifier: "defectSearchSbid") as! DefectSearchController
        
        vc.searchAction = { [weak self] d in
            guard let ss = self else {return}
            ss._searchPars = d
            ss._isSearch = true
            
            ss._pageNum = 1
            ss.loadData(d)
            ss._tableView.scrollsToTop = true
        }
        
        
        //        vc.preferredContentSize = rect.size
        //        vc.view.frame = CGRect (x: kCurrentScreenWidth, y: 0, width: rect.width, height: rect.height)
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.preferredContentSize = rect.size
        nav.view.frame = CGRect (x: kCurrentScreenWidth, y: 0, width: rect.width, height: rect.height)

        UIApplication.shared.keyWindow?.rootViewController?.addChildViewController(nav)
        UIApplication.shared.keyWindow?.addSubview(nav.view)
        
        UIView.animate(withDuration: 0.3) {
            nav.view.frame = CGRect (x:rect.minX, y: 0, width: rect.width, height: rect.height)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "Defect List"
        delete_bg.isHidden = true
        _initSubviews()
        
        loadData()
        
        
        /////
//        rx_selected.value = _selectedIndexArrr
//        
//        let rx =  rx_selected.asObservable().map {$0.count > 0}.shareReplay(1)
//        rx.bindTo(btn_submit.ex_isEnabled).addDisposableTo(disposeBag);
//        rx.bindTo(btn_delete.ex_isEnabled).addDisposableTo(disposeBag);
        
        NotificationCenter.default.rx.notification(NSNotification.Name (rawValue: "creatDefectReportSubmintOkNotification"), object: nil).subscribe { [weak self](e) in
            guard let ss = self else {return}
            ss.loadData()
        }.addDisposableTo(disposeBag)
        
    }

    
    //MARK: - init
    func _initSubviews()  {
        _tableView.register(UINib (nibName: "DefectReportCell", bundle: nil), forCellReuseIdentifier: "DefectReportCellIdentifier")
        _tableView.tableFooterView = UIView()
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 105
        _tableView.separatorStyle = .none
        
        ///Refresh Data
        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss._pageNum =  1
                ss.dataArray.removeAll()
                //ss.loadData()
                ss.loadData(ss._isSearch ? ss._searchPars ?? [:] : [:])
            }
        }
        
        _tableView.mj_header = header
        
        let footer = TTRefreshFooter.init{
            DispatchQueue.main.async {[weak self] in
                guard let ss = self else {return}
                ss._pageNum = ss._pageNum + 1
                ss.loadData(ss._isSearch ? ss._searchPars ?? [:] : [:])
            }
        }
        
        _tableView.mj_footer = footer
    }
    
    
    func loadData(_ d : [String:Any] = [:])  {
        HUD.show(withStatus: hud_msg_loading)
        
        var pars : [String:Any] = d
        pars["page"] = _pageNum
        
        netHelper_request(withUrl: defect_list_url, method: .post, parameters: pars, encoding: JSONEncoding.default, successHandler: { [weak self](res) in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss._pageNum == 1 {
                ss.dataArray.removeAll();
                ss._tableView.mj_footer.resetNoMoreData()
            }
            
            
            if ss._tableView.mj_header.isRefreshing(){
                ss._tableView.mj_header.endRefreshing();
            } else if  ss._tableView.mj_footer.isRefreshing() {
                ss._tableView.mj_footer.endRefreshing();
            }
            
            guard let arr = res["body"] as? [[String:Any]] else {return};
            if arr.count > 0 {
                ss.dataArray = ss.dataArray + arr;
                
                if arr.count < 15 {
                    ss._tableView.mj_footer.state = MJRefreshState.noMoreData;
                }
            }
           
            ss._tableView.reloadData()
            
        }) { (str) in
            print(str);
        }
        
    }
    
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefectReportCellIdentifier", for: indexPath) as! DefectReportCell
        
        if tableView.isEditing{
            cell.setSelectInEdit(_selectedIndexArrr.contains(indexPath.row));
        }
        
        let d = dataArray[indexPath.row]
        cell.fill(d)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard _tableView.isEditing else {
            HUD.show()

            let d = dataArray[indexPath.row]
            guard let _id = d["id"] as? String else {return}
            
            let v = ReporFormController()
            v.read_only = true
            v.reportId = _id
            self.navigationController?.pushViewController(v, animated: true); return;
        }
        
        
        if _selectedIndexArrr.contains(indexPath.row){
            _selectedIndexArrr.remove(at: _selectedIndexArrr.index(of: indexPath.row)!);
        }else {
            _selectedIndexArrr.append(indexPath.row);
        }
        
        
        _tableView.reloadData()

    }
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
