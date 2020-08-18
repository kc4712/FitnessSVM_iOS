//
//  Action.swift
//  CoachPlus
//
//  Created by 심규창 on 2017. 10. 23..
//  Copyright © 2017년 Company Green Comm. All rights reserved.
//

import Foundation


//
//  Action.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 16..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

open class Action
{
    
    static let INDEX_NON_SELECT_EXERCISE = -1;
    static let INDEX_SLEEP = 0;
    static let INDEX_STAND = 1;
    static let INDEX_BICYCLING = 2;
    static let INDEX_JUMP_ROPE = 3;
    static let INDEX_WALK = 4;
    static let INDEX_RUN = 5;
    static let INDEX_CLIMBING = 6;
    static let INDEX_WALK_STAIR = 7;
    static let INDEX_WALK_SLOPE = 8;
    static let INDEX_WALK_FAST = 9;
    static let INDEX_GOLF = 10;
    static let INDEX_DISUSE = 11;
    static let INDEX_SWING_ACT = 12;
    static let INDEX_DAILY_ACT = 13;
    static let INDEX_LIGHT_ACT = 14;
    static let INDEX_MODERATE_ACT = 15;
    static let INDEX_INTENSE_ACT = 16;
    static let INDEX_BADMINTON = 17;
    
    static let INDEX_SWIMMING = 19;
    static let INDEX_TABLE_TENNIS = 20;
    static let INDEX_TENNIS = 21;
    static let INDEX_UNKNOWN = 22;
    static let INDEX_JUMPING_ACT = 23;
    static let INDEX_SWING_JUMPING_ACT = 24;
    static let INDEX_WALK_AND_SLOPE = 25;
    static let INDEX_SPORT = 26;
    
    static let INDEX_MANUAL_BASEBALL = 50;
    static let INDEX_MANUAL_FOOTBALL = 51;
    static let INDEX_MANUAL_BASKETBALL = 52;
    static let INDEX_MANUAL_SOFTBALL = 53;
    static let INDEX_MANUAL_BOWLING = 54;
    static let INDEX_MANUAL_POCKETBALL = 55;
    static let INDEX_MANUAL_SKI = 56;
    static let INDEX_MANUAL_WEIGHT_TRAINNING = 57;
    static let INDEX_MANUAL_CROSS_TRAINNING = 58;
    static let INDEX_MANUAL_INNER_BICYCLING = 59;
    static let INDEX_MANUAL_ELLIPTICAL = 60;
    static let INDEX_MANUAL_YOGA = 61;
    static let INDEX_MANUAL_DANCE = 62;
    
