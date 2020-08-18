//
//  VideoManager.swift
//  CoachMiddleWare
//
//  Created by 심규창 on 2016. 5. 31..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART

private let mVideoManager = VideoManager();

class VideoManager: VideoBase, pNordicFormat, pVideoBase {
    
    fileprivate static let tag = VideoManager.className
    
    /** private variable **/
    fileprivate static let version:String = "1.1.8.13"
    
    
    fileprivate var t_point:Int  = 0
    fileprivate var t_count_percent:Int = 0
    fileprivate var t_accuracy_percent:Int = 0
    fileprivate var t_comment:String = "";
    
    //규창  ---- 블록문 대치 못해 사용 못함
    fileprivate var block: __dispatch_block_flags_t?
    
    
    //private var  sumAccuracyD = 0;
    fileprivate var sumAccuracy:Int = 0;
    fileprivate var avgAccuracy:Int = 0;
    fileprivate var minAccuracy:Int = 0;
    fileprivate var maxAccuracy:Int = 0;
    fileprivate var maxHeartRate:Int = 0;
    fileprivate var minHeartRate:Int = 0;
    fileprivate var avgHeartRate:Int = 0;
    fileprivate var sumHeartRate:Int = 0;
    fileprivate var count_percent:Int = 0;
    fileprivate var sumCountPerecnt:Float = 0;
    fileprivate var size_hr_queue:Int = 0;
    
    //private var sumCalorieD = 0;
    fileprivate var setFormula:Bool = false;
    //char setFormulaD = false;
    
    
    //private var  isAction = false;
    fileprivate var is_R_vid:Int = 0;
    
    // Tag
    fileprivate var setTag:Bool = false;
    fileprivate var setSave:Bool = false;
    //private var setDebugPlay:Bool = false;
   

    fileprivate var mSdPath:String = ""
    fileprivate var realFileName:String = ""
    fileprivate var recordName:String = "";
    fileprivate var hyphen:String = "-";
    fileprivate var mFolder:String = "/coachData/";
    
    //Context mContext;
    
    fileprivate var preCount:Float = 0;
    
    fileprivate var delay_brief:Int = 5;
    
    fileprivate var interval_AccuracyLock:Int = 1 //정확도 1초뒤에 지움
    //Timer t;
    
    fileprivate static let LEE_TRAINER_NUMBER:Int = 1;
    fileprivate static let HONG_TRAINER_NUMBER:Int = 2;
    fileprivate static let CHILDBIRTH_NUMBER:Int = 3;
    
    fileprivate static let SET_VIDEO_ID_1:Int = 3;
    fileprivate static let SET_VIDEO_ID_2:Int = 4;
    fileprivate static let SET_VIDEO_ID_3:Int = 2;
    fileprivate static let SET_VIDEO_ID_4:Int = HONG_TRAINER_NUMBER  * 100 + 1;
    fileprivate static let SET_VIDEO_ID_5:Int = HONG_TRAINER_NUMBER  * 100 + 2;
    fileprivate static let SET_VIDEO_ID_6:Int = LEE_TRAINER_NUMBER  * 100 + 1;
    fileprivate static let SET_VIDEO_ID_7:Int = LEE_TRAINER_NUMBER  * 100 + 2;
    fileprivate static let SET_VIDEO_ID_8:Int = CHILDBIRTH_NUMBER * 100 + 1; // 1~4주차
    fileprivate static let SET_VIDEO_ID_9:Int = CHILDBIRTH_NUMBER * 100 + 2; // full
    // 5~8주차

    
    //규창 Java->C로 하면서 사용된 변수들
    fileprivate var cnt:Int = 0
    fileprivate var Accuracycnt:Int = 0
    fileprivate var Commentcnt:Int = 0
    fileprivate var calorie:Float = 0
    //double getSensor;
    fileprivate var getAccData:[Double] = [0,0,0]
    fileprivate var getHRdata:Int = 0
    //int HRarray[5];
    fileprivate var avgHR:Int = 0;
//    private var HR:[Float] = [0,0]

    
    //--- Array
    fileprivate var HRQueue:ArrayQueueUtil<Int> = ArrayQueueUtil<Int>()
    fileprivate var reset_HRQueue:ArrayQueueUtil<Int> = ArrayQueueUtil<Int>()
    
