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
    var _msgNum:UILabel!
    
    var dataArray:[[String:Any]] = []
    var taskNoData:[String:Int] = [:]
    var warnNoData:[[String:Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _initSubview()
        
        getFlightStatusData()
        
        getActiveData()
        
        //getMsg()
        NotificationCenter.default.addObserver(self, selector: #selector(newMsg(_ :)), name: NSNotification.Name.init("new_msg_notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(msgRead(_ :)), name: NSNotification.Name.init("new_msg_read_notification"), object: nil)
        print(NSHomeDirectory())
        
        //...test
        //print(plist_dic_lazy)
        //HUD.showText("数据加载完成", view: view)
        //_dctt()
    }

    func _dctt() {
        if let data = UserDefaults.standard.value(forKey: "tt") as? Data {
            do{
                if let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                    print(dic)
                    
                    print("------")
                    if let name = dic["name"] as? String {
                        print("- \(name)");
                    }
                    
                    if let name = dic["nickName"] as? String {
                        print("- \(name)");
                    }
                }

                
            }catch{
            
            }
            

        }
        
        
        
    }
    
    
    //MARK:-
    func msgRead(_ noti:Notification) {
        self._msgNum.isHidden = true;
    }
    
    
    
    func newMsg(_ noti:Notification)  {
        if let cnt = noti.userInfo?["cnt"] as? Int ,cnt > 0 {
            self._msgNum.isHidden = false
            self._msgNum.text = "\(cnt)"
        }
        
    }
    
    
    //MARK:- Request
    func getFlightStatusData()  {
        HUD.show(withStatus: "Loading")
        
        netHelper_request(withUrl: flight_info_url, method: .post, parameters: nil, successHandler: {[weak self] (result) in
            HUD.dismiss()
            
            guard let body = result["body"] as? [[String : Any]] else { return;}
            guard let strongSelf = self else{return}
            if strongSelf._collectionView.mj_header.isRefreshing(){
                strongSelf._collectionView.mj_header.endRefreshing();
            }
            
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
    
    func getActiveData() {
        netHelper_request(withUrl: active_basedata_url, method: .post, parameters: nil, successHandler: {[weak self] (result) in
            guard let body = result["body"] as? [String:Any] else {return;}
            guard let strongSelf = self else{return}
            kActive_BASE_DATA = body;
            
            guard let version = body["version"] as? String else {return}
            guard let last = UserDefaults.standard.value(forKey: "MCSTocBaseDataVersion") as? String  else{
                strongSelf.getDocData(version);return;
            }
            
            guard version > last else {return}
            strongSelf.getDocData(version)

            }
        )
    }
    
    func getDocData(_ versoin:String) {
        netHelper_request(withUrl: basic_basedata_url, method: .post, parameters: nil, successHandler: {(result) in
            guard let body = result["body"] as? [String:[[String:String]]] else {return;}
            Model.getUsingLKDBHelper().dropAllTable()
            Model.getUsingLKDBHelper().executeSQL("VACUUM", arguments: nil)
            
            for (k,v) in body {
                FMDB.default().insert(with: v, toc: k)
            }

            UserDefaults.standard.setValue(versoin, forKey: "MCSTocBaseDataVersion")
            UserDefaults.standard.synchronize()
        })
    }
    
    func getMsg() {
        let date = Tools.dateToString(Date(), formatter: "dd/MM/yyyy")
        let d = ["date":date]
        
        /*guard let name = UserDefaults.standard.value(forKey: "loginUserInfo") as? [String:String] , let user = name["userName"] else { return}
        let uid = date + user;
        let _u = UserDefaults.standard.value(forKey: user)
        if _u != nil {
            guard uid != String.isNullOrEmpty(_u) else {
                if let data = UserDefaults.standard.value(forKey: "msg_data") as? Data{
                    do{
                        if let arr = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:Any]] {
                            Msg = arr;
                        }
                    }catch{ }
                };return
            }
        }*/
        
        
        netHelper_request(withUrl: noti_msg_url, method: .post, parameters:d, successHandler: {[unowned self] (res) in
            guard let arr = res["body"] as? [[String:Any]] else {return}
            if arr.count > 0 {
                Msg = arr

                do{
                    let json = try JSONSerialization.data(withJSONObject: arr, options: []);
                    UserDefaults.standard.set(json, forKey: "msg_data")
                }catch{
                    print(error.localizedDescription);
                }
                
                //UserDefaults.standard.set(uid, forKey: user)
                UserDefaults.standard.synchronize()
                self._msgNum.isHidden = false
                self._msgNum.text = "\(arr.count)"
                self.showMsg("New Message Notification", title: "Open", handler: {
                    self._msgNum.isHidden = true
                    self.msgBtnAction()
                })
            }
            
            })
        
    }
    
    
    //MARK: -
    func _initSubview() {
        view.backgroundColor = UIColor.white;
        
        let _largeflowlayout = UICollectionViewFlowLayout()
        _largeflowlayout.minimumLineSpacing = 10
        _largeflowlayout.minimumInteritemSpacing = 5
        _largeflowlayout.scrollDirection = .vertical
        let _w = (kCurrentScreenWidth - 25 - 15) / 4.0
        _largeflowlayout.itemSize = CGSize (width: _w, height: 160 )
        
        _collectionView = UICollectionView.init(frame: CGRect (x: 10, y: 10, width: kCurrentScreenWidth - 20, height: kCurrentScreenHeight - 64 - 20), collectionViewLayout: _largeflowlayout)
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.register(UINib (nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImgCollectionViewCellReuseId)
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
        _collectionView.backgroundColor = UIColor.clear //kTableviewBackgroundColor
        _collectionView.showsVerticalScrollIndicator = false
        view.addSubview(_collectionView)
        
        let header = TTRefreshHeader.init {
            DispatchQueue.main.async {
                self.dataArray.removeAll()
                self.getFlightStatusData()
            }
        }
        
        _collectionView.mj_header = header
        
        //addNavigationItem
        addNavigationItem()
        
        userIsLogin = true
    }
    
    func addNavigationItem()  {
        let user = UILabel (frame: CGRect (x: 0, y: 0, width: 100, height: 30))
        user.font = UIFont.systemFont(ofSize: 20)
        user.textAlignment = .center
        if let name = UserDefaults.standard.value(forKey: "loginUserInfo") as? [String:String] {
            user.text = name["userName"];
        }
        navigationItem.titleView = user
        
        //msg
        let num = UILabel (frame:  CGRect (x: 30, y: -5, width: 30, height: 16))
        num.font = UIFont.systemFont(ofSize: 10)
        num.textColor = UIColor.white
        num.backgroundColor = UIColor.red
        num.textAlignment = .center
        num.layer.cornerRadius = 8
        num.layer.masksToBounds = true
        num.isHidden = true
        _msgNum = num
        
        let msgBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
        msgBtn.setImage(UIImage (named: "msg"), for: .normal)
        msgBtn.setImage(UIImage (named: "msg"), for: .highlighted)
        msgBtn.addTarget(self, action: #selector(msgBtnAction), for: .touchUpInside)
        _msgBtn = msgBtn
        
        msgBtn.addSubview(num)
        let msgItem  = UIBarButtonItem (customView: msgBtn)
        
        //exit
        let exitBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
        exitBtn.setImage(UIImage (named: "setter"), for: .normal)
        exitBtn.setImage(UIImage (named: "setter"), for: .highlighted)//icon_exit
        exitBtn.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        let exitItem  = UIBarButtonItem (customView: exitBtn)
        
        //FIB
        let flibBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
        //flibBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        flibBtn.setImage(UIImage (named: "fib"), for: .normal)
        flibBtn.setImage(UIImage (named: "fib"), for: .highlighted)
        flibBtn.addTarget(self, action: #selector(fibBtnAction), for: .touchUpInside)
        let fibItem  = UIBarButtonItem (customView: flibBtn);
        
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 20
        
        navigationItem.rightBarButtonItems = [fixed, exitItem ,fixed , msgItem,fixed,fibItem]
    }
    
    func msgBtnAction()  {
        let v = MsgViewController();
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func exitAction() {
        let v = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setter_storyboard")
        
        self.navigationController?.pushViewController(v, animated: true)
        
        return
            
//        showMsg("EXIT?", title: "OK") {
//            userIsLogin = false
//            let loginvc = LoginViewController()
//            
//            UIApplication.shared.keyWindow?.rootViewController = loginvc
//        }
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
        cell.backgroundColor = UIColor.white//UIColor.init(colorLiteralRed: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 0.5);
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        
        guard let acId = d["acId"] as? String else {
            HUD.show(info: "暂无航班信息!");return
        }
        
        kFlightInfoListController_airId = acId;
        
        if let date = d["fltDate"] as? String , let fltno = d["fltNo"] as? String {
            ///date
            kFlightInfoListController_flightDate = date
            //kFlightInfoListController_airId = acId
            kFlightInfoListController_fltNo = fltno
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
