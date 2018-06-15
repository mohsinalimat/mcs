//
//  DDAddWPController.swift
//  mcs
//
//  Created by gener on 2018/5/29.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DDAddWPController: BasePickerViewController {

    var isR:Bool = false
    var dic:[String:Any]?

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
        //if isR{
            _fillData(dic);
        //}

    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscape;
        }
    }
    

    override func finishedBtnAction() {
        if let action = selectedAction {
            var igBase64Str = ""
            if let ig = igv.image , let data = UIImageJPEGRepresentation(ig, 0.5) {
                 igBase64Str = "data:image/jpeg;base64,";
                 igBase64Str = igBase64Str.appending(data.base64EncodedString()) ;
            }

            let d = ["wpAta":String.isNullOrEmpty(ata.text),
                     "wpStatus":String.isNullOrEmpty(stas.currentTitle == "Open" ? "0" : "1"),
                     "wpEdAdvice":String.isNullOrEmpty(ed_advice.text),
                     "txToWo":String.isNullOrEmpty(txwo.text),
                     "fileStr":igBase64Str
            ] as [String : Any];
            
            action(d)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func _fillData(_ d:[String:Any]?) {
        guard let d = d else {return}
        
        ata.text = String.isNullOrEmpty(d["wpAta"])
        ed_advice.text = String.isNullOrEmpty(d["wpEdAdvice"])
        stas.setTitle(String.isNullOrEmpty(d["wpStatus"]) == "0" ? "Open" : "Closed", for: .normal)
        txwo.text = String.isNullOrEmpty(d["txToWo"])
        
        if let attachment = d["attachments"] as? [String:Any]  , let _id = attachment["id"] as? String{
            requestImage(_id, completionHandler: { [weak self] (ig) in
                guard let ss = self else {return}
                ss.igv.image = ig;
            });
            
        }
        

        ///
        guard isR else {return}
        let v = UIView (frame: self.view.frame)
        self.view.addSubview(v)
        self.navigationItem.rightBarButtonItem = nil
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
