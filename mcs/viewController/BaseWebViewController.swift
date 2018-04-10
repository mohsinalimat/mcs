//
//  BaseWebViewController.swift
//  mcs
//
//  Created by gener on 2018/1/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class BaseWebViewController: BaseViewController,UIWebViewDelegate,UIGestureRecognizerDelegate {

    var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _addNavigationItems()
        
        webview = UIWebView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64))
        webview.delegate = self
        //webview.scrollView.bounces = false
        webview.backgroundColor = UIColor.white //kTableviewBackgroundColor;
        view.addSubview(webview)
        
        ////add UILongPressGestureRecognizer
        let longpress = UILongPressGestureRecognizer.init(target: self, action: nil)
        longpress.minimumPressDuration = 0.1
        longpress.delegate = self
        webview.addGestureRecognizer(longpress)
        
    }

    private func _addNavigationItems() {
        let msgBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 40))
        msgBtn.addTarget(self, action: #selector(_refreshAction), for: .touchUpInside)
        msgBtn.setImage(UIImage (named: "refreshicon_dynamic_titlebar"), for: .normal);
        msgBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 18, 13, 18)
        
        let fixed = UIBarButtonItem (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 15
        let msgItem  = UIBarButtonItem (customView: msgBtn)
        navigationItem.rightBarButtonItems = [fixed,msgItem]
    }
    
    
    func _refreshAction() {
        
        loadData()
        
    }
    
    func loadData(){}
    func requestWithUrl(_ url:String,parameters:[String:Any]? = nil) {
        HUD.show(withStatus: msg_loading)
        
        netHelper_request(withUrl: url, method: .post, parameters: parameters, successHandler: {[weak self] result in
            guard let body = result["body"] as? String else {HUD.show(info: "请求服务器失败");return;}
            guard let strongSelf = self else{HUD.show(info: "请求服务器失败");return}

            strongSelf.webview.loadHTMLString(body, baseURL: nil)
        }) { error in
            HUD.show(info: error ?? "请求服务器失败")
        }
    }
    

    //MARK:
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    //MARK:
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
        HUD.show(info: error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
