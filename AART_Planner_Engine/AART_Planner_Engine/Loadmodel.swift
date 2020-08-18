//
//  Load_model.swift
//  AART_Planner_Engine
//
//  Created by 심규창 on 2017. 6. 9..
//  Copyright © 2017년 심규창. All rights reserved.
//

import Foundation

@objcMembers
open class Loadmodel : NSObject {
    open static func Loadmodel1() -> NSString {
        var model1_path:NSString
        model1_path = Bundle.main.path(forResource: "model1",ofType: "")! as NSString
        return model1_path;
    }
    open static func Loadmodel2() -> NSString {
        var model2_path:NSString
        model2_path = Bundle.main.path(forResource: "model2",ofType: "")! as NSString
        return model2_path;
    }
    open static func Loadmodel3() -> NSString {
        var model3_path:NSString
        model3_path = Bundle.main.path(forResource: "model3",ofType: "")! as NSString
        return model3_path;
    }
}
