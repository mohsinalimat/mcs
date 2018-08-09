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
let user_token = UserDefaults.standard.value(forKey: "user-token")

///MARK: -  url
let BASE_URL = "http://smart.imsp.cn/mcs/rest"
//let BASE_URL = "http://192.168.6.65:8080/mcs/rest"//linf
//let BASE_URL = "http://192.168.6.57:8081/mcs/rest"//ds

let login_url = "/login"
let task_number_url = "/biz/task/count"  //任务数
let flight_info_url = "/biz/task/flightStatus" //飞机状态信息
let get_flights_url = "/biz/task/flightStatusByAcId" //获取某个飞机某个日期的所有航班
let get_flightInfo_url = "/biz/task/flightStatusByNo" //根据日期和航班号查询航班信息
let plane_info_url = "/biz/viewAcReg"
let defect_history_url = "/biz/defect/history"
let history_detail_url = "/biz/defect/history/viewDetail"
let noti_msg_url = "/biz/findAnnouncementsByBeginDate"

/*
 必须aircraftNo : B-MBM   // 飞机号
 必须beginDate : 2018/3/17	// 开始时间
 必须endDate : 2018/3/19	// 结束时间
 */
let flight_haswarn_url = "/alarm/flight/list" //标记航班是否有告警
let get_fib_url = "/biz/task/FIB" //航班信息板（FIB）
let get_task_pool_url = "/biz/task/pool"
let get_aircraft_status_url = "/alarm/aircraft/status"//飞机状态-GET请求
let get_warn_list_url = "/alarm/list" //航班告警列表
let get_warn_info_url = "/alarm/detail"///{alarm_id} 告警详情-GET请求
let get_cert_url = "/biz/getCert"//飞机证书

////base
let login_basedata_url = "/biz/mobile/data/active" //登录时基础数据
let active_basedata_url = "/biz/data/active" //1
let basic_basedata_url = "/biz/data/basic" //2

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
let task_pooldetail_url         =       "/biz/task/detail"
let handle_over_url             =       "/biz/task/handover"
let taskPool_deleteMis_url      =       "/biz/task/deleteMis"
let taskPool_submit_url         =       "/biz/task/submit"
let taskPool_changeShift_url    =       "/biz/task/changeShift"
let taskPool_addAction_url      =       "/biz/taskAction/"
let action_list_url             =       "/biz/getFeedbackData"
let action_delete_url           =       "/biz/taskAction/"
let action_detail_viewDefect_url =      "/biz/viewDefect"//type ,id
let taskPool_getFltNo_url = "/biz/getAftFlNo"
let taskPool_perform_url = "/biz/perform" //修改Reason，fltno , taskTo
let defect_detail_preview_url = "/biz/printViewFault"//id

////defect
let defect_list_url     =   "/biz/fault/list"
let defect_submit_url   =   "/biz/defect/submit"
let defect_save_fault_url = "/biz/fault"
let defect_delete_url   = "/biz/defect/delete"
let defect_flightNo_url = "/biz/defect/getFlightStatusList"
let defect_faultDetail_url = "/biz/viewBizFault"
let download_url = "/biz/download"
let dd_cal_deadline_url = "/biz/calAcDl"
let get_ipc_url = "/biz/getIpcManUrl"



///dd
let dd_list_url = "/biz/dd/list"
let pn_list_url = "/biz/pnInStock/getList"
let order_list_url = "/biz/getOrders"
let submit_order_url = "/biz/preOrder"
let pn_history_url = "/biz/pnInStockChange/getList"//库存记录变动 "/biz/pnMovementHistory/getList"
let pn_interchange_url = "/biz/pnInStock/interchange/getList"

///vc constant
var kFlightInfoListController_flightDate:String! //航班日期
var kFlightInfoListController_airId:String!//飞机ID
var kFlightInfoListController_fltNo:String!//飞机航班号
var _kTaskPool_BASE_DATA:[String:Any]?
var kTaskPool_BASE_DATA:[String:Any]! {
    get {
        if _kTaskPool_BASE_DATA != nil {
            return _kTaskPool_BASE_DATA;
        } else {
            netHelper_request(withUrl: login_basedata_url, method: .post, parameters: nil, successHandler: {(result) in
                guard let body = result["body"] as? [String : Any] else {return;}
                _kTaskPool_BASE_DATA = body
                }
            )
            return [:]
        }
    }

    set {
        _kTaskPool_BASE_DATA = newValue;
    }
}


var kTaskpool_shift:[String:String]?
var kTaskpool_station:String?
var kTaskpool_date:Date?
var kActive_BASE_DATA:[String:Any]! //基础数据1
enum SectionHeadButtonIndex :Int {
    case addActoinValue1 = 1;
    case addActoinValue2 //2Material
    case addActoinValue3//component
    case addActoinValue4 //附件
    case creatReportValue1//base info
    case creatReportValue2//material tools
    case creatReportValue3//attachment
    case creatReportValue4//dd/nrr
    case creatReportValue5//action
    case ddComponent
    case spare1
}

var kSectionHeadButtonSelectedIndex:SectionHeadButtonIndex = .addActoinValue1
var task_pool_taskno_index:Int = 0
var taskPoolSelectedTask:[String:Any]!//当前操作的Task
var addActionMateralDataArr = [[String:Any]]()//添加action - Materal
var addActionComponentDataArr = [[String:String]]()//添加action - Component
var ddComponentArr = [[String:Any]]()

//Defect
let defect_transferred_key = [" ","TLB","CLB","NIL"]
let defect_transferred_form = [" ":"null","TLB":"0","CLB":"1","NIL":"2"]
let defect_release_ref = ["","MEL","AMM","CDL","SRM","RPAS","NIL"]
let g_staffs = (kActive_BASE_DATA["staffs"] as? [String]) ?? []
let kDefectType = ["Defect Report":"TS" ,"DD":"DD" , "NRR":"NRR"]
var plist_dic : [String:Any] =  {
    let path = Bundle.main.url(forResource: "defectConstants", withExtension: "plist")
    let d = NSDictionary.init(contentsOf: path!)
    return d as! [String : Any];
}()

var plist_dic_lazy:[String:Any] {
    let path = Bundle.main.url(forResource: "defectConstants", withExtension: "plist")
    let d = NSDictionary.init(contentsOf: path!)
    return d as! [String : Any];
}

//TMP
var report_reg:String?//reg
var report_station:String?
var report_date:Date? //issue date
var report_flight_no:String?
var report_flight_date:Date?
var report_release_ref:String?
var report_refresh_cat:Bool = false
var materalDataFromIPC = false
var defect_added_actions = [[String:Any]]()
let defect_all_status : [String:String] = {
    if let arr = plist_dic["total_status"] as? [String:String] {return arr}
    return [:];
}()

var kAttachmentDataArr = [Any]()
let kTemporaryDirectory = NSTemporaryDirectory().appending("cache/")

var pn_selected_number = [String:Int]()

let LM_LEADER = "lm_leader"
let LM_OFFNE = "offline"

var Msg:[[String:Any]]?
var new_msg_cnt:Int = 0
var app_timer_cnt:Int = 0
let APP_TIMER_INTERVAL = 2
let APP_TIMER_LOOP_INTERVAL = 600

var now_is_msgController = false
var userIsLogin:Bool = false


//MARK:
let hud_msg_loading = "Loading"



