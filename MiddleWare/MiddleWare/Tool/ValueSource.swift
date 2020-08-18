//
//  ValueSource.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 24..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

public enum ValueSource {
    case none, value, flag, counter, summary, extend
}


class Converter {
    static func ToSource(_ attr:String) -> ValueSource {
        if (attr == "" || attr.isEmpty){
            return ValueSource.none;
        }
        // if (string.IsNullOrEmpty(str)) return ValueSource.None;
        switch (attr.uppercased()) {
        case "VALUE":
            return ValueSource.value;
        case "FLAG":
            return ValueSource.flag;
        case "COUNTER":
            return ValueSource.counter;
        case "SUMMARY":
            return ValueSource.summary;
        case "EXTEND":
            return ValueSource.extend;
        default:
            return ValueSource.none;
        }
    }
    
    static func ConvertBool(_ attr:String)->Bool {
        var ret:Bool = false
        if (attr != "" || attr.isEmpty ) {
            ret = attr.toBool();
        }
        return ret;
    }
}
