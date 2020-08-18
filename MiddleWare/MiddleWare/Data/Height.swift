//
//  Height.swift
//  MiddleWare
//
//  Created by 김영일 이사 on 2016. 5. 12..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

open class Height
{
    open static let Minimum = 60;
    open static let Maximum = 280;
    open static let Default = 170;
    
    open static var Length: Int {
        return Maximum - Minimum + 1;
    }
    
    open static func ToIndex(_ value: Int) -> Int {
        return (value < Minimum ? 0 : value - Minimum);
    }
    
    open static func FromIndex(_ index: Int) -> Int {
        return index + Minimum;
    }
    
    open static func ToString(_ height: Int) -> String {
        return "\(height) cm";
    }
}
