//
//  Function.swift
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
open class Function:BlockList {
    // 공개 속성 및 메서드
    
    open var Target:FunctionTarget?
    open var Index:Int = 0
    open var Source:Int = 0
    
    /// <summary>
    /// 처리 결과를 저장할 항목의 유형
    /// Flag : void SetFlag(int index, bool flag) 메서드로 저장
    /// Counter : void IncCounter(int index) 메서드로 저장
    /// </summary>
    
    /// <summary>
    /// 조건에 따라 사용사 함수를 실행하고 결과를 처리한다.
    /// </summary>
    open func Submit(_ action:pActionData) {
        //if (action == nil){
        //    return
        //}
        switch (Target!) {
        case .counter:
            if (GetResult(action)) {
                action.IncCounter(Index);
            }
            return;
        case .flag:
            action.SetFlag(Index, flag: GetResult(action));
            return;
        case .summary:
            if (GetResult(action)) {
                let val:Double = action.GetValue(Source);
                action.Summary(Index, val: val);
            }
            return;
        default:
            return;
        }
    }
    
    /// <summary>
    /// 논리 연산 블럭의 내용으로 XML 요소 생성
    /// </summary>
    
    open override func RaiseChange(_ propName: String) {
        
    }
    
    // 생성자 및 복사
    override init(ele: AEXMLElement) {
        //super(ele)
        super.init(ele: ele)
        print("PreFunction 생성")
        
        self.Target = ConverterFT.ToTarget(ele.attributes["Target"]!);
        self.Index = Int.init(ele.attributes["Index"]!)!
        self.Source = Int.init(ele.attributes["Source"]!)!
        print("PreFunction \(String(describing: Target)), \(Index), \(Source) ")
        self.CheckBlocks = Array<CheckBlock>()
        //let ns:NodeList = NodeList.init(str: ele.getElementsByTagName("CheckBlock"))
        for i in 0..<ele["CheckBlock"].count {
            //CheckBlocks?.append(CheckBlock(Element(ns.str![i])))
            self.CheckBlocks?.insert(CheckBlock(ele: ele.children[i]), at: i)
        }
        
    }
}
