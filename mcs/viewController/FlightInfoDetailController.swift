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
        
        let d = ["fltDate":"\(fltDate!)","fltNo":"\(fltNo!)"]
        netHelper_request(withUrl: get_flightInfo_url, method: .post, parameters: d, successHandler: { [weak self](result) in
            HUD.dismiss()
            guard let body = result["body"] as? [String : Any] else {return;}
            guard let strongSelf = self else{return}
            
            strongSelf.flight_info = body;
            strongSelf.collectionView.reloadData()
            
            })
        
        
    }
    
    
    func get_warn_list() {
        let d = ["aircraftNo":fltDic["acId"]!,
            "flightNo":"\(fltNo!)",
            "beginDate":Tools.dateToString(Tools.date("\(fltDic["std"]!)")!, formatter: "yyyy/MM/dd HH:mm:ss"),
            "endDate":Tools.dateToString(Tools.date("\(fltDic["sta"]!)")!, formatter: "yyyy/MM/dd HH:mm:ss")
        ]
        
        netHelper_request(withUrl: get_warn_list_url, method: .post, parameters: d, successHandler: { (res) in
            
            }) { (error) in
                
        }
        
        
    }
    
    func _init()  {
        let _flowlayout = UICollectionViewFlowLayout()
        _flowlayout.minimumLineSpacing = 10
        _flowlayout.minimumInteritemSpacing = 2
        _flowlayout.scrollDirection = .vertical
        let _w = (kCurrentScreenWidth - 45) / 4.0
        _flowlayout.itemSize = CGSize (width: _w, height: 110 )
        _flowlayout.headerReferenceSize = CGSize (width: kCurrentScreenWidth, height: 280)
        
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
    let cellnumber = 12
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellnumber
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let identifier = indexPath.row == cellnumber - 1 ? "UICollectionViewCellReuseIdentifier":"WarnListCellIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) //as! WarnListCell
        
        //        let d = dataArray[indexPath.row]
        //        var taskno:Int = 0
        //        if let acId = d["acId"] as? String , let n = taskNoData[acId] {
        //            taskno = n
        //        }
        //
        //        cell.fillCell(d,taskNumber: taskno)
        if indexPath.row == cellnumber - 1 {
            for v in cell.subviews  {
                if v is UILabel {
                    v.removeFromSuperview();
                }
            }
            let itemsize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
            let l = UILabel.init(frame: CGRect (x: 0, y: 0, width: itemsize.width, height: itemsize.height))
            l.text = "More..."
            l.textAlignment = .center
            l.textColor = UIColor.darkGray
            l.font = UIFont.systemFont(ofSize: 18)
            cell.addSubview(l)
        }
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
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
        guard indexPath.row < cellnumber - 1 else {
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
