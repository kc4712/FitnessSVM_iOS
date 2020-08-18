//
//  StringExtension.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 23..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//


public extension String {
    public var length: Int {
        get {
            return characters.distance(from: startIndex, to: endIndex)
        }
    }
    
    func getLength(_ string: String) -> Int {
        return string.characters.distance(from: string.startIndex, to: string.endIndex)
    }
    
    func substringToIndex(_ index: Int) -> String? {
        if index < 0 || index > self.characters.count {
            return nil
        }
        
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: index))
    }
    
    static func builder(_ string: String...) -> String {
        var ret = ""
        for s in string {
            ret = ret + s
        }
        
        return ret
    }
    
    func substringWithCharacter(_ start: Character, end: Character) -> String? {
        guard let i1 = self.characters.index(of: start) else {
            return nil
        }
        guard let i2 = self.characters.index(of: end) else {
            return nil
        }
        
        return substring(with:(index(i1, offsetBy: 1)..<i2))
    }
}
