//
//  CheckBlock.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART  // Protocol pActionData를 가져오기 위함

/// <summary>
/// 논리 연산 블럭
/// 하위의 논리 검사 항목을 AND 또는 OR 조건으로 결합한다.
/// </summary>
open class CheckBlock {//: NSObject, pXClass {
    // 공개 속성 및 메서드
    
    open var List:Array<CheckItem>?
    open var Combine:LogicalCombine!
    
    
    open func GetResult(_ act:pActionData)->Bool {
        for item:CheckItem in List! {
            if (Combine == LogicalCombine.and && item.Check(act) == false){
                return false;
            }
            if (Combine == LogicalCombine.or && item.Check(act) == true){
                return true;
            }
        }
        //print("(Combine == LogicalCombine.AND ? true : false) \((Combine == LogicalCombine.AND ? true : false))")
        return (Combine == LogicalCombine.and ? true : false)
    }
    
    open func RaiseChange(_ propName: String) {
        
    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        //super(ele)
        print("CheckBlock 생성")
        
        self.List = Array<CheckItem>()
        self.Combine = ConverterLC.ToBlockType(ele.attributes["Combine"]!);
        print("CheckBlock Combine \(Combine)")
        print("eleCheckBlock \(ele["CheckItem"].count)")
        //print("eleCheckBlock \(ele.children[1].xmlString)")
        //let ns:NodeList = NodeList.init(str:ele.getElementsByTagName("CheckItem"))
        for i in 0..<ele["CheckItem"].count {
            //let node1:Node = Node.init(str:ns.str![i])
            //if (node1.getNodeType() == Node.ELEMENT_NODE) {
                //List?.append(CheckItem(Element(node1)))
                self.List?.insert(CheckItem(ele:ele.children[i]), at: i)
            //}
        }
    }
}
