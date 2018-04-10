//
//  TaskNumberListVC.swift
//  mcs
//
//  Created by gener on 2018/4/10.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TaskNumberListVC: BaseTableViewVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func getTextAt(_ indexPath: Int) -> (len:Int , text: String?)? {
        if let d = dataArray[indexPath] as? [String:Any] {
            let taskno = String.stringIsNullOrNil(d["taskNo"]);
            let des = String.stringIsNullOrNilToEmpty(d["defectDesc"])
            return (taskno.lengthOfBytes(using: String.Encoding.utf8) , "\(taskno) \(des)")
        }
        
        return nil
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