    static let INDEX_MANUAL = 100;
    
    
    open static func getActionName(_ actionCode: Int) -> String {
        switch (actionCode) {
        case -1:
            return Common.ResString("activity_non_select");                 // 선택 없음
        case 0:
            return Common.ResString("activity_sleep");                      // 수면
        case 1:
            return Common.ResString("activity_stand");                      // 안정
        case 2:
            return Common.ResString("activity_bicycling");                  // 자전거
        case 3:
            return Common.ResString("activity_jump_rope");                  // 줄넘기
        case 4:
            return Common.ResString("activity_walk");                       // 걷기 운동
        case 5:
            return Common.ResString("activity_run");                        // 달리기
        case 6:
            return Common.ResString("activity_climbing");                   // 등산
        case 7:
            return Common.ResString("activity_walk_stair");                 // 계단 걷기
        case 8:
            return Common.ResString("activity_walk_slope");                 // 경사 걷기
        case 9:
            return Common.ResString("activity_walk_fast");                  // 빨리 걷기
        case 10:
            return Common.ResString("activity_golf");                       // 골프
        case 11:
            return Common.ResString("activity_disuse");                     // 미착용
        case 12:
            return Common.ResString("activity_swing_act");                  // 스윙운동
        case 13:
            return Common.ResString("activity_daily_act");                  // 일상활동
        case 14:
            return Common.ResString("activity_light_act");                  // 가벼운활동
        case 15:
            return Common.ResString("activity_moderate_act");               // 중간활동
        case 16:
            return Common.ResString("activity_intense_act");                // 강한활동
        case 17:
            return Common.ResString("activity_badminton");                  // 배드민턴
            
        case 19:
            return Common.ResString("activity_swimming");                   // 수영
        case 20:
            return Common.ResString("activity_table_tennis");               // 탁구
        case 21:
            return Common.ResString("activity_tennis");                     // 테니스
        case 22:
            return Common.ResString("activity_unknown");                    // 미확인
        case 23:
            return Common.ResString("activity_jumping_act");                // 점핑운동
        case 24:
            return Common.ResString("activity_swing_jumping_act");          // 스윙/점핑 운동
        case 25:
            return Common.ResString("activity_walk_and_slope");             // 걷기(경사)
        case 26:
            return Common.ResString("activity_sport");                      // 스포츠
            
            //--------------------------------------------------------------------------------------
            // 수동 운동 계열
        //--------------------------------------------------------------------------------------
        case 100:
            return Common.ResString("activity_manual");                     // 수동 운동의 대표 코드
        case 50:
            return Common.ResString("activity_manual_baseball");            // 수동 / 야구
        case 51:
            return Common.ResString("activity_manual_football");            // 수동 / 축구
        case 52:
            return Common.ResString("activity_manual_basketball");          // 수동 / 농구
        case 53:
            return Common.ResString("activity_manual_softball");            // 수동 / 소프트볼
        case 54:
            return Common.ResString("activity_manual_bowling");             // 수동 / 볼링
        case 55:
            return Common.ResString("activity_manual_pocketball");          // 수동 / 당구
        case 56:
            return Common.ResString("activity_manual_ski");                 // 수동 / 스키
        case 57:
            return Common.ResString("activity_manual_weight_trainning");    // 수동 / 근육 운동
        case 58:
            return Common.ResString("activity_manual_cross_trainning");     // 수동 / 크로스 트레이닝
        case 59:
            return Common.ResString("activity_manual_inner_bicycling");     // 수동 / 실내 자전거
        case 60:
            return Common.ResString("activity_manual_elliptical");          // 수동 / 일립티컬
        case 61:
            return Common.ResString("activity_manual_yoga");                // 수동 / 요가
        case 62:
            return Common.ResString("activity_manual_dance");               // 수동 / 댄스
            
        default:
            return Common.ResString("activity_error");
        }
    }
    
    open static let UNIT_SPEED = 1;
    open static let UNIT_STRENGTH = 2;
    open static let UNIT_STAIR = 3;
    open static let UNIT_SWING = 4;
    open static let UNIT_TIME = 5;
    open static let UNIT_HEARTRATE = 6;
    open static let UNIT_STATIC = 9;
    
    open static func getCoachUnit(_ unit: Int) -> String {
        switch (unit) {
        case UNIT_SPEED:
            return Common.ResString("unit_speed");
        case UNIT_SWING:
            return Common.ResString("unit_swing");
        case UNIT_STAIR:
            return Common.ResString("unit_stair");
        case UNIT_TIME:
            return Common.ResString("unit_time");
        default:
            return "";
        }
    }
    
    open static func getUnitToString(_ unit: Int, act: Int, speed: Float) -> String {
        switch (unit) {
        case UNIT_SPEED:
            return "\(Int(speed))" + Common.ResString("unit_speed");
        case UNIT_SWING:
            return "\(Int(speed))" + Common.ResString("unit_swing");
        case UNIT_STAIR:
            return "\(Int(speed))" + Common.ResString("unit_stair");
        case UNIT_TIME:
            return "\(Int(speed))" + Common.ResString("unit_time");
        case UNIT_STRENGTH:
            switch (act) {
            case INDEX_JUMP_ROPE:
                return Common.ResString("unit_jumping_rope");
            case INDEX_BICYCLING:
                return Common.ResString("unit_normal_speed");
            case INDEX_CLIMBING:
                return Common.ResString("unit_normal_climbing");
            case INDEX_GOLF:
                return Common.ResString("unit_normal_golf");
            case INDEX_TENNIS, INDEX_TABLE_TENNIS:
                return Common.ResString("unit_tennis");
            default:
                return "";
            }
        default:
            return "";
        }
    }
    
}
