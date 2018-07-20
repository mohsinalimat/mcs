//
//  SetterController.swift
//  mcs
//
//  Created by gener on 2018/7/20.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class SetterController: UITableViewController,ShowAlertControllerAble {

    @IBOutlet weak var version: UILabel!
    
    @IBOutlet weak var cacheSize: UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
        showMsg("EXIT?", title: "OK") {
            userIsLogin = false
            let loginvc = LoginViewController()

            UIApplication.shared.keyWindow?.rootViewController = loginvc
        }
  
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setter";

        _init()
    }

    func _init() {
        tableView.tableFooterView = UIView()
        
        if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ,let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            version.text = "\(v).\(build)";
        }
        
        let manager = FileManager.default
        let exist = manager.fileExists(atPath: kTemporaryDirectory)
 
        if exist {
            let size = calFileSize(kTemporaryDirectory)
            cacheSize.text = String.init(format: "%.1f M", size)
        }
        
        
    }
    
    
    
    func calFileSize(_ path:String) -> Double {
        let manager = FileManager.default
        guard manager.isReadableFile(atPath: path) else {return 0}
        
        var total:Double = 0;
        do{
            let files = try manager.subpathsOfDirectory(atPath: path);
            for f in files {
                let filpath = path + "/\(f)";
                let attri = try manager.attributesOfItem(atPath: filpath)
                if let size = attri[FileAttributeKey.size] as? NSNumber {
                    let d = Double.init(size) / 1024.0 / 1024.0;
                    total += d;
                }
            }
        }catch{
            print(error.localizedDescription);
        }
        
        return total;
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 1 else { return}
        guard calFileSize(kTemporaryDirectory) > 0 else {return}
        let manager = FileManager.default
        
        HUD.show();
        
        defer{
            cacheSize.text = "0M"
            HUD.show(successInfo: "Ok");
        }
        
        if manager.isReadableFile(atPath: kTemporaryDirectory){
            do{
                try manager.removeItem(atPath: kTemporaryDirectory);
            }catch{
                print(error.localizedDescription);
            }
            
        }else {
            print("unreachable");
        }

        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
