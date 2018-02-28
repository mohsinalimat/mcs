//
//  FIBViewController.swift
//  mcs
//
//  Created by gener on 2018/1/24.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class FIBViewController: BaseWebViewController {

    var currentDateStr:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _init()
        
        loadData()
    }
    
    override func loadData()  {
        let d = ["fltDate":"\(currentDateStr!)"]
        
        requestWithUrl(get_fib_url, parameters: d)
    }
    
    
    func _init()  {
        title = "Flight Information Board"

        //msg
        let msgBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 100, height: 40))
        msgBtn.addTarget(self, action: #selector(selectDateAction(_ :)), for: .touchUpInside)
        msgBtn.setTitle("200", for: .normal)
        msgBtn.setTitleColor(kButtonTitleDefaultColor, for: .normal)
        msgBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        currentDateStr = Tools.dateToString(Date(), formatter: "yyyy-MM-dd")
        msgBtn.setTitle(currentDateStr, for: .normal)
        
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 20
        let msgItem  = UIBarButtonItem (customView: msgBtn)
        
        var items = self.navigationItem.rightBarButtonItems;
        items?.append(fixed)//[fixed,msgItem]
        items?.append(msgItem)
        
        navigationItem.rightBarButtonItems = items
    }
    
    func selectDateAction(_ sender: UIButton) {
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        let vc = DatePickerController()
        vc.view.frame = frame
        vc.pickerDidSelectedHandler = {[weak self] s in
            sender.setTitle(s, for: .normal);
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.currentDateStr = s
            strongSelf.loadData()
        }
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        self.present(nav, animated: true, completion: nil)
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
