//
//  CalcBase.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART  // Protocol pActionData를 가져오기 위함

protocol pCalcBase{
    func GetValue(_ action:pActionData)->Double
}

open class CalcBase//:pXClass
{
    // 공개 속성 및 메서드
    var mpCalcBase: pCalcBase!
    open var Add:Double = 0.0
    open var Mul:Double = 0.0
    open var Div:Double = 0.0
    
    /// <summary>
    /// 행동 및 확장 데이터를 가져온다.
    /// </summary>
    //func callGetValue(action:pActionData){
    //    mpCalcBase.callGetValue(action)
    //}
   
    
    
    /// <summary>
    /// 최종 연산 결과를 반환한다.
    /// </summary>
    
    func GetResult(_ action:pActionData) -> Double
    {
        //프로토콜 적용전 이 부분이 주가 됬었던 오버라이드 구현방식
        //let src:Double = action.GetValue(CalcItem.Index)
        let src:Double = mpCalcBase.GetValue(action)
        //if src != 0 {
        //    mpCalcBase.GetValue(action)
        //}
        //let src:Double = mpCalcBase.GetValue(action)
        //print("CalcBase CalcItem.Index:\(CalcItem.Index) Src:\(src)")
        let ret:Double = (src + Add) * Mul / Div
        //print("CalcBase Index!!!!!! \(Add) \(Mul) \(Div)")
        //print("CalcBase Ret!!!! \(ret)")
        return ret;
    }
    
    open func RaiseChange(_ propName: String) {
        
    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        //super(ele)
        self.Add = Double.init(ele.attributes["Add"]!)!
        self.Mul = Double.init(ele.attributes["Mul"]!)!
        self.Div = Double.init(ele.attributes["Div"]!)!
        
        print("calcbase Add:\(Add) Mul:\(Mul) Div:\(Div)")
    }
}
