//
//  constant.swift
//  mcs
//
//  Created by gener on 2018/1/12.
//  Copyright © 2018年 Light. All rights reserved.
//

import Foundation
import UIKit

let kCurrentScreenWidth = UIScreen.main.bounds.width
let kCurrentScreenHeight = UIScreen.main.bounds.height

var APP_IS_BACKGROUND:Bool = false //app是否处于后台

let user_token = UserDefaults.standard.value(forKey: "user-token")

//MARK: - url


#if false
    
//let BASE_URL = "http://192.168.6.59:8080/mcs/rest"
  let BASE_URL = "http://192.168.6.57:8081/mcs/rest"
#else
    
let BASE_URL = "http://smart.imsp.cn/mcs/rest"
    
#endif


let login_url = "/login"

let task_number_url = "/biz/task/count"  //任务数

let flight_info_url = "/biz/task/flightStatus" //飞机状态信息

let get_flights_url = "/biz/task/flightStatusByAcId" //获取某个飞机某个日期的所有航班

let get_flightInfo_url = "/biz/task/flightStatusByNo" //根据日期和航班号查询航班信息

let get_fib_url = "/biz/task/FIB" //航班信息板（FIB）
let get_task_pool_url = "/biz/task/pool"//...

let get_aircraft_status_url = "/alarm/aircraft/status"//飞机状态-GET请求
let get_warn_list_url = "/alarm/list" //航班告警列表
let get_warn_info_url = "/alarm/detail"///{alarm_id} 告警详情-GET请求




///vc constant
var kFlightInfoListController_flightDate:String! //航班日期
var kFlightInfoListController_airId:String!//飞机ID








