//
//  Message.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation


open class Message {//: pXClass {
    // 공개 속성 및 메서드
    
//    public var Code: MessageIndex = .MOVE
    open var Code: Int = 0
    open var List:Array<Translation>?
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
//        Code = MessageIndex(rawValue: Int(ele.attributes["Code"]!)!)!
        Code = Int(ele.attributes["Code"]!)!

        List = Array<Translation>()
        //var ns:NodeList = NodeList(str:ele.getElementsByTagName("Translation"))
        for i in 0..<ele["Translation"].count {
            //List?.append(Translation(Element(ns.str![i])))
            List?.insert(Translation(ele: ele.children[i]), at: i)
        }
    }
}
