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
    
    let disposeBag = DisposeBag.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _setTitleView("Add Material&Tools");
        
        _addCloseItem()
        
        pin.rx.text.orEmpty.map {$0.lengthOfBytes(using: String.Encoding.utf8) > 0}.bindTo(add_tbn.ex_isEnabled).addDisposableTo(disposeBag);
        
    }

    
    @IBAction func selectAction(_ sender: UIButton) {
        
        Tools.showDataPicekr (self,dataSource:["Materal","Tools"] ){ [weak self](obj) in
            guard let strongSelf = self else {return}
            
            let obj = obj as! String
            strongSelf.type_btn.setTitle(obj, for: .normal)

        }
        
    }
    
    
    
    
    @IBAction func addAction(_ sender: AnyObject) {
       let d =  [
         "partType":String.stringIsNullOrNilToEmpty(type_btn.currentTitle),
         "pn":String.stringIsNullOrNilToEmpty(pin.text),
         "description":String.stringIsNullOrNilToEmpty(descri.text),
         "qty":String.stringIsNullOrNilToEmpty(qty.text),
         "fin":String.stringIsNullOrNilToEmpty(fin.text),
         "remark":String.stringIsNullOrNilToEmpty(mark.text),
         "storeInAmasis":String.stringIsNullOrNilToEmpty(store_in.text)]
        
        addActionMateralDataArr.insert(d, at: 0);
        
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
