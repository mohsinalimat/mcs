//
//  Section_TableViewCell3.swift
//  mcs
//
//  Created by gener on 2018/4/8.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit
import Alamofire

class Section_TableViewCell3: UITableViewCell {

    @IBOutlet weak var pre_image: UIImageView!

    
    func fill(_ obj:Any) {

        if obj is [String:Any] {
            //pre_image.image = UIImage (named: "icon_fib");
            guard let d = obj as? [String:Any] ,let _id = d["id"] as? String else {return}
            _requestImage(_id)
        }else {
            let ig = obj as! UIImage
            pre_image.image = ig;
        }
        
        
    }
    
    

    func _requestImage(_ id:String) {
        let url = BASE_URL + download_url + "?id=\(id)"
        let path = NSTemporaryDirectory().appending("cache/") + id
        let exist = FileManager.default.fileExists(atPath: kTemporaryDirectory)
        
        if exist {
            if FileManager.default.fileExists(atPath: path) {
                do {
                    let data = try Data.init(contentsOf:  URL.init(fileURLWithPath: path))
                    let ig = UIImage.init(data: data)
                    pre_image.image = ig;return;
                }catch{
                    print("get error");
                }
            }
        }else {
            do{
                try FileManager.default.createDirectory(atPath: kTemporaryDirectory, withIntermediateDirectories: true, attributes: nil);
            }catch {
                print("createDirectory Error");
            }
        }
        

        var header:HTTPHeaders = [:]
        if let token = UserDefaults.standard.value(forKey: "user-token") as? String {
            header["Authorization"] = token;
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseData(queue: DispatchQueue.main) { [weak  self](data) in
            guard let ss = self else {return}
            guard let da = data.result.value  else{return}
            let ig = UIImage.init(data: da)
            ss.pre_image.image = ig
           
            do{
               try da.write(to: URL.init(string: path)!);
            }catch{
                print("error");
            }

        }
        
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
