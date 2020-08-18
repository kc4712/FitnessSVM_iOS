//
//  ActivityIdentifier.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 11..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

enum ActivityIdentifier: Int16 {
    case low = 1, mid, high, danger
    
    var toString: String {
        var str = ""
        switch self {
        case .low:
            str = Common.ResString("low")
        case .mid:
            str = Common.ResString("mid")
        case .high:
            str = Common.ResString("high")
        case .danger:
            str = Common.ResString("danger")
        }
        
        return str
    }
}
