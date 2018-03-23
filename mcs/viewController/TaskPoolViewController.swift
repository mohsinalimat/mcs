//
//  TaskPoolViewController.swift
//  mcs
//
//  Created by gener on 2018/3/2.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class TaskPoolViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var _tableView: UITableView!
    let disposeBag = DisposeBag()
    
    var type = 0
    
    var dataArray = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
        
        
        ///RxDataSource
        /*let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>()
        
        dataSource.configureCell = {_, tableView, indexPath, user in
            var identifier =  "TaskPoolCellIdentifier"
            
            if self.type == 0 {
                if indexPath.row > 0 {
                    identifier = "TaskActionCellIdentifier";
                }
            }else {
                identifier = "TaskHandCellIdentifier";
            }

            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.selectionStyle = .none
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds , index in
            return ds.sectionModels[index].identity;
        }
        
        
        let items = Observable.just([
                                     SectionModel(model: "B-MAG", items: [1,1,1,1,1,1]),
                                     SectionModel(model: "B-MAM", items: [1,1,1,1,1,1])
            ])
        
        items.bindTo(_tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
        
        ///cell selected
        _tableView.rx.itemSelected.map { indexPath in
            return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                print("itemSelected")
                
                let vc = TaskPoolDetailController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .addDisposableTo(disposeBag)*/
        
        
        /////
        NotificationCenter.default.rx.notification(Notification.Name.init(rawValue: "TaskPoolChangedNotificationName"), object: nil).subscribe { (notification) in
            if let index = notification.element?.userInfo?["index"] as? Int {
                self.type = index
                self._tableView.separatorStyle = index == 0 ? UITableViewCellSeparatorStyle.none : .singleLine
                self._tableView.reloadData()
            }
        }.addDisposableTo(disposeBag)
        
        
        
        
        ///////
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
    
    
    func _init() {
        
        _tableView.register(UINib (nibName: "TaskPoolCell", bundle: nil), forCellReuseIdentifier: "TaskPoolCellIdentifier")
        _tableView.register(UINib (nibName: "TaskActionCell", bundle: nil), forCellReuseIdentifier: "TaskActionCellIdentifier")
        _tableView.register(UINib (nibName: "TaskHandCell", bundle: nil), forCellReuseIdentifier: "TaskHandCellIdentifier")
        
        _tableView.tableFooterView = UIView()
        //_tableView.separatorStyle = .none
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 80
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    
    
    
    //MARK: 
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let list = dataArray[section]["actionList"] as? [String], list.count > 0 {
            return list.count + 1;
        }
        
        
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.type == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskPoolCellIdentifier", for: indexPath) as! TaskPoolCell
                
                let d = dataArray[indexPath.row]
                
                cell.fill( d)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskActionCellIdentifier", for: indexPath) as! TaskActionCell
                cell.fill(_d: nil, first: indexPath.row == 1);
                
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskHandCellIdentifier", for: indexPath) as! TaskHandCell
            
            return cell
        }
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == 0 {
            return indexPath.row == 0 ? 75 : 30;
        }else {
            return 80;
        }
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 30))
        v.backgroundColor = UIColor.white
        
        let lable = UILabel (frame: CGRect (x: 20, y: 0, width: tableView.frame.width - 20, height: 30))
        if let d = dataArray[section]["ac"]  as? String {
            lable.text = d
        }
        
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        lable.textColor = UIColor (colorLiteralRed: 220/255.0, green: 180/255.0, blue: 50/255.0, alpha: 1)
        v.addSubview(lable)
        return v
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = TaskPoolDetailController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
