//
//  BehaviorManager.swift
//  MiddleWare
//
//  Created by 심규창 on 2017. 10. 19..
//  Copyright © 2017년 심규창. All rights reserved.
//

import Foundation


import AART_Planner_Engine


private let mBehaviorManager = BehaviorManager();

class BehaviorManager {
    
    static let tag:String = "BehaviorManager"
    static let KEY_TIME:String = "KEY_TIME"
    static let KEY_NORM_VAR:String = "KEY_NORM_VAR"
    static let KEY_X_VAR:String = "KEY_X_VAR"
    static let KEY_Y_VAR:String = "KEY_Y_VAR"
    static let KEY_Z_VAR:String = "KEY_Z_VAR"
    static let KEY_X_MEAN:String = "KEY_X_MEAN"
    static let KEY_Y_MEAN:String = "KEY_Y_MEAN"
    static let KEY_Z_MEAN:String = "KEY_Z_MEAN"
    static let KEY_NORM_MEAN:String = "KEY_NORM_MEAN"
    static let KEY_NSTEP:String = "KEY_NSTEP"
    static let KEY_JUMP_ROPE_SWING:String = "KEY_JUMP_ROPE_SWING"
    static let KEY_SMALL_SWING:String = "KEY_SMALL_SWING"
    static let KEY_LARGE_SWING:String = "KEY_LARGE_SWING"
    static let KEY_PRESS_VAR:String = "KEY_PRESS_VAR"
    static let KEY_ACCMULATED_STEP:String = "KEY_ACCMULATED_STEP"
    static let KEY_DISPLAY_STEP:String = "KEY_DISPLAY_STEP"
    static let KEY_PRESS:String = "KEY_PRESS"
    static let KEY_PULSE:String = "KEY_PULSE"
    
    static let POSITION_VAR_X:Int = 0
    static let POSITION_VAR_Y:Int = 1
    static let POSITION_VAR_Z:Int = 2
    static let POSITION_VAR_NORM:Int = 3
    
    static let POSITION_MEAN_X:Int = 4
    static let POSITION_MEAN_Y:Int = 5
    static let POSITION_MEAN_Z:Int = 6
    static let POSITION_MEAN_NORM:Int = 7
    
    static let POSITION_STEP:Int = 8
    static let POSITION_JUMP:Int = 9
    static let POSITION_SMALL:Int = 10
    static let POSITION_LARGE:Int = 11
    
    static let POSITION_VAR_PRESS:Int = 12
    static let POSITION_AMP_RTSL:Int = 13
    static let POSITION_FREQ_RTSL:Int = 14
    
    static let POSITION_PRESS:Int = 15
    static let POSITION_DISP_STEP:Int = 16
    static let POSITION_HEART_RATE:Int = 17
    
    //규창 171019 임시 피쳐 저장소
    //var FeatureDicSet:[Dictionary<String, Any>] = []
    /*var FeatureDic:[String:Any] =
        ["KEY_TIME"             : 0    ,
         "KEY_NORM_VAR"         : 0.0  ,
         "KEY_X_VAR"            : 0.0  ,
         "KEY_Y_VAR"            : 0.0  ,
         "KEY_Z_VAR"            : 0.0  ,
         "KEY_X_MEAN"           : 0.0  ,
         "KEY_Y_MEAN"           : 0.0  ,
         "KEY_Z_MEAN"           : 0.0  ,
         "KEY_NORM_MEAN"        : 0.0  ,
         "KEY_NSTEP"            : 0    ,
         "KEY_JUMP_ROPE_SWING"  : 0    ,
         "KEY_SMALL_SWING"      : 0    ,
         "KEY_LARGE_SWING"      : 0    ,
         "KEY_PRESS_VAR"        : 0.0  ,
         "KEY_ACCMULATED_STEP"  : 0    ,
         "KEY_DISPLAY_STEP"     : 0    ,
         "KEY_PRESS"            : 0.0  ,
         "KEY_PULSE"            : 0    ]*/
    
    
    
    var BLEManager:BluetoothLEManager?//=null;
    
    // 공식에 사용되는 변수
    let INLAB_RATE:Float = 7.7
    let THR_CALORIE:Float = 300
    
    //fileprivate ArrayList<KistWrapper> kistList_save;
    var kistList:Array<KistWrapper>?
    var kistList_past:Array<KistWrapper>?
    
    //디버그용 카운트...
    //fileprivate int loopCount=0;
    var mCal = MWCalendar.getInstance()
    
    var Global_Calendar = MWCalendar.getInstance()
    
    //var Global_Contact = Contact()
    var KistracAct:AART_Planner_Engine?
    
    //fileprivate int[] main_HrArray = new int[10];
    var min_hr:Int = 0
    
    var enableRecommendedFlag:Bool = false
    
    //fileprivate float remainCalorie=0;
    
    static var DEBUG:Bool = true
    
    /**
     * 성공.
     */
    let SUCCESS:Int = 0
    /**
     * 실패.
     */
    let FAILED:Int = 1
    /**
     * 허용되지 않는 시간입니다.
     */
    let INCORRECT_TIME_RANGE:Int = 2
    /**
     * 최소 20분의 시간이 필요합니다.
     */
    let NOT_ENOUGH_TIME:Int = 3
    
    /*
     fileprivate class PivotArray {
     //int name;
     int time;
     int countLow;
     int countMid;
     int countHigh;
     boolean isChecked;
     int index;
     int unit;
     int step;
     int swing;
     int bpm;
     }
     fileprivate ArrayList<PivotArray> arPivot;
     */
    /**
     * 직업군 별 MET:사무직 MET
     */
    let OFFICE_JOB_MET:Float = 2.1
    /**
     * 직업군 별 MET:현장 근로자 MET
     */
    let SITE_WORKER_MET:Float = 2.7
    /**
     * 직업군 별 MET:학생 MET
     */
    let STUDENT_MET:Float = 2.2
    /**
     * 직업군 별 MET:주부 MET
     */
    let HOUSEWIFE_MET:Float = 1.9
    /**
     * 수면 status
     */
    let SLEEP:Int = 1
    let ROLLED:Int = 2
    let AWAKEN:Int = 3
    let ACTIVE:Int = 4
    
    /*fileprivate int SLEEP_Q_1 = 1;
     fileprivate int SLEEP_Q_2 = 2;
     fileprivate int SLEEP_Q_3 = 3;
     fileprivate int SLEEP_Q_4 = 4;*/
    let SLEEP_Q_5:Int = 5
    
    /**
     * 수면 발생 상태.
     */
    let SLP_STATUS_NONE:Int = 0
    let SLP_STATUS_START:Int = 1
    let SLP_STATUS_END:Int = 2
    /**
     * 등산 발생 상태.
     */
    //fileprivate int CLM_STATUS_NONE = 0;
    let CLM_STATUS_START:Int = 1
    let CLM_STATUS_END:Int = 2
    /**
     * 골프 발생 상태.
     */
    //fileprivate int GOLF_STATUS_NONE = 0;
    let GOLF_STATUS_START:Int = 1
    let GOLF_STATUS_END:Int = 2
    
    
    
    
    /**
     * 임시운동 종류 DB
     */
    open class ActivityDB {
        //Motion index
        // Activity_Index=1 :: Standing or almost same action
        // Activity_Index=11 :: Walking at flat
        // Activity_Index=13 :: Walking at Stairs
        // Activity_Index=15 :: Walking at Slope
        // Activity_Index=17 :: Walking at Mountain
        // Activity_Index=21 :: Running
        // Activity_Index=23 :: Jumping rope
        // Activity_Index=25 :: Bicycling
        // Activity_Index=31 :: Golfing
        // Activity_Index=33 :: Tennis
        // Activity_Index=35 :: Table tennis
        // 계단 걷기
        // 배드민턴
        // 볼링
        // 수영
        
        static let UNIT_SPEED:Int = 1
        static let UNIT_STRENGTH:Int = 2
        static let UNIT_STAIR:Int = 3
        static let UNIT_SWING:Int = 4
        static let UNIT_TIME:Int = 5
        static let UNIT_HEARTRATE:Int = 6
        static let UNIT_STATIC:Int = 9
        
        static let STRENGTH_LOW:Int = 1
        static let STRENGTH_MIDDLE:Int = 2
        static let STRENGTH_HIGH:Int = 3
        
        // 걷기는 현재 모두 같은 MET로 적용한다. 왜냐면 경사도 구분이 도지 않기 때문.
        // 탁구는 평균 MET 사용.
        // 비활동 임의 MET 사용.
        static let INDEX_NON_SELECT_EXERCISE:Int = -1
        //1
        static let INDEX_RUN:Int = 5
        static let RUN:String = "달리기"
        static let MET_RUN_LOW:Float = 6.0
        static let SPEED_RUN_LOW:Float = 6.1
        static let MET_RUN_MID:Float = 8.3
        static let SPEED_RUN_MID:Float = 7
        static let MET_RUN_HIGH:Float = 9.0
        static let SPEED_RUN_HIGH:Float = 8.0
        static let UNIT_RUN:Int = UNIT_SPEED
        //2
        static let INDEX_WALK:Int = 4
        static let WALK:String = "걷기";
        static let MET_WALK_LOW:Float = 3.0
        static let SPEED_WALK_LOW:Float = 3
        static let MET_WALK_MID:Float = 3.5
        static let SPEED_WALK_MID:Float = 4.0
        static let MET_WALK_HIGH:Float = 4.0
        static let SPEED_WALK_HIGH:Float = 5
        static let UNIT_WALK:Int = UNIT_SPEED;
        
        static let INDEX_BADMINTON:Int = 17
        static let BADMINTON:String = "배드민턴"
        static let MET_BADMINTON_LOW:Float = 3.0
        static let SPEED_BADMINTON_LOW:Float = 3.6
        static let MET_BADMINTON_MID:Float = 3.8
        static let SPEED_BADMINTON_MID:Float = 4.5
        static let MET_BADMINTON_HIGH:Float = 4.8
        static let SPEED_BADMINTON_HIGH:Float = 5.4
        static let UNIT_BADMINTON:Int = UNIT_STRENGTH
        
        static let INDEX_DAILY_ACT:Int = 13
        static let DAILY_ACT:String = "일상활동"
        static let MET_DAILY_ACT_LOW:Float = 2
        static let SPEED_DAILY_ACT_LOW:Float = 3.6
        static let MET_DAILY_ACT_MID:Float = 3.8
        static let SPEED_DAILY_ACT_MID:Float = 4.5
        static let MET_DAILY_ACT_HIGH:Float = 4.8
        static let SPEED_DAILY_ACT_HIGH:Float = 5.4
        static let UNIT_DAILY_ACT:Int = UNIT_STRENGTH
        
        static let INDEX_LIGHT_ACT:Int = 14
        static let LIGHT_ACT:String = "가벼운활동"
        static let MET_LIGHT_ACT_LOW:Float = 2.6
        static let SPEED_LIGHT_ACT_LOW:Float = 3.6
        static let MET_LIGHT_ACT_MID:Float = 3.8
        static let SPEED_LIGHT_ACT_MID:Float = 4.5
        static let MET_LIGHT_ACT_HIGH:Float = 4.8
        static let SPEED_LIGHT_ACT_HIGH:Float = 5.4
        static let UNIT_LIGHT_ACT:Int = UNIT_STRENGTH
        
        static let INDEX_MODERATE_ACT:Int = 15
        static let MODERATE_ACT:String = "중간활동"
        static let MET_MODERATE_ACT_LOW:Float = 3.0
        static let SPEED_MODERATE_ACT_LOW:Float = 3.6
        static let MET_MODERATE_ACT_MID:Float = 3.8
        static let SPEED_MODERATE_ACT_MID:Float = 4.5
        static let MET_MODERATE_ACT_HIGH:Float = 4.8
        static let SPEED_MODERATE_ACT_HIGH:Float = 5.4
        static let UNIT_MODERATE_ACT:Int = UNIT_STRENGTH
        
        static let INDEX_INTENSE_ACT:Int = 16
        static let INTENSE_ACT:String = "강한활동"
        static let MET_INTENSE_ACT_HIGH:Float = 3.8
        static let UNIT_INTENSE_ACT:Int = UNIT_STRENGTH
        
        static let INDEX_TENNIS:Int = 21 // kist는 6번일듯..
        static let TENNIS:String = "테니스"
        static let MET_TENNIS:Float = 7.3
        static let UNIT_TENNIS:Int = UNIT_STRENGTH;
        
        static let INDEX_TABLE_TENNIS:Int = 20 // kist는 6번일듯..
        static let TABLE_TENNIS:String = "탁구"
        static let MET_TABLE_TENNIS:Float = 4.0
        static let UNIT_TABLE_TENNIS:Int = UNIT_STRENGTH
        //3
        static let INDEX_JUMP_ROPE:Int = 3
        static let JUMP_ROPE:String = "줄넘기"
        static let MET_JUMP_ROPE_LOW:Float = 8.8
        static let MET_JUMP_ROPE_MID:Float = 11.8
        static let MET_JUMP_ROPE_HIGH:Float = 12.3
        static let UNIT_JUMP_ROPE:Int = UNIT_SWING
        //4
        static let INDEX_DISUSE:Int = 11
        static let DISUSE:String = "미착용" // 미착용으로 변경하자.
        static let UNIT_DISUSE:Int = UNIT_STRENGTH
        
        static let INDEX_UNKNOWN:Int = 22
        static let UNKNOWN:String = "미확인"
        static let UNIT_UNKNOWN:Int = UNIT_STRENGTH
        
        static let INDEX_JUMPING_ACT:Int = 23
        static let JUMPING_ACT:String = "점핑 운동" // 현재는 줄넘기로..
        static let MET_JUMPING_ACT_LOW:Float = 8
        static let MET_JUMPING_ACT_MID:Float = 9
        static let MET_JUMPING_ACT_HIGH:Float = 10
        static let UNIT_JUMPING_ACT:Int = UNIT_STRENGTH
        
        static let INDEX_SWING_JUMPING_ACT:Int = 24
        static let SWING_JUMPING_ACT:String = "스윙/점핑 운동" // 현재는 테니스로..
        static let UNIT_SWING_JUMPING_ACT:Int = UNIT_STRENGTH
        
        static let INDEX_WALK_AND_SLOPE:Int = 25
        static let WALK_AND_SLOPE:String = "걷기(경사) 운동" // 현재는 테니스로..
        static let UNIT_WALK_AND_SLOPE:Int = UNIT_STRENGTH
        
        static let INDEX_SPORT:Int = 26
        static let SPORT:String = "스포츠"
        static let MET_SPORT_HIGH:Float = 8
        static let UNIT_SPORT:Int = UNIT_STRENGTH
        
        //5
        static let INDEX_BICYCLING:Int = 2
        static let BICYCLING:String = "자전거"
        static let MET_BICYCLING_LOW:Float = 6.8
        //fileprivate static final float SPEED_BICYCLING_LOW = 19.0f;
        //fileprivate static final float MET_BICYCLING_MID = 8.0f;
        //fileprivate static final float SPEED_BICYCLING_MID = 20.0f;
        //fileprivate static final float MET_BICYCLING_HIGH = 10.0f;
        //fileprivate static final float SPEED_BICYCLING_HIGH = 22.0f;
        static let UNIT_BICYCLING:Int = UNIT_STRENGTH;
        //6
        static let INDEX_CLIMBING:Int = 6 // kist는 6번일듯..
        static let CLIMBING:String = "등산"
        static let MET_CLIMBING:Float = 6.5
        static let UNIT_CLIMBING:Int = UNIT_STRENGTH;
        //7
        static let INDEX_GOLF:Int = 10
        static let GOLF:String = "골프"
        static let MET_GOLF_LOW:Float = 4.3
        //fileprivate static final float MET_GOLF_MID = 4.3f;
        static let UNIT_GOLF:Int = UNIT_STRENGTH
        //8
        static let INDEX_SWIMMING:Int = 19
        static let SWIMMING:String = "수영"
        static let MET_SWIMMING_LOW:Float = 3.5
        static let MET_SWIMMING_MID:Float = 4.3
        static let MET_SWIMMING_HIGH:Float = 5.3
        static let UNIT_SWIMMING:Int = UNIT_STRENGTH;
        //9
        //10
        static let INDEX_WALK_STAIR:Int = 7
        static let WALK_STAIR:String = "계단 걷기"
        static let MET_WALK_STAIR_LOW:Float = 6.0
        //fileprivate static final float SPEED_WALK_STAIR_LOW = 3.6f;
        //fileprivate static final float MET_WALK_STAIR_MID = 7.0f;
        //fileprivate static final float SPEED_WALK_STAIR_MID = 4.5f;
        static let MET_WALK_STAIR_HIGH:Float = 8.0
        //fileprivate static final float SPEED_WALK_STAIR_HIGH = 5.4f;
        static let UNIT_WALK_STAIR = UNIT_STAIR;
        //11
        
        static let INDEX_WALK_SLOPE:Int = 8
        static let WALK_SLOPE:String = "경사 걷기"
        static let MET_WALK_SLOPE_LOW:Float = 3.0
        static let SPEED_WALK_SLOPE_LOW:Float = 3.6
        static let MET_WALK_SLOPE_MID:Float = 3.8
        static let SPEED_WALK_SLOPE_MID:Float = 4.5
        static let MET_WALK_SLOPE_HIGH:Float = 4.8
        static let SPEED_WALK_SLOPE_HIGH:Float = 5.4
        static let UNIT_WALK_SLOPE:Int = UNIT_STRENGTH
        
        static let INDEX_WALK_FAST:Int = 9
        static let WALK_FAST:String = "빨리 걷기"
        static let MET_WALK_FAST_LOW:Float = 4.8
        static let SPEED_WALK_FAST_LOW:Float = 6.0
        //fileprivate static final float MET_WALK_FAST_MID = 7.5f;
        //fileprivate static final float SPEED_WALK_FAST_MID = 7.0f;
        /*fileprivate static final float MET_WALK_FAST_HIGH = 4.8f;
         fileprivate static final float SPEED_WALK_FAST_HIGH = 5.4f;*/
        static let UNIT_WALK_FAST:Int = UNIT_SPEED
        
        static let INDEX_SWING_ACT:Int = 12
        static let SWING_ACT:String = "스윙 운동"
        static let MET_SWING_ACT_LOW:Float = 7.5
        static let SPEED_SWING_ACT_LOW:Float = 3.6
        static let MET_SWING_ACT_MID:Float = 8.0
        static let SPEED_SWING_ACT_MID:Float = 4.5
        static let MET_SWING_ACT_HIGH:Float = 8.5
        static let SPEED_SWING_ACT_HIGH:Float = 5.4
        static let UNIT_SWING_ACT:Int = UNIT_STRENGTH
        
        //12
        static let INDEX_STAND:Int = 1
        static let STAND:String = "안정"
        static let MET_STAND_LOW:Float = 1.5
        static let MET_STAND_MID:Float = 2.5
        //fileprivate static final float MET_STAND_HIGH = 2.6f;
        static let UNIT_STAND:Int = UNIT_STRENGTH
        
        static let INDEX_SLEEP:Int = 0
        static let SLEEP:String = "수면"
        static let MET_SLEEP_LOW:Float = 1.0
        static let MET_SLEEP_MID:Float = 1.0
        static let MET_SLEEP_HIGH:Float = 1.0
        static let UNIT_SLEEP:Int = UNIT_STRENGTH
        
        // 이하는 수동 선택 운동
        static let BASEBALL:String = "야구"
        static let INDEX_MANUAL_BASEBALL:Int = 50
        static let BASEBALL_MET:Float = 1.0
        
        static let FOOTBALL:String = "축구"
        static let INDEX_MANUAL_FOOTBALL:Int = 51
        static let FOOTBALL_MET:Float = 1.0
        
        static let BASKETBALL:String = "농구"
        static let INDEX_MANUAL_BASKETBALL:Int = 52
        static let BASKETBALL_MET:Float = 1.0
        
        static let SOFTBALL:String = "소프트볼"
        static let INDEX_MANUAL_SOFTBALL:Int = 53
        static let SOFTBALL_MET:Float = 1.0
        
        static let BOWLING:String = "볼링"
        static let INDEX_MANUAL_BOWLING:Int = 54
        static let BOWLING_MET:Float = 1.0
        
        static let POCKETBALL:String = "당구"
        static let INDEX_MANUAL_POCKETBALL:Int = 55
        static let POCKETBALL_MET:Float = 1.0
        
        static let SKI:String = "스키"
        static let INDEX_MANUAL_SKI:Int = 56
        static let SKI_MET:Float = 1.0
        
        static let WEIGHT_TRAINNING:String = "근육 운동"
        static let INDEX_MANUAL_WEIGHT_TRAINNING:Int = 57
        static let WEIGHT_TRAINNING_MET:Float = 1.0
        
        static let CROSS_TRAINNING:String = "크로스 트레이닝"
        static let INDEX_MANUAL_CROSS_TRAINNING:Int = 58
        static let CROSS_TRAINNING_MET:Float = 1.0
        
        static let INNER_BICYCLING:String = "실내 자전거"
        static let INDEX_MANUAL_INNER_BICYCLING:Int = 59
        static let INNER_BICYCLING_MET:Float = 1.0
        
        static let ELLIPTICAL:String = "일립티컬"
        static let INDEX_MANUAL_ELLIPTICAL:Int = 60
        static let ELLIPTICAL_MET:Float = 1.0
        
        static let YOGA:String = "요가"
        static let INDEX_MANUAL_YOGA:Int = 61
        static let YOGA_MET:Float = 1.0
        
        static let DANCE:String = "댄스"
        static let INDEX_MANUAL_DANCE:Int = 62
        static let DANCE_MET:Float = 1.0
        
        static let MANUAL:String = "수동 운동"
        static let INDEX_MANUAL:Int = 100
    }
    
    // 소수점 2번째자리까지 다 짜른다.
    fileprivate func convertPoint(input:Float) -> Float {
        return Float.init(String.init(format: "%0.2f", input))!//Float.parseFloat(String.format("%.2f",input));
    }
    
    fileprivate func convertPoint(input:Double) -> Double {
        return Double.init(String.init(format: "%0.2f", input))! //Double.parseDouble(String.format("%.2f",input));
    }
    
    /**
     * 추천 운동 정보 클래스.
     */
    class RecommendedExercise {
        //int name;
        var time:Int = 0
        var intensity:Float = 0.0
        var rank:Int = 0
        var isCheckedv:Bool = false
        var index:Int = 0
        var unit:Int = 0
        var speed:Int = 0
        /**
         * 추천 운동의 이름 정보를 받는다.
         * @return 추천 운동의 이름 정보.
         */
        /*public int getName() {
         return name;
         }*/
        /**
         * 추천 운동의 수행하여야 할 시간 정보를 받는다.
         * @return 추천 운동의 수행 하여야 할 시간 정보.
         */
        func getTime() -> Int {
            return time
        }
        /**
         * 추천 운동의 강도 정보를 받는다.
         * @return 추천 운동의 강도 정보.
         */
        func getIntensity() -> Float {
            return intensity
        }
        /**
         * 추천 운동의 순위 정보를 받는다.
         * @return 추천 운동의 순위 정보.
         */
        func getRank() -> Int {
            return rank
        }
        /**
         * 추천 운동의 Check 여부 정보를 받는다.
         * @return 추천 운동의 Check 여부 정보.
         */
        func isChecked() -> Bool {
            return isCheckedv
        }
        /**
         * 추천 운동의 index 정보를 받는다.
         * @return 추천 운동의 index 정보.
         */
        func getIndex() -> Int {
            return index
        }
        /**
         * 추천 운동의 unit 정보를 받는다.
         * @return 추천 운동의 unit 정보. (1:ActivityDB.UNIT_SPEED, 2:ActivityDB.UNIT_STRENGTH)
         */
        func getUnit() -> Int {
            return unit
        }
        /**
         * 추천 운동의 speed 정보를 받는다. unit이 ActivityDB.UNIT_SPEED인 경우에만 유효한 값이다.
         * @return 추천 운동의 speed 정보.
         */
        func getSpeed() -> Int {
            return speed
        }
    }
    
    
    var isInitV:Bool = false;
    var listRecommendedExerciseManual:[RecommendedExercise]?// = Array<RecommendedExercise>()
    
