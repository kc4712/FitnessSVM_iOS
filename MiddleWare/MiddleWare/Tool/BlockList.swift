//
//  BlockList.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 23..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART  // Protocol pActionData를 가져오기 위함

open class BlockList {//:pXClass {
    // 공개 속성 및 메서드
    
    open var CheckBlocks:Array<CheckBlock>?
    
    open func GetResult(_ action:pActionData) -> Bool {
        for item:CheckBlock in CheckBlocks! {
            if item.GetResult(action) == false {
                    return false
            }
        }
        return true;
    }
    
    open func RaiseChange(_ propName: String) {
        
    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        //super(ele)
        print("BlockList \(ele.attributes)");
        self.CheckBlocks = Array<CheckBlock>()
        //var ns:NodeList = NodeList.init(str: ele.getElementsByTagName("CheckBlock"))
        for i in 0..<ele["CheckBlock"].count {
            //CheckBlocks?.append(CheckBlock(str:ns.str?[i]))
            self.CheckBlocks?.insert(CheckBlock(ele: ele.children[i]), at: i)
        }
    }
}
