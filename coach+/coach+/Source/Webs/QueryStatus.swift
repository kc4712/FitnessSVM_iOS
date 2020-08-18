//
//  QueryStatus.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 31..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation

public enum QueryStatus: String {
    case Result
    // 성공
    case OK
    case Success
    // 오류
    case ERROR_Message
    case Service_Error
    
    case ERROR_Query
    case ERROR_Web_Read
    case ERROR_Result_Parse
    case ERROR_Exists_Email
    case ERROR_Account_Not_Match
    case ERROR_Non_Information
    
    case ERROR_Exists_Action
    
    case Catch_Error
    case Non_Upgrade
    case Next_Upgrade
    
//    var getName: String {
//        var ret: String = ""
//        switch self {
//        case .ERROR_Message:
//            ret = "ERROR_Message"
//        case .ERROR_Result_Parse:
//            ret = "ERROR_Result_Parse"
//        case .Service_Error:
//            ret = "Service_Error"
//        case .ERROR_Exists_Action:
//            ret = "ERROR_Exists_Action"
//        case .Catch_Error:
//            ret = "Catch_Error"
//        default:
//            ret = "Result"
//        }
//        
//        return ret
//    }
}