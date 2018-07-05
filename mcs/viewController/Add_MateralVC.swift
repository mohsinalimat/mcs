//
//  Add_MateralVC.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Add_MateralVC: BaseViewController {

    @IBOutlet weak var pin: UITextField!
    
    @IBOutlet weak var qty: UITextField!
    
    @IBOutlet weak var fin: UITextField!
    
    @IBOutlet weak var type_btn: UIButton!
    
    @IBOutlet weak var store_in: UITextField!
    
    @IBOutlet weak var descri: UITextField!
    
    @IBOutlet weak var mark: UITextField!
    
    @IBOutlet weak var add_tbn: UIButton!
    @IBOutlet weak var ipc_btn: UIButton!
    
    let disposeBag = DisposeBag.init()
    
    var index:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _setTitleView("Add Material&Tools");
        
        _addCloseItem()
        
        if index >= 0 {
            _fill(addActionMateralDataArr[index]);
            ipc_btn.isHidden = true
        }
        
        pin.rx.text.orEmpty.map {$0.lengthOfBytes(using: String.Encoding.utf8) > 0}.bindTo(add_tbn.ex_isEnabled).addDisposableTo(disposeBag);
    }

    func _fill(_ d:[String:Any]) {
        pin.text = String.isNullOrEmpty(d["pn"]);
        type_btn.setTitle(String.isNullOrEmpty(d["partType"]), for: .normal)
        descri.text = String.isNullOrEmpty(d["description"])
        qty.text  = String.isNullOrEmpty(d["qty"])
        fin.text = String.isNullOrEmpty(d["fin"])
        mark.text = String.isNullOrEmpty(d["remark"])
        store_in.text = String.isNullOrEmpty(d["storeInAmasis"])
    }
    

    @IBAction func selectAction(_ sender: UIButton) {
        
        Tools.showDataPicekr (self,dataSource:["MATERIAL","TOOL"] ){ [weak self](obj) in
            guard let strongSelf = self else {return}
            
            let obj = obj as! String
            strongSelf.type_btn.setTitle(obj, for: .normal)

        }
        
    }
    
    
    @IBAction func select_ipc_action(_ sender: UIButton) {
        guard report_reg != nil else { HUD.show(info: "Select Reg!"); return};
        
        request(get_ipc_url, parameters: ["acReg":report_reg!], successHandler: {[unowned self]  (res) in
            guard let u = res["body"] as? String else {return}
            let v = SelectIPcController()
            v.req_url = u
            v.view.frame = UIScreen.main.bounds
            
            let root = UIApplication.shared.keyWindow?.rootViewController
            self.dismiss(animated: false, completion: nil)
            root?.present(v, animated: true, completion: nil)
        })
    
    }
    
    
    @IBAction func addAction(_ sender: AnyObject) {
       let d =  [
         "partType":String.isNullOrEmpty(type_btn.currentTitle),
         "pn":String.isNullOrEmpty(pin.text),
         "description":String.isNullOrEmpty(descri.text),
         "qty":String.isNullOrEmpty(qty.text),
         "fin":String.isNullOrEmpty(fin.text),
         "remark":String.isNullOrEmpty(mark.text),
         "storeInAmasis":String.isNullOrEmpty(store_in.text)]
        
        if index >= 0 {
            addActionMateralDataArr.insert(d, at: index);
            addActionMateralDataArr.remove(at: index + 1)
        }else {
            addActionMateralDataArr.insert(d, at: 0);
        }
        
        
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
