//
//  CheckItem.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART  // Protocol pActionData를 가져오기 위함

/// <summary>
/// 값 검사 항목
/// 지정된 인덱스를 사용하여 지정된 메서드의 값을 읽어서 지정된 값과 지정된 방법으로 비교하여 결과를 반환한다.
/// </summary>
open class CheckItem {//: pXClass {
    // 공개 속성 및 메서드
    
    open var Source:ValueSource!
    open var Index:Int = 0
    open var Operator:CompareOperator!
    open var Value:Double = 0.0
    
    /// <summary>
    /// 연산에 사용될 항목의 유형
    /// Value : double GetValue(int index) 메서드의 반환값
    /// Flag : double GetFlag(int index) 메서드의 반환값
    /// Counter : double GetCounter(int index) 메서드의 반환값
    /// Extend : double GetExtend(int index) 메서드의 반환값
    /// </summary>
    
    /// <summary>
    /// 행동 및 확장 데이터를 가져온다.
    /// </summary>
    fileprivate func GetValue(_ action:pActionData) -> Double {
        //if (action == nil){
        //    return 0;
        //}
        
        switch (Source!) {
        case .value:
            //print("CheckItem \(action.GetValue(Index))")
            return action.GetValue(Index)
        case .flag:
            //print("CheckItem \(action.GetFlag(Index))")
            return action.GetFlag(Index);
        case .counter:
            //print("CheckItem \(action.GetCounter(Index))")
            return action.GetCounter(Index);
        case .extend:
            //print("CheckItem \(action.GetExtend(Index))")
            return action.GetExtend(Index);
        default:
            return 0;
        }
    }
    
    /// <summary>
    /// 최종 확인 결과를 반환한다.
    /// </summary>
    open func Check(_ action:pActionData)->Bool {
        let src:Double = self.GetValue(action)
        //print("CheckItem Check src\(src)");
        switch (Operator!) {
        case .equal:
            return (src == Value);
        case .notEqual:
            return (src != Value);
        case .lessThan:
            return (src < Value);
        case .lessThanOrEqualTo:
            return (src <= Value);
        case .greaterThan:
            return (src > Value);
        case .greaterThanOrEqualTo:
            return (src >= Value);
        default:
            return false;
        }
    }
    
    // 생성자
    
    /// <summary>
    /// XML 요소의 값을 채널 클래스로 변환
    /// </summary>
    /// <param name="ele"></param>
    /// <returns></returns>
    open func RaiseChange(_ propName: String) {
        
    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        //super(ele);
        
        self.Source = Converter.ToSource(ele.attributes["Source"]!);
        self.Index = Int.init(ele.attributes["Index"]!)!
        self.Operator = ConverterCO.ToOperator(ele.attributes["Operator"]!);
        self.Value = Double.init(ele.attributes["Value"]!)!
        print("CheckItem \(Source), \(Index), \(Operator), \(Value) ")
    }
}




