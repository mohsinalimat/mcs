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

//MARK: -  url

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
let flight_haswarn_url = "/alarm/flight/list" //标记航班是否有告警

let get_fib_url = "/biz/task/FIB" //航班信息板（FIB）
let get_task_pool_url = "/biz/task/pool"//...

let get_aircraft_status_url = "/alarm/aircraft/status"//飞机状态-GET请求
let get_warn_list_url = "/alarm/list" //航班告警列表
let get_warn_info_url = "/alarm/detail"///{alarm_id} 告警详情-GET请求

////base
let login_basedata_url = "/biz/mobile/data/active" //基础数据
let active_basedata_url = "/biz/data/active"
let basic_basedata_url = "/biz/data/basic"

/* 获取mcs中航线部门工作库数据
 必须shift:'74f3c2d68ac34fcfb03963a428865055', // 班次id
 必须scheduleTime:'26/02/2018', // 日期
 可选的 station: 'MFM' // 航站
 */
let task_pool_url = "/biz/task/pooldata"

/*获取mcs航线工作库中任务的详情
必须taskId:' 708cd28b-f508-11e7-933d-448a5be48bfb', // 工作库列表中获取的taskId
可选 shiftId: '4835345483935fehiur32321edswqrwq', // 当前登录的班次id
可选 date: ' 26/02/2018', // 日期
 */
let task_pooldetail_url = "/biz/task/detail"

let handle_over_url = "/biz/task/handover"



/// 提交故障信息到mcs 系统中

let submit_fault_url = "/biz/fault"









///vc constant
var kFlightInfoListController_flightDate:String! //航班日期
var kFlightInfoListController_airId:String!//飞机ID
var kFlightInfoListController_fltNo:String!//飞机航班号

var kTaskPool_BASE_DATA:[String:Any]!
var kTaskpool_shift:[String:String]?
var kTaskpool_station:String?
var kTaskpool_date:Date?

var kActive_BASE_DATA:[String:Any]?

var addAction_Section2_SelectedIndex:Int = 0


//MARK:
let msg_loading = "Loading"







