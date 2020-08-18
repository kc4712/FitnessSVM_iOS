//
//  DataProtocol.swift
//  planner-swift
//
//  Created by 양정은 on 2016. 3. 16..
//  Copyright © 2016년 이효문. All rights reserved.
//

import Foundation

/*
delegation을 위한 프로토콜
*/
protocol DataProtocol {
//    func updateConsume(contact: Contact.ActInfo!) -> Int32
//    func updateConsume(contact: Contact.ActInfo!, flag: Int32) -> Int32
//    func addConsume(contact: Contact.ActInfo!) -> Int32
//    func getConsumeCalorieContact(date: Int64) -> Contact.ActInfo?
//    func getConsumeCalorieContact(actInfo: [Contact.ActInfo]) -> [Contact.ActInfo]
//    func getConsumeCalorieContactOne() -> Contact.ActInfo?
//    func getConsumeCalorieContact() -> [Contact.ActInfo]?
    func deleteConsume(_ date: Int64) -> Int32
    func deleteConsume() -> Int32
}
