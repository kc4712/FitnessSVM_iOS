//
//  Course.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART  // Protocol pActionData를 가져오기 위함

/// <summary>
/// 유효한 행동인지 확인하는 체커
/// </summary>
open class Course {//: pXClass {
    // 공개 속성 및 메서드
    
    open var Code:Int = 0;
    open var Name:String = ""
    open var Remark:String = ""
    open var InfoOn:Double = 0.0
    open var InfoOff:Double = 0.0
    open var OverallStart:Double = 0.0
    open var OverallDuration:Double = 0.0
    open var TotalCount:Int = 0
    open var ActionList:Array<Action>?
    
    
    open func getStart() -> Double {
        if (ActionList!.count == 0){
            return 0;
        }
        var min:Double = 9999;
        for action:Action in ActionList! {
            if (action.Start < min){
                min = action.Start
            }
        }
        
        return min
    }
    
    open func getEnd() -> Double {
        if (ActionList!.count == 0){
            return 0;
        }
        var max:Double = 0;
        for action:Action in ActionList! {
            if (action.End > max){
                max = action.End
            }
        }
        
        return max;
    }
    
    open func getDuration() -> Double {
        return getEnd() - getStart();
    }
    
    open func getOverallEnd() -> Double {
        return OverallStart + OverallDuration;
    }
    
    open func find(_ sec:Double) -> Action?{
        let ret:Action? = nil
        for item2:Action in ActionList! {
            if (item2.Start <= sec && item2.End >= sec) {
                //print("item2 \(item2.Start)???\(item2.End) sec \(sec)")
                return item2
            }//else{
            //    break
            //}
        }
        
        return ret
    }
    open func RaiseChange(_ propName: String) {
        
    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        //print("COURSE: \(ele.attributes)")
        
        self.Code = Int.init(ele.attributes["Code"]!)!
        self.Name = ele.attributes["Name"]!
        self.Remark = ele.attributes["Remark"]!
        self.InfoOn = Double.init(ele.attributes["InfoOn"]!)!
        self.InfoOff = Double.init(ele.attributes["InfoOff"]!)!
        self.OverallStart = Double.init(ele.attributes["OverallStart"]!)!
        self.OverallDuration = Double.init(ele.attributes["OverallDuration"]!)!
        self.TotalCount = Int.init(ele.attributes["TotalCount"]!)!
        
        print("Code:\(Code) Name:\(Name) Remark:\(Remark) InfoOn:\(InfoOn) InfoOff:\(InfoOff) OverallStart:\(OverallStart) OverallDuration:\(OverallDuration) TotalCount:\(TotalCount)")
        
        //print("Action \(ele["Action"].children.count)")
        self.ActionList = Array<Action>()
        //let ns:NodeList = NodeList.init(str: ele.getElementsByTagName("Action"))
        //print(ele["Course"]["Action"].attributes)
       // for i in 0..<ele.str!.count {
            //ActionList?.append(Action(Element(str: ns.str![i])))
        //    ActionList?.append(Action())
       // }
        
        for i in 0..<ele["Action"].count {
            self.ActionList?.insert(Action(ele: ele.children[i]), at: i)
            //CourseList?.append(Course())
            //print(ele.root.children.count)
            //print("!!!!!!!!!!! \(i)")
        }

    }
}






