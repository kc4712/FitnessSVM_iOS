//
//  SharedBase.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 6. 30..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

class SharedBase: NSObject {
    var Global_Calendar:MWCalendar?
    
    override init() {
        Global_Calendar = MWCalendar.getInstance()
    }
    
    func dispose() {
        
    }
}