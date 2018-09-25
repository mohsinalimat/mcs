//
//  Add_ComponentVC.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class Add_ComponentVC: BaseViewController {
    @IBOutlet weak var pin_off: UITextField!

    @IBOutlet weak var sin_off: UITextField!
    
    @IBOutlet weak var pin_on: UITextField!
    
    @IBOutlet weak var sn_on: UITextField!
    
    @IBOutlet weak var fin: UITextField!
    
    @IBOutlet weak var type_btn: UIButton!
    
    @IBOutlet weak var pos: UITextField!

    @IBOutlet weak var btn_add: UIButton!
    
    
    let disposeBag = DisposeBag.init()

    @IBAction func selectAction(_ sender: UIButton) {
        
        Tools.showDataPicekr (self,dataSource:["MATERIAL","TOOL"] ){ [weak self](obj) in
            guard let strongSelf = self else {return}
            
            let obj = obj as! String
            strongSelf.type_btn.setTitle(obj, for: .normal)
            
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _setTitleView("Add Component");
        _addCloseItem()
        
       let o1 =  pin_on.rx.text.orEmpty.map { $0.lengthOfBytes(using: String.Encoding.utf8) > 0 }.shareReplay(1)
       let o2 =   pin_off.rx.text.orEmpty.map { $0.lengthOfBytes(using: String.Encoding.utf8) > 0 }.shareReplay(1)
       let o3 =   sn_on.rx.text.orEmpty.map { $0.lengthOfBytes(using: String.Encoding.utf8) > 0 }.shareReplay(1)
       let o4 =   sin_off.rx.text.orEmpty.map { $0.lengthOfBytes(using: String.Encoding.utf8) > 0 }.shareReplay(1)
        
       Observable.combineLatest(o1,o2,o3,o4) { $1 && $2 && $3 && $0 }.bindTo(btn_add.ex_isEnabled).addDisposableTo(disposeBag)
        
    }

    
    
    
    
    
    @IBAction func action(_ sender: UIButton) {
        
        let d =          ["pnOff":String.isNullOrEmpty(pin_off.text),
                          "snOff":String.isNullOrEmpty(sin_off.text),
                          "pnOn":String.isNullOrEmpty(pin_on.text),
                          "snOn":String.isNullOrEmpty(sn_on.text),
                          "fin":String.isNullOrEmpty(fin.text),
                          "partType":String.isNullOrEmpty(type_btn.currentTitle),
                          "pos":String.isNullOrEmpty(pos.text)]

        
    
        addActionComponentDataArr.insert(d, at: 0);
        
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
