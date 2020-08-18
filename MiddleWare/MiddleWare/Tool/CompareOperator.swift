//
//  CompareOperator.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation


public enum CompareOperator {
    case none, equal, notEqual, lessThan, lessThanOrEqualTo, greaterThan, greaterThanOrEqualTo
}

class ConverterCO {
    /// <summary>
    /// 비교 연산자를 문자열로 변환하는 메서드
    /// Enum 형식에는 별도의 메서드 작성이 불가능하기에
    /// 확장 메서드 형식으로 메서드를 추가한다.
    /// </summary>
    
    /// <summary>
    /// 문자열로 표현된 비교 연산자를 Enum 형식의 비교 연산자로 변환하는 메서드
    /// Enum 형식에는 별도의 메서드 작성이 불가능하기에
    /// 확장 메서드 형식으로 메서드를 추가한다.
    /// </summary>
    static func ToConvert(_ coStr:String)-> CompareOperator {
        switch (coStr.uppercased()) {
        case "EQ":
            return CompareOperator.equal;
        case "NE":
            return CompareOperator.notEqual;
        case "LT":
            return CompareOperator.lessThan;
        case "LE":
            return CompareOperator.lessThanOrEqualTo;
        case "GT":
            return CompareOperator.greaterThan;
        case "GE":
            return CompareOperator.greaterThanOrEqualTo;
        default:
            return CompareOperator.none;
        }
    }
    
    /// <summary>
    /// 문자열로 표현된 비교 연산자를 Enum 형식의 비교 연산자로 변환하는 메서드
    /// Enum 형식에는 별도의 메서드 작성이 불가능하기에
    /// 확장 메서드 형식으로 메서드를 추가한다.
    /// </summary>
    static func ToOperator(_ attr:String)-> CompareOperator {
        if (attr == "" || attr.isEmpty){
            return CompareOperator.none;
        }
        switch (attr.uppercased()) {
        case "EQ":
            return CompareOperator.equal;
        case "NE":
            return CompareOperator.notEqual;
        case "LT":
            return CompareOperator.lessThan;
        case "LE":
            return CompareOperator.lessThanOrEqualTo;
        case "GT":
            return CompareOperator.greaterThan;
        case "GE":
            return CompareOperator.greaterThanOrEqualTo;
        default:
            return CompareOperator.none;
        }
    }
}
