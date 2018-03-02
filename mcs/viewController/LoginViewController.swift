//
//  LoginViewController.swift
//  mcs
//
//  Created by gener on 2018/1/11.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var loginTableView: UITableView!
    
    let titleArr = ["User","Password","Shift","Schedule Time","Station"]
    
    var isOpenAll:Bool = false
    
    var username_tf:UITextField!
    var pwd_tf:UITextField!
    
    //test
//    let u_name = "test"
//    let u_pwd = "111111"
    
    let u_name = "offline"
    let u_pwd = "111111"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        _initSubview();
        
    }

    func _initSubview() {
        //...
        loginTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
        let _footview = footview()
        //footview.frame =  CGRect (x: 0, y: 0, width: 500, height: 100)
        loginTableView.tableFooterView = _footview
 
    }
    
    
    func footview() -> UIView {
       let _view = UIView (frame: CGRect (x: 0, y: 0, width: 500, height: 100))
        let line = UILabel (frame: CGRect (x: 15, y: 0, width: 500 - 15, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        line.alpha = 0.7
        _view.addSubview(line)
        
       let _s = UISwitch (frame: CGRect (x: 500 - 60, y: 8, width: 60, height: 30))
        _s.addTarget(self, action: #selector(switchStatus(_ :)), for: .valueChanged)
        _s.isOn = false
       
        let info = UILabel (frame: CGRect (x: _s.frame.minX - 65, y: 8, width: 60, height: 30))
        info.font = UIFont.systemFont(ofSize: 14)
        info.textColor = UIColor.lightGray
        info.text = "Shift Info"
        _view.addSubview(info)
        
        _view.addSubview(_s)
        
        for i in 0..<2 {
            let btn = UIButton (frame: CGRect (x: i == 0 ? 10:290, y: 60, width: 200, height: 40));
            btn.backgroundColor = i == 0 ? UIColor.init(colorLiteralRed: 0.318, green: 0.243, blue: 0.533, alpha: 1):UIColor.lightGray;
            btn.setTitle(i == 0 ? "登录":"重置", for: .normal)
            btn.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
            btn.tag = 100 + i;
            _view.addSubview(btn)
        }
        
       return _view
    }
    
    func buttonAction(_ btn:UIButton)  {
        
        if btn.tag == 100 {
            //...
            guard let name = username_tf.text, let pwd = pwd_tf.text else {
                HUD.show(info: "用户名或密码不能为空!")
                return
            }

            HUD.show(withStatus: "登录中...")
            netHelper_request(withUrl: login_url, method: .post, parameters: ["username":name,"password":pwd], successHandler: { (result) in
                
                HUD.show(successInfo: "登录成功!")
                //数据保存
                guard let token = result["body"] else {
                    return;
                }
                
                UserDefaults.standard.set(token, forKey: "user-token")
                UserDefaults.standard.set(name, forKey: "user-name")
                UserDefaults.standard.synchronize()
                
                //页面跳转
//                let vc = HomeViewController()
//                let vc2 = HistoryFaultController()
//                let vc3 = PlaneInfoController()
                
                let tab = BaseTabBarController()
                
//                let nav = BaseNavigationController(rootViewController:tab)
//                nav.navigationBar.barTintColor = UIColor.white
//                nav.navigationBar.tintColor = UIColor.red
                
                UIApplication.shared.keyWindow?.rootViewController = tab
                }
            )
        }else{
            //....清空数据
            
            print("reset")
        }
        
    }
    
    
    func switchStatus(_ s:UISwitch)  {
        isOpenAll = s.isOn

        loginTableView.reloadData()
    }
    
    
    //MARK:-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isOpenAll ? 5 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 2 {
            return 60
        }else{
            return isOpenAll ? 60 : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
        
        for _v  in cell.subviews {
            if _v.isKind(of: UITextField.self){
                _v.removeFromSuperview()
            }
            
        }
        
        if indexPath.row == 0 {
            let username = UITextField.init(frame: CGRect.init(x:10, y:10, width:tableView.frame.width - 20, height:40))
            username.placeholder = "input user name"
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
            username_tf = username;
            
        }else if indexPath.row == 1 {
            let userpwd = UITextField.init(frame: CGRect.init(x:10, y:10, width:tableView.frame.width - 20, height:40))
            userpwd.placeholder = "input user password"
            userpwd.borderStyle = .none;
            userpwd.returnKeyType = .done
            userpwd.isSecureTextEntry = true
            userpwd.clearButtonMode = .whileEditing
            //userpwd.delegate = self;
            cell.addSubview(userpwd)
            let v1 = UIView.init(frame: CGRect.init(x: 0, y: 5, width: 35, height: 30))
            let pwdleftv = UIImageView.init(image: UIImage.init(imageLiteralResourceName: "user_pwd"))
            pwdleftv.frame = CGRect.init(x: 10, y: (v1.frame.height - 16)/2.0, width: 16, height: 16)
            v1.addSubview(pwdleftv)
            userpwd.leftView = v1;
            userpwd.leftViewMode = .always;
            userpwd.text = u_pwd
            pwd_tf = userpwd;
            
        }
        
        if indexPath.row > 1 {
            cell.textLabel?.text = titleArr[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font  = UIFont.systemFont(ofSize: 16)
        }

        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = indexPath.row > 1 ? .disclosureIndicator : .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 1 else {return }
        
        var vc:UIViewController = UIViewController()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        
        switch indexPath.row {
            case 2,4:
                vc = DataPickerController()
                break
            case 3:
                vc = DatePickerController()
                break
            case 4:
                break

            default:break
        }
        

        vc.view.frame = frame
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        self.present(nav, animated: true, completion: nil)
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
