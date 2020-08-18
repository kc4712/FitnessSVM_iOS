//
//  DoubleExtension.swift
//  testHR_Measure
//
//  Created by 심규창 on 2016. 7. 20..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

extension Double {
    func rountToDecimal(_ fractionDigits:Int) ->Double {
        let multiplier = pow(10.0, Double(fractionDigits))
        return (self * multiplier).rounded() / multiplier
    }
}
