//
//  StressIdentifier.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 4..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

enum StressIdentifier: Int16 {
    case veryGood = 1, good, normal, bad
    
    var toString: String {
        var str = ""
        switch self {
        case .veryGood:
            str = Common.ResString("very_good")
        case .good:
            str = Common.ResString("good")
        case .normal:
            str = Common.ResString("normal")
        case .bad:
            str = Common.ResString("bad")
        }
        
        return str
    }
    
    var getColor: UIColor {
        var color: UIColor
        switch self {
        case .veryGood:
            color = Common.makeColor(0xED, 0x6D, 0x2D)
        case .good:
            color = Common.makeColor(0xF2, 0xE3, 0x4D)
        case .normal:
            color = Common.makeColor(0xCB, 0xD0, 0x24)
        case .bad:
            color = Common.makeColor(0xD0, 0x1B, 0x1B)
        }
        
        return color
    }
}
