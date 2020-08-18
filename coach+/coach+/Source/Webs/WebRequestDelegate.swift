//
//  WebRequestMaker.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 3. 28..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation

public protocol WebRequestDelegate
{
    @available(iOS 7.0, *)
    func makeRequest(_ queryCode: QueryCode) -> String;
}
