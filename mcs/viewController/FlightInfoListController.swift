//
//  FlightInfoListController.swift
//  mcs
//
//  Created by gener on 2018/1/19.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

let FlightInfoListCellIdentifier = "FlightInfoListCellIdentifier"

class FlightInfoListController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var flight_No: UILabel!
    
    @IBOutlet weak var dateBtn: UIButton!
    
    @IBOutlet weak var collectionView: BaseCollectionView!
    
    var arr_dataArray:[[String:Any]] = []
    var dep_dataArray:[[String:Any]] = []

    var dataArray:[[String:Any]] = []
    var warnDataArray = [[String:Any]]()//航班告警信息
    
    @IBAction func selectDateAction(_ sender: UIButton) {
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        
        let vc = DatePickerController()
        vc.view.frame = frame
        vc.pickerDidSelectedHandler = { s in
            let date = s as! Date
            let str = Tools.dateToString(date, formatter: "yyyy-MM-dd")
            
            
            sender.setTitle("\(str)", for: .normal);
            kFlightInfoListController_flightDate = "\(str)"
            
            self.get_flight_data()
        }
        
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = UIColor (colorLiteralRed: 0.212, green: 0.188, blue: 0.427, alpha: 1)
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        self.present(nav, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
        
        get_flight_data()
        
    }

    func get_flight_data()  {
        let d = ["fltDate":"\(kFlightInfoListController_flightDate!)","acId":"\(kFlightInfoListController_airId!)"]
        
        arr_dataArray.removeAll()
        dep_dataArray.removeAll()
        dataArray.removeAll()
        
        HUD.show(withStatus: "Loading")
        netHelper_request(withUrl: get_flights_url, method: .post, parameters: d, successHandler: {[weak self] (result) in
            HUD.dismiss()
            guard let body = result["body"] as? [[String : Any]] else {return;}
            guard let strongSelf = self else{return}

            /*if let arr = body["arr"] as? [[String:Any]] {
               strongSelf.arr_dataArray = strongSelf.arr_dataArray + arr;
            }
            
            if let arr = body["dep"] as? [[String:Any]] {
               strongSelf.dep_dataArray = strongSelf.dep_dataArray + arr;
            }*/
            
            strongSelf.get_warn_for_flight();

            strongSelf.dataArray = strongSelf.dataArray + body
            strongSelf.collectionView.reloadData()
            
            
            }
        )
        
    }
    
    
    func get_warn_for_flight() {
        //        let d = ["aircraftNo":fltDic["acId"]!,
        //            "flightNo":"\(fltNo!)",
        //            "beginDate":Tools.dateToString(Tools.date("\(fltDic["std"]!)")!, formatter: "yyyy/MM/dd HH:mm:ss"),
        //            "endDate":Tools.dateToString(Tools.date("\(fltDic["sta"]!)")!, formatter: "yyyy/MM/dd HH:mm:ss")
        //        ]
        //...
        let d = ["aircraftNo":"B-MCB",
                 //"flightNo":"NX825",
                 "beginDate":"2018/02/24 11:00:00",
                 "endDate":"2018/02/26 11:59:59"
        ]
        //TODO:
        
        netHelper_request(withUrl: flight_haswarn_url, method: .post, parameters: d, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [[String : Any]] else {return;}
            guard let strongSelf = self else{return}
            strongSelf.warnDataArray = strongSelf.warnDataArray + body
            strongSelf.collectionView.reloadData()
        }) { (error) in
            
        }
        
        
    }

    func _init()  {
        collectionView.register(UINib (nibName: "FlightInfoListCell", bundle: nil), forCellWithReuseIdentifier: FlightInfoListCellIdentifier)
        collectionView.register(UINib (nibName: "TextMsgViewCell", bundle: nil), forCellWithReuseIdentifier: "TextMsgViewCellIdentifier")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellReuseIdentifier")
        
        let _flowlayout = UICollectionViewFlowLayout()
        _flowlayout.minimumLineSpacing = 20
        _flowlayout.minimumInteritemSpacing = 2
        _flowlayout.scrollDirection = .vertical
        let _w = (kCurrentScreenWidth - 10 - 3) / 2.0
        _flowlayout.itemSize = CGSize (width: _w, height: 100 )
        collectionView.collectionViewLayout = _flowlayout
    
        collectionView.layer.borderColor = UIColor.lightGray.cgColor;
        collectionView.layer.borderWidth = 1.0
        
        ////
        flight_No.text = kFlightInfoListController_airId
        dateBtn.setTitle(kFlightInfoListController_flightDate, for: .normal)
    }
    
    //MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count * 2 + 2
        //return arr_dataArray.count > dep_dataArray.count ? arr_dataArray.count * 2 + 2 : dep_dataArray.count * 2 + 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextMsgViewCellIdentifier", for: indexPath) as! TextMsgViewCell
            cell.msgLable.text = indexPath.row == 0 ? "ARRIVALS":"DEPARTURES"
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightInfoListCellIdentifier, for: indexPath) as! FlightInfoListCell

        let couple = getDataAtIndex(indexPath)
            
        guard let d = couple.dic , couple.isExist == true else {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellReuseIdentifier", for: indexPath)
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
        cell.fillCell(d,show: indexPath.row == 2,left: indexPath.row % 2 == 0)////.....
        cell.warn_tap.isHidden = !_flight_has_warn(d["acReg"] as! String)
        
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row > 1 else {return}
        
        let couple = getDataAtIndex(indexPath)
        guard let d = couple.dic , couple.isExist == true ,let fltDate = d[indexPath.row % 2 == 0 ? "ymdsta" : "ymdstd"] as? String,let fltNo = d[indexPath.row % 2 == 0 ? "fromFltNo" : "toFltNo"]  as? String else {
            return;
        }
        
        
        //guard let d = getDataAtIndex(indexPath).dic ,let fltDate = d["fltDate"] as? String,let fltNo = d["fltNo"]  as? String else{return}
        
        /*let vc = FlightInfoDetailController.init()
        vc.fltDate = fltDate
        vc.fltNo = fltNo
        vc.fltIsArrival = indexPath.row % 2 == 0
        vc.fltDic = d*/
        
        let vc = FlightWarnListController.init()
        vc.fltDate = fltDate
        vc.fltNo = fltNo
        vc.fltIsArrival = indexPath.row % 2 == 0
        vc.fltDic = d
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let _w = (kCurrentScreenWidth - 10 - 3) / 2.0
        if indexPath.row < 2 {
            return CGSize (width: _w, height: 40 )
        }
        
        
        return CGSize (width: _w, height: 100)
    }

    
    func getDataAtIndex(_ indexPath:IndexPath) -> (isExist:Bool,dic:[String:Any]?) {
        let index = indexPath.row - 2
        let d = dataArray[index / 2]
        let s = index % 2 == 0 ? "fromFltNo":"toFltNo"
        var b = false
        if d[s] is String {
            b = true;
        }
        
        return (b,d)
    }
    
    
    
    func _flight_has_warn(_ airId:String) -> Bool {
        guard warnDataArray.count > 0 else {return false}
        
        for obj in warnDataArray {
            if let tail = obj["tailNo"] as? String {
                if tail == airId {
                    guard obj["grade"] != nil else {return false}
                    return true
                }
            }
        }

        return false
    }
    
//    func getDataAtIndex(_ indexPath:IndexPath) -> [String:Any]? {
//        let index = indexPath.row - 2
//        
//        if index % 2 == 0 {
//            let i = index / 2
//            if i < arr_dataArray.count {
//                let d = arr_dataArray[i]
//                return d
//            }else{
//                return nil
//            }
//            
//        }else{
//            let i = (index - 1 ) / 2
//            if i < dep_dataArray.count {
//                let d = dep_dataArray[i]
//                return d;
//            }else{
//                return nil
//            }
//        }
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
