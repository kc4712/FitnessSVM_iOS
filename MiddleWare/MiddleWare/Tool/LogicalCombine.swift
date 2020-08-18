//
//  LogicalCombine.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation


public enum LogicalCombine {
    case and, or
}

class ConverterLC {
    static func ToBlockType(_ str:String) -> LogicalCombine {
        if (str == "" || str.isEmpty){
            return LogicalCombine.and;
        }
        switch (str.uppercased()) {
        case "OR":
            return LogicalCombine.or;
        default:
            return LogicalCombine.and;
        }
    }
}
