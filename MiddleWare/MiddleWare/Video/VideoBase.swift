//
//  VideoBase.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 7. 1..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation
import XML_AART

class VideoBase: TotalScoreBase {
    var currentPosition:Int = 0;
    var isPlaying:Bool = false;
    var set_HRLock:Bool = false;
    var setPlay:Bool = true;
    var is_R_Video:Bool = false;
    var isSave = false
    var isDisableUI:Bool = false;
    var set_AccuracyLock:Bool = false
    
    fileprivate var isShowUI = false
    
    var accuracyQueue:ArrayQueueUtil<Int> = ArrayQueueUtil<Int>()
    var Out:[Int] = [0,0]

    fileprivate static let  THR_NOT_MOVE:Int = 200; // 10초
    var idx_count = 0
    var preCalorie:Float = 0;
    var sumCalorie:Float = 0;
    
    var save_start_time:String = ""
    
    var pBase: pVideoBase!
    
    fileprivate static let MODE_NEW_START:Int = 1;
    fileprivate static let MODE_RESUME:Int = 2;

    let mDBHelper = DBContactHelper.getInstance()
    let mDatabase = Database.getInstance()
    //--- 재생 모드 설정.
    //--- @param mode resume : 변수 보존, new : 변수 초기화.
    
    func setPlayMode(_ mode: Int) {
        if (mode == VideoBase.MODE_NEW_START) {
            pBase.initInstance();
        }
    }
    
    //--- 재생을 담당하며 자동으로 Raw 데이터를 기록. 재생 시, 설정된 파일명으로 Raw 데이터를 기록한다. Kist 엔진과의 연동
    //---시작을 담당.
    //--- @return true:성공, false:실패(이미 재생중. end function을 실행 시켜주세요.)
    func play() -> Bool {
        //Log.i(VideoManager.tag, msg:"플레이 함수시작")
        if isPlaying {
            return false;
        } else {
            isPlaying = true;
            mDatabase.Profile = (mDBHelper?.getUserProfile())!
            return true;
        }
    }
    
    //--- 동영상 종료. 재생이 끝나면 항상 실행해야 함.
    func end() {
        //log(tag, "end()");
        mDatabase.resetVideoVariable()
        isPlaying = false
        pBase.initInstance()
        set_HRLock = false
        //stopVibrate() //밴드에서 자동으로 울리고 있어서 막음.
    }
    
    //--- 사용자가 직접 동영상을 종료할 경우 수행.
    func userExit() {
        //    for (long startTime = 0 ; startTime <= arrayStartTime ; startTime++)
        //        mConfig.deleteUserExerciseData(startTime);
        //    arrayStartTime= 0;//.clear();
    }
    
    
    //--- 현재 동영상 재생을 알리는 flag setting
    //--- @param setPlay 현재 동영상의 재생 상태. (true:재생중, false:중지)
    func setPlaying(_ setPlay: Bool) {
        self.setPlay = setPlay;
    }
    
    
    //--- 현 동영상의 재생 위치를 알림.
    //--- @param currentPosition 현재 동영상의 재생 위치. (sec 단위)
    func setCurrentTimePosition(_ position: Int) {
        currentPosition = position
    }
    
    
    func isRVideo()-> Bool {
        return is_R_Video;
    }
    func FuncisDisableUI()-> Bool {
        return isDisableUI;
    }
    
    func getCourseCodeForQuery(_ programCode: Int) -> String {
        let code = programCode + 320000
        return String(code)
    }
    
    // 이하 내용은 xml파일이 입력됨을 가정하고(stream?) 읽어서 동작시키는 로직의 구현내용.
    func setProgram(_ xml: Data) {
        pro = getProgram(xml)
        setMessageField(pro)
    }
    
    // 임시로 넣도록 하자. 스트림을 어떻게 받아올것인지는 이사님과 논의 필요..
    var pro: Program = Program()
    
    fileprivate var m_languageCode: String = "KO"
    open var LanguageCode: String {
        set {
            let locale:Locale = Locale.current
            print("Locale\(locale)")
            let languageCode:AnyObject = (locale as NSLocale).object(forKey: NSLocale.Key.languageCode)! as AnyObject
            m_languageCode = (languageCode as! String).uppercased()
            print("LanguageCode\(m_languageCode)")
            if m_languageCode != "KO" && m_languageCode != "JA" && m_languageCode != "EN" && m_languageCode != "ZH" {
                m_languageCode = "KO"
            }
            if m_languageCode == "JA" {
                m_languageCode = "JP"
            }
            print("m_languageCode\(m_languageCode)")
        }
        get {
            print("m_languageCode\(m_languageCode)")
            return m_languageCode
        }
    }
    
    
    var v_code: Int = 0
    
    fileprivate var ProgramTotalCount: Int {
        if pro.CourseList!.isEmpty {
            return 0
        }
        
        var count = 0
        for c in pro.CourseList! {
            count += c.TotalCount
        }
        
        return count
    }
    