    var timeList = [Int64]()
    var timeManualList = [Int64]()
    
    
    class func getInstance() -> BehaviorManager! {
        return mBehaviorManager
    }
    
    
    
    /**
     * 모든 미들웨어 객체를 init할때, BehaviorManager를 최초로 해야한다.
     * @return
     */
    func isInit() -> Bool {
        return isInitV
    }
    
    /**
     * 1분 엔진 변경
     * 1. 10개의 출력된 데이터를 배열로 합산.(class???)
     * 2. 합산된 데이터를의 우선순위를 정한다(input:배열, output:행동 데이터(class???))
     * 3. 2의 내부에는 우선 순위 로직이 존재.(2분 이상 지속된 운동->MET 높은 운동 우선, 최우선은 스윙운동/계단이며 1분만 나와도 해당 운동이라 출력)
     * 4. 평균포복 사용. (걷기, 빨리 걷기, 달리기)(속도=(보폭*걸음수)/10분/1000)
     * 5. 선택된 행동의 강도를 사용한다. ( 선택된 데이터의 평균을 사용하자. )
     * 6. 10분의 보폭은 10개의 평균을 사용. 걸음, 스윙은 합을 사용.
     */
    class KistWrapper: KistClassification{
        var step:Int = 0
        var swing:Int = 0
        var small_swing:Int = 0
        var large_swing:Int = 0
        var variance:Double = 0
        var press_variance:Double = 0
        var double_variance:Double = 0
        var coach_intensity:Float = 0
        var speed:Float = 0
        var disp_step:Int = 0
        
        
        var isSlp:Bool = false
        
        var awaken_count:Int = 0
        var rolled_count:Int = 0
        
        var calorie:Float = 0
        var hr:Int = 0
        
        override init(){
            super.init()
        }
        override init(act_index:Int , arrayIdx:Int){
            super.init(act_index: act_index, arrayIdx: arrayIdx)
        }
        /*public KistWrapper() {
         }*/
    }
    class KistClassification {
        var act_index:Int = 0
        var count:Int = 0
        var MET:Float = 0
        var intensity:Float = 0
        fileprivate var arrayIdx:Int = 0
        
        init(){
            
        }
        
        init(act_index:Int , arrayIdx:Int){
            self.act_index = act_index
            self.arrayIdx = arrayIdx
        }
        /*class KistClassification() {
         }
         class KistClassification(int act_index, int arrayIdx) {
         this.act_index = act_index;
         this.arrayIdx = arrayIdx;
         }*/
    }
    
    class CountClass {
        static let ACTIVITY_COUNT:Int = 22
        static let RUN:Int = 0
        static let WALK:Int = 1
        static let WALK_FAST:Int = 2
        static let WALK_STAIR:Int = 3
        static let CLIMBING:Int = 4
        static let GOLF:Int = 5
        static let BADMINTON:Int = 6
        static let LIGHT_ACT:Int = 7
        static let DAILY_ACT:Int = 8
        static let MODERATE_ACT:Int = 9
        static let INTENSE_ACT:Int = 10
        static let JUMP_ROPE:Int = 11
        static let BICYCLING:Int = 12
        static let SWIMMING:Int = 13
        static let SLEEP:Int = 14
        static let STAND:Int = 15
        static let WALK_SLOPE:Int = 16
        static let SWING_ACT:Int = 17
        static let TABLE_TENNIS:Int = 18
        static let TENNIS:Int = 19
        static let JUMP_ACT:Int = 20
        static let SWING_JUMP_ACT:Int = 21
        
        
        var run:KistClassification
        var walk:KistClassification
        var walk_fast:KistClassification
        var walk_stair:KistClassification
        var climbing:KistClassification
        var golf:KistClassification
        var badminton:KistClassification
        var light_act:KistClassification
        var daily_act:KistClassification
        var moderate_act:KistClassification
        var intense_act:KistClassification
        var jump_rope:KistClassification
        var bicycling:KistClassification
        var swimming:KistClassification
        var sleep:KistClassification
        var stand:KistClassification
        var walk_slope:KistClassification
        var swing_act:KistClassification
        var table_tennis:KistClassification
        var tennis:KistClassification
        var jump_act:KistClassification
        var swing_jump_act:KistClassification
        
        init() {
            let i:Int = 0
            run = KistClassification(act_index: ActivityDB.INDEX_RUN,arrayIdx: i+1); // 0
            walk = KistClassification(act_index: ActivityDB.INDEX_WALK,arrayIdx: i+1); // 1
            walk_fast = KistClassification(act_index: ActivityDB.INDEX_WALK_FAST,arrayIdx: i+1); // 2
            walk_stair = KistClassification(act_index: ActivityDB.INDEX_WALK_STAIR,arrayIdx: i+1); // 3
            climbing = KistClassification(act_index: ActivityDB.INDEX_CLIMBING,arrayIdx: i+1); // 4
            golf = KistClassification(act_index: ActivityDB.INDEX_GOLF,arrayIdx: i+1); // 6
            badminton = KistClassification(act_index: ActivityDB.INDEX_BADMINTON,arrayIdx: i+1); // 7
            light_act = KistClassification(act_index: ActivityDB.INDEX_LIGHT_ACT,arrayIdx: i+1);//8
            daily_act = KistClassification(act_index: ActivityDB.INDEX_DAILY_ACT,arrayIdx: i+1);//9
            moderate_act = KistClassification(act_index: ActivityDB.INDEX_MODERATE_ACT,arrayIdx: i+1);//10
            intense_act = KistClassification(act_index: ActivityDB.INDEX_INTENSE_ACT,arrayIdx: i+1);//11
            jump_rope = KistClassification(act_index: ActivityDB.INDEX_JUMP_ROPE,arrayIdx: i+1);//13
            bicycling = KistClassification(act_index: ActivityDB.INDEX_BICYCLING,arrayIdx: i+1);//14
            swimming = KistClassification(act_index: ActivityDB.INDEX_SWIMMING,arrayIdx: i+1);//15
            sleep = KistClassification(act_index: ActivityDB.INDEX_SLEEP,arrayIdx: i+1);//16
            stand = KistClassification(act_index: ActivityDB.INDEX_STAND,arrayIdx: i+1);//17
            walk_slope = KistClassification(act_index: ActivityDB.INDEX_WALK_SLOPE,arrayIdx: i+1);//18
            swing_act = KistClassification(act_index: ActivityDB.INDEX_SWING_ACT,arrayIdx: i+1);//19
            table_tennis = KistClassification(act_index: ActivityDB.INDEX_TABLE_TENNIS,arrayIdx: i+1);//20
            tennis = KistClassification(act_index: ActivityDB.INDEX_TENNIS,arrayIdx: i+1);//21
            jump_act = KistClassification(act_index: ActivityDB.INDEX_JUMPING_ACT,arrayIdx: i+1);//21
            swing_jump_act = KistClassification(act_index: ActivityDB.INDEX_SWING_JUMPING_ACT,arrayIdx: i+1);//21
        }
    }
    
    
    
    func convertName(index:Int) -> String {
        var name:String = ""
        switch (index) {
        case ActivityDB.INDEX_BICYCLING:
            name = "자전거";
            break;
        case ActivityDB.INDEX_GOLF:
            name = "골프";
            break;
        case ActivityDB.INDEX_JUMP_ROPE:
            name = "줄넘기";
            break;
        case ActivityDB.INDEX_RUN:
            name = "달리기";
            break;
        case ActivityDB.INDEX_WALK:
            name = "걷기";
            break;
        case ActivityDB.INDEX_WALK_STAIR:
            name = "계단걷기";
            break;
        case ActivityDB.INDEX_SLEEP:
            name = "수면";
            break;
        case ActivityDB.INDEX_STAND:
            name = "안정";
            break;
        case ActivityDB.INDEX_TABLE_TENNIS:
            name = "탁구";
            break;
        case ActivityDB.INDEX_TENNIS:
            name = "테니스";
            break;
        default:
            name = "null";
            break;
        }
        
        return name;
    }
    
    func testLog(list:Array<KistWrapper>) {
        for kist:KistWrapper in list {
            Log.d(BehaviorManager.tag, msg:  "\(convertName(index: kist.act_index)), \(kist.act_index), \(kist.variance),\(kist.step), \(kist.swing), \(kist.small_swing), \(kist.large_swing), \(0.0),\(kist.hr), \(kist.press_variance)");
        }
    }
    
    //fileprivate final WeakReference<Context> WContext;
    init() {
        // 디버그 2014.10.27.jeyang
        //mCal.set(2014, 3, 1, 6, 0, 0);
        //WContext = new WeakReference<Context>(context);
        
        
        
        
        if(BLEManager == nil){
            BLEManager = BluetoothLEManager.getInstance()
        }
        //if(mDBHelper == nil){
        //    mDBHelper = DBContactHelper.getInstance()
        //}
        
        //setTimeList()
        /*Calendar mCal = Calendar.getInstance();
         preDay = mCal.get(Calendar.DAY_OF_MONTH);*/
        /*var tmpInfo:[Contact.ActInfo]? = mDBHelper?.getActArray()
         if(tmpInfo == nil) {
         //규창...?
         var tmpInfoP:[Contact.ActInfo] = (mDBHelper?.getActListPast())!//mDBHelper?.getActArrayPast()
         if(tmpInfoP == nil) {
         preDay = -1;
         } else {
         Global_Calendar.setTimeInMillis(tmpInfoP[tmpInfoP.count-1].getC_year_month_day());
         preDay = Int(Global_Calendar.day)
         //preDay = Global_Calendar.get(Calendar.DAY_OF_MONTH);
         }
         } else {
         Global_Calendar.setTimeInMillis(tmpInfo[tmpInfo.count-1].getC_year_month_day());
         //preDay = Global_Calendar.get(Calendar.DAY_OF_MONTH);
         preDay = Int(Global_Calendar.day)
         }*/
//        if let tmpInfo:[Contact.ActInfo] = mDBHelper?.getActArray() {
//            Global_Calendar.setTimeInMillis(tmpInfo[tmpInfo.count-1].getC_year_month_day());
//            //preDay = Global_Calendar.get(Calendar.DAY_OF_MONTH);
//            preDay = Int(Global_Calendar.day)
//        } else {
//            if let tmpInfoP:[Contact.ActInfo] = mDBHelper?.getActListPast() {//mDBHelper?.getActArrayPast()
//                Global_Calendar.setTimeInMillis(tmpInfoP[tmpInfoP.count-1].getC_year_month_day());
//                preDay = Int(Global_Calendar.day)
//            } else {
//                preDay = -1
//            }
//        }
        
        /**
         * 1분엔진으로 변경되면서 libsvm 이라는 파일을 root/svm 폴더로 옮겨야 함. 앱의 context를 받으니 package 위치를 알수 있음.
         * 앱의 res에 libsvm 추가하고 package기준으로 폴더 생성하고 넘기도록 하자.
         */
        //규창
        initKIST()
        //KistracAct = AART_Planner_Engine()
        
        /*float consumeCalorie = getConsumeCalorie(65, 10, ActivityDB.INDEX_DAILY_ACT, 1, 80, 2f);
         ActInfo aInfo = new Contact().new ActInfo(BLEManager.getReturnedTime(406020), ActivityDB.INDEX_DAILY_ACT, ActivityDB.STRENGTH_MIDDLE
         , consumeCalorie, ActivityDB.UNIT_DAILY_ACT, ActivityDB.STRENGTH_MIDDLE, 80, 0, 0, 0, 0);
         
         deleteHeartRateInfo();
         mDBHelper.deletePastConsume();
         mDBHelper.deleteTempAct();
         mDBHelper.addTempAct(aInfo);*/
        
        //1분, 과거용 실시간용 따로 만들고 사용?
        //kistList_save = new ArrayList<KistWrapper>();
        kistList = Array<KistWrapper>()
        kistList_past = Array<KistWrapper>()
        // test dummy
        /*Contact contact = new Contact();
         Contact.ActInfo consumeContact = contact.new ActInfo(System.currentTimeMillis(), 2, 1, 100, 1, 6.1f, 100, 100, 100);
         mDBHelper.addConsume(consumeContact);*/
        
        /*if(listRecommendedExercise == null)
         listRecommendedExercise = new ArrayList<RecommendedExercise>();*/
        if(listRecommendedExerciseManual == nil){
            listRecommendedExerciseManual = Array<RecommendedExercise>();
        }
        
        /*if(listNumberOfExercise == null) {
         listNumberOfExercise = new byte[INNER_NUMBER];
         }*/
        
        /*if(arPivot == null)
         arPivot = new ArrayList<PivotArray>();*/
        
        /**
         * 앱 처음 실행시 칼로리 테이블 삭제. 왜냐하면 전부 하루단위 테이블이기 때문에, 킬때마다 삭제해야된다.
         * 만약, 삭제 전에 데이터가 존재하는 경우, 존재한 데이터의 가장 마지막 데이터의 날짜와 현재 날짜를 비교하여
         * 하루 전의 데이터라면 삭제, 아니라면 보존 해야한다.
         */
        // 현재 날짜. "일" 받아옴.
        //String day = getSystemTimetoDay();
        // 2014.10.27.jeyang
        /*long now = System.currentTimeMillis();
         Date date = new Date(now);
         SimpleDateFormat CurDayFormat = new SimpleDateFormat("dd");
         String day = CurDayFormat.format(date);*/
        //
        
        /*Contact.IntakeInfo[] intakeArray = mDBHelper.getIntakeCalorieContact();
         if(intakeArray != null) {
         // 가장 마지막 데이터 확인.
         Contact.IntakeInfo in = intakeArray[intakeArray.length-1];
         long intakeDay = in.getI_year_month_day();
         date.setTime(intakeDay);
         //Date date = new Date(intakeDay);
         
         if( !day.equals(CurDayFormat.format(date)) ) {
         // 날짜가 다른 경우, 미래의 날짜는 올수가 없다. 따라서 어제 혹은 그 전의 날짜
         // 디버그.. 2014.10.27.jeyang
         mDBHelper.deleteIntake();
         }
         }*/
        
        /*Contact.ActInfo[] consumeArray = mDBHelper.getConsumeCalorieContact();
         if(consumeArray != null) {
         // 가장 마지막 데이터 확인.
         Contact.ActInfo con = consumeArray[consumeArray.length-1];
         long consumeDay = con.getC_year_month_day();
         date.setTime(consumeDay);
         //Date date = new Date(consumeDay);
         
         if( !day.equals(CurDayFormat.format(date)) ) {
         // 날짜가 다른 경우, 미래의 날짜는 올수가 없다. 따라서 어제 혹은 그 전의 날짜
         // 디버그.. 2014.10.27.jeyang
         mDBHelper.deleteConsume();
         mDBHelper.deleteIntake();
         
         // 앱 시동 시, 기록된 날짜랑 다른 경우, 바로 과거데이터 테이블로 전부 넘긴다. 이때, 과거 테이블은 비어있는 상태. 들어있으면 뭔가 비정상 동작. 그냥 다 지운다.
         // 왜냐하면 과거 데이터는 오자마자 바로 전송하고 삭제하고 비울때까지 전송하고 삭제하기 때문에 남아있을 수가 없음. -> 지금은 상관없는듯.
         deleteCalorieTable();
         }
         }*/
    }
    
    /*fileprivate Context getContext() {
     return WContext.get();
     }*/
    
    func initKIST() {
        KistracAct = AART_Planner_Engine()
        //KistracAct = new AART_Planner_Engine();
        //KistracAct.getobject(getContext().getFilesDir().getAbsolutePath());
    }
    
    func getHeartRate(feature:[Dictionary<String, Any>]) -> [Int] {
        Log.i(BehaviorManager.tag, msg:"getHeartRate__ \(feature.count)")
        let hr = [Int](repeating:0, count:feature.count)
        var i=0;
        /*for d in feature {
         //hr[i++] = d[28]&0xff;
         Log.i(ActManager.tag, msg:"getHeartRate\(d[Int(ActManager.OFFSET_HEART_RATE)])__ \(d.count)")
         hr[i] = Int(d[Int(ActManager.OFFSET_HEART_RATE)]&0xff)
         i+=1;
         }*/
        
        for i in 0..<10 {
            //Log.i(ActManager.tag, msg:"getHeartRate\(feature[i][Int(ActManager.OFFSET_HEART_RATE)])__ \(i)")
        }
        return hr;
    }
    
    func convertIndextoUnit(actIndex:Int) -> Int {
        switch(actIndex) {
        case ActivityDB.INDEX_SLEEP:
            return ActivityDB.UNIT_HEARTRATE
        case ActivityDB.INDEX_STAND, ActivityDB.INDEX_SWIMMING, ActivityDB.INDEX_DISUSE, ActivityDB.INDEX_BADMINTON, ActivityDB.INDEX_SPORT, ActivityDB.INDEX_DAILY_ACT,
             ActivityDB.INDEX_LIGHT_ACT, ActivityDB.INDEX_MODERATE_ACT, ActivityDB.INDEX_INTENSE_ACT, ActivityDB.INDEX_SWING_ACT, ActivityDB.INDEX_BICYCLING, ActivityDB.INDEX_CLIMBING,
             ActivityDB.INDEX_GOLF, ActivityDB.INDEX_TENNIS, ActivityDB.INDEX_TABLE_TENNIS:
            return ActivityDB.UNIT_STRENGTH
        case ActivityDB.INDEX_WALK_SLOPE, ActivityDB.INDEX_RUN, ActivityDB.INDEX_WALK, ActivityDB.INDEX_WALK_FAST:
            return ActivityDB.UNIT_SPEED;
        case ActivityDB.INDEX_WALK_STAIR:
            return ActivityDB.UNIT_STAIR;
        case ActivityDB.INDEX_JUMP_ROPE:
            return ActivityDB.UNIT_SWING;
        default:
            break
        }
        return ActivityDB.UNIT_STRENGTH;
    }
    
    
    
