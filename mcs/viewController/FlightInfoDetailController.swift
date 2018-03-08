//
//  FlightInfoDetailController.swift
//  mcs
//
//  Created by gener on 2018/1/22.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class FlightInfoDetailController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    var fltDate:String!
    var fltNo:String!
    var fltIsArrival:Bool = true
    var fltDic = [String:Any]()
    
    var alarm_body = [[String:Any]]()
    var alarm = [[String:Any]]()
    
    private var collectionView: UICollectionView!
    private var flight_info:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _init()
        title = "Flight Warn"
        
        load()
        
        get_warn_list()
        
    }

    func load() {
        HUD.show(withStatus: "Loading...")
        
        let d = ["fltDate":"\(fltDate!.substring(to: fltDate.index(fltDate.startIndex, offsetBy: 10)))","fltNo":"\(fltNo!)"]
        netHelper_request(withUrl: get_flightInfo_url, method: .post, parameters: d, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [String : Any] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf.flight_info = body;
            strongSelf.collectionView.reloadData()
            
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
        
        netHelper_request(withUrl: get_warn_list_url, method: .post, parameters: d, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [[String : Any]] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf.alarm_body = body;
            if let _a = body.first?["alarm"] as? [[String : Any]] {
                strongSelf.alarm = _a;
                strongSelf.collectionView.reloadData()
            }

            
        }) { (error) in
                
        }
        
        
    }
    
    func _init()  {
        let _flowlayout = UICollectionViewFlowLayout()
        _flowlayout.minimumLineSpacing = 10
        _flowlayout.minimumInteritemSpacing = 2
        _flowlayout.scrollDirection = .vertical
        let _w = (kCurrentScreenWidth - 45) / 4.0
        _flowlayout.itemSize = CGSize (width: _w, height: 100 )
        _flowlayout.headerReferenceSize = CGSize (width: kCurrentScreenWidth, height: 260)
        
        collectionView = UICollectionView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64), collectionViewLayout: _flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //collectionView.showsVerticalScrollIndicator = false
        //....
        collectionView.backgroundColor = fltIsArrival ? kUICollectionViewLeftColor : kUICollectionViewRightColor
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 10, 10)
        
        view.addSubview(collectionView)
        
        collectionView.register(UINib (nibName: "WarnListCell", bundle: nil), forCellWithReuseIdentifier: "WarnListCellIdentifier")
        collectionView.register(UINib (nibName: "FlightWarnHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FlightWarnHeaderViewIdentifier")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellReuseIdentifier");
    }
    
    //MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return alarm.count > 10 ? 12 : alarm.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let identifier = "WarnListCellIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WarnListCell
        
        let d = alarm[indexPath.row]
        cell.fillWith(status: d)
        
        if alarm.count > 10 && indexPath.row == 11 {
           let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellReuseIdentifier", for: indexPath)
            
            for v in cell.subviews  {
                if v is UILabel {
                    v.removeFromSuperview();
                }
            }
            let itemsize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
            let l = UILabel.init(frame: CGRect (x: 0, y: 0, width: itemsize.width, height: itemsize.height))
            l.text = "More"
            l.textAlignment = .center
            l.textColor = UIColor.darkGray
            l.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(l)
            
            cell.backgroundColor = UIColor.white
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor
            return cell
        }
        
        cell.backgroundColor = UIColor.init(colorLiteralRed: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 0.5);
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard  kind == UICollectionElementKindSectionHeader else { return UICollectionReusableView() }
        
        let _v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FlightWarnHeaderViewIdentifier", for: indexPath) as! FlightWarnHeaderView
        if flight_info != nil {
            _v.fillData(flight_info)
        }
        
        
        return _v
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  indexPath.row == 1 {
            let v = FlightAllWarnController()
            
            self.navigationController?.pushViewController(v, animated: true)
            return
        }
        
        let v = WarnInfoDetailController()
        
        self.navigationController?.pushViewController(v, animated: true)
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
