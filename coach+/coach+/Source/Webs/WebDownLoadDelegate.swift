//
//  WebDownLoadDelegate.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 25..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

public protocol WebDownLoadDelegate: WebResponseDelegate
{
    func OnProgressPercent(_ percent: Int)
    func getDestinationURL(_ url: URL)
}