    //private final ListQueueUtil<Integer> HRQueue = new ListQueueUtil<Integer>();
    //private final ListQueueUtil<Integer> HRQueueD = new ListQueueUtil<Integer>();
    //private final ListQueueUtil<Integer> reset_HRQueue = new ListQueueUtil<Integer>();
    //private final ListQueueUtil<Integer> reset_HRQueueD = new ListQueueUtil<Integer>();
    //private final ListQueueUtil<Integer> accuracyQueue = new ListQueueUtil<Integer>();
    //private final ListQueueUtil<Integer> accuracyQueueD = new ListQueueUtil<Integer>();
    //private final double[] toDouble = new double[BluetoothManager.arrayLength];
    //private final double[] toDoubleD = new double[BluetoothManager.arrayLength];
    //private final int[] out = new int[2];
    ///private final int[] outD = new int[2];
    
    
    
    fileprivate var m_KIST:KIST_AART // = KIST_AART()
    fileprivate var mOut:KIST_AART_output// = KIST_AART_output()
    
    class func getInstance() -> VideoManager {
        return mVideoManager
    }
    
    func initInstance(){
        setFormula = false;
        //isAction = false;
        is_R_Video = false;
        isDisableUI = false;
        is_R_vid = 0;
        isSave = false;
        
        isPlaying = false;
        setSave = false;
        //setDebugPlay = false;
        setPlay = true;
        
        //releaseAccuracyLock();
        
        set_vibrateLock = false;
        set_HRLock = false;
        
        CalculateBase.reset()
        Out = [0,0]
        
        currentPosition = 0;

        t_count_percent = 0
        t_accuracy_percent = 0
        t_point = 0
        t_comment = "";
        
        //sumAccuracyD = 0;
        
        sumAccuracy = 0
        avgAccuracy = 0
        minAccuracy = 0
        maxAccuracy = 0
        maxHeartRate = 0
        minHeartRate = 0
        avgHeartRate = 0
        sumHeartRate = 0
        count_percent = 0
        sumCountPerecnt = 0
        size_hr_queue = 0
        
        preCalorie = 0
        
        idx_count = 0
        
        sumCalorie = 0
        save_start_time = ""
    }
    
    override init() {
        Log.i(VideoManager.tag, msg: "VideoManager 초기화")
        
        //mVideoManager = VideoManager()
        Log.i(VideoManager.tag, msg: "KIST 객체 초기화")
        m_KIST = KIST_AART()
        Log.i(VideoManager.tag, msg: "KIST_AART 객체 초기화")
        mOut = KIST_AART_output()
        Log.i(VideoManager.tag, msg: "KIST_AART_output 객체 초기화")
        /*initQarray();
        self = *initVideoManagerData();
        VideoParameter = *initVideoParameter();
        
        if([GetDefaultValue(DEFAULT_KEY_USER_GENDER)  isEqual: @"남성"]){
            mProfile.sex = 0;
        }else{
            mProfile.sex = 1;
        }
        mProfile.weight=[GetDefaultValue(DEFAULT_KEY_USER_CURRENTWEIGHT) floatValue];*/
        /*
        if HRQueue.isEmpty == true{
            HRQueue.elements.removeAll()
        }
        if accuracyQueue.isEmpty == true{
            accuracyQueue.elements.removeAll()
        }*/
        
        //arrayStartTime.clear();
        
        // 여기서 프로그램 초기화 해야함.
        super.init()
        
        pBase = self
        mBle.nNF = self
    }
    
    
    deinit {
        Log.i(VideoManager.tag, msg: "Videomanager 해제")
    }
    
