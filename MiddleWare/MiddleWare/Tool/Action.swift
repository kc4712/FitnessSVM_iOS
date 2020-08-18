//
//  Action.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 22..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART  // Protocol pActionData를 가져오기 위함

/*extension Action : Hashable{
    var hashValue {
        return Action.hash()
    }
}*/


open class Action :NSObject{//: pXClass {
    // 공개 속성 및 메서드
    var cnt:Int = 0
    open var Start:Double = 0.0
    open var End:Double = 0.0
    open var Remark:String = ""
    
    open var PreFunctions:Array<Function>?// = Array()
    open var ActionChecks:Array<CheckBlock>?// = Array()
    open var m_Accuracy:Accuracy?
    
    open func getDuration()-> Double {
        return End - Start;
    }
    
    open func SubmitFunctions(_ action:pActionData) {
        for mfunc:Function in PreFunctions! {
            mfunc.Submit(action);
        }
    }
    
    open func GetCheckResult(_ action:pActionData)->Bool {
        if m_Accuracy == nil { return false }
        m_Accuracy?.IncrementFrequency()
        if m_Accuracy?.ValidFrequency() == false { return false }
        
        for item:CheckBlock in ActionChecks! {
            //print("**********\(cnt++)")
            if (item.GetResult(action) == false){
                return false;
            }
        }
        return true;
    }
    
    open func RaiseChange(_ propName: String) {
        
    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        //super(ele)
        //print("Action ele:\(ele.attributes) ")
        self.Start = Double.init(ele.attributes["Start"]!)!
        self.End = Double.init(ele.attributes["End"]!)!
        self.Remark = ele.attributes["Remark"]!
        
        print("Start:\(self.Start) End:\(self.End), Remark:\(self.Remark)")
        
        self.PreFunctions = Array<Function>()
        //print("Action ele:\(ele.xmlString) ")
        //print("PreFunctions:\(ele["PreFunctions"].xmlString) PreFunctions:\(ele["PreFunctions"].children.count)")
        //print("ActionChecks:\(ele["ActionChecks"].children[0].attributes) ActionChecks:\(ele["ActionChecks"]["CheckBlock"].count)")
        //print("Accuracy:\(ele["Accuracy"].attributes) Accuracy:\(ele["Accuracy"].attributes.count) ")
        //var nl1:NodeList = NodeList.init(str:ele.getElementsByTagName("PreFunctions"))
        //if (ele["PreFunctions"].attributes.count > 0) {
        if (ele["PreFunctions"].children.count > 0) {
            //var nn1:Node = Node.init(str: nl1.str![0])
            //var ns1:NodeList = NodeList.init(str:nn1.getChildNodes())
            //if (ns1.str!.count > 0) {
                for i in 0..<ele["PreFunctions"].children.count {
                    //var mm1:Node = Node.init(str: ns1.str![i])
                    //if (mm1.getNodeType() == Node.ELEMENT_NODE) {
                        //var ele1:Element = Element.init(str: mm1.str!.popLast()!)
                        //PreFunctions?.append(Function(ele1))
                        self.PreFunctions?.insert(Function(ele: ele["PreFunctions"].children[i]), at: i)
                    //self.PreFunctions?.append(Function(ele: ele.children[i]))
                    //}
                }
           //}
        }
        
        self.ActionChecks = Array<CheckBlock>()
        //var nl2:NodeList = NodeList.init(str:ele.getElementsByTagName("ActionChecks"))
        if (ele["ActionChecks"]["CheckBlock"].attributes.count > 0) {
            //print("+++++++++++++++++++++++++ActionChecks 들어옴!!!")
            //var nn2:Node = Node.init(str:nl2.str![0])
            //var ns2:NodeList = NodeList.init(str: nn2.getChildNodes())
            //if (ns2.str!.count > 0) {
                for i in 0..<ele["ActionChecks"]["CheckBlock"].count {
                    //var mm2:Node = Node.init(str: ns2.str![i])
                    //if (mm2.getNodeType() == Node.ELEMENT_NODE) {
                        //var ele2:Element = Element.init(str:mm2.str!.popLast()!)
                        //ActionChecks?.append(CheckBlock(ele2));
                        self.ActionChecks?.insert(CheckBlock(ele: ele["ActionChecks"].children[i]), at: i)
                    //self.ActionChecks?.append(CheckBlock(ele: ele.children[i]))
                    //}
                }
            //}
        }
        
        //var ns3:NodeList = NodeList.init(str: ele.getElementsByTagName("Accuracy"))
        if (ele["Accuracy"].count > 0) {
            //m_Accuracy = Accuracy(Element(ns3.item(0)))
            //print("ele[Accuracy].attributes.count \(ele["Accuracy"].attributes)")
            //self.m_Accuracy = Accuracy(ele:ele.children[2])//(Element(ns3.str[0]))
            self.m_Accuracy = Accuracy(ele:ele["Accuracy"])//(Element(ns3.str[0]))
        }
    }
}
