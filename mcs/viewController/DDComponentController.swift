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
        _setTitleView("Add Component");
        _addCloseItem()
        
    }
    
    
    @IBAction func addAction(_ sender: UIButton) {
    
    
    
    
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
