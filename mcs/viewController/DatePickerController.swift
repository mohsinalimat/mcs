//
//  DatePickerController.swift
//  mcs
//
//  Created by gener on 2018/1/12.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DatePickerController: BasePickerViewController {

    @IBOutlet weak var datePicker: UIDatePicker!

    private var _row : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _init()
    }

    init(_ formatter:String? = "yyyy") {
        super.init(nibName: nil, bundle: nil)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func _init() {
        
        let now = dateToString(Date())
        let year = Int.init(now)
        
        let min = stringToDate("\(year! - 2)")
        let max = stringToDate("\(year! + 2)")
        
        datePicker.minimumDate = min
        datePicker.maximumDate = max
        
    }
    
    func stringToDate(_ dateStr:String, formatter:String = "yyyy") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.date(from: dateStr)!
    }
    
    func dateToString(_ date:Date, formatter:String = "yyyy") -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.string(from: date)
    }
    

    //MARK:

    override func finishedBtnAction()  {

        if let handler = pickerDidSelectedHandler {
            //let str = dateToString(datePicker.date,formatter: "yyyy-MM-dd")
            handler(datePicker.date);
        }
        
        self.dismiss(animated: true, completion: nil)
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
