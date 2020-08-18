//
//  BaseJsonPaser.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 1..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

class BaseJsonParser {
    func getString(_ json: NSDictionary, _ key: String) -> String? {
        if let szAny = json[key] {
            if szAny is NSNull {
                return nil;
            }
            return szAny as? String;
        }
        return nil;
    }
    
    func getInt(_ json: NSDictionary, _ key: String) -> Int {
        if let szAny = json[key] {
            if szAny is NSNull {
                return 0;
            }
            return szAny as! Int;
        }
        return 0;
    }
    
    func getBoolean(_ json: NSDictionary, _ key: String) -> Bool {
        if let szAny = json[key] {
            if szAny is NSNull {
                return false;
            }
            return szAny as! Bool;
        }
        return false;
    }
    
    func getFloat(_ json: NSDictionary, _ key: String) -> Float {
        if let szAny = json[key] {
            if szAny is NSNull {
                return 0;
            }
            return szAny as! Float;
        }
        return 0;
    }
}
