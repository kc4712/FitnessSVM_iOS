//
//  ArrayQueueUtil.swift
//  Swift_Middleware
//
//  Created by 심규창 on 2016. 6. 6..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

//--- 크기에 제약이 없는 FIFO 큐
//--- 복잡도: push O(1), pop O('count')
public struct ArrayQueueUtil<T>:ExpressibleByArrayLiteral {
    // 내부 배열 저장소
    public fileprivate(set) var elements:Array<T> = []
    
    // 새로운 엘리먼트 추가. 소요시간 = O(1)
    public mutating func push(_ value: T){
        elements.append(value)
    }
    
    // 가장 앞에 있는 엘리먼트를 꺼내오기. 소요시간 = O('count')
    public mutating func pop() -> T {
        return elements.removeFirst()
    }
    
    // 큐가 비었는지 검사
    public var isEmpty: Bool{
        return elements.isEmpty
    }
    
    
    // 큐의 크기, 연산 프로퍼티
    public var count: Int {
        return elements.count
    }
    
    // ArrayLiteralConvertible 프로토콜 지원
    public init(arrayLiteral elements:T...){
        self.elements = elements
    }
    
}

//참고 http://outofbedlam.github.io/swift/2016/03/11/Queue-in-Swift/
