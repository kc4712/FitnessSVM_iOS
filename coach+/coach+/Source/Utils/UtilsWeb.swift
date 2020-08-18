//
//  UtilsWeb.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 31..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation
import MiddleWare

open class UtilsWeb {
    open static func LongToDate(_ time: Int64) -> MWCalendar {
        let cal = MWCalendar.getInstance()
        cal.setTimeInMillis(time)
        return cal
    }
    
    open static func convertDate(_ str: String) -> Int64 {
        guard let timeString = str.substringWithCharacter("(", end: ")") else {
            return 0
        }
        
        let timeSegments = timeString.characters.split(separator: "+")
        let timeZoneOffset = Int64(String(timeSegments[1]))! * 36000
        
        return LongToDate(Int64(String(timeSegments[0]))!).getTimeInMillis() + timeZoneOffset
    }
}
