//
//  Translation.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 24..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

open class Translation {//:pXClass {
    open var Language: String = ""
    open var Display:String = ""
    
    open func RaiseChange(_ propName: String) {
        
    }
    
    // 생성자 및 복사
    init(ele: AEXMLElement) {
        //super(ele);
        self.Language = ele.attributes["Language"]!
        self.Display = ele.attributes["Display"]!;
    }
}
