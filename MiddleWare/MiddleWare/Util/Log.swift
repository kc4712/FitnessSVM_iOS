//
//  Log.swift
//  Swift_Middleware
//
//  Created by 심규창 on 2016. 6. 9..
//  Copyright © 2016년 심규창. All rights reserved.
//


import Foundation

private let format = DateFormatter()

private func setFormat() {
    format.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    format.timeZone = TimeZone.current;
}

open class Log {
    open static func d(_ tag: String, msg: String) {
        setFormat()
        print("[\(format.string(from: Date()))][\(tag)]->\(msg)");
    }
    
    open static func v(_ tag: String, msg: String) {
        setFormat()
        print("[\(format.string(from: Date()))][\(tag)]->\(msg)");
    }
    
    open static func w(_ tag: String, msg: String) {
        setFormat()
        print("[\(format.string(from: Date()))][\(tag)]->\(msg)");
    }
    
    open static func i(_ tag: String, msg: String) {
        setFormat()
        print("[\(format.string(from: Date()))][\(tag)]->\(msg)");
    }
    
    open static func e(_ tag: String, msg: String) {
        setFormat()
        print("[\(format.string(from: Date()))][\(tag)]->\(msg)");
    }
}
