//
//  HomeViewController.swift
//  mcs
//
//  Created by gener on 2018/1/12.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class HomeViewController: BaseTabItemController,UICollectionViewDelegate,UICollectionViewDataSource {

    var _collectionView : UICollectionView!
    let ImgCollectionViewCellReuseId = "HomeCollectionViewCellIdentifier"
    var _msgBtn:UIButton!
    
    var dataArray:[[String:Any]] = []
    var taskNoData:[String:Int] = [:]
    var warnNoData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _initSubview()
        
        getFlightStatusData()
    }

    
    //MARK:-
    func getFlightStatusData()  {
        HUD.show(withStatus: "Loading")
        
        netHelper_request(withUrl: flight_info_url, method: .post, parameters: nil, successHandler: {[weak self] (result) in
            HUD.dismiss()
            
            guard let body = result["body"] as? [[String : Any]] else {
                return;
            }
            
            guard let strongSelf = self else{return}
            
            strongSelf.dataArray = strongSelf.dataArray + body
            strongSelf._collectionView.reloadData()
            strongSelf.getTaskNumber();
            
            strongSelf.getWarnNumber()
            }
        )
        
    }
    
    func getTaskNumber() {
        netHelper_request(withUrl: task_number_url, method: .post, parameters: nil, successHandler: {[weak self] (result) in
            guard let body = result["body"] as? [String : Int] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf.taskNoData =  body
            strongSelf._collectionView.reloadData()
            }
        )
    }
    
    func getWarnNumber() {
        netHelper_request(withUrl: get_aircraft_status_url, successHandler: { [weak self] (result) in
            guard let body = result["body"] as? [[String:Any]] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf.warnNoData =  body
            strongSelf._collectionView.reloadData()
            
            })
    }
    
    //MARK: -
    func _initSubview() {
        view.backgroundColor = UIColor.white;
        
        let _largeflowlayout = UICollectionViewFlowLayout()
        _largeflowlayout.minimumLineSpacing = 5
        _largeflowlayout.minimumInteritemSpacing = 5
        _largeflowlayout.scrollDirection = .vertical
        let _w = (kCurrentScreenWidth - 25 - 15) / 4.0
        _largeflowlayout.itemSize = CGSize (width: _w, height: 160 )
        
        _collectionView = UICollectionView.init(frame: CGRect (x: 10, y: 0, width: kCurrentScreenWidth - 20, height: kCurrentScreenHeight - 64 - 0), collectionViewLayout: _largeflowlayout)
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.register(UINib (nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImgCollectionViewCellReuseId)
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
        _collectionView.backgroundColor = UIColor.clear //kTableviewBackgroundColor
        
        _collectionView.showsVerticalScrollIndicator = false
        view.addSubview(_collectionView)
        
        let header = TTRefreshHeader.init {
            self._collectionView.mj_header.endRefreshing()
        }
        
        _collectionView.mj_header = header
        
        //addNavigationItem
        addNavigationItem()
    }
    
    func addNavigationItem()  {


        let user = UILabel (frame: CGRect (x: 0, y: 0, width: 100, height: 30))
        user.font = UIFont.systemFont(ofSize: 15)
        user.text = "当前用户 \(UserDefaults.standard.value(forKey:"user-name")!)"
        navigationItem.titleView = user
        
        //msg
        let msgBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
        msgBtn.setImage(UIImage (named: "mail_icon"), for: .normal)//30 30
        msgBtn.setImage(UIImage (named: "mail_icon"), for: .highlighted)
        msgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 20)
        msgBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        msgBtn.addTarget(self, action: #selector(msgBtnAction), for: .touchUpInside)
        msgBtn.setTitle("200", for: .normal)
        msgBtn.setTitleColor(UIColor.red, for: .normal)
        msgBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        _msgBtn = msgBtn
        
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 10
        let msgItem  = UIBarButtonItem (customView: msgBtn)
        
        //FIB
        let fibItem = UIBarButtonItem.init(image: UIImage (named: "icon_fib")?.withRenderingMode(.alwaysOriginal) , style: .done, target: self, action: #selector(fibBtnAction))
        //let fibItem = UIBarButtonItem.init(title: "FIB", style: .plain, target: self, action: #selector(fibBtnAction))
        //fibItem.setTitleTextAttributes([/*NSForegroundColorAttributeName:UIColor.black,*/NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: .normal)
        
        navigationItem.rightBarButtonItems = [fixed,msgItem,fixed,fixed,fixed,fibItem]
    }
    
    func msgBtnAction()  {
        
    }
    
    func fibBtnAction() {
        
        #if true
        let v = FIBViewController()
        
        self.navigationController?.pushViewController(v, animated: true)
        #else
            let v = ViewController()
            
            self.navigationController?.pushViewController(v, animated: true)
            
            
        #endif
    }
    
    
    
    //MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImgCollectionViewCellReuseId, for: indexPath) as! HomeCollectionViewCell
    
        let d = dataArray[indexPath.row]
        var taskno:Int = 0
        var warn:[String:Any]?
        
        if let acId = d["acId"] as? String , let n = taskNoData[acId] {
            taskno = n
            warn = get_status(byId: acId)
        }
        
        cell.fillCell(d,taskNumber: taskno,status: warn)
        cell.backgroundColor = UIColor.init(colorLiteralRed: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 0.5);
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        
        guard d["fltNo"] != nil else {
            HUD.show(info: "暂无航班信息!");return
        }
        
        
        if let acId = d["acId"] as? String, let date = d["fltDate"] as? String{
            ///date
            kFlightInfoListController_flightDate = date
            kFlightInfoListController_airId = acId
        }
        
        let vc = HomeDetailTabController.init()

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK:-
    func get_status(byId:String) -> [String:Any]? {
        for _d in warnNoData {
            if byId == _d["tailNo"] as? String{
                return _d;
            }
        }
        
        return nil
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
