//
//  DataControlBase.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 6. 30..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

class DataControlBase: DeviceBaseTrans {
    fileprivate static let ref_millisec_utc: Int64 = 946684800000; // 2000-01-01 00:00:00.000 (msec) UTC
    // 1970년 기준 시간을 ->UTC 2000.1.1 00:00:00.000
    static func getConvertedTime(_ time: Int64) -> Int32 {
        //        if DataControlBase.DEBUG {
        //            Log.d(DataControlBase.tag, msg: "getConvertedTime : input time->\(time)");
        //            Log.d(DataControlBase.tag, msg: "getConvertedTime : output time->\((time - ref_millisec_utc)/(1000*60))");
        //        }
        return Int32((time - ref_millisec_utc)/(1000*60));
    }
    
    static func getReturnedTime(_ time: Int32) -> Int64 {
        //        if DataControlBase.DEBUG {
        //            Log.d(DataControlBase.tag, msg: "getReturnedTime : input time->\(time)");
        //            Log.d(DataControlBase.tag, msg: "getReturnedTime : output time->\(Int64(time)*1000*60+ref_millisec_utc)");
        //        }
        return Int64(time)*1000*60+ref_millisec_utc;
    }
}
