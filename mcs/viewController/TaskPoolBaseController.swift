//
//  TaskPoolBaseController.swift
//  
//
//  Created by gener on 2018/3/2.
//
//

import UIKit

class TaskPoolBaseController: BaseTabItemController {

    @IBOutlet weak var topBgView: UIView!
    @IBOutlet weak var search_bgview: UIView!
    
    @IBOutlet weak var select_date_btn: UIButton!
    
    @IBOutlet weak var select_shift_btn: UIButton!
    
    @IBOutlet weak var select_station_btn: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _init()
        
        topBgView.layer.borderColor = kTableviewBackgroundColor.cgColor
        topBgView.layer.borderWidth = 1
        
        navigationItem.titleView = navigatoinItemTitleView()
        
    }

    
    func _init()  {
        let currentDateStr = Tools.dateToString(Date(), formatter: "yyyy-MM-dd")
        select_date_btn.setTitle(currentDateStr, for: .normal)
        
        
        let vc = TaskPoolViewController()
        vc.view.frame = CGRect (x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height  - 49 - 60)
        
        self.addChildViewController(vc)
        
        self.view.addSubview(vc.view)

    
    }
    
    @IBAction func selectData(_ sender: UIButton) {
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        let vc = DatePickerController()
        vc.view.frame = frame
        vc.pickerDidSelectedHandler = {[weak self] s in
            let date = s as! Date
            let str = Tools.dateToString(date, formatter: "yyyy-MM-dd")
            
            sender.setTitle("\(str)", for: .normal);
            guard let strongSelf = self else {
                return
            }
            
            //            strongSelf.currentDateStr = "\(str)"
            //            strongSelf.loadData()
        }
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func selectShift(_ sender: UIButton) {
        
        
    }
    
    @IBAction func selectStation(_ sender: UIButton) {
        
    }
    
    
    
    func navigatoinItemTitleView() -> UIView  {
        let seg = UISegmentedControl.init(items: ["Task Pool","HandleOver"])
        
        seg.frame = CGRect (x: 0, y: 0, width: 400, height: 30)
        seg.addTarget(self, action: #selector(segClicked(_:)), for:.valueChanged )
        seg.selectedSegmentIndex = 0
        seg.tintColor = kViewDefaultBgColor
        
        return seg
    }
    
    func segClicked( _ seg:UISegmentedControl)  {
        search_bgview.isHidden = seg.selectedSegmentIndex == 1
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "TaskPoolChangedNotificationName"), object: nil, userInfo: ["index":seg.selectedSegmentIndex])
    
    
    
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
