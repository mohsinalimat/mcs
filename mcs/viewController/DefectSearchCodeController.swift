//
//  DefectSearchCodeController.swift
//  mcs
//
//  Created by gener on 2018/5/7.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh
class DefectSearchCodeController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    var docType:String!
    var cellSelectedAction:((Any) -> Void )?
    
    @IBOutlet weak var tableView: UITableView!
    
    var _searchBar:UISearchBar!
    
    var dataArray = [Any]()
    
    let disposeBag = DisposeBag.init()
    
    var _pageNumber = 1
    var _searchCode:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        
        // Do any additional setup after loading the view.
        _init()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _searchBar.becomeFirstResponder()
    }
    
    
    func _init() {
        let closebtn = UIButton (frame: CGRect (x: 0, y: 0, width: 50, height: 40))
        closebtn.setTitle("Cancel", for: .normal)
        closebtn.setTitleColor(UIColor.white, for: .normal)
        closebtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        closebtn.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        closebtn.tag = 100
        let litem = UIBarButtonItem (customView: closebtn)
        navigationItem.rightBarButtonItem = litem

        let searchBar = UISearchBar.init(frame: CGRect (x: 0, y: 0, width: 400, height: 25))
        searchBar.placeholder = "Search"
        searchBar.keyboardType = .numberPad
        _searchBar = searchBar
        
        let litem1 = UIBarButtonItem (customView: searchBar)
        navigationItem.leftBarButtonItem = litem1
        
        searchBar.rx.text//.filter({ ($0?.lengthOfBytes(using: String.Encoding.utf8))! > 0 })
            .subscribe { [weak self](event) in
            guard let ss = self else {return};
                
            if let v = event.element {
                ss.dataArray.removeAll()
                ss._pageNumber = 1
                ss._searchCode = v
                ss._search(v)
            }
        }.addDisposableTo(disposeBag)
        
        
        /////
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib (nibName: "BaseTableViewVCCell", bundle: nil), forCellReuseIdentifier: "BaseTableViewVCCellIdentifier")
        tableView.rowHeight = 50
        
        let footer = TTRefreshFooter.init{[weak self] in
            guard let ss = self else {return}
            
            ss._pageNumber = ss._pageNumber + 1
            ss._search(ss._searchCode)
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
    }
    
    func _search(_ s:String? = nil)  {
        guard let code = s else {return}

        if code.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            if docType == "AMM"{
                if let arr =   /*AMMModel.search(with: "taskCode LIKE '\(code)%%'", orderBy: nil)*/
                        AMMModel.search(withWhere: "taskCode LIKE '\(code)%%'", orderBy: nil, offset: (_pageNumber - 1) * 100, count: 100)
                {
                    if tableView.mj_footer.isHidden {
                        tableView.mj_footer.isHidden = false;
                    }
                    
                    tableView.mj_footer.state = arr.count < 100 ? MJRefreshState.noMoreData : MJRefreshState.idle
                
                    
                    ////////////////
                    var a = [Any]()
                    a = a + arr
                    let new = _fliterData(a)

                    dataArray = dataArray + new
                }
            }else if docType == "MEL"{
                if let arr =   MELModel.search(with: "code LIKE '\(code)%%'", orderBy: nil){
                    dataArray = dataArray + arr
                }
            }else {
                if let arr =   TSMModel.search(with: "code LIKE '\(code)%%'", orderBy: nil){
                    dataArray = dataArray + arr
                    

                }

            }
        }
        
        
        tableView.reloadData()
    }
    
    //过滤ATA重复数据
    func _fliterData(_ arr: [Any]) -> [Any] {
        var new = [Any]();
        var added = [String]()
        
        for m in arr {
            let model = m as! AMMModel
            let s = "\(String.isNullOrEmpty(model.taskCode))\(String.isNullOrEmpty(model.taskName))"
            if !added.contains(s){
                added.append(s);
                new.append(model)
            }
        }
        
        
        return new
    }
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaseTableViewVCCellIdentifier", for: indexPath) as! BaseTableViewVCCell
        let m = dataArray[indexPath.row]
        
        cell._title.text = _text(m)
        cell._title.font = UIFont.systemFont(ofSize: 15)
        cell.selectionStyle = .default
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tmp = cellSelectedAction {
            tmp(dataArray[indexPath.row])
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    
    
    func _text(_ m:Any) -> String? {
        var s:String? = nil
        
        if docType == "AMM"{
            let model = m as! AMMModel;
            s = "\(String.isNullOrEmpty(model.taskCode)) - \(String.isNullOrEmpty(model.taskName))"
        }else if docType == "MEL"{
            let model = m as! MELModel;
            s = "\(String.isNullOrEmpty(model.code)) - \(String.isNullOrEmpty(model.title))"
        }else {
            let model = m as! TSMModel;
            s = "\(String.isNullOrEmpty(model.code)) - \(String.isNullOrEmpty(model.message))"
        }
        
       return s
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
