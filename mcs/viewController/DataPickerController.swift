//
//  DataPickerController.swift
//  mcs
//
//  Created by gener on 2018/1/12.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class DataPickerController: BasePickerViewController ,UIPickerViewDelegate,UIPickerViewDataSource{

    @IBOutlet weak var pickView: UIPickerView!
    
    private var _row : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    //MARK:

    override func finishedBtnAction()  {
        if  (dataArray != nil){
            if let handler = pickerDidSelectedHandler {
                handler(dataArray![_row]);
            }

        }

        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - UIPickerViewDelegate , UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let arr = dataArray else {return 0}
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let str = dataArray?[row] as? String{
            return str;
        }else if let obj = dataArray?[row] as? [String:Any]{
            if let flt = obj["fltNo"] as? String {
                return flt;
            }
            
            return "\(obj["value"]!)";
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        _row = row
        
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
