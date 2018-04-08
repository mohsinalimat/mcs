//
//  Action_Materal_Cell.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Action_Materal_Cell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    var section_index = 0
    
    @IBOutlet weak var _tableView: UITableView!
    @IBAction func addAction(_ sender: UIButton) {
        
        Tools.showAlert(addAction_Section2_SelectedIndex == 2 ? "Add_MateralVC" : "Add_ComponentVC" ,withBar: true,frame:CGRect (x: 0, y: 0, width: 500, height: 500))
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        _tableView.layer.borderWidth = 1
        _tableView.layer.borderColor = kTableviewBackgroundColor.cgColor
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "Section_TableViewCell", bundle: nil), forCellReuseIdentifier: "Section_TableViewCellIdentifier")
        _tableView.register(UINib (nibName: "Section_TableViewCell2", bundle: nil), forCellReuseIdentifier: "Section_TableViewCell2Identifier")
        _tableView.register(UINib (nibName: "Section_TableViewCell3", bundle: nil), forCellReuseIdentifier: "Section_TableViewCell3Identifier")
        
        _tableView.tableFooterView = UIView()
        _tableView.rowHeight = 60
    }

    
    override func prepareForReuse() {
        _tableView.scrollsToTop = true;
    }
    
    //MARK:-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//
        var name = "Section_TableViewCellIdentifier"
        if addAction_Section2_SelectedIndex == 3 {
            name = "Section_TableViewCell2Identifier";
        } else if addAction_Section2_SelectedIndex == 4 {
            name = "Section_TableViewCell3Identifier";
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var name = "Section_Matera_header"
        if addAction_Section2_SelectedIndex == 3 {
            name = "Section_Comp_header";
        } else if addAction_Section2_SelectedIndex == 4 {
            name = "Section_Attach_header";
        }
        
        
        let v = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as! UIView
        v.frame = CGRect (x: 0, y: 0, width: tableView.frame.width, height: 40)
        
        return v;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
}
