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

class TaskPoolViewController: BaseViewController,UITableViewDelegate {

    @IBOutlet weak var _tableView: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        _init()
        
        
        ///RxDataSource
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>()
        
        dataSource.configureCell = {_, tableView, indexPath, user in
            var identifier =  "TaskPoolCellIdentifier"
            if indexPath.row > 0 {
                identifier = "TaskActionCellIdentifier";
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
            })
            .addDisposableTo(disposeBag)
        
        
        /////
        NotificationCenter.default.rx.notification(Notification.Name.init(rawValue: "TaskPoolChangedNotificationName"), object: nil).subscribe { (notification) in
            print("rec noti...")
        }.addDisposableTo(disposeBag)
        
        
    }
    
    func _init() {
        
        _tableView.register(UINib (nibName: "TaskPoolCell", bundle: nil), forCellReuseIdentifier: "TaskPoolCellIdentifier")
        _tableView.register(UINib (nibName: "TaskActionCell", bundle: nil), forCellReuseIdentifier: "TaskActionCellIdentifier")
        _tableView.register(UINib (nibName: "TaskHandCell", bundle: nil), forCellReuseIdentifier: "TaskHandCellIdentifier")
        
        _tableView.tableFooterView = UIView()
        //_tableView.separatorStyle = .none
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        _tableView.delegate = self
        _tableView.rowHeight = 80
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    //MARK: 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 75 : 30
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