    //규창 171020 블루투스에서 피쳐를 전달받으면 이리로 넘겨서 피쳐를 엔진으로 전달하여 엔진의 결과 확인
    func onReceiveFeature(feature:[Dictionary<String, Any>]) -> Contact.ActInfo {
        // feature 데이터를 정렬하는 부분. 달라질수 있음.
        //Array<UInt8> featureArray = BLEManager.getFeature();
        //var featureArray:[[UInt8]] = Array(repeating: Array(repeating: 0, count: 43), count: 10)
        //var k:Int = 0;
        
        if(BehaviorManager.DEBUG) {
            Log.w(BehaviorManager.tag, msg: "onReceiveFeature()")
            /*Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_NORM_VAR])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_X_VAR])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_Y_VAR])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_Z_VAR])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_X_MEAN])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_Y_MEAN])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_Z_MEAN])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_NORM_MEAN])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_NSTEP])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_JUMP_ROPE_SWING])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_SMALL_SWING])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_LARGE_SWING])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_PRESS_VAR])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_ACCMULATED_STEP])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_DISPLAY_STEP])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_PRESS])")
            Log.w(BehaviorManager.tag, msg: " \(feature[BehaviorManager.KEY_PULSE])")*/
    
            for i in 0..<feature.count {
                
            }
            
            /*Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_TIME)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_NORM_VAR)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_X_VAR)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_Y_VAR)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_Z_VAR)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_X_MEAN)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_Y_MEAN)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_Z_MEAN)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_NORM_MEAN)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_NSTEP)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_JUMP_ROPE_SWING)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_SMALL_SWING)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_LARGE_SWING)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_PRESS_VAR)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_ACCMULATED_STEP)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_DISPLAY_STEP)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_PRESS)))")
            Log.w(BehaviorManager.tag, msg: " \(String(describing: feature.index(forKey: BehaviorManager.KEY_PULSE)))")*/
        }
        
        var FeatureData:[[Double]] = Array(repeating: Array(repeating: 0, count:18), count:10)
        for i in 0..<10{
            /*
             static let POSITION_VAR_X:UInt8 = 0
             static let POSITION_VAR_Y:UInt8 = 1
             static let POSITION_VAR_Z:UInt8 = 2
             static let POSITION_VAR_NORM:UInt8 = 3
             
             static let POSITION_MEAN_X:UInt8 = 4
             static let POSITION_MEAN_Y:UInt8 = 5
             static let POSITION_MEAN_Z:UInt8 = 6
             static let POSITION_MEAN_NORM:UInt8 = 7
             
             static let POSITION_STEP:UInt8 = 8
             static let POSITION_JUMP:UInt8 = 9
             static let POSITION_SMALL:UInt8 = 10
             static let POSITION_LARGE:UInt8 = 11
             
             static let POSITION_VAR_PRESS:UInt8 = 12
             static let POSITION_AMP_RTSL:UInt8 = 13
             static let POSITION_FREQ_RTSL:UInt8 = 14
             
             static let POSITION_PRESS:UInt8 = 15
             static let POSITION_DISP_STEP:UInt8 = 16
             static let POSITION_HEART_RATE:UInt8 = 17
             */
            FeatureData[i][BehaviorManager.POSITION_VAR_NORM] = feature[i][BehaviorManager.KEY_NORM_VAR] as! Double
            FeatureData[i][BehaviorManager.POSITION_VAR_X] = feature[i][BehaviorManager.KEY_X_VAR] as! Double
            FeatureData[i][BehaviorManager.POSITION_VAR_Y] = feature[i][BehaviorManager.KEY_Y_VAR] as! Double
            FeatureData[i][BehaviorManager.POSITION_VAR_Z] = feature[i][BehaviorManager.KEY_Z_VAR] as! Double
            FeatureData[i][BehaviorManager.POSITION_MEAN_X] = feature[i][BehaviorManager.KEY_X_MEAN] as! Double
            FeatureData[i][BehaviorManager.POSITION_MEAN_Y] = feature[i][BehaviorManager.KEY_Y_MEAN] as! Double
            FeatureData[i][BehaviorManager.POSITION_MEAN_Z] = feature[i][BehaviorManager.KEY_Z_MEAN] as! Double
            FeatureData[i][BehaviorManager.POSITION_MEAN_NORM] = feature[i][BehaviorManager.KEY_NORM_MEAN] as! Double
            let step:Int16 = feature[i][BehaviorManager.KEY_NSTEP] as! Int16
            FeatureData[i][BehaviorManager.POSITION_STEP] = Double(step)
            let JRS:Int16 = feature[i][BehaviorManager.KEY_JUMP_ROPE_SWING] as! Int16
            FeatureData[i][BehaviorManager.POSITION_JUMP] =  Double(JRS)
            let SS:Int16 = feature[i][BehaviorManager.KEY_SMALL_SWING] as! Int16
            FeatureData[i][BehaviorManager.POSITION_SMALL] = Double(SS)
            let LS:Int16 = feature[i][BehaviorManager.KEY_LARGE_SWING] as! Int16
            FeatureData[i][BehaviorManager.POSITION_LARGE] = Double(LS)
            FeatureData[i][BehaviorManager.POSITION_VAR_PRESS] = feature[i][BehaviorManager.KEY_PRESS_VAR] as! Double
            let ACStep:Int16 = feature[i][BehaviorManager.KEY_ACCMULATED_STEP] as! Int16
            FeatureData[i][BehaviorManager.POSITION_AMP_RTSL] = Double(ACStep)
            FeatureData[i][BehaviorManager.POSITION_FREQ_RTSL] = Double(ACStep)
            let DStep:Int16 = feature[i][BehaviorManager.KEY_DISPLAY_STEP] as! Int16
            FeatureData[i][BehaviorManager.POSITION_DISP_STEP] = Double(DStep)
            FeatureData[i][BehaviorManager.POSITION_PRESS] = feature[i][BehaviorManager.KEY_PRESS] as! Double
            let Pulse:Int16 = feature[i][BehaviorManager.KEY_PULSE] as! Int16
            FeatureData[i][BehaviorManager.POSITION_HEART_RATE] = Double(Pulse)
        }
        
    
        
        
        /*
        //byte[][] byteFeature = getByteArrayFromFeature(featureArray);
        let byteFeature:[[UInt8]] = featureArray//getByteArrayFromFeature(feature: featureArray)
        var FeatureData:[[Double]] = getDataFromByteFeature(byteFeature: byteFeature)
        //long[] FeatureTime = getTimeFromByteFeature(byteFeature);
        let FeatureTime:Int64 = getTime(feature: byteFeature)
        let timeArray:[Int64] = getTimeArray(feature: byteFeature)
        let pressArray:[Float] = getPressArray(feature: FeatureData)
        let dispStepArray:[Int] = getDispStep(feature: FeatureData)
        */
        // 1분 feature의 시간이 여러 시간대인 경우는...???
        /** 현재 KIST의 feature 개수는 10개이며, 심박수가 11번째 **/
        //var hrArray:[Int] = getHeartRate(feature: byteFeature)
        
        
        var heartrate:Int = 0
        
        for i in 0..<10 {
            if(BehaviorManager.DEBUG){
                //Log.d(BehaviorManager.tag, msg: "getHeartRate-> hr:\(Int(FeatureData[i][16]))")
            }
            if(Int(FeatureData[i][BehaviorManager.POSITION_HEART_RATE]) > heartrate) {
                heartrate = Int(FeatureData[i][BehaviorManager.POSITION_HEART_RATE])
            }
        }
        if(BehaviorManager.DEBUG){
            Log.d(BehaviorManager.tag, msg: "getHeartRate-> final hr:\(heartrate)");
        }
        //addHeartRateInfo(timeArray, hrArray);
        
        var pressVariance:Float = 0;
        /*for p:Float in pressArray {
            pressVariance += p
        }*/
        //규창 171027 기압차 추가
        for i in 0..<10 {
            pressVariance += Float(FeatureData[i][BehaviorManager.POSITION_VAR_PRESS])
        }
        if(abs(pressVariance) > 20) {
            //setZeroPressArray(feature: &FeatureData)
            //var pressArray = [Float](repeating: 0, count: 10)
            for i in 0..<10 {
                FeatureData[i][BehaviorManager.POSITION_VAR_PRESS] = 0
            }
        }
        
        //kistList.clear();
        kistList?.removeAll()
        
         // 이제 feature의 정렬은 끝났으며, KISTact에 대입하고, Time 값을 DB에 add
         // 배열의 모든 lengh 만큼 DB 업데이트를 해야한다. while??
         //
        //for(int i=0; i<10; i++) {
        var timeArray:[Int64] = Array(repeating: 0, count:10)
        for i in 0..<10 {
            let TestTime:Int64 = BluetoothLEManager.getReturnedTime(feature[i][BehaviorManager.KEY_TIME] as! Int32)
            timeArray[i] = TestTime
            let format = DateFormatter()
            format.dateFormat = "yyyy/MM/dd HH:mm"
            let formatTime = Date(timeIntervalSince1970: TimeInterval(TestTime/1000))
            Log.i(BehaviorManager.tag, msg: " ")
            Log.i(BehaviorManager.tag, msg: " ")
            Log.v(BehaviorManager.tag, msg: "esti array date:\(format.string(from: formatTime as Date))");
            
            
            
            
            var tmpActData:[Double]  = KistracAct!.ActivityOut(feature_data: FeatureData[i])
            //if(tmpActData != null) {
            // getFromKist = tmpActData;
            // Log.i(ActManager.tag, msg: "get kist data");
            // Log.i(ActManager.tag, msg: "Act Index:"+getFromKist[0]+" vari:"+getFromKist[1]+" step:"+getFromKist[2]+" swing:"+getFromKist[3]);
            //}
            // 1분 변경되는 내용. 아직은 주석 처리.
            let wrap = KistWrapper()
            wrap.act_index = Int(tmpActData[0])
            wrap.variance = tmpActData[1]
            wrap.press_variance = tmpActData[2]
            wrap.step = Int(tmpActData[3])
            wrap.swing = Int(tmpActData[4])
            wrap.small_swing = Int(tmpActData[5])
            wrap.large_swing = Int(tmpActData[6])
            wrap.hr = Int(FeatureData[i][BehaviorManager.POSITION_HEART_RATE])
            wrap.disp_step = Int(FeatureData[i][BehaviorManager.POSITION_DISP_STEP])
        
        //    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        //    % Definition of Activity_Index %
        //    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        //    % % Activity_Index=2 :: 수면 --> 0
        //    % % Activity_Index=4 :: 안정 --> 1
        //    % % Activity_Index=6 :: 자전거 --> 2
        //    % % Activity_Index=8 :: 사이클 --> 2
        //    % % Activity_Index=10 :: 줄넘기 --> 3
        //    % % Activity_Index=12 :: 걷기 스윙 --> 4
        //    % % Activity_Index=14 :: 걱기 물건 --> 4
        //    % % Activity_Index=16 :: 걷기 주머니 --> 4
        //    % % Activity_Index=18 :: 걷기 --> 4
        //    % % Activity_Index=20 :: 걷기 --> 4
        //    % % Activity_Index=22 :: 안정 --> 1
        //    % % Activity_Index=24 :: 걷기 --> 4
        //    % % Activity_Index=26 :: 달리기 --> 5
        //    % % Activity_Index=28 :: 달리기 --> 5
        //    % % Activity_Index=30 :: 등산 --> 6
        //    % % Activity_Index=32 :: 계단 --> 7
        //    % % Activity_Index=34 :: 계단 --> 7
        //    % % Activity_Index=36 :: 계단 --> 7
        //    % % Activity_Index=38 :: 계단 --> 7
        //    % % Activity_Index=40 :: 테니스 --> 8
        //    % % Activity_Index=42 :: 탁구 --> 9
        //    % % Activity_Index=44 :: 골프--> 10
        
            Log.i(BehaviorManager.tag, msg: "Act Index:\(wrap.act_index) vari:\(wrap.variance) step:\(wrap.step) swing:\(wrap.swing) press_var:\(wrap.press_variance) small:\(wrap.small_swing) large:\(wrap.large_swing)")
        Log.i(BehaviorManager.tag, msg: " ")
        Log.i(BehaviorManager.tag, msg: " ")
            //kistList.add(wrap);
            kistList?.append(wrap)
        }
        
         // 1분 엔진 변경
         //1. 10개의 출력된 데이터를 배열로 합산.(class???)
         // 2. 합산된 데이터를의 우선순위를 정한다(input:배열, output:행동 데이터(class???))
         // 3. 2의 내부에는 우선 순위 로직이 존재.(2분 이상 지속된 운동->MET 높은 운동 우선, 최우선은 스윙운동/계단이며 1분만 나와도 해당 운동이라 출력) ( 수면 제외. 수면은 8개 들어오면 무조건 수면이다 )
         // 4. 평균포복 사용. (걷기, 빨리 걷기, 달리기)(속도=(보폭*걸음수)/10분/1000)
         //5. 선택된 행동의 강도를 사용한다. ( 선택된 데이터의 평균을 사용하자. )
         // 6. 10분의 보폭은 10개의 평균을 사용. 걸음, 스윙은 합을 사용.
 
        //saveDbFeature(getSDPath(), FeatureData, getFileNameDateFormat(BLEManager.getMac()+"-Feature"), FeatureTime);
        
        let output_kist:KistWrapper = summuryKistOut(kistList: &kistList!, time: timeArray)
        Log.i(BehaviorManager.tag, msg: "--->Act Index:\(output_kist.act_index) vari:\(output_kist.variance) step:\(output_kist.step) swing:\(output_kist.swing)")
        
        
        //  계단 오르기만 step_len 에 분당 계단 수 들어간다.
        /// 이제 feature에 time 데이터가 얹혀져서 온다
        // 초,밀리초 삭제.
        
        //let now:Int64 = FeatureTime/100000*100000
        let now:Int64 = timeArray.first!
        let actIndex:Int = output_kist.act_index
        var intensity:Float = output_kist.intensity
        let step:Int = output_kist.step
        let swing:Int = output_kist.swing
        
        let MET:Float = output_kist.MET
        let coach_intensity:Float = output_kist.coach_intensity
        var consumeCalorie:Float = 0
        
        
        let profile:Contact.Profile = DBContactHelper.getInstance().PLgetUserProfile()// (mDBHelper?.getUserProfile())!;
        if(actIndex == ActivityDB.INDEX_DISUSE) {
            heartrate = 0
        }
        if(actIndex == ActivityDB.INDEX_WALK || actIndex == ActivityDB.INDEX_WALK_FAST
            || actIndex == ActivityDB.INDEX_WALK_SLOPE || actIndex == ActivityDB.INDEX_RUN
            || actIndex == ActivityDB.INDEX_WALK_STAIR) {
            consumeCalorie = output_kist.calorie;
        } else {
            consumeCalorie = getConsumeCalorie(weight: profile.getWeight(), time: 10, actIndex: actIndex, jobIndex: Int(profile.getJob()), heartrate: heartrate, MET: MET)
        }
        
        let unit:Int = convertIndextoUnit(actIndex: actIndex);
        
        var speed:Float = 0;
        if(actIndex == ActivityDB.INDEX_WALK_STAIR || actIndex == ActivityDB.INDEX_JUMP_ROPE) {
            speed = output_kist.coach_intensity
        } else {
            speed = getSpeedtoDB(kist: output_kist);
        }
        
        if(actIndex == ActivityDB.INDEX_SLEEP) {
            intensity = Float(output_kist.rolled_count);
            speed = Float(output_kist.awaken_count);
        }
        
        /*Date date = new Date();
         SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm");
         date.setTime(now);
         Log.v(ActManager.tag, msg: "        date:"+format.format(date));*/
        
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm"
        //let formatTime = Date(timeIntervalSince1970: TimeInterval(time[i]))
        let formatTime = Date(timeIntervalSince1970: TimeInterval(now/1000))
        Log.v(BehaviorManager.tag, msg: "onReceiveFeature esti array date:\(format.string(from: formatTime as Date))");
        testLog(list: kistList!)
        Log.d(BehaviorManager.tag, msg: "addConsume->act:\(actIndex) intensity:\(intensity) consumeCalorie:\(consumeCalorie) speed:\(speed) heartrate:\(heartrate) step:\(step) swing:\(swing) pressVariance:\(pressVariance) coach_intensity:\(coach_intensity) [time\(now)]")
        //Contact contact = new Contact();
        
        //규창 아래는 리턴 처리
        //ActInfo consumeContact = Global_Contact.new ActInfo(now, actIndex, intensity, consumeCalorie, unit,
        //                                                    speed, heartrate, step, swing, pressVariance, coach_intensity, DBContactHelper.NONSET_UPDATED);
        
        //let consumeContact = Contact.ActInfo(c_year_month_day: now, c_exercise: Int32(actIndex), c_intensity: Float32(intensity), c_calorie: Float32(consumeCalorie), c_unit: Int32(unit), c_intensity_number: Float32(speed), c_heartrate: Int32(heartrate), c_step: Int32(step), c_swing: Int32(swing), c_press_variance: Float32(pressVariance), c_coach_intensity: Float32(coach_intensity), c_flag: 1)
        
        let consumeContact = Contact.ActInfo(c_year_month_day: now, c_exercise: Int32(actIndex), c_intensity: Float32(intensity), c_calorie: Float32(consumeCalorie), c_unit: Int32(unit), c_intensity_number: Float32(speed), c_heartrate: Int32(heartrate), c_step: Int32(step), c_swing: Int32(swing), c_press_variance: Float32(pressVariance), c_coach_intensity: Float32(coach_intensity), c_flag: 1)
        
        //규창 임시...
        return consumeContact
        
        //규창 아마... 여기서 부터는 노티피케이션 처리로 보인다.
        /*
         //mDBHelper.estimateValidTime(now);
         mDBHelper.addActList(consumeContact);
         
         mDBHelper.clearTempActInfo();
         mDBHelper.addTempActInfo(consumeContact);
         
         if(thisCb != null)
         thisCb.onReceiveActInfo();*/
        /*data_count++;
         if(data_count > data_limit) {
         data_count = 0;
         if(thisCb != null)
         thisCb.onReceiveActInfo();
         }*/
    }
    
    
    
    
    
    
    func estimateActivity(kistList:Array<KistWrapper>, ref_count:Int) -> KistWrapper {
        let result:KistWrapper = KistWrapper();
        var zone:[Float] = getHeartRateDangerZone();
        //int hr = getKarvonenHR(0.5f, min_hr);
        var hr_avg:Int = 0
        var hr_count:Int = 0
        var index_count:Int = 0
        var tStep:Int = 0
        var tSwing:Int = 0
        
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_BICYCLING || kist.act_index == ActivityDB.INDEX_WALK
                || kist.act_index == ActivityDB.INDEX_RUN || kist.act_index == ActivityDB.INDEX_TENNIS
                || kist.act_index == ActivityDB.INDEX_TABLE_TENNIS || kist.act_index == ActivityDB.INDEX_WALK_STAIR
                || kist.act_index == ActivityDB.INDEX_GOLF || kist.act_index == ActivityDB.INDEX_JUMP_ROPE) {
                index_count = index_count+1
                hr_avg += kist.hr
            }
            
