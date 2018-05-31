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
    
    @IBOutlet weak var deleteIg: UIButton!

    var selectedAction:(([String:Any]) -> Void)?

    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            Tools.showDataPicekr(self,dataSource:["Open","Closed"]) {(obj) in
                let obj = obj as! String
                sender.setTitle(obj, for: .normal)
            }
            break
        case 2://添加附件
            TTImagePicker().show(inView:self, sourceView : sender , completion: { (ig) in
                DispatchQueue.main.async {[weak self] in
                    guard let ss = self else {return}
                    ss.igv.image = ig
                    ss.deleteIg.isHidden = false
                }
            })

            break
        case 3:
            igv.image = nil;
            deleteIg.isHidden = true
            break
        default: break
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscape;
        }
    }
    

    override func finishedBtnAction() {
        if let action = selectedAction {
            let d = ["wpAta":String.isNullOrEmpty(ata.text),
                     "wpStatus":String.isNullOrEmpty(stas.currentTitle == "Open" ? "0" : "1"),
                     "wpEdAdvice":String.isNullOrEmpty(ed_advice.text),
                     "txToWo":String.isNullOrEmpty(txwo.text),
                     "file":igv.image
            ] as [String : Any];
            
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
