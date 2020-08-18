//
//  FunctionTarget.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

public enum FunctionTarget {
    case none, flag, counter, resetCounter, summary
}

class ConverterFT {
    static func ToTarget(_ attr:String) -> FunctionTarget {
        if (attr == "" || attr.isEmpty){
            return FunctionTarget.none
        }
        switch (attr.uppercased()) {
        case "FLAG":
            return FunctionTarget.flag;
        case "COUNTER":
            return FunctionTarget.counter;
        case "RESETCOUNTER":
            return FunctionTarget.resetCounter;
        case "SUMMARY":
            return FunctionTarget.summary;
        default:
            return FunctionTarget.none;
        }
    }
}
