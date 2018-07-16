//
//  DDComponentController.swift
//  mcs
//
//  Created by gener on 2018/7/10.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDComponentController: BaseViewController {
    @IBOutlet weak var pn: UITextField!
    @IBOutlet weak var sn: UITextField!
    @IBOutlet weak var fin: UITextField!
    @IBOutlet weak var fh: UITextField!
    @IBOutlet weak var fc: UITextField!
    @IBOutlet weak var reg: UIButton!
    @IBOutlet weak var pos: UITextField!
    @IBOutlet weak var enable_monitoring: UISwitch!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        _setTitleView("Add Component");
        _addCloseItem()
        
    }
    
    
    @IBAction func selectReg(_ sender: UIButton) {
        Tools.showDataPicekr (self,dataSource:Tools.acs()){ (obj) in
            let obj = obj as! String
            sender.setTitle(obj, for: .normal)
        }
        
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        let d = [["pn":String.isNullOrEmpty(pn.text),
                  "sn":String.isNullOrEmpty(sn.text),
                  "fin":String.isNullOrEmpty(fin.text),
                  "pos":String.isNullOrEmpty(pos.text),
                  "fh":String.isNullOrEmpty(fh.text),
                  "fc":String.isNullOrEmpty(fc.text),
                  "acReg":String.isNullOrEmpty(reg.currentTitle),
                  "enableMonitoring":enable_monitoring.isOn ? "1" : "0"]]

        ddComponentArr = d;
        
        NotificationCenter.default.post(name: NSNotification.Name.init("add_materialOrComponent_notification"), object: nil);
        
        self.dismiss(animated: true, completion: nil);
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
