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

class TaskPoolViewController: TaskPoolBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
        

        /////
//        NotificationCenter.default.rx.notification(Notification.Name.init(rawValue: "TaskPoolChangedNotificationName"), object: nil).subscribe { (notification) in
//            if let index = notification.element?.userInfo?["index"] as? Int {
//                self.type = index
//                self._tableView.separatorStyle = index == 0 ? UITableViewCellSeparatorStyle.none : .singleLine
//                self._tableView.reloadData()
//            }
//        }.addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name.init("notification-selected-complete")).subscribe { [weak self] (event) in
            guard let strongSelf = self else {return}
            
            strongSelf.getTaskPool();
            
            }.addDisposableTo(disposeBag)
        
        
        ///////
        //getTaskPool()
        _test()
    }
    


    
    
    
    
    //MARK:-
    func _test() {
        netHelper_request(withUrl: basic_basedata_url, method: .post, parameters: nil, successHandler: { (res) in
            
            }) { (str) in
                
        }
    }
    
    func _init() {
        
        

    }
    
    
    
    
    
    //MARK: 
    



}
