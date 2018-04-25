//
//  TaskPoolSelectController.swift
//  mcs
//
//  Created by gener on 2018/3/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskPoolSelectController: BaseViewController {

    @IBOutlet weak var date_btn: UIButton!
    
    @IBOutlet weak var shift_btn: UIButton!
    
    @IBOutlet weak var station_btn: UIButton!
    
    
    @IBAction func buttonClickedAction(_ sender: UIButton) {
        var vc = BasePickerViewController()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        
        switch sender.tag {
        case 2,3:
            vc = DataPickerController()
            vc.dataType = sender.tag == 2 ? PickerDataSourceItemTpye.obj : .str
            if let station = kTaskPool_BASE_DATA[sender.tag == 2 ? "shifts" : "stations"] as? [Any] {
                vc.dataArray = station;
            }
            
            break
        case 1:vc = DatePickerController();
        
            break
        default:break
        }
        
        vc.pickerDidSelectedHandler = { s in
            if sender.tag == 2 {
                let obj = s as! [String:String]
                kTaskpool_shift = obj
                sender.setTitle(obj["value"], for: .normal)
            }else if sender.tag == 1 {
                let obj = s as! Date
                kTaskpool_date = obj
                sender.setTitle(Tools.dateToString(obj, formatter: "yyyy-MM-dd"), for: .normal)
            }else if sender.tag == 3 {
                let obj = s as! String
                kTaskpool_station = obj
                sender.setTitle(obj, for: .normal)
            }

        }
        
        vc.view.frame = frame
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        self.present(nav, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white;
        
        _init()
        
        
    }

    func _init() {
        let _titlev = UILabel (frame: CGRect (x: 0, y: 0, width: 100, height: 30))
        _titlev.textColor = UIColor.white
        _titlev.text = "Please Select"
        _titlev.textAlignment = .center
        navigationItem.titleView = _titlev
        
        // Do any additional setup after loading the view.
        //close
        let closebtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        closebtn.setTitle("Cancel", for: .normal)
        closebtn.setTitleColor(UIColor.white, for: .normal)
        closebtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: 1)
        closebtn.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        closebtn.tag = 100
        let litem = UIBarButtonItem (customView: closebtn)
        navigationItem.leftBarButtonItem = litem
        
        let finishedbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        finishedbtn.setTitle("OK", for: .normal)
        finishedbtn.setTitleColor(UIColor.white, for: .normal)
        finishedbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: 1)
        finishedbtn.addTarget(self, action: #selector(finishedBtnAction), for: .touchUpInside)
        finishedbtn.tag = 100
        finishedbtn.layer.cornerRadius = 10
        finishedbtn.layer.masksToBounds = true
        let ritem = UIBarButtonItem (customView: finishedbtn)
        navigationItem.rightBarButtonItems = nil
        navigationItem.rightBarButtonItem = ritem
        
        
        guard kTaskpool_date != nil ,kTaskpool_shift != nil , kTaskpool_station != nil else {return}
        shift_btn.setTitle(kTaskpool_shift?["value"], for: .normal)
        date_btn.setTitle(Tools.dateToString(kTaskpool_date!, formatter: "yyyy-MM-dd"), for: .normal)
        station_btn.setTitle(kTaskpool_station, for: .normal)
 
    }
    
    func finishedBtnAction() {
        guard kTaskpool_date != nil ,kTaskpool_shift != nil , kTaskpool_station != nil else {
            HUD.show(info: "Please Select!");
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init("notification-selected-complete"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    



}