    func getExerCount(_ pro: Program, v_code: Int) -> Int {
        for c in pro.CourseList! {
            if c.Code == v_code {
                return c.TotalCount
            }
        }
        
        return 15
    }
    
    fileprivate func findLocalizeMessage(_ list: [Translation]) -> String {
        for t in list {
            if t.Language == m_languageCode {
                return t.Display
            }
        }
        
        return ""
    }
    
    fileprivate func setMessageField(_ pro: Program) {
        if pro.MessageList == nil {
            return
        }
        
        for message in pro.MessageList! {
            TotalScoreDic.updateValue(findLocalizeMessage(message.List!), forKey: message.Code)
        }
    }
    
    fileprivate func getProgram(_ xml: Data) -> Program {
        var pro: Program?
        var doc:AEXMLDocument?
        
        // example of using NSXMLParserOptions
        var options = AEXMLDocument.NSXMLParserOptions()
        options.shouldProcessNamespaces = false
        options.shouldReportNamespacePrefixes = false
        options.shouldResolveExternalEntities = false
        do {
            doc = try AEXMLDocument(xmlData: xml, xmlParserOptions: options)
            
            pro = Program(ele: doc!.root)
        }
        catch {
            print("\(error)")
        }
        
        
        return pro!
    }
    
    fileprivate func getMsg(_ grade: Int, action: Action) -> Int {
        var msg = 0;
        
        switch grade {
        case 5 where action.m_Accuracy!.OutFlag5:
            msg = action.m_Accuracy!.MsgNum5
        case 4 where action.m_Accuracy!.OutFlag4:
            msg = action.m_Accuracy!.MsgNum4
        case 3 where action.m_Accuracy!.OutFlag3:
            msg = action.m_Accuracy!.MsgNum3
        case 2 where action.m_Accuracy!.OutFlag2:
            msg = action.m_Accuracy!.MsgNum2
        case 1 where action.m_Accuracy!.OutFlag1:
            msg = action.m_Accuracy!.MsgNum1
        default:
            msg = 0
        }
        
        return msg;
    }
    
    fileprivate func getComment(_ pro: Program, index: Int) -> String? {
        if pro.MessageList!.isEmpty {
            return nil
        }
        
        for m in pro.MessageList! {
            if m.Code == index {
                // 언어 값은??? 프로퍼티를 셋만 쓸까?
                return findLocalizeMessage(m.List!)
            }
        }
        
        return nil
    }
    
    func onUiDisplay(_ pro: Program, currentPosition: Int) -> (showUi: Bool, name: String) {
        return pro.getUiDisplay(currentPosition)
    }
    
    func switchVideo(_ isUiDisPlay: Bool) {
        if isShowUI != isUiDisPlay {
            isShowUI = isUiDisPlay
            MWNotification.postNotification(MWNotification.Video.ShowUI, info: [MWNotification.Video.ShowUI : isShowUI as AnyObject])
        }
//        if !isUiDisPlay {
//            isDisableUI = true
//        } else {
//            isDisableUI = false
//        }
    }
    
    fileprivate func reset() {
        // 리셋은 총점이 표시된 다음 실시해야함.
        // 총점의 값 세팅은 코스 하나가 끝나자마자 실시.
        // 총점의 표시는 코스끝+총점시작시간에서 총점표시시간만큼 표시.
        
    }
    
    fileprivate func convertIndexFor15min(_ v_code: Int) -> Int {
        switch v_code {
        case 311:
            return 301
        case 312:
            return 302
        case 313:
            return 303
        case 314:
            return 304
        case 315:
            return 305
        case 316:
            return 306
        case 317:
            return 307
        case 318:
            return 308
        case 319:
            return 309
        case 320:
            return 310
        default:
            return v_code
        }
    }
    
