//
//  Accuracy.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 22..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART  // Protocol pActionData를 가져오기 위함

open class Accuracy{// : pXClass {
    // 공개 속성 및 메서드
    
    open var Multiply:Bool = false
    
    open var CalcBlocks:Array<CalcBlock>?
    
    open var Minimum:Int = 0;
    open var Frequency:Int = 0;
    fileprivate var m_now_freq = 0;
    
    open var Grade5:Int = 0;
    open var Grade4:Int = 0;
    open var Grade3:Int = 0;
    open var Grade2:Int = 0;
    open var Grade1:Int = 0;
    
    open var OutFlag5:Bool = false;
    open var OutFlag4:Bool = false;
    open var OutFlag3:Bool = false;
    open var OutFlag2:Bool = false;
    open var OutFlag1:Bool = false;
    
    open var MsgNum5:Int = 0;
    open var MsgNum4:Int = 0;
    open var MsgNum3:Int = 0;
    open var MsgNum2:Int = 0;
    open var MsgNum1:Int = 0;
    
    open func ResetFrequency() {
        m_now_freq = 0
    }
    
    open func IncrementFrequency() {
        if Frequency > 0 {
            m_now_freq += 1
        }
    }
    
    open func ValidFrequency() -> Bool {
        if Frequency == 0 { return true }
        if m_now_freq >= Frequency { return true }
        return false
    }
    
    open func GetResult(_ action:pActionData) -> Double {
        var ret:Double = (Multiply ? 1 : 0)
        for item:CalcBlock in CalcBlocks! {
            if (Multiply) {
                ret *= item.GetResult(action)
            }
            else {
                ret += item.GetResult(action)
            }
        }
        return ret >= Double(Minimum) ? ret : 0;
    }
    
    fileprivate func GetResultNoMinimum(_ action:pActionData) -> Double {
        var ret:Double = (Multiply ? 1 : 0)
        for item:CalcBlock in CalcBlocks! {
            if (Multiply) {
                ret *= item.GetResult(action)
            }
            else {
                ret += item.GetResult(action)
            }
        }
        return ret;
    }
    
    open func GetGrade(_ action:pActionData) -> Int {
        let acc:Double = GetResultNoMinimum(action);
        //print("Accuracy !!! \(acc)")
        if (Grade5 > 0 && acc >= Double(Grade5)){
            return 5;
        }
        if (Grade4 > 0 && acc >= Double(Grade4)){
            return 4;
        }
        if (Grade3 > 0 && acc >= Double(Grade3)){
            return 3;
        }
        if (Grade2 > 0 && acc >= Double(Grade2)){
            return 2;
        }
        if (Grade1 > 0 && acc >= Double(Grade1)){
            return 1;
        }
        return 0;
    }
    open func RaiseChange(_ propName: String) {

    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        //print("Accuracy 생성 \(ele.xmlString)")
        //super(ele)
        //print(" MulAttr:\(ele.attributes["Multiply"]!)")
        self.Multiply = ele.attributes["Multiply"]!.toBool()
        //print("Multiply:\(Multiply), MulAttr:\(ele.attributes["Multiply"]!)")
        self.Grade5 = Int.init(ele.attributes["Grade5"]!)!;
        self.Grade4 = Int.init(ele.attributes["Grade4"]!)!;
        self.Grade3 = Int.init(ele.attributes["Grade3"]!)!;
        self.Grade2 = Int.init(ele.attributes["Grade2"]!)!;
        self.Grade1 = Int.init(ele.attributes["Grade1"]!)!;
        self.Minimum = Int.init(ele.attributes["Minimum"]!)!;
        self.Frequency = Int.init(ele.attributes["Frequency"]!)!;
        self.OutFlag5 = ele.attributes["OutFlag5"]!.toBool()
        self.OutFlag4 = ele.attributes["OutFlag4"]!.toBool()
        self.OutFlag3 = ele.attributes["OutFlag3"]!.toBool()
        self.OutFlag2 = ele.attributes["OutFlag2"]!.toBool()
        self.OutFlag1 = ele.attributes["OutFlag1"]!.toBool()
        self.MsgNum5 = Int.init(ele.attributes["MsgNum5"]!)!;
        self.MsgNum4 = Int.init(ele.attributes["MsgNum4"]!)!;
        self.MsgNum3 = Int.init(ele.attributes["MsgNum3"]!)!;
        self.MsgNum2 = Int.init(ele.attributes["MsgNum2"]!)!;
        self.MsgNum1 = Int.init(ele.attributes["MsgNum1"]!)!;
        
        
        print("Accuracy Multiply:\(self.Multiply) Grade5:\(self.Grade5) Grade4:\(self.Grade4) Grade3:\(self.Grade3) Grade2:\(self.Grade2) Grade1:\(self.Grade1) Minimum:\(self.Minimum) Frequency:\(self.Frequency) OutFlag5:\(self.OutFlag5) OutFlag4:\(self.OutFlag4) OutFlag3:\(self.OutFlag3) OutFlag2:\(self.OutFlag2) OutFlag1:\(self.OutFlag1) MsgNum5:\(self.MsgNum5) MsgNum4:\(self.MsgNum4) MsgNum3:\(self.MsgNum3) MsgNum2:\(self.MsgNum2) MsgNum1:\(self.MsgNum1)")
        
        self.CalcBlocks = Array<CalcBlock>()
        //let ns:NodeList = NodeList.init(str: ele.getElementsByTagName("CalcBlock"))
        //for i in 0..<ele["CalcBlock"].count {
        for i in 0..<ele["CalcBlock"].count {
            //CalcBlocks?.append(CalcBlock(kiElement(str: ns.str![i])))
            self.CalcBlocks?.insert(CalcBlock(ele:ele.children[i]), at: i)
        }
    }
}
