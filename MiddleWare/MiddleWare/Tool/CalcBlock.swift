//
//  CalcBlock.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART  // Protocol pActionData를 가져오기 위함

/// <summary>
/// 계산식 합산 블럭
/// 하위의 계산식의 계산 결과를 모두 합산한다.
/// </summary>
open class CalcBlock: CalcBase, pCalcBase
{
    // 공개 속성 및 메서드
    open var List:Array<CalcItem>?
    open var Multiply:Bool = false;
    open var Abs:Bool = false;
        /// <summary>
    /// 행동 및 확장 데이터를 가져온다.
    /// </summary>
    
    
    //--- protocol 적용 전의 추상메소드 적용방식
    /*override func GetResult(action:pActionData) -> Double
    {
  
        let src:Double = self.GetValue(action)
        
        print("CalcBlock CalcItem.Index:\(CalcItem.Index) Src:\(src)")
        let ret:Double = (src + Add) * Mul / Div
        //print("CalcBase Index!!!!!! \(Add) \(Mul) \(Div)")
        //print("CalcBase Ret!!!! \(ret)")
        return ret;
    }
     */
    func GetValue(_ action:pActionData) -> Double
    {
        
        var ret:Double = Multiply ? 1 : 0;
       
        for calcItem:CalcItem in List! {
            if(Multiply) {
                ret *= calcItem.GetResult(action);
            } else {
                ret += calcItem.GetResult(action);
            }
        }
        
        if(Abs) {
            ret = abs(ret);
        }
        //print("calcBlock++++ \(ret)")
        return ret;
    }
    
    // 생성자 및 복사
    override init(ele: AEXMLElement) {
        super.init(ele: ele)
        super.mpCalcBase = self
        super.Add = Double.init(ele.attributes["Add"]!)!
        super.Mul = Double.init(ele.attributes["Mul"]!)!
        super.Div = Double.init(ele.attributes["Div"]!)!
        self.Multiply = ele.attributes["Multiply"]!.toBool()
        self.Abs = ele.attributes["Abs"]!.toBool()
        
        print("CalcBlock Add:\(Add) Mul:\(Mul) Div:\(Div) Multiply:\(Multiply) Abs:\(Abs)")
        print("ele[CalcItem] \(ele["CalcItem"].count)")
        
        List = Array<CalcItem>()
        for i in 0..<ele["CalcItem"].count {
            //List?.append(CalcItem(Element(ns.item(i))))
            List?.insert(CalcItem(ele: ele.children[i]), at: i)
        }
    }
}
