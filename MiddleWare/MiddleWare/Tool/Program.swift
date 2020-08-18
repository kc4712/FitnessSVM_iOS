//
//  Program.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

/// <summary>
/// 유효한 행동인지 확인하는 체커
/// </summary>
open class Program {
    // 공개 속성 및 메서드
    
    open var Code:Int = 0
    open var Name:String = ""
    open var File:String = ""
    open var CourseList:Array<Course>?
    open var MessageList:Array<Message>?
    
    fileprivate var j:Int = 0
    
    
    
    open func RaiseChange(_ propName: String) {
        
    }
    
    init() {
        
    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        print("!!!!!!!!!!!")
        //super(ele);
        self.Code = Int.init(ele.attributes["Code"]!)!
        self.Name = ele.attributes["Name"]!
        self.File = "";
        //print(ele["Course"].attributes)
        print("Name:\(Name), Code:\(Code)")
        // prints cats, dogs
        //for child in ele.root.children {
        
        //}["Name": "매트 운동", "Code": "3"]
        //print(ele.xmlString)
        
        self.CourseList = Array<Course>()
        //let ns:NodeList = NodeList(str:ele.getElementsByTagName("Course"))
        //print(ele["Course"].attributes)
        //print(ele["Course"].count)
        for i in 0..<ele["Course"].count {
            //self.CourseList?.append(Course(ele: ele.children[i]))
            self.CourseList?.insert(Course(ele: ele.children[i]), at: i)
            //print("children: \(ele.children[i].xmlString)")
            //CourseList?.append(Course())
            //print(ele.root.children.count)
            //print("!!!!!!!!!!! \(i)")
        }
        
        self.MessageList = Array<Message>()
        //let ns2:NodeList = NodeList(str:ele.getElementsByTagName("Message"))
    
        for i in ele["Course"].count..<(ele["Message"].count+ele["Course"].count) {
            self.MessageList?.insert(Message(ele: ele.children[i]), at: j)
            j = j + 1
        }
    }
    
    open func find(_ sec:Double) -> Course? {
        let ret:Course? = nil
        for item:Course in CourseList! {
            if(item.getStart() <= sec && item.getEnd() >= sec) {
                return item;
            }
        }
        return ret
    }
    
    func getUiDisplay(_ sec: Int) -> (showUi: Bool, name: String) {
        for c in CourseList! {
            if Int(c.getStart() + c.InfoOn) <= sec && Int(c.getEnd() + c.InfoOff) >= sec {
                return (true, Int(c.getStart() + 5) >= sec ? c.Name : "")
            }
        }
        
        return (false, "")
    }
    
    func getToTalScoreDisplay(_ sec: Int) -> (showScore: Bool, duration: Double) {
        for c in CourseList! {
            if Int(c.getEnd() + c.OverallStart) == sec {
                return (true, c.OverallDuration)
            }
        }
        
        return (false, 0)
    }
}
