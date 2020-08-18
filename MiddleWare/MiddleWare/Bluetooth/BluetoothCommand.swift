//
//  BluetoothCommand.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 6. 29..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

public enum BluetoothCommand: UInt16 {
    case stepCount_Calorie = 0x06
    case activity = 0x0b
    case sleep = 0x0c
    case stress = 0x13
    case state = 0x14
    case battery = 0x04
    case rtc = 0x02
    case acc = 0x10
    case userData = 0x03
    case vibrate = 0x07
    case dataClear = 0x11
    case version = 0x0d
    case coachCalorie = 0x12
    case productID = 0x15
    case noticeONOFF = 0x16
    case noticeMessage = 0x17 // 추가는 하지만 ios는 ANCS를 사용하므로, 쓰지 않음.
    case coachReceiveAcc = 0x50
    
    //규창 피쳐 전달기능
    case featureSet1 = 0xa1
    case featureSet2 = 0xa2
    case featureSet3 = 0xa3
    
    //규창 이전 피쳐 덩어리들을 raw데이터 전송 흉내144
    case pastFeatureRequest = 0xb1
    case pastFeatureSet1 = 0xba
    case pastFeatureSet2 = 0xbb
    case pastFeatureSet3 = 0xbc
    
    //규창 과거피쳐데이터 전송완료
    case pastFeatureSetComplete = 0xbf
    case featureError = 0xaf
}
