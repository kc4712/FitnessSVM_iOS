//
//  pActionData.swift
//  Swift_AART
//
//  Created by 심규창 on 2016. 6. 22..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

public protocol pActionData
{
    func GetValue(_ index:Int) -> Double
    
    func SetFlag(_ index:Int , flag:Bool)
    func GetFlag(_ index:Int) -> Double
    func ResetFlag()
    
    func Reset()
    func ResetSummary()
    func Summary(_ index:Int, val:Double)
    func GetSummary(_ index:Int) -> Double
    
    func IncCounter(_ index:Int)
    func GetCounter(_ index:Int) -> Double
    func ResetCounter()
    
    func GetExtend(_ index:Int) -> Double
    
    func ResetGlobal()
}
