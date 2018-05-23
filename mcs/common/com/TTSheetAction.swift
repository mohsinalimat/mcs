//
//  TTSheetAction.swift
//  mcs
//
//  Created by gener on 2018/5/22.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class TTSheetAction: NSObject ,UITableViewDelegate,UITableViewDataSource{

    static let share = TTSheetAction.init()
    
    let titles = ["Camera","Choose from Album"]
    
    var selectedAtIndex:((Int) -> Void)?
    
    //MARK:
    private var maskView:UIView!
    private var tableView:UITableView!
    private let _rowHeight = 70
    private let _cancelBtnHeight = 70
    private var _tableViewHeight:CGFloat = 0
    
    override init() {
        super.init()
        maskView = UIView (frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.5
        var _h = CGFloat.init(_cancelBtnHeight + (titles.count * _rowHeight))
        if _h > kCurrentScreenHeight - 50 {
            _h = kCurrentScreenHeight - 50;
        }
        
        _tableViewHeight = _h
        tableView = UITableView (frame: CGRect (x: 0, y: kCurrentScreenHeight, width: kCurrentScreenWidth, height: _h), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = CGFloat(_rowHeight)
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellIdentifier")
        
        let footbg = UIView (frame: CGRect (x: 0, y:0, width: kCurrentScreenWidth, height: CGFloat( _cancelBtnHeight)))
        let cancleBtn = UIButton (frame: CGRect (x: 0, y:footbg.frame.height - 60, width: footbg.frame.width, height: 60))
        cancleBtn.setTitle("Cancel", for: .normal)
        cancleBtn.setTitleColor(UIColor.black, for: .normal)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cancleBtn.addTarget(self, action: #selector(cancel(_ :)), for: .touchUpInside)
        footbg.addSubview(cancleBtn)
        cancleBtn.backgroundColor = UIColor.white
        footbg.backgroundColor = kTableviewBackgroundColor
        tableView.tableFooterView = footbg
        
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        maskView.addGestureRecognizer(gesture)
    }
    
    func tapAction(_ gesture:UITapGestureRecognizer) {
        dismiss()
    }
    
    func cancel(_ button:UIButton)  {
        dismiss();
    }
    
    
    //MARK:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellIdentifier", for: indexPath)
        let t = titles[indexPath.row]
        
        cell.textLabel?.text = t
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.selectionStyle = .none
        
        for v in cell.subviews {
            if v.tag == 100 {
                v.removeFromSuperview();break
            }
        }
        
        let _line = UILabel (frame: CGRect (x: 0, y: cell.frame.height - 1, width: cell.frame.width, height: 1))
        _line.backgroundColor = kTableviewBackgroundColor
        _line.tag = 100
        cell.addSubview(_line)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selected = selectedAtIndex{
            selected(indexPath.row);
        }
        
        dismiss();
    }
    
    //MARK:
    func show() {
       let w = UIApplication.shared.keyWindow
        w?.addSubview(maskView)
        w?.addSubview(tableView)
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            guard let ss = self else {return}
            ss.tableView.transform = CGAffineTransform.init(translationX: 0, y: -ss._tableViewHeight)
        }
    }
    
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let ss = self else {return}
            ss.tableView.transform = CGAffineTransform.identity
        }) { [weak self] b in
            guard let ss = self else {return}
            
            if b {
                ss.tableView.removeFromSuperview()
                ss.maskView.removeFromSuperview()
            }
        }
    }
    
    
    
}
