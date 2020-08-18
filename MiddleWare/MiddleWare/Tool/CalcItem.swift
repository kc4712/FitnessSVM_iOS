//
//  CalcItem.swift
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
open class CalcItem: CalcBase, pCalcBase
{
    // 공개 속성 및 메서드
    //public var Add:Double = 0.0
    //public var Mul:Double = 0.0
    //public var Div:Double = 0.0
    open var Index:Int = 0
    open var Source:ValueSource!
    
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

    //protocol 적용전의 추상메소드 적용방식
    /*override func GetResult(action:pActionData) -> Double
    {
     
        let src:Double = self.GetValue(action)
        //if src != 0 {
        //    mpCalcBase.GetValue(action)
        //}
        //let src:Double = mpCalcBase.GetValue(action)
        print("CalcItem CalcItem.Index:\(CalcItem.Index) Src:\(src)")
        let ret:Double = (src + Add) * Mul / Div
        //print("CalcBase Index!!!!!! \(Add) \(Mul) \(Div)")
        //print("CalcBase Ret!!!! \(ret)")
        return ret;
    }*/
    
    func GetValue(_ action:pActionData) -> Double {
        //if (action == nil){
        //  return 0;
        //}
        //print("CalcItem GetValue Index!? \(CalcItem.Index)")
        var ret:Double = 0;
        switch (Source!) {
        case .value:
            ret = action.GetValue(Index)
            break;
        case .flag:
            ret = action.GetFlag(Index)
            break;
        case .counter:
            ret = action.GetCounter(Index)
            break;
        case .summary:
            ret = action.GetSummary(Index)
            break;
        case .extend:
            ret = action.GetExtend(Index);
            break;
        default:
            return 0;
        }
        //print("CalcItem GetValue!? \(ret)")
        return ret;
    }
    
    //public func RaiseChange(propName: String) {
        
    //}
    
    // 생성자 및 복사
    override init(ele: AEXMLElement) {
        super.init(ele: ele)
        super.mpCalcBase = self
        //print("ele.attributes[Source]: \(ele.attributes["Source"]!)")
        Source = Converter.ToSource(ele.attributes["Source"]!)
        Index = Int(ele.attributes["Index"]!)!
        Add = Double(ele.attributes["Add"]!)!
        Mul = Double(ele.attributes["Mul"]!)!
        Div = Double(ele.attributes["Div"]!)!
        
        print("CalcItem Source:\(Source) Index:\(Index) Add:\(Add) Mul:\(Mul) Div:\(Div)")
        
    }
    
}
