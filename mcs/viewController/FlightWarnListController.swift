//
//  FlightWarnListController.swift
//  mcs
//
//  Created by gener on 2018/3/7.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class FlightWarnListController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    var fltDate:String!
    var fltNo:String!
    var fltIsArrival:Bool = true
    var fltDic = [String:Any]()
    var isArr:Bool = true
    
    let disposeBag = DisposeBag.init()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: FlightWarnListTopView!
    
    var is_in_editing = Variable(false)
        
    var has_selected_index = [Int]()
    
    var alarm_body = [[String:Any]]()
    var alarm = [[String:Any]]()
    var _fltDate:String?
    var _fltInfo:[String:Any]?
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _init()
        
        get_flight_info()
        
        get_warn_list()
        
        addObserver();
   
    }

    
    func _init()  {
        tableView.register(UINib (nibName: "FlightWarnListCell", bundle: nil), forCellReuseIdentifier: "FlightWarnListCellIdentifier")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0.01
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = "Flight Warn"
        
        topView.selectBuuttonClickHandler = { [weak self] b in
            guard let strongSelf = self else { return }
            strongSelf.is_in_editing.value = b
        }
    }
    
    
    func addObserver(){
        is_in_editing.asObservable()/*.filter({ (b) -> Bool in
             return b;
             })*/.subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                strongSelf.has_selected_index.removeAll()
                strongSelf.tableView.reloadData()
            }.addDisposableTo(disposeBag)
       
        //创建故障报告
        topView.reportBtn.rx.controlEvent(UIControlEvents.touchUpInside) .subscribe { [weak self] (event) in
                guard let ss = self else { return }
                ss._creatReport();
            }.addDisposableTo(disposeBag)
    }
    
    func _creatReport() {
        HUD.show()
        let v = ReporFormController()
        v.is_from_warn = true
        
        var flightDate:String?
        if let flDate = _fltDate {
            let date = Tools.stringToDate(flDate, formatter: "yyyy-MM-dd")
            flightDate = Tools.dateToString(date, formatter: "dd/MM/yyyy")
        }
        
        if let info = _fltInfo {
            let d = ["acReg":info["acId"],
                     "station":info["arrApt"],
                     "flNo":"NX" + String.isNullOrEmpty(info["fltNo"]),
                     "flDate":flightDate
            ]
            v.warnInfo = d

        }
        
        self.navigationController?.pushViewController(v, animated: true);

    }
    
    
    //MARK: -
    func get_flight_info() {
        HUD.show(withStatus: "Loading...")
        var d = [//"fltDate":"\(fltDate!.substring(to: fltDate.index(fltDate.startIndex, offsetBy: 10)))",
            "fltNo":"\(fltNo!)"]
        
        if isArr {
            d["sta"] = String.isNullOrEmpty(fltDic["ymdsta"]);
        }else {
            d["std"] = String.isNullOrEmpty(fltDic["ymdstd"]);
        }
        
        netHelper_request(withUrl: get_flightInfo_url, method: .post, parameters: d, successHandler: { [weak self](result) in
                HUD.dismiss()
                guard let body = result["body"] as? [String : Any] else {return;}
                guard let strongSelf = self else{return}
                strongSelf._fltDate = body["fltDate"] as? String
                strongSelf._fltInfo = body
                strongSelf.topView.fillData(body)
            })
    }
    
    
    func get_warn_list() {
        var datestr = "\(fltDate!.substring(to: fltDate.index(fltDate.startIndex, offsetBy: 10)))"
        datestr = datestr.replacingOccurrences(of: "-", with: "/")
        let d = ["aircraftNo":fltDic["acReg"]!,
                 "flightNo":"NX\(fltNo!)",
                 "beginDate":"\(datestr) 00:00:00",
                 "endDate":"\(datestr) 23:59:59"
        ]

        netHelper_request(withUrl: get_warn_list_url, method: .post, parameters: d, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [[String : Any]] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf.alarm_body = body;
            if let _a = body.first?["alarm"] as? [[String : Any]] {
                if _a.count > 0 {
                    strongSelf.alarm = _a;
                    strongSelf.tableView.reloadData()
                }
            }else {
                let l = UILabel (frame: CGRect (x: 0, y: 100, width: kCurrentScreenWidth, height: 60))
                l.text = "No Warn"
                l.textColor = UIColor.lightGray
                l.font = UIFont.systemFont(ofSize: 18)
                
                l.textAlignment = .center
                strongSelf.view.addSubview(l)
                strongSelf.topView.selectBtn.isEnabled = false
            }
 
        }) { (error) in
            
        }
        
        
    }

    
    
    //MARK: - 
    func numberOfSections(in tableView: UITableView) -> Int {
        return alarm.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section > 0 else {return 0 }
        guard let arr = alarm[section - 1]["detail"] as? [[String:Any]] else { return 0}
        
        return  arr.count //Int(arc4random_uniform(5)) + 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section > 0 else {return 1}
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightWarnListCellIdentifier", for: indexPath) as! FlightWarnListCell
        
        if let arr = alarm[indexPath.section - 1]["detail"] as? [[String:Any]] {
            let d = arr[indexPath.row];
            cell.fillWith(status: d)
        }
        
        cell.backgroundColor = indexPath.section % 2 == 1 ? kTableViewCellbg_whiteColor : kTableViewCellbg_hightlightColor

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else {return nil}
        
        let v = Bundle.main.loadNibNamed("FlightWarnListHeadView", owner: nil, options: nil)?.last as! FlightWarnListHeadView

        v.backgroundColor = section % 2 == 1 ? kTableViewCellbg_whiteColor : kTableViewCellbg_hightlightColor
        
        v.selecedtBtn.isHidden = is_in_editing.value == false
        
        v.selecedtBtn.isSelected = has_selected_index.contains(section)
        
        v.topButton.addTarget(self, action: #selector(topBtnClick(_ :)), for: .touchUpInside)
        v.topButton.tag = section
        
        if let arr = alarm[section - 1]["detail"] as? [[String:Any]] {
            let d = arr[0];
            
            if let warn_level = d["grade"] as? String {
                v.statusLable.backgroundColor = kFlightWarnLevelColor["\(warn_level)"];
            }
        }
        
        return v
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        _tableviewDidSelectHandle(indexPath.section)
        
    }
    
    
    func topBtnClick(_ btn: UIButton) {
        _tableviewDidSelectHandle(btn.tag)
    }
    
    
    func _tableviewDidSelectHandle(_ index:Int) {
        guard !is_in_editing.value else {
            if has_selected_index.contains(index) {
                has_selected_index.remove(at: has_selected_index.index(of: index)!);
            }else{
                has_selected_index.append(index);
            }
            
            tableView.reloadSections([index], animationStyle: .none);return
        }
        

        if let arr = alarm[index - 1]["detail"] as? [[String:Any]] , let _d = alarm[index - 1]["id"] as? String {
            let d = arr[0];//....
            
            let v = WarnInfoDetailController_new()
            v._warnInfoLast = d
            v._id = _d
            v._flightDate = _fltDate
            self.navigationController?.pushViewController(v, animated: true)
        }
 
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
