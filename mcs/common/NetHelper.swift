//
//  NetHelper.swift
//  JobCard
//
//  Created by gener on 17/11/3.
//  Copyright © 2017年 Light. All rights reserved.
//

import Foundation
import Alamofire

//MARK:-

/// download file from url
///
/// - parameter path:               file location
/// - parameter to:                 destation to save
/// - parameter downloadProgress:   progress
/// - parameter completionResponse: complete handler
func netHelper_download(fromUrl path:String,
              to:String,
              parameters:Parameters? = nil,
              downloadProgress:((Progress) -> Void)? = nil ,
              completionResponse:((DownloadResponse<Any>) -> Void)? = nil)
{
    let downloadDestation:DownloadRequest.DownloadFileDestination = {_,_ in
        let des = URL (fileURLWithPath: to)
        return (des,[DownloadRequest.DownloadOptions.removePreviousFile, .createIntermediateDirectories])
    }
    
    Alamofire.download(path, parameters: nil, headers: nil, to: downloadDestation).downloadProgress { (progress) in
        if let progressHandler = downloadProgress {
            progressHandler(progress)
        }
        }.responseJSON { (response) in
            if let completeHandler = completionResponse {
                completeHandler(response)
            }
    }
    
}


/// Request
///
/// - parameter withUrl:        url
/// - parameter method:         method
/// - parameter parameters:     pars
/// - parameter successHandler: successHandler
/// - parameter failureHandler: failure
func netHelper_request(withUrl:String,
                       method:HTTPMethod = .get,
                       parameters:[String:Any]? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       successHandler:(([String:Any]) -> Void)? = nil,
                       failureHandler:((String?) -> Void)? = nil)
{
    guard withUrl.lengthOfBytes(using: String.Encoding.utf8) > 0 else { return}
    
    var header:HTTPHeaders = [:]
    if let token = UserDefaults.standard.value(forKey: "user-token") as? String {
        header["Authorization"] = token;
    }
    
    
    Alamofire.request(BASE_URL + withUrl, method: method, parameters: parameters, encoding:encoding, headers: header)
        .validate()
        .responseJSON { (dataResponse) in
        DispatchQueue.main.async {
            if let dic = dataResponse.result.value as? [String:Any] ,let status = dic["state"] {
                if "\(status)" == "200" {
                    if let success = successHandler {
                        success(dic);
                    }

                }else{
                    if let failure = failureHandler {
                        failure(dic["msg"] as? String)
                        
                    } else {
                        HUD.show(info: "\(dic["msg"])");
                    }
                }
              
                
            }
        }
    }
    
}



func request(_ url :String,
    parameters:[String:Any]? = nil,
             successHandler:(([String:Any]) -> Void)? = nil,
             failureHandler:((String?) -> Void)? = nil)
{

    netHelper_request(withUrl: url, method: .post, parameters: parameters, successHandler: successHandler, failureHandler: failureHandler);

}



