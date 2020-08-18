//
//  ConnectStatus.swift
//  MiddleWare
//
//  Created by 양정은 on 2016. 3. 23..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation

public enum ConnectStatus {
    /**
     * 연결 끊김.
     */
    case state_DISCONNECTED
    /**
     * 연결 중.
     */
    case state_CONNECTING
    /**
     * 연결 완료.
     */
    case state_CONNECTED
    /**
     * 완벽한 종료. 내부 변수로만 활용.
     */
    case state_EXIT
}
