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
    
    var dataArray = [[String:Any]]()

    @IBAction func buttonAction(_ sender: UIButton) {
    
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Order";
        view.backgroundColor = UIColor.white;
        
        // Do any additional setup after loading the view.
        _initSubviews()
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
            let d = dataArray[indexPath.row]
            let pn = String.isNullOrEmpty(d["stpn"])
            pn_selected_number.removeValue(forKey: pn)
            
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            __calTotal()
        }
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
