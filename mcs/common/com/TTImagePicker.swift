//
//  TTImagePicker.swift
//  mcs
//
//  Created by gener on 2018/5/31.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import AVFoundation

typealias TTImagePickerHandler = ((UIImage) -> Void)?

class TTImagePicker: NSObject , UIImagePickerControllerDelegate,UINavigationControllerDelegate ,TTSheetActionDelegate {

    static let single  = TTImagePicker()
    var imagePickerDidFinishedHandler:TTImagePickerHandler
    var destController:UIViewController?
    var _sourceView:UIView?
    
    override init() {
        
    }
    
    
    func show(inView inVC : UIViewController? = nil , sourceView:UIView? = nil , completion:TTImagePickerHandler)  {
        imagePickerDidFinishedHandler = completion
        destController = inVC
        _sourceView = sourceView
        
        let v = TTSheetAction.share
        v.delegate = self
        v.show();
    }
    
    
    func imgPicker(_ index:Int)  {
        if index == 0 {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {HUD.show(info: "NO Camera Available");return}
            guard AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized else {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (b) in
                    DispatchQueue.main.async {
                        if b {
                            print("Allow");
                        }else {
                            HUD.show(info: "Allow access to the camera in Settings");
                            print("Not Allow");
                        }
                    }
                })
                
                return
            }
        }
        
        
        let picker = UIImagePickerController.init();
        picker.delegate  = self
        picker.allowsEditing = true
        
        switch index {
        case 0:picker.sourceType = .camera;break
        case 1:picker.sourceType = .photoLibrary;
            let rect = CGRect (x: 0, y: 0, width: 500, height: 400)
            picker.modalPresentationStyle = .popover
            picker.popoverPresentationController?.sourceView = _sourceView
            picker.popoverPresentationController?.sourceRect = CGRect (x: 240, y: 0, width: 10, height: 30)
            picker.preferredContentSize = rect.size
            picker.view.frame = rect
        
            if destController == nil {
                picker.popoverPresentationController?.sourceRect = CGRect (x: 0, y: 0, width: 10, height: 30);
            }
            break
        default:break
        }

        if let des = destController {
            des.navigationController?.present(picker, animated: true, completion: nil);
        }else {
            UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true, completion: nil);
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            if let handler = imagePickerDidFinishedHandler {
                handler(img);
            }
        }
        
        picker.dismiss(animated: true, completion: nil)

    }

    //MARK: - TTSheetActionDelegate
    func ttSheetActionDidSelectedIndex(_ index: Int) {
        DispatchQueue.main.async {[weak self] in
            guard let ss = self else {return}
            ss.imgPicker(index);
        }
        
    }
    
    
}