    // Delegate
    func onSensor(_ sensor: [Double]) {
        if !isPlaying {
            return
        }
        getAccData = [sensor[0], sensor[1], sensor[2]]
        getHRdata = Int(sensor[3])
        print("x \(getAccData[0]) y \(getAccData[1]) z \(getAccData[2]) HR: \(getHRdata)")
        
        // float[] sensor 내용
        // 배열의 0,1,2 = 가속도 x,y,z
        // 배열의 3,4,5 = 자이로 x,y,z
        // 배열의 6 = 기압
        // 배열의 7 = 심박
        
        if (!setPlay){
            return
        }
        
        if (pro.Code == 0){
            return
        }
        
        //--- KIST 엔진 실행
        //getSensor= onSensor();
        //getAccData
        //본래는 여기서 센서 인터페이스에 접근하여 받아와서 사용하나, 뷰컨트롤(bleManager+app)단에서 이쪽에 직접전송
        
        mOut = m_KIST.fn_AART_Cal_parameter(getAccData)
        
        //Log.d("HR","hr:"+toDouble[7]);
        
        //--- 심박수
        ////NSLog(@"VideoManager.videoID%d, 포지션%d",VideoManager.videoID,VideoManager.currentPosition);
        let uiDisplay = onUiDisplay(pro, currentPosition: currentPosition)
        switchVideo(uiDisplay.showUi)
        
        if(getHRdata != 0) {
            //for (int i = 0; i <= 5; i++) {
            //if(HRQueue.isEmpty == true){
            HRQueue.push(getHRdata)
            //}
//            Log.i(VideoManager.tag, msg: "HR enqueue, \(HRQueue.count)")
            //NSLog(@"HR enqueue=%d", arQarray[0].size);
            //}
        }
        
        
        //--- 최대 심박수 대비 현재 심박수 계산(%)
        avgHR = CalculateBase.avgHeartRate(getHRdata)
        if (!set_HRLock) {
            
            ////NSLog(@"디버깅테스트 avgHR:%d", avgHR);
//            Log.i(VideoManager.tag, msg: "avgHR:\(avgHR)")
            onHeartRateCompared(avgHR);
            
            //--- 심박수 감시.
            onHeartRateWarnning(avgHR);
            set_HRLock = true;
            //mHandler_avgHR.postDelayed(mRunnable_avgHR, 5 * 1000);
            let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.set_HRLock = false;
            }
        }
        
