//
//  MyOrderController.swift
//  mcs
//
//  Created by gener on 2018/6/19.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class MyOrderController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pn_total: UILabel!
    @IBOutlet weak var qty: UILabel!
    
    @IBOutlet weak var ac: UIButton!
    @IBOutlet weak var shift: UIButton!
    var pn_selected_reg:String?
    var pn_selected_shift:String?
    
    
    var dataArray = [[String:String]]()
    var leaveHandler:(([[String:String]]) -> Void)?
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            guard dataArray.count > 0 else {return}
            self.showMsg("Clear All Record?", title: "OK", handler: {[weak self] in
                guard let ss = self else {return}
                ss.__clear()
                })

            break
        case 2:
            guard pn_selected_reg != nil else {HUD.show(info: "Select A/C "); return}
            guard pn_selected_shift != nil else {HUD.show(info: "Select Shift "); return}
            guard dataArray.count > 0 else {return}
            
            
            var pnArr = [[String:String]]()
            for _d in dataArray {
                let pn = String.isNullOrEmpty(_d["stpn"])
                let des = String.isNullOrEmpty(_d["description"])
                let num = pn_selected_number[pn] ?? 1
                
                let new = ["pn" : pn,
                           "description":des,
                           "totalQty": "\(num)"]
                
                pnArr.append(new)
            }
            
            
            let d = ["shift":pn_selected_shift!,
                     "ac":pn_selected_reg!,
                     "taskPns":pnArr
                ] as [String : Any]
            
            HUD.show()
            requestJSONEncoding(submit_order_url, parameters: d, successHandler: {[weak self] (res) in
                HUD.show(successInfo: "Success! ")
                guard let ss = self else {return}
                ss.__clear()
                _  = ss.navigationController?.popViewController(animated: true)
                })

            break
        
        
        case 3://reg
        Tools.showDataPicekr (dataSource:Tools.acs()){ [weak self](obj) in
            let obj = obj as! String
            sender.setTitle(obj, for: .normal)
            
            guard let strongSelf = self else {return}
            strongSelf.pn_selected_reg = obj
        }
        break
            
        case 4:
            
            Tools.showDataPicekr(dataSource:Tools.shift()) { [weak self](obj) in
                guard let strongSelf = self else {return}
                let obj = obj as! [String:String]
                strongSelf.shift.setTitle(obj["value"], for: .normal)
                strongSelf.pn_selected_shift = obj["value"]
            }
            
            break
            
        default:break
        }
    
    }
    
    func __clear()  {
        dataArray.removeAll();
        tableView.reloadData()
        
        pn_selected_number.removeAll()
        __calTotal()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Order";
        view.backgroundColor = UIColor.white;
        
        // Do any additional setup after loading the view.
        _initSubviews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handler = leaveHandler {
            handler(dataArray);
        }
    }
    
    
    //MARK: - init
    func _initSubviews()  {
        tableView.register(UINib (nibName: "MyOrderCell", bundle: nil), forCellReuseIdentifier: "MyOrderCelldentifier")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        
        
        __calTotal()
        
    }
    
    
    
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCelldentifier", for: indexPath) as! MyOrderCell
        let d = dataArray[indexPath.row]
        let num = pn_selected_number[String.isNullOrEmpty(d["stpn"])]
        
        cell.fill(d , num:num)
        cell.buttonActionHandler = {[weak self] num in
            guard let ss = self else {return}
            ss._add(indexPath.row, num: num);
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return  true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showMsg("Delete This Record?", title: "Delete", handler: {[weak self] in
                guard let ss = self else {return}
                    ss.__delete(tableView, indexPath: indexPath)
                })
        }
    }
    
    func __delete(_ tableView: UITableView ,indexPath: IndexPath)  {
        let d = dataArray[indexPath.row]
        let pn = String.isNullOrEmpty(d["stpn"])
        pn_selected_number.removeValue(forKey: pn)
        
        dataArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        __calTotal()
    }
    
    //MARK: -
    func _add(_ index:Int , num:Int)  {
        let pn = String.isNullOrEmpty(dataArray[index]["stpn"])
        pn_selected_number[pn] = num
        __calTotal()
    }

    
    func __calTotal()  {
        var total = 0
        var i = 0
        for (_ , v) in pn_selected_number {
            total = total + v;
            i = i + 1
        }
        
        
        qty.text = "\(dataArray.count + total - i)"
        pn_total.text = "\(dataArray.count)"
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
