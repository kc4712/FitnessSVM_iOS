//
//  ITimeZone.swift
//  planner-swift
//
//  Created by 이효문 on 2016. 3. 9..
//  Copyright © 2016년 이효문. All rights reserved.
//

import Foundation

protocol pTimeZone {
    func getTimeZoneOffset() -> Int16;
    func setTimeZoneOffset(_ offset : Int16);
    func setTimeZoneOffset(Init offset : Int16);
}
