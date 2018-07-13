//
//  LoginViewController.swift
//  mcs
//
//  Created by gener on 2018/1/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var loginTableView: UITableView!
    @IBOutlet weak var versoinInfo: UILabel!
    let titleArr = ["User","Password","Shift","Schedule Time","Station"]
    
    var isOpenAll:Bool = false
    var username_tf:UITextField!
    var pwd_tf:UITextField!
    var _selectedValue = [Int:Any]()
    //test
    var u_name = "offline"
    var u_pwd = "111111"

    override func viewDidLoad() {
        super.viewDidLoad()

        get_basedata();
        
        _initSubview();
        loginTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    }

    func _initSubview() {

        loginTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
        let _footview = footview()
        //footview.frame =  CGRect (x: 0, y: 0, width: 500, height: 100)
        loginTableView.tableFooterView = _footview
        loginTableView.rowHeight = 60;
        loginTableView.separatorColor = kTableviewBackgroundColor

        if let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ,let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versoinInfo.text = "Version\(v).\(build)";
        }

    }
    
    //MARK: -
    func get_basedata() {
        HUD.show()
        netHelper_request(withUrl: login_basedata_url, method: .post, parameters: nil, successHandler: {(result) in
            guard let body = result["body"] as? [String : Any] else {return;}
            HUD.dismiss()
            
            kTaskPool_BASE_DATA = body
            
            }
        )
    }

    
    func footview() -> UIView {
       let _view = UIView (frame: CGRect (x: 0, y: 0, width: 500, height: 100))
        let line = UILabel (frame: CGRect (x: 15, y: 0, width: 500 - 30, height: 0.5))
        line.backgroundColor = kTableviewBackgroundColor
        _view.addSubview(line)
        
       let _s = UISwitch (frame: CGRect (x: 500 - 60, y: 8, width: 60, height: 30))
        _s.addTarget(self, action: #selector(switchStatus(_ :)), for: .valueChanged)
        _s.isOn = false
       
        let info = UILabel (frame: CGRect (x: _s.frame.minX - 65, y: 8, width: 60, height: 30))
        info.font = UIFont.systemFont(ofSize: 13)
        info.textColor = UIColor.lightGray
        info.text = "Shift Info"
        _view.addSubview(info)
        _view.addSubview(_s)
        
        for i in 0..<2 {
            let btn = UIButton (frame: CGRect (x: i == 0 ? 10:290, y: 60, width: 200, height: 40));
            btn.backgroundColor = i == 1 ? UIColor.init(colorLiteralRed: 0.318, green: 0.243, blue: 0.533, alpha: 1):UIColor.lightGray;
            btn.setTitle(i == 1 ? "Login":"Reset", for: .normal)
            btn.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
            btn.tag = 100 + i;
            btn.layer.cornerRadius = 8
            btn.layer.masksToBounds = true            
            _view.addSubview(btn)
        }
        
       return _view
    }
    
    func buttonAction(_ btn:UIButton)  {        
        if btn.tag == 101 {
            guard let name = username_tf.text, let pwd = pwd_tf.text else { return}
            guard name.lengthOfBytes(using: String.Encoding.utf8) > 0 , pwd.lengthOfBytes(using: String.Encoding.utf8) > 0 else {
                HUD.show(info: "username and password can't be null"); return
            }
            
            HUD.show(withStatus: hud_msg_loading)
            netHelper_request(withUrl: login_url, method: .post, parameters: ["username":name,"password":pwd], successHandler: { (result) in
                HUD.show(successInfo: "Success")
                //数据保存
                guard let body = result["body"] as? [String:String] else {return;}
                if let token = body["token"] {
                    UserDefaults.standard.set(token, forKey: "user-token");
                }
                
                if let  role = body["roleCode"]{
                    UserDefaults.standard.set(role, forKey: "user-role");
                }
                
                UserDefaults.standard.set(name, forKey: "user-name")
                UserDefaults.standard.set(body, forKey: "loginUserInfo")
                UserDefaults.standard.set(["username":name,"password":pwd], forKey: "account")
                UserDefaults.standard.synchronize()
                
                let tab = BaseTabBarController()
                UIApplication.shared.keyWindow?.rootViewController = tab
                } , failureHandler: { err in
                    HUD.show(info: err ?? "request error!")
                }
            )
        }else{
            //清空数据
            u_name = ""
            u_pwd = ""
            _selectedValue.removeAll()
            loginTableView.reloadData()
        }
        
    }
    
    
    func switchStatus(_ s:UISwitch)  {
        u_name = String.isNullOrEmpty(username_tf.text)
        u_pwd = String.isNullOrEmpty(pwd_tf.text)
        isOpenAll = s.isOn
        loginTableView.reloadData()
    }
    
    
    //MARK:-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isOpenAll ? 5 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
        
        for _v  in cell.subviews {
            if _v.isKind(of: UIView.self) && _v.tag == 101 {
                _v.removeFromSuperview()
            }
        }
        
        if indexPath.row == 0 {
            let username = UITextField.init(frame: CGRect.init(x:10, y:10, width:tableView.frame.width - 20, height:40))
            username.placeholder = "username"
            username.borderStyle = .none;
            username.returnKeyType = .next
            username.keyboardType = .asciiCapable
            username.clearButtonMode = .whileEditing
            //username.delegate = self;
            cell.addSubview(username)
            let v0 = UIView.init(frame: CGRect.init(x: 0, y: 5, width: 35, height: 30))
            let nameleftv = UIImageView.init(image: UIImage.init(imageLiteralResourceName: "user_icon"))
            nameleftv.frame = CGRect.init(x: 10, y: (v0.frame.height - 16)/2.0, width: 16, height: 16)
            v0.addSubview(nameleftv)
            username.leftView = v0;
            username.leftViewMode = .always;
            username.text = u_name
            username.tag = 101
            username_tf = username;
            
        }else if indexPath.row == 1 {
            let userpwd = UITextField.init(frame: CGRect.init(x:10, y:10, width:tableView.frame.width - 20, height:40))
            userpwd.placeholder = "password"
            userpwd.borderStyle = .none;
            userpwd.returnKeyType = .done
            userpwd.isSecureTextEntry = true
            userpwd.clearButtonMode = .whileEditing
            //userpwd.delegate = self;
            cell.addSubview(userpwd)
            let v1 = UIView.init(frame: CGRect.init(x: 0, y: 5, width: 35, height: 30))
            let pwdleftv = UIImageView.init(image: UIImage.init(imageLiteralResourceName: "user_pwd"))
            pwdleftv.frame = CGRect.init(x: 10, y: (v1.frame.height - 16)/2.0, width: 16, height: 16)
            userpwd.tag = 101
            v1.addSubview(pwdleftv)
            userpwd.leftView = v1;
            userpwd.leftViewMode = .always;
            userpwd.text = u_pwd
            pwd_tf = userpwd;
            
        } else {
            cell.textLabel?.text = titleArr[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font  = UIFont.systemFont(ofSize: 15)
            
            let detail = UILabel (frame: CGRect (x: cell.frame.width - 130, y: 0, width: 100, height: cell.frame.height))
            if indexPath.row == 2 {
               if  let obj = _selectedValue[indexPath.row] as? [String:String] {
                    detail.text = obj["value"]
                }
            } else if indexPath.row == 3 {
                if  let obj = _selectedValue[indexPath.row] as? Date {
                    detail.text = Tools.dateToString(obj, formatter: "yyyy-MM-dd")
                }
            }else {
                let s  =  _selectedValue[indexPath.row] as? String;
                detail.text = s
            }
            
            
            detail.textAlignment = .left
            detail.font  = UIFont.systemFont(ofSize: 15)
            //detail.textColor = UIColor.lightGray
            detail.tag = 101
            cell.addSubview(detail)
        }

        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = indexPath.row > 1 ? .disclosureIndicator : .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 1 else {return }
        u_name = String.isNullOrEmpty(username_tf.text)
        u_pwd = String.isNullOrEmpty(pwd_tf.text)
        
        var vc = BasePickerViewController()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        
        switch indexPath.row {
            case 2,4:
                vc = DataPickerController()
                vc.dataType = indexPath.row == 2 ? PickerDataSourceItemTpye.obj : .str
                if let station = kTaskPool_BASE_DATA[indexPath.row == 2 ? "shifts" : "stations"] as? [Any] {
                    vc.dataArray = station;
                }
                
                break
            case 3:vc = DatePickerController();
            
            break
            default:break
        }
        
        vc.pickerDidSelectedHandler = { [weak self] s in
            guard let strongSelf = self else { return}
            if indexPath.row == 2 {
                let obj = s as! [String:String]
                kTaskpool_shift = obj
            }else if indexPath.row == 3 {
                let obj = s as! Date
                kTaskpool_date = obj

            }else if indexPath.row == 4 {
                let obj = s as! String
                kTaskpool_station = obj
                
            }
            
            
            strongSelf._selectedValue[indexPath.row] = s
            strongSelf.loginTableView.reloadData()
        }

        vc.view.frame = frame
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        self.present(nav, animated: true, completion: nil)
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
