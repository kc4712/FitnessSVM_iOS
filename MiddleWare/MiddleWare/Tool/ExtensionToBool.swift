//
//  ExtensionBoolToString.swift
//  XML_MW_AART_test
//
//  Created by 심규창 on 2016. 6. 24..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

extension String {
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
}