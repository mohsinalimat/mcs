//
//  PlaneCertInfoController.swift
//  mcs
//
//  Created by gener on 2018/6/28.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class PlaneCertInfoController: BaseViewController , UICollectionViewDelegate,UICollectionViewDataSource{

    var _id:String!
    
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _tableView: UITableView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stas: UILabel!
    @IBOutlet weak var loadDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    var attaches:[[String:Any]]?
    var history:[[String:Any]]?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _addCloseItem()
        _init()
        
        loadData()
    }

    func _init()  {
        //////////
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.register(UINib (nibName: "PlaneCertImageCell", bundle: nil), forCellWithReuseIdentifier: "PlaneCertImageCellIdentifier")
        
    }
    
    func loadData() {
        request(get_cert_url, parameters: ["id":_id], successHandler: {[weak self] (res) in
            guard let ss = self else {return}
            guard let d = res["body"] as? [String:Any] else {return}
            ss._fillData(d);
            }) { (str) in
                
        }
        
    }
    
    
    func _fillData( _ d:[String:Any]) {
        name.text = String.isNullOrEmpty(d["name"])
        stas.text = String.isNullOrEmpty(d["status"]) == "0" ? "Not Expired":"Expired"
        
        if let date = Tools.date(String.isNullOrEmpty(d["beginTime"])) {
            let s = Tools.dateToString(date, formatter: "yyyy-MM-dd");
            loadDate.text = s
        }
        
        if let enddate = Tools.date(String.isNullOrEmpty(d["endTime"])) {
            let s = Tools.dateToString(enddate, formatter: "yyyy-MM-dd");
            endDate.text = s
        }
        
        
        if let atta = d["attaches"] as? [[String:Any]] {
            attaches = atta;
        }

        if let atta = d["certList"] as? [[String:Any]] {
            history = atta;
        }
        
    }
    
    
    //MARK:UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaneCertImageCellIdentifier", for: indexPath);
        
        cell.backgroundColor = UIColor.white;
        return cell
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
