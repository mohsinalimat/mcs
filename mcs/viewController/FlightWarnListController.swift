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
    
    let disposeBag = DisposeBag.init()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: FlightWarnListTopView!
    
    var is_in_editing = Variable(false)
        
    var has_selected_index = [Int]()
    
    var alarm_body = [[String:Any]]()
    var alarm = [[String:Any]]()
    
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
        topView.reportBtn.rx.controlEvent(UIControlEvents.touchUpInside).subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            
            print("创建故障报告")
            
        }.addDisposableTo(disposeBag)
      
     
    }
    
    
    //MARK: -
    func get_flight_info() {
        HUD.show(withStatus: "Loading...")
        
        let d = ["fltDate":"\(fltDate!.substring(to: fltDate.index(fltDate.startIndex, offsetBy: 10)))","fltNo":"\(fltNo!)"]
        netHelper_request(withUrl: get_flightInfo_url, method: .post, parameters: d, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [String : Any] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf.topView.fillData(body)
            
            })
        
        
    }
    
    
    func get_warn_list() {
        //        let d = ["aircraftNo":fltDic["acId"]!,
        //            "flightNo":"\(fltNo!)",
        //            "beginDate":Tools.dateToString(Tools.date("\(fltDic["std"]!)")!, formatter: "yyyy/MM/dd HH:mm:ss"),
        //            "endDate":Tools.dateToString(Tools.date("\(fltDic["sta"]!)")!, formatter: "yyyy/MM/dd HH:mm:ss")
        //        ]
        //...
        let d = ["aircraftNo":"B-MBM",
                 "flightNo":"NX825",
                 "beginDate":"2018/02/25 11:00:00",
                 "endDate":"2018/02/26 22:59:59"
        ]
        //TODO:
        
        netHelper_request(withUrl: get_warn_list_url, method: .post, parameters: d, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [[String : Any]] else {return;}//...后台数据问题，待确定？
            guard let strongSelf = self else{return}
            
            strongSelf.alarm_body = body;
            if let _a = body.first?["alarm"] as? [[String : Any]] {
                strongSelf.alarm = _a;
                strongSelf.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section > 0 else {return 1}
        return 50
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
        /*v.topButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe { [weak self] (event) in
            guard let strongSelf = self else { return }
            print("...")
            
            guard !strongSelf.is_in_editing.value else {
                if strongSelf.has_selected_index.contains(section) {
                    strongSelf.has_selected_index.remove(at: strongSelf.has_selected_index.index(of: section)!);
                }else{
                    strongSelf.has_selected_index.append(section);
                }
                
                //tableView.reloadSections([section], animationStyle: .none);
                return
            }
        }.addDisposableTo(disposeBag)*/
        
        v.topButton.addTarget(self, action: #selector(topBtnClick(_ :)), for: .touchUpInside)
        v.topButton.tag = section
        
        
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
            self.navigationController?.pushViewController(v, animated: true)
        }
 
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
