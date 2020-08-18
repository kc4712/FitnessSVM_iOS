//
//  WebResponseDelegate.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 3. 28..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation

public protocol WebResponseDelegate
{
    @available(iOS 7.0, *)
    func parse(_ json: NSDictionary, queryCode: QueryCode) -> QueryStatus;
    
    func OnQuerySuccess(_ queryCode: QueryCode);
    func OnQueryFail(_ queryStatus: QueryStatus);
}
