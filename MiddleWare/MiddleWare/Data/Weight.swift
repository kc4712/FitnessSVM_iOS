//
//  Weight.swift
//  MiddleWare
//
//  Created by 김영일 이사 on 2016. 5. 12..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//
import Foundation

open class Weight
{
    open static let Minimum = 30;
    open static let Maximum = 240;
    open static let Default = 60;
    
    fileprivate static let INLAB_RATE: Float32 = 7.7
    
    open static var Length: Int {
        return Maximum - Minimum + 1;
    }
    
    open static func ToIndex(_ value: Int) -> Int {
        return (value < Minimum ? 0 : value - Minimum);
    }
    
    open static func FromIndex(_ index: Int) -> Int {
        return index + Minimum;
    }
    
    open static func ToString(_ weight: Int) -> String {
        return "\(weight) kg";
    }
    
    static func getCalorieConsumeDaily(_ weight: Float32, goalWeight: Float32, dietPeriod: Int32) -> Float32 {
        if weight < goalWeight || dietPeriod < 1 {
            return 0;
        }
        
        let ans = floor((weight - goalWeight) * 1000 * INLAB_RATE) / Float(dietPeriod*7)
        return ans;
    }
}