            tStep += kist.step;
            tSwing += kist.swing + kist.small_swing + kist.large_swing;
        }
        hr_avg = index_count == 0 ? 0 : hr_avg / index_count;
        
        result.act_index = ActivityDB.INDEX_DAILY_ACT;
        result.MET = ActivityDB.MET_DAILY_ACT_LOW;
        result.intensity = Float(ActivityDB.STRENGTH_MIDDLE)
        result.step = tStep;
        result.swing = tSwing;
        
        if(index_count >= ref_count) {
            if(Float(hr_avg) >= zone[0]*0.7) {
                result.act_index = ActivityDB.INDEX_SPORT;
                result.MET = ActivityDB.MET_SPORT_HIGH;
                result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            } else if(zone[0]*0.6 <= Float(hr_avg) && Float(hr_avg) < zone[0]*0.7) {
                result.act_index = ActivityDB.INDEX_INTENSE_ACT;
                result.MET = ActivityDB.MET_INTENSE_ACT_HIGH;
                result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            }
        }
        
        return result
    }
    
    /**
     * 1분 결과가 합당한 결과인지 전체적인 검사를 한다. 10분을 보았을 경우의 변경사항도 포함.
     * @param kistList
     * @return
     */
    func layer_1(kistList:inout Array<KistWrapper>) {// -> Array<KistWrapper> {
        //boolean isRun = false, isJump = false;
        //var kist:KistWrapper = KistWrapper()
        var idx:Int = 0;
        for kist in kistList {
            if(kist.act_index == ActivityDB.INDEX_WALK_STAIR) {
                if(kist.step <= 10) {
                    kist.act_index = ActivityDB.INDEX_STAND;
                }
            } else if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE) {
                if(kist.swing > 50 && kist.variance > 30 && kist.small_swing < 10) {
                    kist.act_index = ActivityDB.INDEX_JUMP_ROPE;
                } else if(kist.variance > 30 && kist.swing > 50) {
                    kist.act_index = ActivityDB.INDEX_RUN;
                } else if(kist.variance < 30 || kist.swing < 50) {
                    kist.act_index = ActivityDB.INDEX_STAND;
                } else if(kist.swing > 150) {
                    kist.act_index = ActivityDB.INDEX_RUN;
                } else if(kist.step < 10) {
                    kist.act_index = ActivityDB.INDEX_STAND;
                } else if(kist.step >= 20) {
                    kist.act_index = ActivityDB.INDEX_WALK;
                } else if(abs(kist.press_variance) > 0.3 && kist.step == 0) {
                    kist.act_index = ActivityDB.INDEX_STAND;
                }
                else if(abs(kist.press_variance) > 0.3 && kist.step > 0) {
                    kist.act_index = ActivityDB.INDEX_WALK;
                }
            } else if(kist.act_index == ActivityDB.INDEX_BICYCLING) {
                if(kist.step < 10 && kist.swing >= 30) {
                    kist.act_index = ActivityDB.INDEX_STAND;
                } else if(kist.step >= 20) {
                    kist.act_index = ActivityDB.INDEX_WALK;
                }
            } else if(kist.act_index == ActivityDB.INDEX_WALK) {
                if(kist.step <= 10) {
                    kist.act_index = ActivityDB.INDEX_STAND;
                }
                else if(kist.variance > 30 && kist.swing > 60) {
                    kist.act_index = ActivityDB.INDEX_JUMP_ROPE;
                }
            }
            /*
             if(kist.act_index == ActivityDB.INDEX_RUN)
             isRun = true;
             else if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE)
             isJump = true;
             */
            
            
            //kistList.insert(kist, at: idx)
            //규창 배열이 2배 증가... 수정.
            kistList[idx] = kist
            idx = idx+1
        }
        
        // 이하는 달리기 & 줄넘기 처리.
        /*
         if(!(isRun && isJump))
         return;
         
         idx = 0;
         for(KistWrapper kist : kistList) {
         if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE && kist.step < 80)
         kist.act_index = ActivityDB.INDEX_RUN;
         
         kistList.set(idx, kist);
         idx++;
         }
         */
        //return kistList
    }
    
    /**
     * kist 엔진에서 나온 행동을 들고 가장 처음으로 행동을 판별하는 filter
     * @param kistList
     * @return
     */
    func layer_2(kistList:inout Array<KistWrapper>) -> KistWrapper {
        //ArrayList<KistWrapper> tList = (ArrayList<KistWrapper>)kistList.clone();
        //tList = sort(tList);
        let resultOver:KistWrapper = KistWrapper()
        let resultCon:KistWrapper = KistWrapper()
        var tStep:Int = 0
        var tSwing:Int = 0
        // 수면, 등산, 골프, 테니스, 탁구 제외(시작 끝이 존재하는 행동)
        // 왜냐하면 시작 끝이 존재하는 행동은 이미 시작이 된 경우 다른 행동이 내부에 존재할 수 없기 때문
        /**
         * 절차
         * 1. 시작 끝 행동들의 시작 여부 판단. (현재는 수면만 해당)
         * 2. 시작 행동이 있으면 바로 return.
         * 3. 없으면 나머지 행동의 판단 조건 확인.
         * 4. 확정된 행동들을 나열.
         * 5. 나열된 행동이 여러개면 MET 높은 행동을 return.
         * 6. 하나면 그냥 return.
         */
        
        // 여기에서 이렇게 return 하면 행동들이 바뀔 우려가 있음. 여기는 수면만 확인!!!!! 수면만 내부에 아무 행동도 올수 없다.
        /*if(InnerEditor.getSleepFlagStatus(mContext) == SLP_STATUS_START) {
         return new KistWrapper(ActivityDB.INDEX_SLEEP);
         }*/
        var isGolf:Bool = false;
        for kist in kistList {
            // 골프가 무조건 1개라도 있으면 그건 그냥 골프야
            if(kist.act_index == ActivityDB.INDEX_GOLF){
                isGolf = true;
            }
            
            tStep += kist.step;
            tSwing += kist.swing + kist.small_swing + kist.large_swing;
        }
        if(isGolf) {
            resultOver.act_index = ActivityDB.INDEX_GOLF;
            resultOver.MET = ActivityDB.MET_GOLF_LOW;
            resultOver.intensity = Float(ActivityDB.STRENGTH_LOW);
            resultOver.step += tStep;
            resultOver.swing += tSwing;
            
            return resultOver;
        }
        
        // 계단 조건을 만족하는지 미리 확인. 만족하지 않는다면 계단을 전부 걷기로 변경한다.
        var isWStair:Bool = false
        var tmp_count:Int = 0
        //for(int i=0; i<kistList.size(); i++) {
        for i in 0..<kistList.count {
            if(kistList[i].act_index == ActivityDB.INDEX_WALK_STAIR) {
                tmp_count += 1
                if(BehaviorManager.DEBUG) {
                    //Log.d(BehaviorManager.tag, msg: "pre WStair tmp_count:\(tmp_count)");
                }
            } else {
                if(BehaviorManager.DEBUG) {
                    //Log.d(BehaviorManager.tag, msg: "pre WStair tmp_count reset");
                }
                tmp_count = 0;
            }
            
            if(tmp_count == 2) {
                // 계단 하나라도 만족함.
                isWStair = true;
                if(BehaviorManager.DEBUG){
                    //Log.d(BehaviorManager.tag, msg: "pre WStair true");
                }
                break;
            }
        }
        
        // 계단 사전 점검 후, 걷기로 치환.
        if(!isWStair) {
            var idx:Int = 0
            //for(KistWrapper kist : kistList) {
            for kist in kistList {
                if(kist.act_index == ActivityDB.INDEX_WALK_STAIR) {
                    kist.act_index = ActivityDB.INDEX_WALK;
                    //규창 170609
                    //kistList.set(idx, kist);
                    kistList.insert(kist, at: idx)
                }
                idx = idx+1
            }
        }
        
        ////////
        // 현재 최대 2개의 연속인 행동이 올수 있음. (2개 6개, 3개 6개, 2개 3개...) 하지만, 알고리즘 상 2:2:2:2:2 를 고려해서 만들어야함. 연속성 체크.
        var con_count = [Int](repeating: 0, count : 10/2) // feature 10 / 2
        var con_idx = [Int](repeating: 0, count : 10/2)
        //for(int i=0 ;i<con_idx.length;i++)
        for i in 0..<con_idx.count{
            con_idx.insert(-1, at: i);
        }
        
        var jCount:Int = 0;
        
        if(BehaviorManager.DEBUG){
            //Log.d(BehaviorManager.tag, msg: "start con filter_3 esti \(kistList)");
        }
        var tmp_idx:Int = kistList[0].act_index //kistList.get(0).act_index;
        tmp_count = 1;
        //for(int i=1; i<kistList.size() ; i++) {
        //for i in 1..<kistList.count {
        for i in 1..<10 {
            if(BehaviorManager.DEBUG){
                //Log.d(BehaviorManager.tag, msg: "for loop get(i)index:\(kistList[i].act_index) tmpidx:\(tmp_idx)");
            }
            if(tmp_idx == kistList[i].act_index) {
                tmp_count += 1
                if(BehaviorManager.DEBUG){
                    //Log.d(BehaviorManager.tag, msg: "tmp_count:\(tmp_count)");
                }
            } else if(tmp_count != 1){
                if(BehaviorManager.DEBUG){
                    //Log.d(BehaviorManager.tag, msg: "tmp_count reset");
                }
                tmp_count = 1
                jCount += 1
            }
            tmp_idx = kistList[i].act_index;
            if(tmp_count > 1) {
                con_idx[jCount] = tmp_idx;
                con_count[jCount] = tmp_count;
                if(BehaviorManager.DEBUG){
                    //Log.d(BehaviorManager.tag, msg:"con idx[\(jCount)]:con_idx[\(jCount)] : con_count[\(jCount)]:\(con_count[jCount])");
                }
            }
        }
        if(BehaviorManager.DEBUG){
            //Log.d(BehaviorManager.tag, msg:"end con filter_3 esti");
        }
        
        //규창 불형이 없어서 임시로 Int형 선언
        //boolean con2Min = new boolean[CountClass.ACTIVITY_COUNT];
        var con2Min = Array(repeating: false, count : CountClass.ACTIVITY_COUNT)
        let conC:CountClass = CountClass()
        var c:Int = 0
        var maxMET:Float = 0
        var isCon:Bool = false;
        //for(int act_index : con_idx) {
        for act_index in con_idx {
            var diffMET:Float = 0
            if(act_index == ActivityDB.INDEX_CLIMBING) {
                conC.climbing.count = con_count[c];
                if(conC.climbing.count >= 6) {
                    //con2Min[conC.climbing.arrayIdx] = true;
                    //diffMET = ActivityDB.MET_CLIMBING;
                }
            } else if(act_index == ActivityDB.INDEX_WALK_STAIR) {
                conC.walk_stair.count = con_count[c];
                if(conC.walk_stair.count >= 2) {
                    con2Min[conC.walk_stair.arrayIdx] = true;
                    diffMET = ActivityDB.MET_WALK_STAIR_HIGH;
                }
            } else if(act_index == ActivityDB.INDEX_BICYCLING) {
                conC.bicycling.count = con_count[c];
                if(conC.bicycling.count >= 6) {
                    con2Min[conC.bicycling.arrayIdx] = true;
                    diffMET = ActivityDB.MET_BICYCLING_LOW;
                }
            }/*else if(act_index == ActivityDB.INDEX_SLEEP) {
             conC.sleep.count = con_count[c];
             if(conC.sleep.count >= 8) {
             con2Min[conC.sleep.arrayIdx] = true;
             diffMET = ActivityDB.MET_SLEEP_LOW;
             }
             }*/
            c += 1;
            if(diffMET > maxMET) {
                maxMET = diffMET;
                
                resultCon.act_index = act_index;
                resultCon.MET = maxMET;
                isCon = true;
            }
        }
        ///////// 연속성 체크 완료.
        // 연속성 체크 끝났는데 등산 판정조건에 부합하지 않으면 등산->걷기 변경
        /*
         if(!con2Min[conC.climbing.arrayIdx]) {
         Log.d(ActManager.tag, msg: "clm->walk change");
         int idx=0;
         for(KistWrapper kist:kistList) {
         if(kist.act_index == ActivityDB.INDEX_CLIMBING)
         kist.act_index = ActivityDB.INDEX_WALK;
         
         kistList.set(idx, kist);
         idx++;
         }
         con2Min[conC.climbing.arrayIdx] = false; // 등산은 비교 대상이 아님. 시작 끝 행동.
         }
         */
        // 연속성도 체크 가능해야한다. 연속되는 행동은 결국 한가지 밖에 없음. 현재 행동이 이전 행동과 같은지 체크, 이게 반복 체크.
        // 여기는 각각 운동의 개수가 몇개인지 파악하는 곳. 불연속 운동 파악.
        //규창 어레이 불형이 없어서 임시로 Int형 선언
        //boolean[] over2Min = new boolean[CountClass.ACTIVITY_COUNT];
        var over2Min = Array(repeating: false, count : CountClass.ACTIVITY_COUNT)
        let countC:CountClass = CountClass()
        var isOver:Bool = false
        maxMET = 0;
        for kist:KistWrapper in kistList {
            var diffMET:Float=0;
            if(kist.act_index == ActivityDB.INDEX_RUN) {
                countC.run.count += 1;
                if(countC.run.count >= 6) {
                    over2Min[countC.run.arrayIdx] = true;
                    diffMET = ActivityDB.MET_RUN_HIGH;
                }
            } else if(kist.act_index == ActivityDB.INDEX_WALK) {
                countC.walk.count += 1;
                if(countC.walk.count >= 6) {
                    over2Min[countC.walk.arrayIdx] = true;
                    diffMET = ActivityDB.MET_WALK_HIGH;
                }
            } /*else if(kist.act_index == ActivityDB.INDEX_GOLF) {
                 countC.golf.count++;
                 if(countC.golf.count >= 1) {
                 over2Min[countC.golf.arrayIdx] = true;
                 diffMET = ActivityDB.MET_GOLF_LOW;
                 }
             }*/ else if(kist.act_index == ActivityDB.INDEX_STAND) {
                countC.stand.count += 1;
                if(countC.stand.count >= 6) {
                    over2Min[countC.stand.arrayIdx] = true;
                    diffMET = ActivityDB.MET_STAND_MID;
                }
            } else if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE) { // 점프 운동
                countC.jump_act.count = countC.jump_act.count+1;
                if(countC.jump_act.count >= 3) {
                    over2Min[countC.jump_act.arrayIdx] = true;
                    diffMET = ActivityDB.MET_JUMPING_ACT_HIGH;
                }
                /*
                 countC.jump_rope.count++;
                 if(countC.jump_rope.count >= 3) {
                 over2Min[countC.jump_rope.arrayIdx] = true;
                 diffMET = ActivityDB.MET_JUMP_ROPE_LOW;
                 }*/
            } else if(kist.act_index == ActivityDB.INDEX_TENNIS || kist.act_index == ActivityDB.INDEX_TABLE_TENNIS) { // 스윙 운동
                countC.swing_act.count += 1;
                if(countC.swing_act.count >= 6) {
                    over2Min[countC.swing_act.arrayIdx] = true;
                    diffMET = ActivityDB.MET_SWING_ACT_HIGH;
                }
                /*
                 countC.tennis.count++;
                 if(countC.tennis.count >= 6) {
                 over2Min[countC.tennis.arrayIdx] = true;
                 diffMET = ActivityDB.MET_TENNIS;
                 }*/
            }
            
            if(diffMET > maxMET) {
                maxMET = diffMET;
                
                resultOver.act_index = kist.act_index;
                resultOver.MET = maxMET;
                isOver = true;
            }
        }
        // 탁구 한번 더 체크함. 테니스가 flag가 켜지지 않은 경우만, 테니스의 우선순위가 높음.
        /*
         if(!over2Min[countC.tennis.arrayIdx])
         for(KistWrapper kist : kistList) {
         float diffMET = 0;
         if(kist.act_index == ActivityDB.INDEX_TABLE_TENNIS || kist.act_index == ActivityDB.INDEX_TENNIS) {
         countC.table_tennis.count++;
         if(countC.table_tennis.count >= 6) {
         over2Min[countC.table_tennis.arrayIdx] = true;
         diffMET = ActivityDB.MET_TABLE_TENNIS;
         }
         }
         
         if(diffMET > resultOver.MET) {
         resultOver.act_index = ActivityDB.INDEX_TABLE_TENNIS;
         resultOver.MET = diffMET;
         isOver = true;
         }
         }
         */
        
        // 체크가 다 끝났음. 체크된 운동이 여러개면 MET 비교해야함. 그러면 MET를 알아야되. 근데 MET가 여러개인 운동이 있어...? -> 각 운동의 최대 MET로 비교.
        if(isCon && isOver) {
            // 둘다 존재하면 MET 비교.
            if(resultCon.MET >= resultOver.MET) {
                return resultCon;
            }
            else {
                return resultOver;
            }
        } else if(isCon) {
            return resultCon;
        } else if(isOver){
            return resultOver;
        } else {
            // 여긴 아무런 flag도 스지 않음. 그럼 들어있는 모든 idx를 탐색해서 가장 높은 MET 선택. -> ...일상활동으로 변경.
            if(BehaviorManager.DEBUG){
                Log.d(BehaviorManager.tag, msg: "is Chaos!!");
            }
            
            return estimateActivity(kistList: kistList, ref_count: 5);
        }
    }
    
    
    func estimateKistOut(kistList:inout Array<KistWrapper>) -> KistWrapper {
        //kistList_save = (ArrayList<KistWrapper>) kistList.clone();
        layer_1(kistList: &kistList);
        // debug
        if(BehaviorManager.DEBUG) {
            Log.d(BehaviorManager.tag, msg: "layer_1 over");
            for kist:KistWrapper in kistList {
                Log.d(BehaviorManager.tag, msg: "act idx : \(kist.act_index)");
            }
        }
        return layer_2(kistList: &kistList);
    }
    
    
    
    // 스윙은???
    /** 전체적으로 모든 행동은 고정적으로 step이 발생하며, 포함시켜야 한다. 하지만 10분 중 사용할 1분을 선택하는 행동의 경우 선택된 행동의 데이터만 포함된다. **/
    func summuryKistOut(kistList:inout Array<KistWrapper>, time:[Int64]) -> KistWrapper {
        let status_golf:Int = 0
        let status_clm:Int = 0
        var status_slp:Int = 0
        var slp:KistWrapper?
        var clm:KistWrapper?
        var golf:KistWrapper?
        
        
        let disUse:KistWrapper? = estimateDisuse(kistList: kistList)
        var isDisuse:Bool = false
        if(disUse != nil) {
            isDisuse = true;
            Log.d(BehaviorManager.tag, msg: "disUse flag Set");
        }
        //status_slp = Preference.getSleepFlagStatus(getContext());
        status_slp = Int(Preference.getSleepFlagStatus());
        /*
         status_golf = InnerEditor.getGolfFlagStatus(mContext);
         status_clm = InnerEditor.getClimbingFlagStatus(mContext);
         */
        
        var result:KistWrapper = estimateKistOut(kistList: &kistList);
        //saveDb(getSDPath(), kistList, kistList_save, getFileNameDateFormat(BLEManager.getMac()+"-Planner+"), time[0]);
        //debug
        if(BehaviorManager.DEBUG) {
            Log.d(BehaviorManager.tag, msg: "layer_2 over");
            for kist:KistWrapper in kistList {
                Log.d(BehaviorManager.tag, msg: "act idx : \(kist.act_index)");
            }
            
            Log.d(BehaviorManager.tag, msg: "status slp: \(status_slp) clm:\(status_clm) golf:\(status_golf)");
        }
        
        slp = estimateSleep(kistList: &kistList, time: time, disUse: isDisuse);
        if(slp?.isSlp)! {
            Log.i(BehaviorManager.tag, msg: "estimate Sleep ->idx:\(String(describing: slp?.act_index))");
            result = slp!;
        } else {
            Log.i(BehaviorManager.tag, msg: "estimate idx:\(result.act_index)");
            // 밑에서 Index가 판별되면, 가장 마지막에 속도(강도) 계산. 강도가 나오면 MET로 calorie 계산.
            if(result.act_index == ActivityDB.INDEX_STAND){
                result = estimateRest(kistList: kistList);
            }
            else if(result.act_index == ActivityDB.INDEX_WALK){
                result = estimateWalk(kistList: &kistList);
            }
            else if(result.act_index == ActivityDB.INDEX_RUN){
                result = estimateRun(kistList: &kistList, time: time);
            }
            else if(result.act_index == ActivityDB.INDEX_WALK_STAIR){
                result = estimateWalkStair(kistList: kistList);
            }
            else if(result.act_index == ActivityDB.INDEX_JUMP_ROPE) { // 점핑
                //if(!compareTime(time[0], timeList) && !compareTime(time[0], timeManualList))
                if(compareTime(time: time[0], timeList: timeManualList)){
                    result = estimateJumpingRope(kistList: &kistList, time: time);
                }
                else{
                    result = estimateJumpAct(kistList: &kistList, time: time);
                }
                /*
                 if(SET_EXERCISE_TABLE == RECOMMENDED_EXERCISE_NON_TABLE) {
                 result = estimateJumpAct(kistList);
                 } else if(!compareTime(time[0], SET_EXERCISE_TABLE == RECOMMENDED_EXERCISE_TABLE ? timeList : timeManualList)) {
                 result = estimateJumpingRope(kistList);
                 }
                 */
            } else if(result.act_index == ActivityDB.INDEX_BICYCLING){
                result = estimateBicycling(kistList: kistList);
            }
            else if(result.act_index == ActivityDB.INDEX_TABLE_TENNIS || result.act_index == ActivityDB.INDEX_TENNIS) {// 스윙
                //if(!compareTime(time[0], timeList) && !compareTime(time[0], timeManualList))
                if(compareTime(time: time[0], timeList: timeManualList)){
                    result = estimateTennisNTableTennis(kistList: kistList);
                }
                else{
                    result = estimateSwingAct(kistList: kistList);
                }
                /*
                 if(SET_EXERCISE_TABLE == RECOMMENDED_EXERCISE_NON_TABLE) {
                 result = estimateSwingAct(kistList);
                 } else if(!compareTime(time[0], SET_EXERCISE_TABLE == RECOMMENDED_EXERCISE_TABLE ? timeList : timeManualList)) {
                 result = estimateTennisNTableTennis(kistList);
                 }
                 */
            }
                /*
                 else if(result.act_index == ActivityDB.INDEX_TABLE_TENNIS) // 스윙
                 result = estimateTableTennis(kistList);
                 else if(result.act_index == ActivityDB.INDEX_TENNIS) // 스윙
                 result = estimateTennis(kistList);
                 */
            else if(result.act_index == ActivityDB.INDEX_GOLF){
                result = estimateGolf(kistList: kistList, time: time, disUse: isDisuse);
            }
            /*else if(result.act_index == ActivityDB.INDEX_CLIMBING)
             result = estimateClimbing(kistList, time, isDisuse);
             else if(result.act_index == ActivityDB.INDEX_GOLF)
             result = estimateGolf(kistList, time, isDisuse, result.act_index);*/
            
            
            /*if(result.act_index != ActivityDB.INDEX_SLEEP)
             result = finalResult(kistList, result.act_index);*/
        }
        // estimate를 거치면 step, swing, idx, met, intensity가 채워져있음.
        
        // 등산이 시작된 경우 판단. (기압 누적, 등산 끝) -> 이제 아래 코드는 다 쓰지 않음. 한곳에서 end 판정 같이 함.
        /*if(InnerEditor.getClimbingFlagStatus(mContext) == CLM_STATUS_START)
         estimateClimbingEnd(kistList, time, cumulativePress(press));
         
         if(InnerEditor.getGolfFlagStatus(mContext) == GOLF_STATUS_START)
         estimateGolfEnd(result.act_index, time, isDisuse);*/
        if let tmp:KistWrapper = estimateClimbing(kistList: kistList, time: time, disUse: isDisuse, act_index: result.act_index) {
            result = tmp
        }
        
        result = estimateFinal(kistList: kistList, result: result);
        
        // theta 요청 사항. step 관련 임시 코드. 나중에 확정되면 고쳐야함.
        //estimateStepInfo(kistList, time);
        if(isDisuse) {
            result = disUse!;
        }
        
        //Preference.putGolfPreActivity(Int32(result.act_index));
        
        return result;
    }
    
    
    
    func estimateRest(kistList:Array<KistWrapper>) -> KistWrapper {
        var result:KistWrapper = KistWrapper();
        var rest_count_stand:Int = 0
        var rest_count_daily:Int = 0
        var rest_count_light:Int = 0
        var step_count_stand:Int = 0
        var step_count_daily:Int = 0
        var step_count_light:Int = 0
        var swing_count_stand:Int = 0
        var swing_count_daily:Int = 0
        var swing_count_light:Int = 0
        var SORT_LEN:Int = 3
        var SORT_COUNT:Int = 0
        var tStep:Int = 0
        var tSwing:Int = 0
        
        //SortIdx[] sortList = new SortIdx[SORT_LEN];
        //var sortList = Array(repeating: SortIdx, count : SORT_LEN)
        //for(int i=0; i<SORT_LEN; i++){
        /*for i in 0..<SORT_LEN {
         sortList[i] = SortIdx();
         }*/
        
        // 굳이 clone 필요없음. 순서를 체크하는 것이 아님.
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_STAND) {
                rest_count_stand += 1;
                step_count_stand += kist.step;
                swing_count_stand += kist.swing + kist.small_swing + kist.large_swing;
                //if(BehaviorManager.DEBUG){
                //    Log.d(BehaviorManager.tag, msg: "rest->count++");//jeyang
                //}
            }
            tStep += kist.step;
            tSwing += kist.swing + kist.small_swing + kist.large_swing;
        }
        
        result.step = tStep;
        result.swing = tSwing;
        
        if(9 <= rest_count_stand && rest_count_stand <= 10) {
            result.act_index = ActivityDB.INDEX_STAND;
            result.intensity = Float(ActivityDB.STRENGTH_LOW);
            result.MET = ActivityDB.MET_STAND_LOW;
        } else {
            result = estimateActivity(kistList: kistList, ref_count: 5);
        }
        return result;
    }
    
    func getMETfromSpeed(act_index:Int, speed:Float) -> Float {
        var MET:Float = 0
        switch(act_index) {
        case ActivityDB.INDEX_WALK:
            if(speed <= 3.6) {
                MET = ActivityDB.MET_WALK_LOW;
            } else if(3.6 < speed && speed <= 4.5) {
                MET = ActivityDB.MET_WALK_MID;
            } else if(4.5 < speed && speed <= 5.4) {
                MET = ActivityDB.MET_WALK_HIGH;
            } else{
                MET = ActivityDB.MET_WALK_HIGH;
                break;
            }
        default: break
        }
        return MET
    }
    
    func estimateWalk( kistList:inout Array<KistWrapper>) -> KistWrapper {
        let result:KistWrapper = KistWrapper();
        var walk_count_low:Int = 0
        var walk_count_mid:Int = 0
        var walk_count_high:Int = 0
        var walkfast_count_low:Int = 0
        var walk_stepcount_low:Int = 0
        var walk_stepcount_mid:Int = 0
        var walk_stepcount_high:Int = 0
        var walkfast_stepcount_low:Int = 0
        var walk_swingcount_low:Int = 0
        var walk_swingcount_mid:Int = 0
        var walk_swingcount_high:Int = 0
        var walkfast_swingcount_low:Int = 0
        var tStep:Int = 0
        var tSwing:Int = 0
        var tIntensity:Int = 0;
        
        let profile:Contact.Profile = DBContactHelper.getInstance().PLgetUserProfile()//(mDBHelper?.getUserProfile())!;
        
        var isUp:Bool = false
        var isDown = false
        
        var sum_press:Float = 0
        var speed:Float = 0
        
        
        // 굳이 clone 필요없음. 순서를 체크하는 것이 아님.
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_WALK) {
                speed = getSpeedForRecommended(act_index: ActivityDB.INDEX_WALK, step: kist.step);
                if(speed < 3) {
                    walk_count_low += 1
                    walk_stepcount_low += kist.step;
                    walk_swingcount_low += kist.swing + kist.small_swing + kist.large_swing;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_LOW), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "walk->walk_count_low++");//jeyang
                    }
                } else if(3 <= speed && speed < 4.5) {
                    walk_count_mid += 1
                    walk_stepcount_mid += kist.step;
                    walk_swingcount_mid += kist.swing + kist.small_swing + kist.large_swing;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_MIDDLE), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "walk->walk_count_mid++");//jeyang
                    }
                } else if(4.5 <= speed && speed < 5.5) {
                    walk_count_high += 1
                    walk_stepcount_high += kist.step;
                    walk_swingcount_high += kist.swing + kist.small_swing + kist.large_swing;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_HIGH), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "walk->walk_count_high++");//jeyang
                    }
                } else {
                    walkfast_count_low += 1
                    walkfast_stepcount_low += kist.step;
                    walkfast_swingcount_low += kist.swing + kist.small_swing + kist.large_swing;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: ActivityDB.INDEX_WALK_FAST, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_HIGH), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "walk->walkfast_count_low++");//jeyang
                    }
                }
            } else {
                result.calorie += getConsumeCalorieBMR(weight: profile.getWeight(), time: 1);
            }
            tStep += kist.step;
            tSwing += kist.swing + kist.small_swing + kist.large_swing;
            sum_press += Float(kist.press_variance);
        }
        result.step = tStep;
        result.swing = tSwing;
        
        if(walk_count_low == 0 && walk_count_mid == 0 && walk_count_high == 0 && walkfast_count_low == 0) {
            result.act_index = ActivityDB.INDEX_DAILY_ACT;
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE);
            result.MET = ActivityDB.MET_DAILY_ACT_LOW;
            
            return result;
        }
        
        
        if(!(-4 < sum_press && sum_press < 4)) {
            if(sum_press <= -4){
                isUp = true;
            }
            else{
                isDown = true;
            }
        }
        
        // 경사걷기로 판단될 경우 다시 일괄 계산.
        if(isUp) {
            result.calorie = 0;
            
            var grade:Int = 0;
            if(-6 <= sum_press && sum_press < -4){
                grade = 2;
            }
            else if(-8 <= sum_press && sum_press < -6){
                grade = 3;
            }
            else if(sum_press <= -8){
                grade = 4;
            }
            
            for kist:KistWrapper in kistList {
                if(kist.act_index == ActivityDB.INDEX_WALK) {
                    speed = getSpeedForRecommended(act_index: ActivityDB.INDEX_WALK, step: kist.step);
                    if(speed < 3) {
                        result.calorie += getConsumeCalorieSlope(profile: profile, intensity: Float(ActivityDB.STRENGTH_LOW), grade: grade, index: ActivityDB.INDEX_WALK);
                        if(BehaviorManager.DEBUG){
                            Log.d(BehaviorManager.tag, msg: "walk slope->walk_count_low++");//jeyang
                        }
                    } else if(3 <= speed && speed < 4.5) {
                        result.calorie += getConsumeCalorieSlope(profile: profile,intensity: Float(ActivityDB.STRENGTH_MIDDLE), grade: grade, index: ActivityDB.INDEX_WALK);
                        if(BehaviorManager.DEBUG) {
                            Log.d(BehaviorManager.tag, msg: "walk slope->walk_count_mid++");//jeyang
                        }
                    } else if(4.5 <= speed && speed < 5.5) {
                        result.calorie += getConsumeCalorieSlope(profile: profile,intensity: Float(ActivityDB.STRENGTH_HIGH), grade: grade, index: ActivityDB.INDEX_WALK);
                        if(BehaviorManager.DEBUG){
                            Log.d(BehaviorManager.tag, msg: "walk slope->walk_count_high++");//jeyang
                        }
                    } else {
                        result.calorie += getConsumeCalorieSlope(profile: profile,intensity: Float(ActivityDB.STRENGTH_HIGH), grade: grade, index: ActivityDB.INDEX_WALK_FAST);
                        if(BehaviorManager.DEBUG){
                            Log.d(BehaviorManager.tag, msg: "walk slope->walkfast_count_low++");//jeyang
                        }
                    }
                } else {
                    result.calorie += getConsumeCalorieBMR(weight: profile.getWeight(), time: 1);
                }
            }
        }
        
        tIntensity = (walk_stepcount_low + walk_stepcount_mid + walk_stepcount_high + walkfast_stepcount_low) / (walk_count_low + walk_count_mid + walk_count_high + walkfast_count_low);
        speed = getSpeedForRecommended(act_index: ActivityDB.INDEX_WALK, step: tIntensity);
        if(speed < 3) {
            result.act_index = ActivityDB.INDEX_WALK;
            result.intensity = Float(ActivityDB.STRENGTH_LOW);
            result.MET = ActivityDB.MET_WALK_LOW;
        } else if(3 <= speed && speed < 4.5) {
            result.act_index = ActivityDB.INDEX_WALK;
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE);
            result.MET = ActivityDB.MET_WALK_MID;
        } else if(4.5 <= speed && speed < 5.5) {
            result.act_index = ActivityDB.INDEX_WALK;
            result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            result.MET = ActivityDB.MET_WALK_HIGH;
        } else {
            result.act_index = ActivityDB.INDEX_WALK_FAST;
            result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            result.MET = ActivityDB.MET_WALK_FAST_LOW;
        }
        result.coach_intensity = Float(tIntensity);
        result.speed = speed;
        if(isUp){
            result.act_index = ActivityDB.INDEX_WALK_SLOPE;
        }
        
        return result;
    }
    
    // 현재 보폭이 제대로 나오지 않으므로 전부다 임시로 estimate에서 계산하고 있음. final에서 해야되는디..
    func estimateRun(kistList:inout Array<KistWrapper>, time:[Int64]) -> KistWrapper {
        var result:KistWrapper = KistWrapper()
        var tmp_result:KistWrapper?
        var run_count_low:Int = 0
        var run_count_mid:Int = 0
        var run_count_high:Int = 0
        var run_stepcount_low:Int = 0
        var run_stepcount_mid:Int = 0
        var run_stepcount_high:Int = 0
        var run_swingcount_low:Int = 0
        var run_swingcount_mid:Int = 0
        var run_swingcount_high:Int = 0
        var tStep:Int = 0
        var tSwing:Int = 0
        var tIntensity:Int = 0
        var ss_over_count:Int = 0
        var idx_count = 0
        var isRun:Bool = false
        var isJump:Bool = false
        
        let profile:Contact.Profile = DBContactHelper.getInstance().PLgetUserProfile()
        
        var speed:Float = 0
        
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE || kist.act_index == ActivityDB.INDEX_RUN) {
                idx_count += 1
                if(kist.small_swing >= 16) {
                    ss_over_count += 1
                }
            }
        }
        if( Float(ss_over_count/idx_count) >= 2/3 ) {
            isRun = true
        } else if( (idx_count - ss_over_count) >= 3 ) {
            isJump = true
        }
        
        if(!isRun && !isJump) {
            if(BehaviorManager.DEBUG){
                Log.d(BehaviorManager.tag, msg:  "not over count : run->rest");//jeyang
            }
            return estimateRest(kistList: kistList);
        }
        
        
        //for(int i=0; i<kistList.size(); i++) {
        for i in 0..<kistList.count{
            if(kistList[i].act_index == ActivityDB.INDEX_JUMP_ROPE || kistList[i].act_index == ActivityDB.INDEX_RUN) {
                tmp_result = kistList[i];
                if(isRun) {
                    tmp_result?.act_index = ActivityDB.INDEX_RUN;
                    //kistList.set(i, tmp_result);
                    kistList.insert(tmp_result!, at: i)
                } else if(isJump) {
                    tmp_result?.act_index = ActivityDB.INDEX_JUMP_ROPE;
                    //kistList.set(i, tmp_result);
                    kistList.insert(tmp_result!, at: i)
                }
            }
        }
        if(isJump) {
            if(compareTime(time: time[0], timeList: timeManualList)){
                result = estimateJumpingRope(kistList: &kistList, time: time)
            }
            else{
                result = estimateJumpAct(kistList: &kistList, time: time)
            }
            return result;
        }
        
        // 굳이 clone 필요없음. 순서를 체크하는 것이 아님.
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_RUN) {
                speed = getSpeedForRecommended(act_index: ActivityDB.INDEX_RUN, step: kist.swing);
                if(speed < 6.1) {
                    //|| speed < ActivityDB.SPEED_RUN_LOW) {
                    run_count_low += 1;
                    run_stepcount_low += kist.step;
                    run_swingcount_low += kist.swing;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_LOW), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "run->run_count_low++");//jeyang
                    }
                } else if(6.1 <= speed && speed < 7) {
                    run_count_mid += 1;
                    run_stepcount_mid += kist.step;
                    run_swingcount_mid += kist.swing;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_MIDDLE), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "run->run_count_mid++");//jeyang
                    }
                } else {
                    run_count_high += 1;
                    run_stepcount_high += kist.step;
                    run_swingcount_high += kist.swing;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_HIGH), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "run->run_count_high++");//jeyang
                    }
                }
            } else if(kist.act_index == ActivityDB.INDEX_WALK) {
                speed = getSpeedForRecommended(act_index: ActivityDB.INDEX_WALK, step: kist.step);
                if(speed < 3) {
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_LOW), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "run->walk_count_low++");//jeyang
                    }
                } else if(3 <= speed && speed < 4.5) {
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_MIDDLE), heartrate: 0);
                    if(BehaviorManager.DEBUG) {
                        Log.d(BehaviorManager.tag, msg: "run->walk_count_mid++");//jeyang
                    }
                } else if(4.5 <= speed && speed < 5.5) {
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_HIGH), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "run->walk_count_high++");//jeyang
                    }
                } else {
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: ActivityDB.INDEX_WALK_FAST, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_HIGH), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "run->walkfast_count_low++");//jeyang
                    }
                }
            } else {
                result.calorie += getConsumeCalorieBMR(weight: profile.getWeight(), time: 1);
            }
            tStep += kist.step;
            tSwing += kist.swing + kist.small_swing + kist.large_swing;
        }
        result.step = tStep;
        result.swing = tSwing;
        
        if(run_count_low == 0 && run_count_mid == 0 && run_count_high == 0) {
            result.act_index = ActivityDB.INDEX_DAILY_ACT;
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE);
            result.MET = ActivityDB.MET_DAILY_ACT_LOW;
            
            return result;
        }
        
        tIntensity = (run_swingcount_low + run_swingcount_mid + run_swingcount_high) / (run_count_low + run_count_mid + run_count_high);
        speed = getSpeedForRecommended(act_index: ActivityDB.INDEX_RUN, step: tIntensity);
        if(speed < 6.1) {
            result.act_index = ActivityDB.INDEX_RUN;
            result.intensity = Float(ActivityDB.STRENGTH_LOW);
            result.MET = ActivityDB.MET_RUN_LOW;
        } else if(6.1 <= speed && speed < 7) {
            result.act_index = ActivityDB.INDEX_RUN;
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE);
            result.MET = ActivityDB.MET_RUN_MID;
        } else {
            result.act_index = ActivityDB.INDEX_RUN;
            result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            result.MET = ActivityDB.MET_RUN_HIGH;
        }
        
        //result.coach_intensity = run_swingcount_low + run_swingcount_mid + run_swingcount_high;
        result.speed = speed;
        result.coach_intensity = Float(tIntensity);
        
        return result;
    }
    
    /**
     * 이미 계단 1분 판단을 앞쪽에서 하므로 여기는 정말 계단으로 판정된 애들만 들어오니까 그냥 index로 판단하면 됨.
     * 결국 여기로 들어오면 그냥 계단 조건에 만족함. 기압 체크 불 필요.
     * @param kistList
     * @param press
     * @return
     */
    func estimateWalkStair(kistList:Array<KistWrapper>) -> KistWrapper{
        let result:KistWrapper = KistWrapper();
        
        //float thr = -0.07f;
        var i:Int = 0
        //Log.d(BehaviorManager.tag, msg: "walk stair->first preVariancePerStep:"+preVariancePerStep);
        
        var stair_count_low:Int = 0
        var stair_count_high:Int = 0
        var stair_stepcount_low:Int = 0
        var stair_stepcount_high:Int = 0
        var stair_swingcount_low:Int = 0
        var stair_swingcount_high:Int = 0
        var tStep:Int = 0
        var tSwing:Int = 0
        var tIntensity:Int = 0;
        
        let profile:Contact.Profile = DBContactHelper.getInstance().PLgetUserProfile()
        
        // 이미 연속 체크가 실행된 데이터로 연속여부 판단 필요 없음.
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_WALK_STAIR) {
                if(kist.step <= 50) {
                    stair_stepcount_low += kist.step;
                    stair_swingcount_low += kist.swing + kist.small_swing + kist.large_swing;
                    stair_count_low += 1;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_LOW), heartrate: 0);
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "walk stair->stair_count_low++");//jeyang
                    }
                } else {
                    stair_stepcount_high += kist.step;
                    stair_swingcount_high += kist.swing + kist.small_swing + kist.large_swing;
                    stair_count_high += 1;
                    result.calorie += getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: kist.act_index, jobIndex: Int(profile.getJob()), isAct: true, intensity: Float(ActivityDB.STRENGTH_HIGH), heartrate: 0);
                    if(BehaviorManager.DEBUG) {
                        Log.d(BehaviorManager.tag, msg: "walk stair->stair_count_high++");//jeyang
                    }
                }
            } else {
                result.calorie += getConsumeCalorieBMR(weight: profile.getWeight(), time: 1);
            }
            tStep += kist.step;
            tSwing += kist.swing + kist.small_swing + kist.large_swing;
        }
        result.step = tStep;
        result.swing = tSwing;
        
        if(stair_count_low == 0 && stair_count_high == 0 ) {
            result.act_index = ActivityDB.INDEX_DAILY_ACT;
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE);
            result.MET = ActivityDB.MET_DAILY_ACT_LOW;
            
            return result;
        }
        
        tIntensity = (stair_stepcount_low + stair_stepcount_high)/(stair_count_low + stair_count_high);
        if(tIntensity <= 50) {
            result.act_index = ActivityDB.INDEX_WALK_STAIR;
            result.intensity = Float(ActivityDB.STRENGTH_LOW);
            result.MET = ActivityDB.MET_WALK_STAIR_LOW;
        } else {
            result.act_index = ActivityDB.INDEX_WALK_STAIR;
            result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            result.MET = ActivityDB.MET_WALK_STAIR_HIGH;
        }
        
        //result.stair = (stair_stepcount_low + stair_stepcount_high)/(stair_count_low + stair_count_high);
        result.coach_intensity = Float(tIntensity);
        /*
         result.act_index = getLargestIndex(sortList);
         if(result.act_index == ActivityDB.INDEX_WALK_STAIR) {
         result.act_index = ActivityDB.INDEX_WALK_STAIR;
         result.intensity = ActivityDB.STRENGTH_LOW; // 계단수가 들어가야함? 일단은....
         result.MET = ActivityDB.MET_WALK_STAIR_LOW;
         } else {
         result.act_index = ActivityDB.INDEX_WALK_STAIR;
         result.intensity = ActivityDB.STRENGTH_HIGH;
         result.MET = ActivityDB.MET_WALK_STAIR_HIGH;
         }
         */
        return result;
    }
    
    func estimateJumpAct(kistList:inout Array<KistWrapper>, time:[Int64]) -> KistWrapper {
        var result:KistWrapper = KistWrapper()
        var tmp_result:KistWrapper?
        var JAct_count_stand:Int = 0
        var tStep:Int = 0
        var tSwing:Int = 0
        var ss_over_count:Int = 0
        var idx_count:Int = 0
        var isRun:Bool = false
        var isJump:Bool = false
        
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE || kist.act_index == ActivityDB.INDEX_RUN) {
                idx_count += 1;
                if(kist.small_swing >= 16){
                    ss_over_count += 1;
                }
            }
        }
        if( Float(ss_over_count/idx_count) >= 2/3 ) {
            isRun = true;
        } else if( (idx_count-ss_over_count) >= 3 ) {
            isJump = true;
        }
        
        //for(int i=0; i<kistList.size(); i++) {
        for i in 0..<kistList.count {
            if(kistList[i].act_index == ActivityDB.INDEX_JUMP_ROPE || kistList[i].act_index == ActivityDB.INDEX_RUN) {
                tmp_result = kistList[i]
                if(isRun) {
                    tmp_result?.act_index = ActivityDB.INDEX_RUN;
                    //kistList.set(i, tmp_result);
                    kistList.insert(tmp_result!, at: i)
                } else if(isJump) {
                    tmp_result?.act_index = ActivityDB.INDEX_JUMP_ROPE;
                    //kistList.set(i, tmp_result);
                    kistList.insert(tmp_result!, at: i)
                }
            }
        }
        if(isRun) {
            if(BehaviorManager.DEBUG){
                Log.d(BehaviorManager.tag, msg:  "not over count : jAct->Run");//jeyang
            }
            return estimateRun(kistList: &kistList, time: time)
        }
        
        return estimateActivity(kistList: kistList, ref_count: 3)
        // 굳이 clone 필요없음. 순서를 체크하는 것이 아님.
        /*for(KistWrapper kist : kistList) {
         if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE) {
         JAct_count_stand++;
         if(BehaviorManager.DEBUG)
         Log.d(BehaviorManager.tag, msg: "JAct->count++");//jeyang
         }
         tStep += kist.step;
         tSwing += kist.swing + kist.small_swing + kist.large_swing;
         }
         
         result.step = tStep;
         result.swing = tSwing;
         
         if(3 <= JAct_count_stand && JAct_count_stand <= 4) {
         result.act_index = ActivityDB.INDEX_JUMPING_ACT; // 점프 운동으로 교체 필요.
         result.intensity = ActivityDB.STRENGTH_LOW;
         result.MET = ActivityDB.MET_JUMPING_ACT_LOW;
         } else if(5 <= JAct_count_stand && JAct_count_stand <= 6) {
         result.act_index = ActivityDB.INDEX_JUMPING_ACT;
         result.intensity = ActivityDB.STRENGTH_MIDDLE;
         result.MET = ActivityDB.MET_JUMPING_ACT_MID;
         } else {
         result.act_index = ActivityDB.INDEX_JUMPING_ACT;
         result.intensity = ActivityDB.STRENGTH_HIGH;
         result.MET = ActivityDB.MET_JUMPING_ACT_HIGH;
         }
         return result;*/
    }
    
    func estimateSwingAct(kistList:Array<KistWrapper>) ->KistWrapper  {
        return estimateActivity(kistList: kistList, ref_count: 6)
        /*KistWrapper result = new KistWrapper();
         int SAct_count_stand=0;
         int SORT_LEN=3, SORT_COUNT=0;
         int tStep = 0, tSwing = 0;
         
         SortIdx[] sortList = new SortIdx[SORT_LEN];
         for(int i=0; i<SORT_LEN; i++)
         sortList[i] = new SortIdx();
         
         // 굳이 clone 필요없음. 순서를 체크하는 것이 아님.
         for(KistWrapper kist : kistList) {
         if(kist.act_index == ActivityDB.INDEX_TENNIS || kist.act_index == ActivityDB.INDEX_TABLE_TENNIS) {
         SAct_count_stand++;
         if(BehaviorManager.DEBUG)
         Log.d(BehaviorManager.tag, msg: "SAct->count++");//jeyang
         }
         tStep += kist.step;
         tSwing += kist.swing + kist.small_swing + kist.large_swing;
         }
         
         result.step = tStep;
         result.swing = tSwing;
         
         if(SAct_count_stand == 6) {
         result.act_index = ActivityDB.INDEX_SWING_ACT; // 스윙 운동으로 교체 필요.
         result.intensity = ActivityDB.STRENGTH_LOW;
         result.MET = ActivityDB.MET_SWING_ACT_LOW;
         } else if(7 <= SAct_count_stand && SAct_count_stand <= 8) {
         result.act_index = ActivityDB.INDEX_SWING_ACT;
         result.intensity = ActivityDB.STRENGTH_MIDDLE;
         result.MET = ActivityDB.MET_SWING_ACT_MID;
         } else {
         result.act_index = ActivityDB.INDEX_SWING_ACT;
         result.intensity = ActivityDB.STRENGTH_HIGH;
         result.MET = ActivityDB.MET_SWING_ACT_HIGH;
         }
         return result;*/
    }
    
    func estimateJumpingRope(kistList:inout Array<KistWrapper>, time:[Int64]) -> KistWrapper {
        let result:KistWrapper = KistWrapper()
        var tmp_result:KistWrapper?
        var jp_count_low:Int = 0
        var jp_count_mid:Int = 0
        var jp_count_high:Int = 0
        var    jp_swingcount_low:Int = 0
        var jp_swingcount_mid:Int = 0
        var jp_swingcount_high:Int = 0
        var jp_stepcount_low:Int = 0
        var jp_stepcount_mid:Int = 0
        var jp_stepcount_high:Int = 0
        var SORT_LEN:Int = 3
        var SORT_COUNT:Int = 0
        var tStep:Int = 0
        var tSwing:Int = 0
        var ss_over_count:Int = 0
        var idx_count:Int = 0
        var isRun:Bool = false
        var isJump:Bool = false
        
        // intensity에 속도가 들어가있음. 현재 값이 넘어오지 않음. 따라서 variance를 보고 속도를 계산해야됨.
        
        //규창...?
        //var sortList = [BehaviorManager.SortIdx](repeating: 0, count : SORT_LEN)
        var sortList = [SortIdx]()
        /*SortIdx[] sortList = new SortIdx[SORT_LEN];
         for(int i=0; i<SORT_LEN; i++)
         sortList[i] = new SortIdx();*/
        
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE || kist.act_index == ActivityDB.INDEX_RUN) {
                idx_count += 1
                if(kist.small_swing >= 16) {
                    ss_over_count += 1
                }
            }
        }
        if(Float(ss_over_count/idx_count) >= 2/3 ) {
            isRun = true;
        } else if( (idx_count-ss_over_count) >= 3 ) {
            isJump = true;
        }
        
        if(!isRun && !isJump) {
            if(BehaviorManager.DEBUG){
                Log.d(BehaviorManager.tag, msg:  "not over count : jumpingrope->jAct");//jeyang
            }
            return estimateJumpAct(kistList: &kistList, time: time);
        }
        
        //for(int i=0; i<kistList.size(); i++) {
        for i in 0..<kistList.count {
            if(kistList[i].act_index == ActivityDB.INDEX_JUMP_ROPE || kistList[i].act_index == ActivityDB.INDEX_RUN) {
                tmp_result = kistList[i];
                if(isRun) {
                    tmp_result?.act_index = ActivityDB.INDEX_RUN;
                    //kistList.set(i, tmp_result);
                    kistList.insert(tmp_result!, at: i)
                } else if(isJump) {
                    tmp_result?.act_index = ActivityDB.INDEX_JUMP_ROPE;
                    //kistList.set(i, tmp_result);
                    kistList.insert(tmp_result!, at: i)
                }
            }
        }
        if(isRun) {
            if(BehaviorManager.DEBUG){
                Log.d(BehaviorManager.tag, msg:  "not over count : jumpingrope->Run");//jeyang
            }
            return estimateRun(kistList: &kistList, time: time);
        }
        
        // 굳이 clone 필요없음. 순서를 체크하는 것이 아님.
        for kist:KistWrapper in kistList {
            if(kist.act_index == ActivityDB.INDEX_JUMP_ROPE) {
                if(kist.swing <= 100) {
                    jp_count_low += 1;
                    //jp_swingcount_low += kist.swing + kist.small_swing + kist.large_swing;
                    jp_swingcount_low += kist.swing;
                    jp_stepcount_low += kist.step;
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "jump->jp_count_low++");//jeyang
                    }
                } else if(101 <= kist.swing && kist.swing <= 120) {
                    jp_count_mid += 1;
                    //jp_swingcount_mid += kist.swing + kist.small_swing + kist.large_swing;
                    jp_swingcount_mid += kist.swing;
                    jp_stepcount_mid += kist.step;
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "jump->jp_count_mid++");//jeyang
                    }
                } else {
                    jp_count_high += 1;
                    //jp_swingcount_high += kist.swing + kist.small_swing + kist.large_swing;
                    jp_swingcount_high += kist.swing;
                    jp_stepcount_high += kist.step;
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "jump->jp_count_high++");//jeyang
                    }
                }
            } /*else if(kist.act_index == ActivityDB.INDEX_RUN) {
             jp_count_low = jp_count_mid = jp_count_high = 0;
             break;
             }*/
        }
        
        for kist:KistWrapper in kistList {
            tStep += kist.step;
            tSwing += kist.swing + kist.small_swing + kist.large_swing;
        }
        result.step = tStep;
        result.swing = tSwing;
        
        if(jp_count_low == 0 && jp_count_mid == 0 && jp_count_high == 0) {
            result.act_index = ActivityDB.INDEX_DAILY_ACT;
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE);
            result.MET = ActivityDB.MET_DAILY_ACT_LOW;
            
            return result;
        }
        
        sortList[SORT_COUNT].act_index = ActivityDB.INDEX_JUMP_ROPE;
        sortList[SORT_COUNT].count = jp_count_low;
        
        SORT_COUNT += 1;
        sortList[SORT_COUNT].act_index = ActivityDB.INDEX_JUMP_ROPE+1;
        sortList[SORT_COUNT].count = jp_count_mid;
        
        SORT_COUNT += 1;
        sortList[SORT_COUNT].act_index = ActivityDB.INDEX_JUMP_ROPE+2;
        sortList[SORT_COUNT].count = jp_count_high;
        
        result.coach_intensity = Float((jp_swingcount_low + jp_swingcount_mid + jp_swingcount_high)/(jp_count_low + jp_count_mid + jp_count_high));
        result.act_index = getLargestIndex(sortList: sortList);
        if(result.act_index == ActivityDB.INDEX_JUMP_ROPE) {
            result.act_index = ActivityDB.INDEX_JUMP_ROPE;
            result.intensity = Float(ActivityDB.STRENGTH_LOW);
            result.MET = ActivityDB.MET_JUMP_ROPE_LOW;
        } else if(result.act_index == ActivityDB.INDEX_JUMP_ROPE+1) {
            result.act_index = ActivityDB.INDEX_JUMP_ROPE;
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE);
            result.MET = ActivityDB.MET_JUMP_ROPE_MID;
        } else {
            result.act_index = ActivityDB.INDEX_JUMP_ROPE;
            result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            result.MET = ActivityDB.MET_JUMP_ROPE_HIGH;
        }
        return result;
    }
    
    // 골프 스윙이 무조건 1개 발생하면 골프!!
    // 골프 스윙 idx를 준다고 한다. 현재는 골프 idx를 골프 스윙이라고 보자.
    // 10분이 골프고 이 전 10분이 골프->시작 , 발생 10분전 이 안정or걷기
    func estimateGolf(kistList:Array<KistWrapper>, time:[Int64], disUse:Bool) -> KistWrapper {
        let result:KistWrapper = KistWrapper();
        var pre_activity_index:Int = 0
        var valid_1:Bool = false
        var valid_2 = false
        let valid_3 = true
        
        pre_activity_index = Int(Preference.getGolfPreActivity());
        if(pre_activity_index == ActivityDB.INDEX_STAND || pre_activity_index == ActivityDB.INDEX_DAILY_ACT
            || pre_activity_index == ActivityDB.INDEX_WALK || pre_activity_index == ActivityDB.INDEX_GOLF) {
            if(BehaviorManager.DEBUG){
                Log.d(BehaviorManager.tag, msg: "valid 1 true");//jeyang
            }
            valid_1 = true;
        }
        
        //for(int i=0; i<kistList.size() ; i++) {
        for  i in 0..<kistList.count {
            if(kistList[i].act_index == ActivityDB.INDEX_GOLF) {
                // 앞뒤 1분이 안정/걷기 이어야 함. ->한번만 true가 발생하면 통과하는 것으로 변경.
                if(i == 0) {
                    if(kistList[i+1].act_index == ActivityDB.INDEX_STAND
                        || kistList[i+1].act_index == ActivityDB.INDEX_WALK
                        || kistList[i+1].act_index == ActivityDB.INDEX_GOLF
                        || kistList[i+1].act_index == ActivityDB.INDEX_BICYCLING) {
                        valid_2 = true
                    }
                } else if(i == 9){
                    if(kistList[i-1].act_index == ActivityDB.INDEX_STAND
                        || kistList[i-1].act_index == ActivityDB.INDEX_WALK
                        || kistList[i-1].act_index == ActivityDB.INDEX_GOLF
                        || kistList[i-1].act_index == ActivityDB.INDEX_BICYCLING) {
                        valid_2 = true
                    }
                } else {
                    if(kistList[i+1].act_index == ActivityDB.INDEX_STAND
                        || kistList[i+1].act_index == ActivityDB.INDEX_WALK
                        || kistList[i+1].act_index == ActivityDB.INDEX_GOLF
                        || kistList[i+1].act_index == ActivityDB.INDEX_BICYCLING) {
                        valid_2 = true
                    }
                    if(kistList[i-1].act_index == ActivityDB.INDEX_STAND
                        || kistList[i-1].act_index == ActivityDB.INDEX_WALK
                        || kistList[i-1].act_index == ActivityDB.INDEX_GOLF
                        || kistList[i-1].act_index == ActivityDB.INDEX_BICYCLING) {
                        valid_2 = true
                    }
                }
                
                if(valid_2) {
                    if(BehaviorManager.DEBUG){
                        Log.d(BehaviorManager.tag, msg: "valid 2 true idx:\(i)")//jeyang
                    }
                    break;
                }
            }
            
            /*if(kistList.get(i).act_index == ActivityDB.INDEX_TENNIS
             || kistList.get(i).act_index == ActivityDB.INDEX_TABLE_TENNIS) {
             valid_3 = false;
             break;
             }*/
        }
        
        if(BehaviorManager.DEBUG){
            Log.d(BehaviorManager.tag, msg: "valid 1:\(valid_1) valid 2:\(valid_2) valid 3:\(valid_3)")//jeyang
        }
        
        result.act_index = ActivityDB.INDEX_GOLF
        result.intensity = Float(ActivityDB.STRENGTH_LOW)
        result.MET = ActivityDB.MET_GOLF_LOW
        for kist:KistWrapper in kistList {
            result.step += kist.step
            result.swing += kist.swing + kist.small_swing + kist.large_swing
        }
        
        if(!valid_1 || !valid_2 || !valid_3) {
            result.act_index = ActivityDB.INDEX_DAILY_ACT
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE)
            result.MET = ActivityDB.MET_DAILY_ACT_LOW
        }
        
        return result
    }
    
    
    
    
    /**
     * 연속성 체크하는 것들은 항상 검사해야하므로 상위로 올라와야함. (골프, 등산, 수면). 즉, 1차 조건 검사를 내부에서 진행해야함.
     * 등산은 연속 6분이 조건이다. 시작, 끝을 여기서 모두 판단해야함. 수면처럼...
     * @param kistList
     * @param time
     * @return
     */
    // 등산은 강도가 '약'뿐. 대신 시작, 끝을 판별해야함. 등산이 발생하면 앞의 data 20분을 보고 총 30분간 등산판정을 받아야함.
    // 이곳에 들어왔다는건 이미 10분 데이터가 등산으로 판정이 완료되었음을 의미. 그럼 앞의 20분의 데이터만 보면 됨. 없으면? 현재는 없는데로...
    // 기압은 항상 계산해야함. 등산일때만 하는게 아니라...항상 밖에서 등산 시작을 체크하고 계산해야한다.
    // 기압도 밖에서 하고, 등산 끝도 밖에서 체크->등산 시작 flag 보고 판단.
    func estimateClimbing(kistList:Array<KistWrapper>, time:[Int64], disUse:Bool, act_index:Int) -> KistWrapper? {
        var result:KistWrapper = KistWrapper()
        
        var valid_1:Bool = true
        var valid_2:Bool = false
        var isWStair:Bool = false
        var pre_press_1:Float = 0
        var pre_press_2:Float = 0
        var pre_activity_index_1:Int = 0
        var pre_activity_index_2:Int = 0
        var tmp_count:Int = 0
        var sum_pre_press:Float = 0
        var sum_press:Float = 0
        var sum_now_press:Float = 0
        var press:Float = 0
        
        if(act_index == ActivityDB.INDEX_DAILY_ACT){
            for kist:KistWrapper in kistList {
                if(kist.act_index == ActivityDB.INDEX_WALK || kist.act_index == ActivityDB.INDEX_WALK_STAIR){
                    press += Float(kist.press_variance);
                }
            }
        }
        
        if(BehaviorManager.DEBUG){
            Log.d(BehaviorManager.tag, msg: "----------press:\(press)")//jeyang
        }
        if(abs(press) > 2) {
            isWStair = true;
        }
        
        var count:Int = Int(Preference.getClimbingFlagCount())
        if(act_index == ActivityDB.INDEX_WALK || act_index == ActivityDB.INDEX_WALK_STAIR
            || act_index == ActivityDB.INDEX_WALK_SLOPE || isWStair) {
            if(BehaviorManager.DEBUG){
                Log.d(BehaviorManager.tag, msg: "clm chk 1");//jeyang
            }
            count += 1;
            
            pre_press_1 = Preference.getClimbingPrePress1();
            pre_press_2 = Preference.getClimbingPrePress2();
            pre_activity_index_1 = Int(Preference.getClimbingPreActivity1());
            pre_activity_index_2 = Int(Preference.getClimbingPreActivity2());
            
            sum_pre_press = pre_press_1 + pre_press_2
            for kist:KistWrapper in kistList {
                sum_now_press += Float(kist.press_variance);
            }
            sum_press = sum_pre_press + sum_now_press;
            
            if(BehaviorManager.DEBUG) {
                Log.d(BehaviorManager.tag, msg: "pre idx 1 :\(pre_activity_index_1) + pre idx 2 : \(pre_activity_index_2)")//jeyang
                Log.d(BehaviorManager.tag, msg: "pre press 1 : \(pre_press_1) pre press 2 : \(pre_press_2)")//jeyang
            }
            
            if(pre_activity_index_1 != ActivityDB.INDEX_WALK && pre_activity_index_1 != ActivityDB.INDEX_WALK_STAIR
                && pre_activity_index_1 != ActivityDB.INDEX_CLIMBING && pre_activity_index_1 != ActivityDB.INDEX_WALK_SLOPE
                && pre_activity_index_2 != ActivityDB.INDEX_WALK && pre_activity_index_2 != ActivityDB.INDEX_WALK_STAIR
                && pre_activity_index_2 != ActivityDB.INDEX_CLIMBING && pre_activity_index_2 != ActivityDB.INDEX_WALK_SLOPE){
                valid_1 = false;
            }
        } else {
            count = 0;
            if(BehaviorManager.DEBUG){
                Log.d(BehaviorManager.tag, msg: "clm chk 2");//jeyang
            }
        }
        if(!valid_1) {
            count = 1;
            if(isWStair){
                count = 0;
            }
        }
        if(BehaviorManager.DEBUG) {
            Log.d(BehaviorManager.tag, msg: "valid_1 : \(valid_1) isWStair : \(isWStair)");//jeyang
            Log.d(BehaviorManager.tag, msg: "count : \(count) sum_now_press:\(sum_now_press) act_index:\(act_index)");//jeyang
        }
        
        if(count < 3) {
            Preference.putClimbingFlagCount(Int32(count));
            if(count == 1) {
                Preference.putClimbingPreActivity1(Int32(act_index));
                Preference.putClimbingPrePress1(sum_now_press);
            } else if(count == 2) {
                Preference.putClimbingPreActivity2(Int32(act_index));
                Preference.putClimbingPrePress2(sum_now_press);
            }
            return nil
        }
        
        if(sum_press < -12 || sum_press > 12) {
            valid_2 = true;
        }
        
        if(BehaviorManager.DEBUG){
            Log.d(BehaviorManager.tag, msg: "clm valid 1:\(valid_1) valid 2:\(valid_2)");//jeyang
        }
        for kist:KistWrapper in kistList {
            result.step += kist.step;
            result.swing += kist.swing + kist.small_swing + kist.large_swing;
        }
        
        result.act_index = ActivityDB.INDEX_CLIMBING;
        result.intensity = Float(ActivityDB.STRENGTH_LOW);
        result.MET = ActivityDB.MET_CLIMBING;
        
        if(pre_activity_index_1 == ActivityDB.INDEX_WALK_STAIR && pre_activity_index_2 == ActivityDB.INDEX_WALK_STAIR
            && act_index == ActivityDB.INDEX_WALK_STAIR) {
            result = estimateWalkStair(kistList: kistList);
        }
        
        // pre_press를 하나씩 뒤로 밀어야한다. 1->삭제, 2->1, now->2
        pre_press_1 = pre_press_2;
        pre_press_2 = sum_now_press;
        
        pre_activity_index_1 = pre_activity_index_2;
        pre_activity_index_2 = act_index;
        
        
        Preference.putClimbingFlagCount(Int32(count))
        Preference.putClimbingPrePress1(pre_press_1)
        Preference.putClimbingPrePress2(pre_press_2)
        Preference.putClimbingPreActivity1(Int32(pre_activity_index_1))
        Preference.putClimbingPreActivity2(Int32(pre_activity_index_2))
        
        
        if(!valid_2) {
            //result = nil
            return nil
        }
        
        return result;
    }
    
    /**
     * 자전거는 '약'만 존재. step 삭제. 자전거 이외에 안정만 들어와야함. 나머지가 들어오면 예외처리.
     * @param kistList
     * @return
     */
    func estimateBicycling(kistList:Array<KistWrapper>) -> KistWrapper {
        let result:KistWrapper = KistWrapper()
        result.act_index = ActivityDB.INDEX_BICYCLING;
        result.intensity = Float(ActivityDB.STRENGTH_LOW);
        result.MET = ActivityDB.MET_BICYCLING_LOW;
        if(BehaviorManager.DEBUG) {
            Log.d(BehaviorManager.tag, msg: "bicy->count");//jeyang
        }
        for kist:KistWrapper in kistList {
            result.step += kist.step
            result.swing += kist.swing + kist.small_swing + kist.large_swing;
        }
        
        return result;
    }
    
    func estimateTennis(kistList:Array<KistWrapper>) -> KistWrapper {
        let result:KistWrapper = KistWrapper();
        
        result.act_index = ActivityDB.INDEX_TENNIS;
        result.intensity = Float(ActivityDB.STRENGTH_LOW); // 단식
        result.MET = ActivityDB.MET_TENNIS;
        if(BehaviorManager.DEBUG){
            Log.d(BehaviorManager.tag, msg: "tennis->count");//jeyang
        }
        for kist:KistWrapper in kistList {
            result.step += kist.step
            result.swing += kist.swing + kist.small_swing + kist.large_swing
        }
        
        return result;
    }
    
    func estimateTableTennis(kistList:Array<KistWrapper>) -> KistWrapper {
        let result:KistWrapper = KistWrapper();
        
        result.act_index = ActivityDB.INDEX_TABLE_TENNIS;
        result.intensity = Float(ActivityDB.STRENGTH_LOW); // 단식
        result.MET = ActivityDB.MET_TABLE_TENNIS;
        if(BehaviorManager.DEBUG){
            Log.d(BehaviorManager.tag, msg: "table tennis->count");//jeyang
        }
        for kist:KistWrapper in kistList {
            result.step += kist.step;
            result.swing += kist.swing + kist.small_swing + kist.large_swing;
        }
        
        return result;
    }
    
    func estimateFinal(kistList:Array<KistWrapper>, result:KistWrapper) -> KistWrapper{
        //float press = 0;
        var hr:Int = 0
        var hr_count:Int = 0
        //int pre_activity_index = InnerEditor.getGolfPreActivity(mContext);
        
        let zone:Float = getHeartRateIntenseZone();
        
        // 10분 운동이 판정난뒤 최종 작업을 위함.
        if(BehaviorManager.DEBUG){
            Log.d(BehaviorManager.tag, msg: "final estimate");//jeyang
        }
        for kist:KistWrapper in kistList {
            /*if(result.act_index == ActivityDB.INDEX_DAILY_ACT && pre_activity_index == ActivityDB.INDEX_CLIMBING) {
             if(kist.act_index == ActivityDB.INDEX_WALK_STAIR || kist.act_index == ActivityDB.INDEX_WALK)
             press += kist.press_variance;
             }*/
            
            if(kist.hr > 0) {
                hr += kist.hr;
                hr_count += 1;
            }
        }
        hr /= hr_count == 0 ? 1 : hr_count;
        
        if(min_hr == 0) {
            if(result.act_index == ActivityDB.INDEX_DAILY_ACT && Float(hr) > zone) {
                result.act_index = ActivityDB.INDEX_INTENSE_ACT; // MET, 강도는?
                result.MET = ActivityDB.MET_INTENSE_ACT_HIGH;
                result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            }
            min_hr = hr
        } else {
            if(result.act_index == ActivityDB.INDEX_DAILY_ACT && Float(hr) > (Float(min_hr) * 1.6 < 100.0 ? 100.0 : Float(min_hr)*1.6)) {
                result.act_index = ActivityDB.INDEX_INTENSE_ACT; // MET, 강도는?
                result.MET = ActivityDB.MET_INTENSE_ACT_HIGH;
                result.intensity = Float(ActivityDB.STRENGTH_HIGH);
            }
        }
        
        if(hr != 0 && min_hr > hr){
            min_hr = hr;
        }
        
        if(result.act_index == ActivityDB.INDEX_JUMPING_ACT || result.act_index == ActivityDB.INDEX_SWING_ACT) {
            result.act_index = ActivityDB.INDEX_SPORT
        }
        
        /*if(result.act_index == ActivityDB.INDEX_DAILY_ACT || result.act_index == ActivityDB.INDEX_STAND) {
         //목표심박수 = 운동강도(%) x (최대심박수 - 안정시 심박수) + 안정시 심박수
         hr_count = 0;
         hr = getKarvonenHR(0.4f, min_hr);
         
         for(KistWrapper kist : kistList) {
         if(kist.hr >= hr) {
         hr_count++;
         if(hr_count >= 3) {
         result.act_index = ActivityDB.INDEX_INTENSE_ACT;
         result.MET = ActivityDB.MET_INTENSE_ACT_HIGH;
         result.intensity = ActivityDB.STRENGTH_HIGH;
         break;
         }
         }
         }
         }*/
        
        return result;
    }
    
    func getKarvonenHR(ref:Float, stand_hr:Int) -> Int {
        return Int(ref * (getHeartRateDangerZone()[0] - Float(stand_hr)) + Float(stand_hr))
    }
    
    class SortIdx {
        var act_index:Int;
        var count:Int;
        init(act_index:Int, count:Int) {
            self.act_index = act_index;
            self.count = count;
        }
        /*init() {
         
         }*/
    }
    
    func getLargestIndex(sortList:Array<SortIdx>) -> Int {
        var L_Idx:Int=sortList[0].act_index, L_Count=sortList[0].count;
        for s:SortIdx in sortList {
            if(L_Count < s.count) {
                L_Count = s.count;
                L_Idx = s.act_index;
            }
        }
        
        return L_Idx
    }
    
    func getLargestIndex(sortList:Array<SortIdx>, len:Int) -> Int {
        var L_Idx:Int = sortList[0].act_index
        var L_Count:Int = sortList[0].count
        var i:Int = 0
        for s:SortIdx in sortList {
            if(len-1 > i){
                break
            }
            if(L_Count < s.count) {
                L_Count = s.count
                L_Idx = s.act_index
            }
            i += 1
        }
        
        return L_Idx
    }
    /**
     * status로 모든 내용을 변경하여 반환.
     * @param slpInfo
     * @param status
     * @return
     */
    func resetSleepInfo(slpInfo:Array<Contact.SleepInfo>, status:Int) -> Array<Contact.SleepInfo> {
        //for(int i=0; i<slpInfo.length; i++) {
        for i in 0..<slpInfo.count {
            slpInfo[i].setStatus(Int32(status));
            slpInfo[i].setCount(0);
        }
        
        return slpInfo;
    }
    
    
    /**
     * 수면 판정. 현재 DB와 웹에서 받은 DB를 종합하여 판단. 현재 판단 기준은 10분으로 되어있음.
     * 판정이 끝나면 수면에 영향을 받은 10분정보 반환. 수면으로 판정되면 값이 들어있고 아니면 null 반환.
     * 이 말은 이곳에서 칼로리를 계산 해야함. 칼로리는 밖에서 계산하자. -> true 면 수면 판정됨. false 면 그대로 진행.
     * @param kistList 계산될 10분 데이터
     * @param QNumber 데이터가 들어갈 수면 Q number
     * @param time 10분에 해당하는 time Array(long)
     * @return true:수면 판정. false:그대로 진행.
     */
    // 10분당 발생한 걸음 수 리턴해야함.
    func estimateSleep(kistList:inout Array<KistWrapper>, time:[Int64], disUse:Bool) -> KistWrapper {
        let result:KistWrapper = KistWrapper()
        
        var status_slp_count:Int = 0
        var status_rolled_count:Int = 0
        var status_awaken_count:Int = 0
        var step_slp_count:Int = 0
        var step_rolled_count:Int = 0
        var step_awaken_count:Int = 0
        var step_active_count:Int = 0
        var swing_slp_count:Int = 0
        var swing_rolled_count:Int = 0
        var swing_awaken_count:Int = 0
        var swing_active_count:Int = 0
        var tStep:Int = 0
        var tSwing:Int = 0
        
        // 오늘치 수면 정보를 받아옴. 향후 웹에서 받는 형식으로 수정해야한다. 수면 정보는 이미 계산되어 확정된 정보들이 들어가 있음. 그래프이기 때문...
        //Contact.SleepInfo[] slpInfo = getSleepInfo(0);
        //var slg_pre_start_flag_time:Int64 = Preference.getSleepPreStartFlagTime();
        let slp_pre_start_flag_status:Int = Int(Preference.getSleepPreStartFlagStatus());
        //var slg_pre_end_flag_time:Int64 = Preference.getSleepPreEndFlagTime();
        let slp_pre_end_flag_status:Int = Int(Preference.getSleepPreEndFlagStatus());
        
        var slp_flag_status:Int = Int(Preference.getSleepFlagStatus());
        var slp_flag_time:Int64 =  Preference.getSleepFlagTime();
        var now_slp_start_time:Int64 = 0
        var now_slp_exit_time:Int64 = 0
        
        //Contact contact = new Contact();
        
        if(BehaviorManager.DEBUG) {
            
            let date = Date().timeIntervalSince1970
            let format = DateFormatter()
            format.dateFormat = "yyyy/MM/dd HH:mm"
            //for(int i=0; i<time.length; i++){
            for i in 0..<time.count {
                Log.i(BehaviorManager.tag , msg: "this time? \(time[i])")
                let formatTime = Date(timeIntervalSince1970: TimeInterval(time[i]/1000))
                Log.v(BehaviorManager.tag, msg: "esti array date:\(format.string(from: formatTime as Date))");
            }
        }
        //수면 최종 판졍 flag
        var final_flag:Bool = false;
        /*jeyang
         Log.d(BehaviorManager.tag, msg: "--------esti start-------");
         Log.d(BehaviorManager.tag, msg: "slp_flag_status:"+slp_flag_status + " slp_pre_start_flag:"+
         slp_pre_start_flag_status+" slp_pre_end_flag:"+slp_pre_end_flag_status);
         */
        
        // 현재 저장된 수면 정보가 오늘날짜인지 판별. 유효성 검사.
        // 규창 왜 죽였을까..?
        /*Global_Calendar.setTimeInMillis(slp_flag_time);
         var day:Int = Global_Calendar.get(Calendar.DAY_OF_MONTH);
         var system_time:Int64 = System.currentTimeMillis();
         Global_Calendar.setTimeInMillis(system_time);
         int today = Global_Calendar.get(Calendar.DAY_OF_MONTH);*/
        // 굳이 날짜를 볼 필욘 없나?...
        // 만약, 사용중인 밴드였다면, 값이 들어가 있을것이고, 그때부터 과거 데이터를 받으니까 그냥 사용해도 될듯.
        // 만약, 한번도 사용하지 않았었다면, 값도 없고 서버에도 데이터가 없을 것이다. 그러면 최초 받는 데이터로 검증 시도.
        // 1. 서버로부터 정보 받기 필요.
        // 2. 지금은 서버로부터 받지 않으므로,  날짜 간격을 보자. 서버 데이터를 보면 굳이 볼 필요 없을듯. 대신 NONE으로 발생한 경우, 서버 데이터를 받는 동작 필요.
        /*if(day != today || Math.abs(system_time - slp_flag_time) > 1000*60*60*24)
         slp_flag_status = SLP_STATUS_NONE;*/
        
        
        //Log.d(BehaviorManager.tag, msg: "slp_flag_status2:"+slp_flag_status);//jeyang
        /**
         * 이 경우는 저장되어 있는 수면 시작 날짜가 다르던가, 날짜는 같은데 시간이 다르던가...
         * 1. 오늘 날짜의 시작 시간인 경우.
         * 2. 오늘 날짜의 중간에 삭제하고 다시 재설치를 한 경우.
         */
        if(slp_flag_status == SLP_STATUS_NONE) {
            // 현재 존재하는 데이터의 첫 시작부터 찾기 시작. -> 수면 시작과 끝 시간을 찾아야 한다.
            // 수면 시작을 찾으려면 1분 데이터가 필요함. 현재 1분 데이터를 저장하는 내용이 없다. 서버에도 저장 안함...
            // 임시로 10분 데이터만 가지고 수면 시작을 찾는다.
            // ->추후에 서버에 저장된 수면 데이터를 받아와야 함. 만약, 서버에도 데이터가 읍다면? 최초라고 생각해야한다.
            // 최초인 경우, 현재 데이터를 바탕으로 수면 데이터를 갱신해야함.
            //ActInfo[] tmpActInfo = mDBHelper?.getActArray();
            /*var tmpActInfo:[Contact.ActInfo]? = mDBHelper?.getActArray();
             if(tmpActInfo != nil) {
             if(tmpActInfo[tmpActInfo.count - 1].getC_Exercise() == Int32(ActivityDB.INDEX_SLEEP)) {
             slp_flag_time = tmpActInfo[tmpActInfo.count-1].getC_year_month_day();
             slp_flag_status = SLP_STATUS_START;
             } else {
             slp_flag_time = tmpActInfo[tmpActInfo.count-1].getC_year_month_day();
             slp_flag_status = SLP_STATUS_END;
             }
             } else {
             // 최초 여기 들어온 ArrayList를 바탕으로 최초 판단을 하자.
             // 복병... -_-
             if(estimateKistOut(kistList: &kistList).act_index == ActivityDB.INDEX_SLEEP) {
             slp_flag_time = time[0];
             slp_flag_status = SLP_STATUS_START;
             } else {
             slp_flag_time = time[0];
             slp_flag_status = SLP_STATUS_END;
             }
             }*/
            //규창 171023 db에서 읽네...? 일단 본 분기문 주석
            //if let tmpActInfo:[Contact.ActInfo] = mDBHelper?.getActArray() {
                /*if(tmpActInfo[tmpActInfo.count - 1].getC_Exercise() == Int32(ActivityDB.INDEX_SLEEP)) {
                    slp_flag_time = tmpActInfo[tmpActInfo.count-1].getC_year_month_day();
                    slp_flag_status = SLP_STATUS_START;
                } else {
                    slp_flag_time = tmpActInfo[tmpActInfo.count-1].getC_year_month_day();
                    slp_flag_status = SLP_STATUS_END;
                }*/
            //} else {
                // 최초 여기 들어온 ArrayList를 바탕으로 최초 판단을 하자.
                // 복병... -_-
                //규창...?
                //if(layer_2(kistList: &kistList).act_index == ActivityDB.INDEX_SLEEP) {
                if(estimateKistOut(kistList: &kistList).act_index == ActivityDB.INDEX_SLEEP) {
                    slp_flag_time = time[0];
                    slp_flag_status = SLP_STATUS_START;
                } else {
                    slp_flag_time = time[0];
                    slp_flag_status = SLP_STATUS_END;
                }
            //}
            
        }
        
        // 10분 데이터를 보고 뽑을 수 있는 데이터를 한번에 다 뽑음.
        //Contact.SleepInfo[] slpInfo = new Contact.SleepInfo[kistList.size()];
        var slpInfo:Array<Contact.SleepInfo> = Array(repeating: Contact.SleepInfo(), count : kistList.count)
        var k:Int = 0
        /*for K:KistWrapper in kistList {
         var tmp_status:Int = 0
         var tmp_count:Int = 0
         if(K.act_index == ActivityDB.INDEX_SLEEP) {
         //Log.d(BehaviorManager.tag, msg: "for if K SLEEP");//jeyang
         
         step_slp_count += K.step;
         swing_slp_count += K.swing + K.small_swing + K.large_swing;
         status_slp_count += 1;
         tmp_count += 1;
         tmp_status = SLEEP;
         // 1분단위 동작으로 구성되어있으므로 지금은 1분의 첫 발견 시간을 수면 시간으로 설정. 만약, 10분단위로 되면 그냥 가장 첫 배열 값을 쓰면 됨.
         if(now_slp_start_time == 0) {
         now_slp_start_time = time[k];
         }
         } else {
         tmp_count += 1;
         if(K.act_index == ActivityDB.INDEX_STAND) {
         if( K.step < 10) {
         // 뒤척임
         //Log.d(BehaviorManager.tag, msg: "for else K 1 ROLLED"); // jeyang
         //step_rolled_count += K.step;
         swing_rolled_count += K.swing + K.small_swing + K.large_swing;
         tmp_status = ROLLED;
         status_rolled_count += 1;
         } else if( K.step >= 12) {
         // 깨어남
         //Log.d(BehaviorManager.tag, msg: "for else K 1 AWAKEN");//jeyang
         step_awaken_count += K.step;
         swing_awaken_count += K.swing + K.small_swing + K.large_swing;
         tmp_status = AWAKEN;
         status_awaken_count += 1;
         }
         //                    else {
         //                     Log.d(BehaviorManager.tag, msg: "for else K 1 ACTIVE");
         //                     step_active_count += K.step;
         //                     swing_active_count += K.swing;
         //                     tmp_status = ACTIVE;
         //                     status_active_count++;
         //                     }
         } else {
         // 깨어남
         //Log.d(BehaviorManager.tag, msg: "for else K 2 AWAKEN");//jeyang
         step_awaken_count += K.step;
         swing_awaken_count += K.swing + K.small_swing + K.large_swing;
         tmp_status = AWAKEN;
         status_awaken_count += 1;
         //                    if( K.step >= 20) {
         //                     // 깨어남
         //                     Log.d(BehaviorManager.tag, msg: "for else K 2 AWAKEN");
         //                     step_awaken_count += K.step;
         //                     swing_awaken_count += K.swing;
         //                     tmp_status = AWAKEN;
         //                     status_awaken_count++;
         //                     } else {
         //                     Log.d(BehaviorManager.tag, msg: "for else K 2 ACTIVE");
         //                     step_active_count += K.step;
         //                     swing_active_count += K.swing;
         //                     tmp_status = ACTIVE;
         //                     status_active_count++;
         //                     }
         if(now_slp_exit_time == 0) {
         now_slp_exit_time = time[k];
         }
         }
         
         //                if(now_slp_exit_time == 0)
         //                 now_slp_exit_time = time[k];
         }
         
         // 1분단위 재판단 후 재정렬.
         ///규창
         //var tmp:Contact.SleepInfo = Global_Contact.SleepInfo()
         var tmp:Contact.SleepInfo = Contact.SleepInfo()
         
         tmp.setTime(time[k])
         tmp.setStatus(Int32(tmp_status));
         tmp.setCount(Int32(tmp_count));
         tmp.setFlag(flag: DBContactHelper.NONSET_UPDATED);
         slpInfo[k] = tmp;
         k += 1;
         
         tStep += K.step;
         tSwing += K.swing + K.small_swing + K.large_swing
         }*/
        
        
        
        for i in 0..<10 {
            var tmp_status:Int = 0
            var tmp_count:Int = 0
            if(kistList[i].act_index == ActivityDB.INDEX_SLEEP) {
                //Log.d(tag,"for if K SLEEP");//jeyang
                
                step_slp_count += kistList[i].step;
                swing_slp_count += kistList[i].swing + kistList[i].small_swing + kistList[i].large_swing;
                status_slp_count += 1
                tmp_count += 1
                tmp_status = SLEEP;
                // 1분단위 동작으로 구성되어있으므로 지금은 1분의 첫 발견 시간을 수면 시간으로 설정. 만약, 10분단위로 되면 그냥 가장 첫 배열 값을 쓰면 됨.
                if(now_slp_start_time == 0){
                    now_slp_start_time = time[k];
                }
            } else {
                tmp_count += 1
                if(kistList[i].act_index == ActivityDB.INDEX_STAND) {
                    if( kistList[i].step < 10) {
                        // 뒤척임
                        //Log.d(tag,"for else K 1 ROLLED"); // jeyang
                        //step_rolled_count += kistList[i].step;
                        swing_rolled_count += kistList[i].swing + kistList[i].small_swing + kistList[i].large_swing;
                        tmp_status = ROLLED;
                        status_rolled_count += 1
                    } else if( kistList[i].step >= 12) {
                        // 깨어남
                        //Log.d(tag,"for else K 1 AWAKEN");//jeyang
                        step_awaken_count += kistList[i].step;
                        swing_awaken_count += kistList[i].swing + kistList[i].small_swing + kistList[i].large_swing;
                        tmp_status = AWAKEN;
                        status_awaken_count += 1
                    } /*else {
                     Log.d(tag,"for else K 1 ACTIVE");
                     step_active_count += kistList[i].step;
                     swing_active_count += kistList[i].swing;
                     tmp_status = ACTIVE;
                     status_active_count++;
                     }*/
                } else {
                    // 깨어남
                    //Log.d(tag,"for else K 2 AWAKEN");//jeyang
                    step_awaken_count += kistList[i].step;
                    swing_awaken_count += kistList[i].swing + kistList[i].small_swing + kistList[i].large_swing;
                    tmp_status = AWAKEN;
                    status_awaken_count += 1
                    /*if( kistList[i].step >= 20) {
                     // 깨어남
                     Log.d(tag,"for else K 2 AWAKEN");
                     step_awaken_count += kistList[i].step;
                     swing_awaken_count += kistList[i].swing;
                     tmp_status = AWAKEN;
                     status_awaken_count++;
                     } else {
                     Log.d(tag,"for else K 2 ACTIVE");
                     step_active_count += kistList[i].step;
                     swing_active_count += kistList[i].swing;
                     tmp_status = ACTIVE;
                     status_active_count++;
                     }*/
                    if(now_slp_exit_time == 0){
                        now_slp_exit_time = time[k]
                    }
                }
                
                /*if(now_slp_exit_time == 0)
                 now_slp_exit_time = time[k];*/
            }
            // 1분단위 재판단 후 재정렬.
            ///규창
            //var tmp:Contact.SleepInfo = Global_Contact.SleepInfo()
            let tmp:Contact.SleepInfo = Contact.SleepInfo()
            
            tmp.setTime(time[i])
            tmp.setStatus(Int32(tmp_status));
            tmp.setCount(Int32(tmp_count));
            tmp.setFlag(flag: 0);
            slpInfo[i] = tmp;
            k += 1;
            
            tStep += kistList[i].step;
            tSwing += kistList[i].swing + kistList[i].small_swing + kistList[i].large_swing;
        }
        
        
        
        
        
        
        result.act_index = ActivityDB.INDEX_SLEEP
        result.intensity = Float(ActivityDB.STRENGTH_LOW)
        //result.step = step_slp_count + step_awaken_count + step_rolled_count;
        //result.swing = swing_slp_count + swing_awaken_count + swing_rolled_count;
        result.step = tStep
        result.swing = tSwing
        result.MET = ActivityDB.MET_SLEEP_LOW
        
        // 10분 행동 판정.
        var isSlp:Bool = false
        var overSlp:Bool = false
        
        // 변경된 로직은 ACTIVE가 판정될 공간이 없음. 때문에 수면 시작, 끝이 아닌 경우 ACTIVE로 전부 판정해야하는 상황. 혹은 ACTIVE 자체를 판정하지 않거나..
        // 여기의 10분 판정은 실제 10분 행동 판정에 반영이 되어야함.
        if(slp_flag_status == SLP_STATUS_START) {
            // 이미 시작되었으므로, 종료 조건만 기억. (연속 5개의 다른 행동)
            // 수면 이외 연속 5개면 수면 끝으로 판정.
            // 이걸 알려면 slpInfo 가 아니라 ArrayList를 봐야함.
            //Log.d(BehaviorManager.tag, msg: "start 10 min esti");//jeyang
            var tmp_idx:Int = kistList[0].act_index
            var tmp_count:Int = 1
            //for(int i=1; i<kistList.size() ; i++) {
            for i in 1..<kistList.count {
                //Log.d(BehaviorManager.tag, msg: "for loop get(i)index:"+kistList.get(i).act_index+ " tmpidx:"+tmp_idx);//jeyang
                if(kistList[i].act_index != ActivityDB.INDEX_SLEEP) {
                    //&& tmp_idx == kistList.get(i).act_index) {
                    tmp_count += 1;
                    //Log.d(BehaviorManager.tag, msg: "tmp_count:"+tmp_count);//jeyang
                } else {
                    //Log.d(BehaviorManager.tag, msg: "tmp_count reset");//jeyang
                    tmp_count = 1;
                }
                tmp_idx = kistList[i].act_index;
                if(tmp_count == 6) {
                    overSlp = true;
                    break;
                }
            }
            //Log.d(BehaviorManager.tag, msg: "end 10 min esti");jeyang
        } else {
            // 수면이 끝난 상태이므로, slp_count가 8개 이상이 되어야만 수면 시작 판정.
            //Log.d(BehaviorManager.tag, msg: "else start 10 min esti");//jeyang
            if(status_slp_count >= 8){
                isSlp = true;
            }
            else{
                slpInfo = resetSleepInfo(slpInfo: slpInfo, status: ACTIVE);
                //Log.d(BehaviorManager.tag, msg: "else end 10 min esti");//jeyang
            }
        }
        if(disUse) {
            Log.d(BehaviorManager.tag, msg: "disUse Sleep");
            overSlp = true;
            isSlp = false;
        }
        
        //Log.d(BehaviorManager.tag, msg: "isSlp:"+isSlp+" overSlp:"+overSlp);//jeyang
        
        
        //1분 데이터의 수면 그래프 DB 처리.
        if(slp_flag_status == SLP_STATUS_START) {
            if(overSlp) { // 수면 종료 flag 처리됨.
                if(slp_pre_end_flag_status == SLP_STATUS_END) {
                    //Log.d(BehaviorManager.tag, msg: "final 1");//jeyang
                    // 수면으로 판정 중인데, 수면이 종료되었음.
                    final_flag = false;
                    //result = null;
                    Preference.putSleepFlagStatus(Int32(SLP_STATUS_END));
                    Preference.putSleepFlagTime(now_slp_exit_time);
                    
                    //수면 종료됬으므로 종료 flag 삭제.
                    Preference.putSleepPreEndFlagStatus(Int32(SLP_STATUS_NONE));
                    Preference.putSleepPreEndFlagTime(0)
                    
                    result.isSlp = false;
                    /*for(Contact.SleepInfo slp : slpInfo) {
                     mDBHelper.addSleepInfo(slp);
                     }*/
                } else {
                    //아직 수면 종료 조건 충족하지 못했으나, 이번에 수면종료 판정이 났음. 그럼 수면 end flag 등록.
                    //Log.d(BehaviorManager.tag, msg: "final 2");//jeyang
                    Preference.putSleepPreEndFlagStatus(Int32(SLP_STATUS_END));
                    Preference.putSleepPreEndFlagTime(now_slp_exit_time);
                    
                    // 아직은 수면
                    result.isSlp = true;
                    result.rolled_count = status_rolled_count;
                    result.awaken_count = status_awaken_count;
                }
            } else {
                //Log.d(BehaviorManager.tag, msg: "final 3");//jeyang
                // 지속적인 수면 판정중임.
                // 내부에는 활동의 정보는 올 수 없음. 만약, 활동 정보가 존재한다면 전부 "깨어남"으로 변경.
                final_flag = true;
                
                // 수면 종료 조건 충족하지 못한 상태. 이 경우 수면 end flag 삭제해야함.
                Preference.putSleepPreEndFlagStatus(Int32(SLP_STATUS_NONE));
                Preference.putSleepPreEndFlagTime(0);
                
                result.isSlp = true;
                result.rolled_count = status_rolled_count;
                result.awaken_count = status_awaken_count;
                /*for(Contact.SleepInfo slp : slpInfo) {
                 mDBHelper.addSleepInfo(slp);
                 }*/
            }
        } else { // 종료상태.
            if(isSlp) {
                if(slp_pre_start_flag_status == SLP_STATUS_START) {
                    //Log.d(BehaviorManager.tag, msg: "final 4");//jeyang
                    // 수면이 재시작되었음.
                    final_flag = true;
                    Preference.putSleepFlagStatus(Int32(SLP_STATUS_START));
                    Preference.putSleepFlagTime(now_slp_start_time);
                    
                    //수면 판정 났으니 수면 start flag 삭제.
                    Preference.putSleepPreStartFlagStatus(Int32(SLP_STATUS_NONE));
                    Preference.putSleepPreStartFlagTime(0);
                    
                    result.isSlp = true;
                    result.rolled_count = status_rolled_count;
                    result.awaken_count = status_awaken_count;
                    /*for(Contact.SleepInfo slp : slpInfo) {
                     mDBHelper.addSleepInfo(slp);
                     }*/
                } else {
                    //아직 수면 조건 충족하지 못했으나, 이번에 수면으로 판정이 났음. 그럼 수면 start flag 등록.
                    //Log.d(BehaviorManager.tag, msg: "final 5");//jeyang
                    Preference.putSleepPreStartFlagStatus(Int32(SLP_STATUS_START));
                    Preference.putSleepPreStartFlagTime(now_slp_start_time);
                    
                    result.isSlp = false;
                    //result는 안정으로 처리.
                    result.act_index = ActivityDB.INDEX_STAND;
                    result.intensity = Float(ActivityDB.STRENGTH_LOW);
                    //result.step = step_slp_count + step_awaken_count + step_rolled_count;
                    //result.swing = swing_slp_count + swing_awaken_count + swing_rolled_count;
                    result.MET = ActivityDB.MET_STAND_LOW;
                }
            } else { // 수면 조건 충족하지 못한 상태. 이 경우 수면 start flag 삭제해야함.
                // 아직 수면 종료 상태. 이 상태에서 내부에 수면이 발생하면 전부 활동으로 변경한다.
                //Log.d(BehaviorManager.tag, msg: "final 6");//jeyang
                final_flag = false;
                //result = null;
                
                Preference.putSleepPreStartFlagStatus(Int32(SLP_STATUS_NONE));
                Preference.putSleepPreStartFlagTime(0);
                
                slpInfo = resetSleepInfo(slpInfo: slpInfo, status: ACTIVE);
                /*for(Contact.SleepInfo slp : slpInfo) {
                 mDBHelper.addSleepInfo(slp);
                 }*/
                result.isSlp = false;
            }
        }
        
        //return final_flag;
        return result;
    }
    
    func estimateTennisNTableTennis(kistList:Array<KistWrapper>) -> KistWrapper {
        let result:KistWrapper = KistWrapper();
        var tmp_tennis_count:Int = 0
        var tmp_tbl_tennis_count = 0
        
        var isTennis:Bool = false
        var isTableTennis:Bool = false
        
        //for(int i=0; i<kistList.size() ; i++) {
        for i in 0..<kistList.count {
            if(kistList[i].act_index == ActivityDB.INDEX_TENNIS){
                tmp_tennis_count += 1;
            }
            else{
                tmp_tennis_count = 0;
            }
            
            
            if (kistList[i].act_index == ActivityDB.INDEX_TABLE_TENNIS || kistList[i].act_index == ActivityDB.INDEX_TENNIS){
                tmp_tbl_tennis_count += 1;
            }
            else{
                tmp_tbl_tennis_count = 0;
            }
            
            
            if(tmp_tennis_count == 6){
                isTennis = true;
            }
            
            if(tmp_tbl_tennis_count == 6){
                isTableTennis = true;
            }
            result.step += kistList[i].step;
            result.swing += kistList[i].swing + kistList[i].small_swing + kistList[i].large_swing;
        }
        
        if(isTennis) {
            return estimateTennis(kistList: kistList);
        }
        else if(isTableTennis){
            return estimateTableTennis(kistList: kistList);
        }
        else {
            result.act_index = ActivityDB.INDEX_DAILY_ACT;
            result.intensity = Float(ActivityDB.STRENGTH_MIDDLE);
            result.MET = ActivityDB.MET_DAILY_ACT_LOW;
            return result;
        }
    }
    
    
    // 미착용, 모든 행동의 최우선. 수면보다 우선.
    // 미착용도 하나의 행동으로 취급한다. flag가 아니라 행동을 변화 시켜야함
    func estimateDisuse(kistList:Array<KistWrapper>) -> KistWrapper? {
        let result:KistWrapper = KistWrapper();
        var count:Int = 1
        var preHr:Int = kistList[0].hr;
        //double preVar = kistList.get(0).variance;
        var tStep:Int = 0
        var tSwing:Int = 0
        
        var isDisuse:Bool = false;
        
        //for(int i=1; i<kistList.size(); i++) {
        for i in 1..<kistList.count {
            if(kistList[0].hr == 0 && preHr == 0) {
                count += 1
            } else {
                count = 1
            }
            //preVar = kistList.get(i).variance;
            preHr = kistList[i].hr;
            if(count == 6) {
                isDisuse = true;
                break;
            }
        }
        
        if(!isDisuse){
            return nil
        }
        
        for kist:KistWrapper in kistList {
            tStep += kist.step;
            tSwing += kist.swing + kist.small_swing + kist.large_swing;
        }
        
        result.act_index = ActivityDB.INDEX_DISUSE; // 임시 미착용 IDX;
        result.MET = 1; // 기초대사량
        result.intensity = Float(ActivityDB.STRENGTH_LOW);
        result.step = tStep;
        result.swing = tSwing;
        
        return result;
    }
    
    
    //Motion index
    // Activity_Index=1 :: Standing or almost same action
    // Activity_Index=11 :: Walking at flat
    // Activity_Index=13 :: Walking at Stairs
    // Activity_Index=15 :: Walking at Slope
    // Activity_Index=17 :: Walking at Mountain
    // Activity_Index=21 :: Running
    // Activity_Index=23 :: Jumping rope
    // Activity_Index=25 :: Bicycling
    // Activity_Index=31 :: Golfing
    // Activity_Index=33 :: Tennis
    // Activity_Index=35 :: Table tennis
    
    //Activity Results
    //[0] Activity
    //[1] Strength -> variance
    //[2] Number of Motion -> 걸음수
    //[3] Number of Step -> 스윙
    
    func getIntensityFromKIST(kist:[Double])-> Float {
        return Float(kist[1])//Double.valueOf(kist[1]).floatValue();
        //return ActivityDB.STRENGTH_LOW;
    }
    
    /**
     * 속도로 적용되지 않는 act는 intensity가 그대로 return 된다.
     * intensity를 보고 속도를 맞추는데, 이제 모든 행동에 intensity가 제대로 들어가야함. 이건 추천운동에만 씀. 실제 DB에 넣는건 따로...
     * @param actIndex
     * @param intensity
     * @return
     */
    func getSpeedfromIntensity(actIndex:Int, intensity:Float) -> Float {
        var speed:Float = 0
        
        switch(actIndex) {
        case ActivityDB.INDEX_RUN:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                speed = ActivityDB.SPEED_RUN_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                speed = ActivityDB.SPEED_RUN_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                speed = ActivityDB.SPEED_RUN_HIGH;
            } else{
                speed = ActivityDB.SPEED_RUN_LOW; // 임시... 아직 결정되지 않아서 표시만 위해서.
            }
            break;
        case ActivityDB.INDEX_WALK:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                speed = ActivityDB.SPEED_WALK_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                speed = ActivityDB.SPEED_WALK_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                speed = ActivityDB.SPEED_WALK_HIGH;
            } else {
                speed = ActivityDB.SPEED_WALK_LOW; // 임시... 아직 결정되지 않아서 표시만 위해서.
            }
            break;
        case ActivityDB.INDEX_WALK_FAST:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                speed = ActivityDB.SPEED_WALK_FAST_LOW;
            } else {
                speed = ActivityDB.SPEED_WALK_FAST_LOW; // 임시... 아직 결정되지 않아서 표시만 위해서.
            }
            break;
        case ActivityDB.INDEX_BICYCLING, ActivityDB.INDEX_STAND, ActivityDB.INDEX_WALK_SLOPE, ActivityDB.INDEX_WALK_STAIR, ActivityDB.INDEX_JUMP_ROPE, ActivityDB.INDEX_DISUSE,
             ActivityDB.INDEX_GOLF, ActivityDB.INDEX_CLIMBING, ActivityDB.INDEX_SWIMMING, ActivityDB.INDEX_SLEEP, ActivityDB.INDEX_BADMINTON, ActivityDB.INDEX_DAILY_ACT,
             ActivityDB.INDEX_LIGHT_ACT, ActivityDB.INDEX_MODERATE_ACT, ActivityDB.INDEX_INTENSE_ACT, ActivityDB.INDEX_SWING_ACT, ActivityDB.INDEX_TENNIS, ActivityDB.INDEX_TABLE_TENNIS:
            speed = 0;
            break;
        default:
            break
        }
        return speed;
    }
    
    /**
     * 이건 Act DB에 넣는 분류기.
     * @param kist
     * @return
     */
    func getSpeedtoDB(kist:KistWrapper) -> Float {
        var speed:Float = 0
        
        switch(kist.act_index) {
        case ActivityDB.INDEX_RUN, ActivityDB.INDEX_WALK, ActivityDB.INDEX_WALK_FAST, ActivityDB.INDEX_WALK_SLOPE:
            speed = kist.speed
            break
        case ActivityDB.INDEX_WALK_STAIR:
            speed = kist.intensity
            break
        case ActivityDB.INDEX_JUMP_ROPE:
            speed = Float(kist.swing)
            break
        case ActivityDB.INDEX_BICYCLING, ActivityDB.INDEX_STAND, ActivityDB.INDEX_DISUSE, ActivityDB.INDEX_GOLF, ActivityDB.INDEX_CLIMBING, ActivityDB.INDEX_SWIMMING, ActivityDB.INDEX_SLEEP,
             ActivityDB.INDEX_BADMINTON, ActivityDB.INDEX_DAILY_ACT, ActivityDB.INDEX_LIGHT_ACT, ActivityDB.INDEX_MODERATE_ACT, ActivityDB.INDEX_INTENSE_ACT, ActivityDB.INDEX_SWING_ACT,
             ActivityDB.INDEX_TENNIS, ActivityDB.INDEX_TABLE_TENNIS:
            speed = Float(ActivityDB.STRENGTH_LOW);
            break
        default:
            break
        }
        return speed;
    }
    
    /**
     * speed를 강도로 리턴해줌.
     * @param actIndex
     * @param MET
     * @return
     */
    /*private float getIntensityfromSpeed(int actIndex, float speed) { // 안씀
     float intensity=0;
     
     switch(actIndex) {
     case ActivityDB.INDEX_RUN:
     if (Float.compare(speed, ActivityDB.SPEED_RUN_LOW) { // 같다:0
     intensity = ActivityDB.STRENGTH_LOW;
     } else if (Float.compare(speed, ActivityDB.SPEED_RUN_MID) {
     intensity = ActivityDB.STRENGTH_MIDDLE;
     } else if (Float.compare(speed, ActivityDB.SPEED_RUN_HIGH) {
     intensity = ActivityDB.STRENGTH_HIGH;
     } else {
     intensity = ActivityDB.STRENGTH_LOW;
     }
     break;
     case ActivityDB.INDEX_WALK:
     if (Float.compare(speed, ActivityDB.SPEED_WALK_LOW) { // 같다:0
     intensity = ActivityDB.STRENGTH_LOW;
     } else if (Float.compare(speed, ActivityDB.SPEED_WALK_MID) {
     intensity = ActivityDB.STRENGTH_MIDDLE;
     } else if (Float.compare(speed, ActivityDB.SPEED_WALK_HIGH) {
     intensity = ActivityDB.STRENGTH_HIGH;
     } else {
     intensity = ActivityDB.STRENGTH_LOW;
     }
     break;
     case ActivityDB.INDEX_WALK_FAST:
     if (Float.compare(speed, ActivityDB.MET_WALK_FAST_LOW) { // 같다:0
     intensity = ActivityDB.STRENGTH_LOW;
     } else {
     intensity = ActivityDB.STRENGTH_LOW;
     }
     break;
     case ActivityDB.INDEX_BICYCLING:
     if (Float.compare(speed, ActivityDB.MET_BICYCLING_LOW) { // 같다:0
     intensity = ActivityDB.STRENGTH_LOW;
     } else {
     intensity = ActivityDB.STRENGTH_LOW;
     }
     break;
     case ActivityDB.INDEX_WALK_SLOPE:
     case ActivityDB.INDEX_WALK_STAIR:
     case ActivityDB.INDEX_STAND:
     case ActivityDB.INDEX_JUMP_ROPE:
     case ActivityDB.INDEX_DISUSE:
     case ActivityDB.INDEX_GOLF:
     case ActivityDB.INDEX_CLIMBING:
     case ActivityDB.INDEX_SWIMMING:
     case ActivityDB.INDEX_SLEEP:
     case ActivityDB.INDEX_BADMINTON:
     case ActivityDB.INDEX_DAILY_ACT:
     case ActivityDB.INDEX_LIGHT_ACT:
     case ActivityDB.INDEX_MODERATE_ACT:
     case ActivityDB.INDEX_INTENSE_ACT:
     case ActivityDB.INDEX_SWING_ACT:
     case ActivityDB.INDEX_TENNIS:
     case ActivityDB.INDEX_TABLE_TENNIS:
     // intensity = speed;
     }
     return intensity;
     }*/
    
    func getMETfromActivity(actIndex:Int, intensity:Float) -> Float {
        var MET:Float=0;
        switch(actIndex) {
        case ActivityDB.INDEX_RUN:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_RUN_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                MET = ActivityDB.MET_RUN_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                MET = ActivityDB.MET_RUN_HIGH;
            } else {// 임시
                MET = ActivityDB.MET_RUN_HIGH;
            }
            break;
        case ActivityDB.INDEX_WALK:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_WALK_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                MET = ActivityDB.MET_WALK_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                MET = ActivityDB.MET_WALK_HIGH;
            } else { // 임시
                MET = ActivityDB.MET_WALK_HIGH;
            }
            break;
        case ActivityDB.INDEX_SLEEP:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_SLEEP_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                MET = ActivityDB.MET_SLEEP_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                MET = ActivityDB.MET_SLEEP_HIGH;
            } else {// 임시
                MET = ActivityDB.MET_SLEEP_HIGH;
            }
            break;
        case ActivityDB.INDEX_WALK_STAIR:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_WALK_STAIR_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                MET = ActivityDB.MET_WALK_STAIR_HIGH;
            } else { // 임시
                MET = ActivityDB.MET_WALK_STAIR_HIGH;
            }
            break;
        case ActivityDB.INDEX_STAND:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_STAND_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                MET = ActivityDB.MET_STAND_MID;
            } else { // 임시
                MET = ActivityDB.MET_STAND_MID;
            }
            break;
        case ActivityDB.INDEX_JUMP_ROPE:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_JUMP_ROPE_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                MET = ActivityDB.MET_JUMP_ROPE_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                MET = ActivityDB.MET_JUMP_ROPE_HIGH;
            } else { // 임시
                MET = ActivityDB.MET_JUMP_ROPE_HIGH;
            }
            break;
        case ActivityDB.INDEX_DISUSE:
            MET = 1;
            break;
        case ActivityDB.INDEX_BICYCLING:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_BICYCLING_LOW;
            } else { // 임시
                MET = ActivityDB.MET_BICYCLING_LOW;
            }
            break;
        case ActivityDB.INDEX_GOLF:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_GOLF_LOW;
            } else { // 임시
                MET = ActivityDB.MET_GOLF_LOW;
            }
            break;
        case ActivityDB.INDEX_CLIMBING:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_CLIMBING;
            } else {
                MET = ActivityDB.MET_CLIMBING;
            }
            break;
        case ActivityDB.INDEX_DAILY_ACT:
            if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) { // 같다:0
                MET = ActivityDB.MET_DAILY_ACT_LOW;
            } else { // 임시
                MET = ActivityDB.MET_DAILY_ACT_LOW;
            }
            break;
        case ActivityDB.INDEX_SWING_ACT:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_SWING_ACT_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                MET = ActivityDB.MET_SWING_ACT_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                MET = ActivityDB.MET_SWING_ACT_HIGH;
            } else { // 임시
                MET = ActivityDB.MET_SWING_ACT_HIGH;
            }
            break;
        case ActivityDB.INDEX_WALK_SLOPE:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_WALK_SLOPE_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                MET = ActivityDB.MET_WALK_SLOPE_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                MET = ActivityDB.MET_WALK_SLOPE_HIGH;
            } else {// 임시
                MET = ActivityDB.MET_WALK_SLOPE_HIGH;
            }
            break;
        case ActivityDB.INDEX_WALK_FAST:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_WALK_FAST_LOW;
            } else {// 임시
                MET = ActivityDB.MET_WALK_FAST_LOW;
            }
            break;
        case ActivityDB.INDEX_TENNIS:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_TENNIS;
            } else { // 임시
                MET = ActivityDB.MET_TENNIS;
            }
            break;
        case ActivityDB.INDEX_TABLE_TENNIS:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_TABLE_TENNIS;
            } else { // 임시
                MET = ActivityDB.MET_TABLE_TENNIS;
            }
            break;
        case ActivityDB.INDEX_INTENSE_ACT:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_INTENSE_ACT_HIGH;
            } else { // 임시
                MET = ActivityDB.MET_INTENSE_ACT_HIGH;
            }
            break;
        case ActivityDB.INDEX_SPORT:
            if(intensity == Float(ActivityDB.STRENGTH_LOW)) { // 같다:0
                MET = ActivityDB.MET_JUMPING_ACT_LOW;
            } else if(intensity == Float(ActivityDB.STRENGTH_MIDDLE)) {
                MET = ActivityDB.MET_JUMPING_ACT_MID;
            } else if(intensity == Float(ActivityDB.STRENGTH_HIGH)) {
                MET = ActivityDB.MET_JUMPING_ACT_HIGH;
            } else { // 임시
                MET = ActivityDB.MET_JUMPING_ACT_HIGH;
            }
            break;
            
            
        // 수동 운동!!
        case ActivityDB.INDEX_MANUAL_BASEBALL:
            MET = ActivityDB.BASEBALL_MET;
            break;
        case ActivityDB.INDEX_MANUAL_BASKETBALL:
            MET = ActivityDB.BASKETBALL_MET;
            break;
        case ActivityDB.INDEX_MANUAL_BOWLING:
            MET = ActivityDB.BOWLING_MET;
            break;
        case ActivityDB.INDEX_MANUAL_CROSS_TRAINNING:
            MET = ActivityDB.CROSS_TRAINNING_MET;
            break;
        case ActivityDB.INDEX_MANUAL_DANCE:
            MET = ActivityDB.DANCE_MET;
            break;
        case ActivityDB.INDEX_MANUAL_ELLIPTICAL:
            MET = ActivityDB.ELLIPTICAL_MET;
            break;
        case ActivityDB.INDEX_MANUAL_FOOTBALL:
            MET = ActivityDB.FOOTBALL_MET;
            break;
        case ActivityDB.INDEX_MANUAL_INNER_BICYCLING:
            MET = ActivityDB.INNER_BICYCLING_MET;
            break;
        case ActivityDB.INDEX_MANUAL_POCKETBALL:
            MET = ActivityDB.POCKETBALL_MET;
            break;
        case ActivityDB.INDEX_MANUAL_SKI:
            MET = ActivityDB.SKI_MET;
            break;
        case ActivityDB.INDEX_MANUAL_SOFTBALL:
            MET = ActivityDB.SOFTBALL_MET;
            break;
        case ActivityDB.INDEX_MANUAL_WEIGHT_TRAINNING:
            MET = ActivityDB.WEIGHT_TRAINNING_MET;
            break;
        case ActivityDB.INDEX_MANUAL_YOGA:
            MET = ActivityDB.YOGA_MET;
            break;
        default:
            break
        }
        return MET;
    }
    
    func getMETfromJob(jobIndex:Int) -> Float {
        var MET:Float = 0
        switch(jobIndex) {
        case DBContactHelper.JOB_OFFICE_JOB:
            MET = OFFICE_JOB_MET;
            break;
        case DBContactHelper.JOB_SITE_WORKER:
            MET = SITE_WORKER_MET;
            break;
        case DBContactHelper.JOB_STUDENT:
            MET = STUDENT_MET;
            break;
        case DBContactHelper.JOB_HOUSEWIFE:
            MET = HOUSEWIFE_MET;
            break;
        default:
            break
        }
        return MET;
    }
    
    
    func getConsumeCalorie(weight:Float, time:Int, actIndex:Int, jobIndex:Int, isAct:Bool, intensity:Float, heartrate:Int) -> Float {
        let MET:Float = getMETfromActivity(actIndex: actIndex, intensity: intensity);
        return floor(MET*weight*Float(time)*0.0175) //Int(bigMET.multiply(bigWeight).multiply(bigMETdefine).floatValue()*time);
    }
    
    func getConsumeCalorie(weight:Float, time:Int, actIndex:Int, jobIndex:Int, heartrate:Int, MET:Float) -> Float {
        return floor(MET*weight*Float(time)*0.0175)
    }
    
    func getConsumeCalorieBMR(weight:Float, time:Int) -> Float {
        let MET:Float = ActivityDB.MET_DAILY_ACT_LOW
        //return (int) (bigMET.multiply(bigWeight).multiply(bigMETdefine).floatValue() * time);
        return floor(MET*weight*Float(time)*0.0175)
    }
    
    func getConsumeCalorieSlope(profile:Contact.Profile, intensity:Float, grade:Int, index:Int) -> Float {
        let cal:Float = getConsumeCalorie(weight: profile.getWeight(), time: 1, actIndex: index, jobIndex: Int(profile.getJob()), isAct: true, intensity: intensity, heartrate: 0);
        //return (float)(grade == 0 ? cal : cal*(grade*10+100)/100);
        return floor((grade == 0 ? cal : cal * Float(grade*10+100)/100))
    }
    
    // 수동 선택 관련 이제 안씀.
    func getConsumeCalorie(weight:Float, time:Int, actIndex:Int, intensity:Float) -> Float {
        let MET:Float = getMETfromActivity(actIndex: actIndex, intensity: intensity);
        return floor(MET*weight*Float(time)*0.0175) //Int(bigMET.multiply(bigWeight).multiply(bigMETdefine).floatValue()*time);
    }
    /*
    func setDailyRemainCalorie(intake:Float, consume:Float) -> Float {
        return floor(((intake - consume) < 0 ? 0 : (intake - consume)) + getCalorieConsumeDaily());
    }*/
    
    /**
     * 총 소비 칼로리를 float 형태로 반환한다.
     * @return 총 소비 칼로리 반환.
     */
    /*
    func getCalorieConsumeTotal() -> Float {
        var cSum:Float = 0
        
        Global_Calendar.setTimeInMillis(MWCalendar.currentTimeMillis())
        let nowDay:Int32 = Global_Calendar.day
        Log.i(BehaviorManager.tag, msg:"getCalorieConsumeTotal")
        /*var consumeArray:[Contact.ActInfo] = mDBHelper!.getActArray()!;
         if(consumeArray != nil) {
         for consume:Contact.ActInfo in consumeArray {
         Global_Calendar.setTimeInMillis(consume.getC_year_month_day());
         if(nowDay == Global_Calendar.day) {
         cSum += consume.getC_calorie()
         //cSum += consume.getC_calorie();
         //cSum = convertPoint(cSum);
         }
         }
         }*/
        if let consumeArray:[Contact.ActInfo] = mDBHelper?.getActArray() {
            for consume:Contact.ActInfo in consumeArray {
                Global_Calendar.setTimeInMillis(consume.getC_year_month_day());
                if(nowDay == Global_Calendar.day) {
                    cSum += consume.getC_calorie()
                    //cSum += consume.getC_calorie();
                    //cSum = convertPoint(cSum);
                }
            }
        }
        return Float(Int(cSum))
    }*/
    
    
    /**
     * 수면 정보를 DB에 임시로 저장하며, FIFO 방식으로 저장. 데이터가 5일치가 들어가기 때문에, 여유 시간에 하지 않으면 부하가 심할듯..
     * 1) 저장할때 FIFO 처리? 혹은 Load할때 FIFO 처리?
     * 2) 웹에 업로드하면서 FIFO 처리?
     */
    
    /**
     * 사용자 나이 정보로 계산된 심박 위험 존
     * @return 심박 위험 존 정보. ( [0]:최대 심박수, [1]:최고 심박수 )
     */
    func getHeartRateDangerZone() -> [Float] {
        guard let profile:Contact.Profile = DBContactHelper.getInstance().PLgetUserProfile()
            else {
                return [Float(0), Float(0)]
        }
        
        let maxHR:Float = Float(Int32(220) - profile.getAge())
        let largeHR:Float = maxHR * 0.8;
        
        return [Float(maxHR), Float(largeHR)]//new float[]{maxHR, largeHR};
    }
    
    func getHeartRateIntenseZone() -> Float {
        guard let profile:Contact.Profile = DBContactHelper.getInstance().PLgetUserProfile()
            else {
                return Float(0)
        }
        let maxHR:Float = Float(Int32(220) - profile.getAge())
        let intenseHR:Float = maxHR * 0.6
        
        return intenseHR;
    }
    
    func getSpeedForRecommended(act_index:Int, step:Int) -> Float {
        var spd:Float = 0
        switch(act_index) {
        case ActivityDB.INDEX_WALK, ActivityDB.INDEX_WALK_SLOPE, ActivityDB.INDEX_WALK_FAST, ActivityDB.INDEX_WALK_AND_SLOPE:
            if(step <= 30){
                spd = 0.5;
            } else if(31 < step && step < 65) {
                spd = 1;
            } else {
                spd = Float((step-65) / 10)
            }
            break;
        case ActivityDB.INDEX_RUN:
            if(step <= 40) {
                spd = 4;
            }else if(41 < step && step < 85) {
                spd = 5;
            }
            else{
                spd = Float((step-85) / 10)
            }
            break;
        default: break
        }
        spd = Float.init(String.init(format: "%.1f", spd))!
        
        return spd < 1 ? 1 : spd;
    }
    
    /**
     * 시간 list에 포함되는 시간인지 판단. 시간 리스트는 절대시간 10분 단위로 작성되어 있어야 하며, 시작시간은 포함하고 끝 시간은 포함하지 않게 검색.
     * @param time
     * @param timeList
     * @return
     */
    func compareTime(time:Int64, timeList:[Int64]) -> Bool {
        if(timeList.count == 0){
            Log.i(BehaviorManager.tag, msg:"compare TIME \(time) \(timeList)")
            return false
        }
        Log.i(BehaviorManager.tag, msg:"compare TIME \(time) \(timeList) \(timeList.count)")
        //for(int i=0; i< timeList.length; i++) {
        for i in 0..<timeList.count {
            if(i % 2 == 0) {
                // 홀수인 경우, start 시간 판단.
                if(timeList[i] <= time) { // 1차 조건 판정.
                    if(i+1 < timeList.count && timeList[i+1] > time){ // 2차 조건 판정.
                        return true;
                    }
                    else if(i+1 == timeList.count && timeList[i] <= time){
                        return true;
                    }
                    else if(1 == timeList.count && timeList[0] <= time){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    
    /*
    func setTimeList() {
        //RecommendedStore[] recList = getTimeList();
        //var recList:[Contact.RecommendedStore]? = getTimeList()
        var recList:[Recommend]? = getTimeList()
        if(recList != nil) {
            var tList = [Int64](repeating: 0, count: (recList?.count)!) //= new long[recList.length];
            //for(int i=0; i<tList.length; i++) {
            for i in 0..<tList.count {
                tList[i] = Int64((recList?[i].getTime)!);
            }
            timeManualList = tList;
            if(BehaviorManager.DEBUG) {
                Log.d(BehaviorManager.tag, msg: "timeManualList");
                var j:Int = 0
                for l:Int64 in timeManualList {
                    Log.d(BehaviorManager.tag, msg: "i:\(j) time:\(l)")
                    j += 1
                }
            }
        } else{
            Log.i(BehaviorManager.tag, msg: "setTimeList()에서 전부지워지나?")
            timeManualList.removeAll()
        }
    }
    //규창... RecommendedStore의 존재... 골아프네
    
    //func getTimeList() -> [Contact.RecommendedStore]?  {
    func getTimeList() -> [Recommend]? {
        /*let tList:String = Preference.getTimeList()!
         //let tFlag:String = Preference.getTimeListFlag()
         if(tList.length <= 0){
         Log.i(ActManager.tag, msg: "getTimeList()에서 리턴먹나?")
         //return nil
         return nil
         }*/
        guard let tList:String = Preference.getTimeList() else {
            //if(tList == nil){
            Log.i(BehaviorManager.tag, msg: "getTimeList()에서 리턴먹나?")
            //return nil
            return nil
        }
        //let tmptList = String(data:tList.data(using: String.Encoding.utf8)!, encoding: String.Encoding.nonLossyASCII)
        Log.d(BehaviorManager.tag, msg: "timelist : \(tList)\(Preference.getTimeList()!) \(Preference.getTimeListFlag()!) ")
        let tFlag:String = Preference.getTimeListFlag()!
        
        
        
        var tArray:[String] = tList.components(separatedBy: ",")// tList.split(",");
        //let tIntArray = tArray.map{ Int64($0)! }
        Log.d(BehaviorManager.tag, msg: "tArray : \(tArray) , int64 \(tArray[0])")
        var tFArray:[String] = tFlag.components(separatedBy: ",")//tFlag.split(",");
        let len:Int = tArray.count
        //RecommendedStore[] rec = new RecommendedStore[len];
        //var rec = Array(repeating: Contact.RecommendedStore(), count: len)
        var rec = Array(repeating: Recommend(), count: len)
        
        //for(int i=0; i<len; i++) {
        for i in 0..<len {
            //규창
            //RecommendedStore tmp = Global_Contact.new RecommendedStore();
            //let tmp:Contact.RecommendedStore = Contact.RecommendedStore()
            let tmp:Recommend = Recommend()
            let tmpTstr:String = tArray[i]
            let tmpTFstr:String = tFArray[i]
            Log.i(BehaviorManager.tag, msg: "tArray : \(tmpTstr) , int64 \(tArray[i])")
            Log.i(BehaviorManager.tag, msg: "tArray : \(tmpTFstr) , int64 \(tFArray[i])")
            var tempTime:Int64 = 0
            if tArray[i].length != 0 || tArray[i] != "" {
                tempTime = Int64(tArray[i])!
            }
            var tempFlag:Int = 0
            if tFArray[i].length != 0 || tFArray[i] != "" {
                tempFlag = Int(tFArray[i])!
            }
            
            /*guard let tempTime = NumberFormatter().number(from: tArray[i])?.int64Value else {
             Log.i(ActManager.tag, msg: "getTimeList()에서 시간언팩이 안된다....")
             break;
             }*/
            
            /*guard let tempFlag = Int.init(tFArray[i]) else {
             Log.i(ActManager.tag, msg: "getTimeList()에서 시간플래그 언팩이 안된다....")
             break;
             }*/
            //if tempTime == nil {
            //tmp.setTime(time: 0)
            //   tmp.setFlag(flag: 0)
            //}else {
            tmp.setTime(time: tempTime)
            tmp.setFlag(flag: tempFlag)
            //tmp.setFlag(flag: 0)
            //}
            Log.d(BehaviorManager.tag, msg: "tmp.getTime : \(tmp.getTime)")
            //tmp.setTime(time: Int64(tArray[i])!)//(Long.valueOf(tArray[i]));
            //tmp.setFlag(flag: Int.init(tFArray[i])!)
            rec[i] = tmp
        }
        if(BehaviorManager.DEBUG) {
            Log.d(BehaviorManager.tag, msg: "getTimeList")
            Log.d(BehaviorManager.tag, msg: "timelist : \(String(describing: tList))")
            Log.d(BehaviorManager.tag, msg: "timelistFlag : \(String(describing: tFlag))")
        }
        
        return rec;
    }
    
    //func addTimeList(rec:Contact.RecommendedStore?) {
    func addTimeList(rec:Recommend?) {
        guard let temprec = rec else {
            Log.i(BehaviorManager.tag, msg: "addTimeList()에서 리턴먹나?")
            return
        }
        var tFlag:String? = Preference.getTimeListFlag()
        Log.d(BehaviorManager.tag, msg: "addTimeList1" );
        var tList:String? = Preference.getTimeList()
        Log.d(BehaviorManager.tag, msg: "addTimeList2");
        if(tList != nil) {
            //if(tList?.length != 0) {
            //if(tList.length >= 0) {
            tList? += "," + String.init(temprec.getTime)
            tFlag? += "," + String.init(temprec.getFlag())
        } else {
            tList = String.init(temprec.getTime);
            tFlag = String.init(temprec.getFlag());
        }
        
        Preference.putTimeList(tList);
        Preference.putTimeListFlag(tFlag);
        
        if(ActManager.DEBUG) {
            Log.d(ActManager.tag, msg: "addTimeList");
            Log.d(ActManager.tag, msg: "timelist : \(String(describing: tList))");
            Log.d(ActManager.tag, msg: "timelistFlag : \(String(describing: tFlag))");
        }
    }
    
    func deleteTimeList() {
        Preference.putTimeList(nil)
        Preference.putTimeListFlag(nil)
    }
    //규창....?
    func deleteTimeList(index:Int) {
        guard var tList:String = Preference.getTimeList() else {
            //if(tList == nil) {
            return
        }
        var tFlag:String = Preference.getTimeListFlag()!
        let spiltPoint:Int = tList.lastIndex(of:",")
        let spiltPointF:Int = tFlag.lastIndex(of: ",")
        
        if(spiltPoint > 0) {
            tList = tList.substringToIndex(spiltPoint)!
            tFlag = tFlag.substringToIndex(spiltPointF)!
        } else {
            tList = ""
            tFlag = ""
        }
        
        Preference.putTimeList(tList)
        Preference.putTimeListFlag(tFlag)
    }*/
}

