//
//  WarnInfoDetailController.swift
//  mcs
//
//  Created by gener on 2018/2/26.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa


class WarnInfoDetailController: BaseViewController,UITableViewDelegate {

    @IBOutlet weak var _tableView: UITableView!
    
    var current_selected_btn:UIButton!
    var current_selected_btn_index = 0
    let current_selected_btn_bgcolor = UIColor.init(colorLiteralRed: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Warn Info"
        
        // Do any additional setup after loading the view.
        _init()
        
        
        ///RxDataSource
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>()
        
        dataSource.configureCell = {_, tableView, indexPath, user in
            var identifier =  "WarnDetailTopCellIdentifier"
            if indexPath.section == 1 {
                identifier = "WarnFaultInfoCellIdentifier";
            }else if indexPath.section == 2 {
                identifier = "WarnDisPoseCellIdentifier";
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.selectionStyle = .none
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds , index in
            return ds.sectionModels[index].identity;
        }

        
        let items = Observable.just([SectionModel(model: "", items: [1]),
                                     SectionModel(model: "Fault Information", items: [1,1,1,1,1,1]),
                                     SectionModel(model: "", items: [1])
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
        
        
    }

    func _init() {

        _tableView.register(UINib (nibName: "WarnDetailTopCell", bundle: nil), forCellReuseIdentifier: "WarnDetailTopCellIdentifier")
        _tableView.register(UINib (nibName: "WarnFaultInfoCell", bundle: nil), forCellReuseIdentifier: "WarnFaultInfoCellIdentifier")
        _tableView.register(UINib (nibName: "WarnDisPoseCell", bundle: nil), forCellReuseIdentifier: "WarnDisPoseCellIdentifier")

        _tableView.tableFooterView = UIView()
        //_tableView.separatorStyle = .none
        _tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        
        _tableView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section > 0 else { return 130 }
        guard indexPath.section > 1 else { return 60 }
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40;
        } else if section == 2 {
            return 50;
        }
    
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {return 15}
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 1 else { return nil }
        
        let l = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 50))
        l.backgroundColor = UIColor.white
        
        let t = ["Probable reason of fault","Fault isolation manual","MEL","Other files"]
        let x = [0,230,430,530]
        for i in 0..<t.count {
            let btn = UIButton (frame: CGRect (x: x[i], y: 0, width: i > 1 ? 100:200, height: 50));
            btn.setTitle(t[i], for: .normal)
            btn.tag = 100 + i
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.setTitleColor(UIColor.black, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.addTarget(self, action: #selector(sectionBtnClicked(_:)), for: .touchUpInside)
            
            if i == 0{
                btn.isSelected = i == 0;
                btn.backgroundColor = current_selected_btn_bgcolor
                current_selected_btn = btn
            }
            
            
            l.addSubview(btn)
        }
        
        
        return l
    }
    
    //MARK:
    func get_warn_list() {
        let d = ["":""]
        
        netHelper_request(withUrl: get_warn_list_url, method: .post, parameters: d, successHandler: { (res) in
            
        }) { (error) in
            
        }
        
        
    }
    
    
    func sectionBtnClicked(_ button:UIButton) {
        guard button.tag != current_selected_btn.tag else { return}
        
        current_selected_btn.isSelected = false
        current_selected_btn.backgroundColor = UIColor.white
        
        button.isSelected = true
        button.backgroundColor = current_selected_btn_bgcolor
        
        current_selected_btn = button
        
        //_tableView.reloadSections([2], animationStyle: .none)
        
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
