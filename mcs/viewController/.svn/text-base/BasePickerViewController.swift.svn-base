//
//  BasePickerViewController.swift
//  mcs
//
//  Created by gener on 2018/1/12.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

enum PickerDataSourceItemTpye {
    case str
    
    case obj
}



class BasePickerViewController: BaseViewController {

    var pickerDidSelectedHandler:((Any) -> Void)?//选中操作回调
    
    var dataType :PickerDataSourceItemTpye =  .str
    
    var dataArray:[Any]?
    
    var head_title:String? = "Please Select"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let _titlev = UILabel (frame: CGRect (x: 0, y: 0, width: 100, height: 30))
        _titlev.textColor = UIColor.white
        _titlev.textAlignment = .center
        _titlev.text = headTitle()
        navigationItem.titleView = _titlev

        
        addNavigationItem();
        
    }

    func headTitle() -> String? {
        return head_title
    }
    
    func addNavigationItem()  {
        //checkupdatebtn
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
        
        //close
        let closebtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        closebtn.setTitle("Cancel", for: .normal)
        closebtn.setTitleColor(UIColor.white, for: .normal)
        closebtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: 1)
        closebtn.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        closebtn.tag = 100
        let litem = UIBarButtonItem (customView: closebtn)
        navigationItem.leftBarButtonItem = litem
    }
    
    
    //MARK:

    func finishedBtnAction() {}
    
    
    
    
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
