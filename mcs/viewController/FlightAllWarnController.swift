//
//  FlightAllWarnController.swift
//  mcs
//
//  Created by gener on 2018/2/7.
//  Copyright © 2018年 Light. All rights reserved.
//




/*
 
 Test Rx
 
 */





import UIKit
import RxDataSources
import RxSwift
import RxCocoa

struct User {
    let followersCount: Int
    let followingCount: Int
    let screenName: String
}


class FlightAllWarnController: BaseViewController/*,UITableViewDelegate,UITableViewDataSource*/ {

    @IBOutlet weak var airNo: UILabel!
    @IBOutlet weak var flt_no: UILabel!
    @IBOutlet weak var flt_no_v: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func selectedDateAction(_ sender: UIButton) {
        
        
        
    }

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _init()
        

        ///RxDataSource
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>()
        
        dataSource.configureCell = {_, tableView, indexPath, user in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllWarnTableViewCellIdentifier", for: indexPath)
            return cell
        }
        
        let items = Observable.just([SectionModel(model: "First section", items: [1,2,3,4,5,6,7,8,9])])

        items.bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
        
        ///cell selected
        tableView.rx.itemSelected.map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { indexPath, model in
            print("itemSelected")
        })
            .addDisposableTo(disposeBag)
    }
    
    
    
    func _init() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.register(UINib (nibName: "AllWarnTableViewCell", bundle: nil), forCellReuseIdentifier: "AllWarnTableViewCellIdentifier")
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
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
