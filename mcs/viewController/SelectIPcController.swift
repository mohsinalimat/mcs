//
//  SelectIPcController.swift
//  mcs
//
//  Created by gener on 2018/7/4.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit


class SelectIPcController: BaseWebViewController {

    var _bridge:WebViewJavascriptBridge!
    var _cloeseBtn:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _cloeseBtn = UIButton (frame: CGRect (x: kCurrentScreenWidth - 100, y: 50, width: 60, height: 50))
        _cloeseBtn.setImage(UIImage (named: "close_discover"), for: .normal)
        _cloeseBtn.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        
        webview.frame = UIScreen.main.bounds;
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.delegate = self
        
        _bridge = WebViewJavascriptBridge.init(for: webview, webViewDelegate: self, handler: {[unowned self] (obj,callback) in
            print("1")
            

            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.init("ipc_selected_ok_notification"), object: nil, userInfo: ["data":obj])
            }
            
            self.dismiss(animated: true, completion: nil)
        })
        
        //WebViewJavascriptBridge.enableLogging()
        
        loadData()
        
    }

    deinit {
        print("..")
    }
    
    
    override func requestWithUrl(_ url: String, parameters: [String : Any]?) {
        HUD.show(withStatus: hud_msg_loading)
        let req = URLRequest.init(url: URL(string: url)!)
        webview.loadRequest(req)
        
    }
    
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // 禁用用户选择
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        
        // 禁用长按弹出框
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none';")
        webView.stringByEvaluatingJavaScript(from: "$('div.col-sm-2:last button:first').remove()")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: NSEC_PER_SEC * 10)) {
            HUD.dismiss()
        }
    
    
        webView.addSubview(_cloeseBtn)
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
