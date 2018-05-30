//
//  DDAddWPController.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDAddWPController: BasePickerViewController {

    @IBOutlet weak var ata: UITextField!
    @IBOutlet weak var stas: UIButton!
    @IBOutlet weak var ed_advice: UITextField!
    @IBOutlet weak var txwo: UITextField!
    
    @IBOutlet weak var igv: UIImageView!
    
    var selectedAction:(([String:String]) -> Void)?

    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            Tools.showDataPicekr(self,dataSource:["Open","Closed"]) {(obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }
            break
        case 2://添加附件
            
            break

        default: break
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func finishedBtnAction() {
        if let action = selectedAction {
            let d = ["wpAta":String.isNullOrEmpty(ata.text),
                     "wpStatus":String.isNullOrEmpty(stas.currentTitle == "Open" ? "0" : "1"),
                     "wpEdAdvice":String.isNullOrEmpty(ed_advice.text),
                     "txToWo":String.isNullOrEmpty(txwo.text),
                     "file":"" //...
            ];
            
            action(d)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func headTitle() -> String? {
        return "Add WP"
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
