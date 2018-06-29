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
    @IBOutlet weak var pageCtr: UIPageControl!
    
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
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "PlaneCertHistoryCell", bundle: nil), forCellReuseIdentifier: "PlaneCertHistoryCellIdentifier")
        _tableView.rowHeight = 60
        _tableView.tableFooterView = UIView()
        _tableView.backgroundColor = kTableviewBackgroundColor
        _tableView.layer.borderWidth = 1
        _tableView.layer.borderColor = UIColor.lightGray.cgColor
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
        
        _collectionView.reloadData()
        _tableView.reloadData()
        pageCtr.currentPage = 0
        pageCtr.numberOfPages = (attaches?.count) ?? 0
    }
    
    
    //MARK:UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let arr = attaches else {return 0}
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaneCertImageCellIdentifier", for: indexPath) as! PlaneCertImageCell;
        let d = attaches?[indexPath.row]
        cell.fill(d!)
        
        cell.backgroundColor = kTableviewBackgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PlaneCertImageCell
        guard let ig = cell.ig.image else {return}
        
        let v = TTImagePreviewController()
        v.img = ig //UIImage (named: "launchImage")

        
        self.navigationController?.present(v, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let i = lroundf(Float(scrollView.contentOffset.x / scrollView.frame.width))
        pageCtr.currentPage = i
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

extension PlaneCertInfoController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (history?.count) ?? 0

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaneCertHistoryCellIdentifier", for: indexPath) as! PlaneCertHistoryCell
        if let arr = history {
            let d = arr[indexPath.row]
            cell.fill(d)
        }
        
        
        return cell
    }
    
    
    
    
    
    
}