        //--- KIST 엔진에서 어느정도 간격으로 데이터를 갱신하려는지 모름. KIST 엔진의 갱신에 맞추어서
        //--- 심박수를 계산해야 함. 현재는 임시로 5초 간격으로 구성해놓음. sumInterval = 5;
        if (!self.setFormula) {
            self.setFormula = true;
            let popTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                //void run() {
                var sumHR:Int = 0
                var HR:Int = 0
                //int sumAccuracy = 0;
                //int acc = 0;
                var size_hr_queue:Int = self.HRQueue.count
                self.size_hr_queue += size_hr_queue;
                var minus:Int = 0
                if(size_hr_queue > 0){
                    for _ in 0..<size_hr_queue {
                        if self.HRQueue.isEmpty != true {
                            HR = self.HRQueue.pop()
                        }else{
//                            Log.i(VideoManager.tag, msg: "심박큐 비어있음")
                            minus = minus + 1
                        }
                        //do{
                        //    try HR = self.HRQueue.pop()
                        //}catch let error as NSError{
                        //    Log.i(VideoManager.tag, msg: "심박큐 비어있음 \(error)")
                        //    minus += 1
                        //}
                        
                        
//                        Log.i(VideoManager.tag, msg: "HR dequeue:\(self.HR) Qsize:\(self.HRQueue.count) // \(size_hr_queue)")
                        
                        sumHR += HR;
//                        Log.i(VideoManager.tag, msg: "sumHR:\(sumHR)")
                        if (self.maxHeartRate < HR){
                            self.maxHeartRate = HR;
                        }
                        if (self.minHeartRate > HR){
                            self.minHeartRate = HR;
                        }
                        if (self.minHeartRate == 0){
                            self.minHeartRate = HR;
                        }
                    }
                }
                size_hr_queue -= minus;
                //NSLog(@"HR Qsize:%d,localQsize:%d\n", VideoManager.size_hr_queue,size_hr_queue);
                
                
                //--- 5초 딜레이를 주면서, 수집한 데이터를 계산함
                var retCal:Float = 0;
                if (size_hr_queue > 0) {
                    retCal = CalculateBase.formulaHeartRate(sumHR/size_hr_queue, profile: self.mDatabase.Profile);
//                    Log.i(VideoManager.tag, msg: "sumHR/size_hr_queue:\(sumHR/size_hr_queue)")
                }
                if (retCal > 0) {
                    self.sumCalorie += retCal;
                }
                
                self.sumHeartRate += sumHR;
                
                if (size_hr_queue != 0){
                    self.avgHeartRate = (self.sumHeartRate/self.size_hr_queue) ;
                }
                
                
                self.mDatabase.VideoCalorie = self.sumCalorie
                
                self.setFormula = false;
            }
        }
        
        mDatabase.ActivityName = seperateActivityNameForLanguage(uiDisplay.name)
        onTotalScore(pro, currentPosition: currentPosition)

        let result = getResult(pro, out: mOut, extra: (avgHR, count_percent, minAccuracy, maxAccuracy, avgAccuracy, minHeartRate, maxHeartRate, avgHeartRate))
        if !result {
            preCalorie = sumCalorie;
            Out[0] = 0;
            Out[1] = 0;
            count_percent = 0;
            minAccuracy = 0;
            maxAccuracy = 0;
            avgAccuracy = 0;
            minHeartRate = 0;
            maxHeartRate = 0;
            sumHeartRate = 0
            avgHeartRate = 0;
            sumAccuracy = 0
            size_hr_queue = 0
            
            save_start_time = ""
        }
        
        mDatabase.Count = (Out[0], getExerCount(pro, v_code: v_code))
        
        var acc:Int = 0;
        let size_accuracy_queue:Int = accuracyQueue.count
        if (size_accuracy_queue > 0){
            for _ in 0..<size_accuracy_queue {
                if self.accuracyQueue.isEmpty != true {
                    acc = self.accuracyQueue.pop()
                }else{
//                    Log.i(VideoManager.tag, msg: "정확도 큐 비어있음")
                    
                }
                
                if acc > 100 {
                    acc = 100
                }
                
                sumAccuracy += acc;
                if (maxAccuracy < acc) {
                    maxAccuracy = acc;
                }
                if (minAccuracy > acc) {
                    minAccuracy = acc;
                }
                if (minAccuracy == 0){
                    minAccuracy = acc;
                }
            }
        }
        
        ////NSLog(@"Acc Qsize:%d, localQsize:%d\n", size_accuracy_queue, arQarray[1].size);
        
        if (Out[0] != 0){
            avgAccuracy = sumAccuracy / Out[0] > 100 ? 100 : sumAccuracy / Out[0];
        }
        else{
            avgAccuracy = 0;
        }
        
        let count = getExerCount(pro, v_code: v_code)
        count_percent = Int(100.0 * Double(Out[0]) / Double(count) > 100 ? 100 : 100.0 * Double(Out[0]) / Double(count));
        //if(out[1] != PHASE_0) {// 0으로 가지 않아서 그래프가 사라지지 않음. 다른 처리 필요.
        if (Out[0] != Int(self.preCount)) {// 0으로 가지 않아서 그래프가 사라지지 않음. 다른 처리 필요.
            releaseAccuracyLock();
            
            mDatabase.Accuracy = Out[1] > 100 ? 100 : Out[1]
            mDatabase.Point = CalculateBase.getPoint(count_percent, accuracy: avgAccuracy)
            
            let popTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.Out[1] = 0;
                self.mDatabase.Accuracy = self.Out[1]
                self.mDatabase.Point = CalculateBase.getPoint(self.count_percent, accuracy: self.avgAccuracy)
            }
            setAccuracyLock();
        }
        
        preCount = Float(Out[0])
    }
    
    fileprivate func seperateActivityNameForLanguage(_ name: String) -> String {
        let seperate = name.components(separatedBy: "/")
        if seperate.count < 4 {
            return name
        }
        
        if LanguageCode == "KO" {
            return seperate[0]
        } else if LanguageCode == "JP" {
            return seperate[1]
        } else if LanguageCode == "EN" {
            return seperate[2]
        } else if LanguageCode == "ZH" {
            return seperate[3]
        } else {
            return name
        }
    }

    //--- 정확한 심박수가 들어온다는 가정하에 comment를 하기 위한 함수.
    //--- @param hr
    func onHeartRateWarnning(_ hr:Int) {
        //if (mIView == null)
        //	return;
        var hrZone:[Float] = CalculateBase.getHeartRateDangerZone(mDatabase.Profile);
        ////NSLog(@"hrzone0:%f, hrzone1:%f", hrZone[0], hrZone[1]);
        if (Int(hrZone[1]) < hr) {// 최대 심박수의 80%
            mDatabase.HRWarnning = (TotalScoreDic[MessageIndex.heart.rawValue]!)
            NSLog(TotalScoreDic[MessageIndex.heart.rawValue]!);
            //startVibrate(); //밴드에서 자동으로 울리고 있어서 막음.
            // 진동 구현 필요.
        }
    }
    
    func setTotalScore(_ point:Int, count_percent:Int, accuracy_percent:Int, comment:String) {
        t_point = point;
        t_count_percent = count_percent;
        t_accuracy_percent = accuracy_percent;
        t_comment = comment;
    }
    
    //--- 정확도 lock 설정. 6초 안으로 0의 값이 들어오면 무시.
    func setAccuracyLock() {
        //    if (mHandler_AccuracyLock != null) {
        //        return;
        //	}
        //	mHandler_AccuracyLock = new Handler(Looper.getMainLooper());
        //	mHandler_AccuracyLock.postDelayed(mRunnable_AccuracyLock, interval_AccuracyLock * 1000);
        
        //Accuracycnt++;
        //NSLog(@"정확도 락 설정:%d", Accuracycnt);
        Accuracycnt += 1;
        self.set_AccuracyLock = true;
        
    }
    
    //--- 정확도 lock 해제.
    func releaseAccuracyLock() {
        //    if (mHandler_AccuracyLock == NULL)
        //        return;
        //	mHandler_AccuracyLock.removeCallbacks(mRunnable_AccuracyLock);
        //	mHandler_AccuracyLock = NULL;
        
        
        self.set_AccuracyLock = false;
        
    }
    
    //--- 현재 정확도 lock 확인.
    //--- @return 현재 정확도 lock flag.
    func getAccuracyLock() -> Bool {
        return set_AccuracyLock;
    }
    
    func onHeartRateCompared(_ hr:Int) {
        mDatabase.HRCmp = CalculateBase.getHeartRateCompared(hr, profile: mDatabase.Profile);
    }
    
    // delegate need
    func onTotalScore(_ pro: Program, currentPosition: Int) {
        let score = pro.getToTalScoreDisplay(currentPosition)
        if score.showScore {
            if t_comment == "" {
                return
            }
            
            mDatabase.TotalScore = (score.duration, t_point, t_count_percent, t_accuracy_percent, t_comment)
            //값 뿌리면 리셋 실시.
            // 총점 관련 변수 리셋 필요.
            
            t_point = 0
            t_count_percent = 0
            t_accuracy_percent = 0
            t_comment = ""
        }
    }
}