    func getResult(_ pro: Program, out: KIST_AART_output, extra: (avgHR: Int, count_percent: Int, minAccuracy: Int, maxAccuracy: Int, avgAccuracy: Int, minHeartRate: Int, maxHeartRate: Int, avgHeartRate: Int)) -> Bool {
        // 엔진 구동 시간으로 결정. UI 표시 시간은 다름. switchUI 기능 포함.
        let doublePosition = Double(currentPosition)
        if let course = pro.find(doublePosition) {
            isSave = false
            
            mDatabase.resetTotalScore()
            
            is_R_Video = false
            if save_start_time == "" {
                let millieseconds:TimeInterval =  Date().timeIntervalSince1970*1000
                save_start_time = String(format: "%f", millieseconds)
            }
            
            v_code = course.Code;
            print("v_code->\(v_code)")
            
            if let action = course.find(doublePosition) {
                print("action->\(action) \(action.Start)")
                var duration: Double = 0
                for act in course.ActionList! {
                    duration += act.getDuration()
                }
                
                action.SubmitFunctions(out)
                if action.GetCheckResult(out) {
                    action.m_Accuracy?.ResetFrequency()
                    
                    let acc = action.m_Accuracy!.GetResult(out)
                    let grade = action.m_Accuracy!.GetGrade(out)
                    print("GETRESULT 1. code: \(v_code) acc:\(acc) grade:\(grade)")
                    
                    if(accuracyQueue.isEmpty == true) {
                        if acc > 0 {
                            accuracyQueue.push(Int(acc))
                            
                            Out[1] = Int(acc)
                            Out[0] += 1
                        }
                        
                        let msgIdx = getMsg(grade, action: action)
                        if set_AccuracyLock == true {
                            if let msg = getComment(pro, index: msgIdx) {
                                if msg == "RANDOM" {
                                    func getRandom(_ idx: Int) -> String {
                                        switch idx {
                                        case 0:
                                            return TotalScoreDic[MessageIndex.random1.rawValue]!
                                        case 1:
                                            return TotalScoreDic[MessageIndex.random2.rawValue]!
                                        case 2:
                                            return TotalScoreDic[MessageIndex.random3.rawValue]!
                                        case 3:
                                            return TotalScoreDic[MessageIndex.random4.rawValue]!
                                        default:
                                            return TotalScoreDic[MessageIndex.random1.rawValue]!
                                        }
                                    }
                                    mDatabase.BottomComment = getRandom(Int(acc) % 4)
                                } else {
                                    mDatabase.BottomComment = msg
                                }
                                idx_count = 0
                            }
                        }
                        
                        print("GETRESULT code : \(course.Code) currentPosition : \(currentPosition) acc : \(acc) grade : \(grade) msgIdx : \(msgIdx) action : \(action)")
                    }
                    out.Reset();
                }
                
                idx_count += 1
                if (idx_count > VideoManager.THR_NOT_MOVE) {
                    //setCommentFlagUI(1);
                    
                    idx_count = 0;
                    
                    let hr_percent = CalculateBase.getHeartRateCompared(extra.avgHR, profile: mDatabase.Profile)
                    if (hr_percent <= 20) {
                        mDatabase.BottomComment = TotalScoreDic[MessageIndex.bad.rawValue]!
                    } else if (hr_percent >= 60) {
                        mDatabase.BottomComment = TotalScoreDic[MessageIndex.rest.rawValue]!
                    }
                }
            }
        } else {
            out.Reset()
            out.ResetGlobal()
            is_R_Video = true
            if v_code != 0 && !isSave {
                // 총점 값 세팅.
                // 전역변수로 잡아놔야함
                // 쓰는놈하고 표시하려는놈하고 다름.
                // 이때, 운동 하나 끝나므로, 데이터 저장.
                
                // 밑의 코멘트의 선택 로직은 동일하나, 코멘트의 저장필요.(XML)
                isSave = true
                let point = CalculateBase.getPoint(extra.count_percent, accuracy: extra.avgAccuracy)
                pBase.setTotalScore(point, count_percent: extra.count_percent, accuracy_percent: extra.avgAccuracy, comment: getCommentSection(extra.count_percent, accuracy_percent: extra.avgAccuracy))
                
                let cmpHeartRate = CalculateBase.getHeartRateCompared(extra.avgHeartRate, profile: mDatabase.Profile)
                // max 심박수 자리에, 안정심박수를 넣어서 서버로 전달.(카르보넨 사용)
                var stable = mDatabase.HeartRateStable
                if stable == 0 {
                    stable = 60
                }
                
                let millieseconds:TimeInterval =  Date().timeIntervalSince1970*1000
                let save_end_time = String(format: "%f", millieseconds)
                let starttime:Int64 = strtoll(save_start_time, nil, 10)
                let endtime:Int64 = strtoll(save_end_time, nil, 10)
                
                let exer_count = getExerCount(pro, v_code: v_code)
                
                if extra.minHeartRate == 0 || extra.avgHeartRate == 0 {
                    print("break save exer data.. reason: heartrate == 0")
                    return false
                }
                if starttime <= 0 || endtime <= 0 {
                    print("break save exer data.. reason: savetime <= 0")
                    return false
                }
                
                let consume_calorie = sumCalorie - preCalorie
                mDatabase.ExerData = (pro.Code, video_full_count: ProgramTotalCount, exer_idx: convertIndexFor15min(v_code),  exer_count: exer_count, start_time: starttime, end_time: endtime, consume_calorie: Int(roundf(consume_calorie)), count: Out[0], count_percent: extra.count_percent, perfect_count: 0/*perfect count*/,minAccuracy: extra.minAccuracy, maxAccuracy: extra.maxAccuracy, avgAccuracy: extra.avgAccuracy, minHeartRate: extra.minHeartRate, maxHeartRate: Int(stable), avgHeartRate: extra.avgHeartRate, cmpHeartRate: cmpHeartRate, point: point)
                
                return false
            }
        }
        
        return true
    }
}
