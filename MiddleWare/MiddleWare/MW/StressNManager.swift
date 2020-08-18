//
//  StressN_Manager.swift
//  MiddleWare
//
//  Created by 심규창 on 2016. 8. 16..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

private let mStressNManager = StressNManager()


class StressNManager: NSObject, pStressNormal {
    
    fileprivate static let tag = StressNManager.className
    
    fileprivate var stressNQueue:ArrayQueueUtil<Double> = ArrayQueueUtil<Double>()
    fileprivate var stressHrArray:[Double] = []
    var isMeasuring:Bool = false;
    let mDatabase = Database.getInstance()
    fileprivate var measureSteady:Int = 0;
    
    
    class func getInstance() -> StressNManager! {
        return mStressNManager
    }
    
    
    override init() {
        Log.i(StressNManager.tag, msg: "StressNManager 초기화")
        super.init()
    }
    
    deinit {
        Log.i(StressNManager.tag, msg: "StressNManager 해제")
    }
    
    
    
    
    
    // Delegate
    func onstressHr(_ stressHr: Double) {
        if !isMeasuring {
            return
        }
        measureSteady = measureSteady + 1
        
        //stressNQueue.push(stressHr)
        Log.i(StressNManager.tag, msg: "pStressNormal(프로토콜) -> StressNManager(클래스) \(stressHr) measureSteady:\(measureSteady)")
        if measureSteady >= 500 {
            Log.i(StressNManager.tag, msg: "pStressNormal(프로토콜) -> StressNManager(클래스) \(stressHr)")
            if stressHrArray.last != stressHr {
                stressHrArray.append(stressHr)
            }
        }
        
        //심박이 0이 아닐 때만 값을 넣기
        //if stressHr > 0 {
        //    stressHrArray.append(stressHr)
        //}        // 만약 심박이 0일 경우엔 이전값 넣기
        //if stressHr == 0 || stressHr == nil {
        //    stressHrArray.append(stressHrArray[stressHrArray.count-1])
        //}
    }
    
    
    
    
    //--- 재생을 담당하며 자동으로 Raw 데이터를 기록. 재생 시, 설정된 파일명으로 Raw 데이터를 기록한다.
    //---시작을 담당.
    //--- @return true:성공, false:실패(이미 재생중. end function을 실행 시켜주세요.)
    func play() {//-> Bool {
        Log.i(StressNManager.tag, msg:"StressNManager play()")
        //if isMeasuring == false {
        //    Log.i(StressNManager.tag, msg:"플레이 함수시작:\(isMeasuring)")
        //    return false;
            
        //} else {
        isMeasuring = true;
            
        //    Log.i(StressNManager.tag, msg:"플레이 함수시작:\(isMeasuring)")
            //resultMeasure(stressHrArray)
         //   return true;
        //}
    
    }
    
    
    func end() {
        
        isMeasuring = false
        Log.i(StressNManager.tag, msg: "StressNManager end()");
        if stressHrArray.count != 0 {
            minHRwithErrorCheck(stressHrArray)
        }else {
            Log.i(StressNManager.tag, msg: "심박 보정중 문제가 발생!!!")
            //MWNotification.postNotification(MWNotification.Bluetooth.NormalStressErrorInform)
            var sendStressNIndex:Int16 = 0
            sendStressNIndex = 3
            mDatabase.StressNResult = sendStressNIndex
            //Log.i(StressNManager.tag, msg: "심박 측정중 문제가 발생!!!")
        }
        measureSteady = 0;
        stressHrArray.removeAll()
        
    }
    func minHRwithErrorCheck(_ HrArrayTemp:[Double]){
        var FindMinHR:[Double] = []
        for i in 0..<HrArrayTemp.count {
            if HrArrayTemp[i] != 0 && HrArrayTemp[i] > 1 {
                FindMinHR.append(HrArrayTemp[i])
            }
        }
        Log.i(StressNManager.tag, msg:"보정된 심박\(FindMinHR)")
        if FindMinHR.count == 0 {
            Log.i(StressNManager.tag, msg: "심박 보정중 문제가 발생!!!")
            //MWNotification.postNotification(MWNotification.Bluetooth.NormalStressErrorInform)
            var sendStressNIndex:Int16 = 0
            sendStressNIndex = 3
            mDatabase.StressNResult = sendStressNIndex
        } else {
            fBPM2NNCalc(FindMinHR.min()!, HrArrayTemp: HrArrayTemp)
        }
        
    }
    
    
    
    func fBPM2NNCalc(_ FixHR:Double , HrArrayTemp: [Double]) {
        var HrArray:[Double] = []
        
        
        let BPMlength = Double(HrArrayTemp.count)
        //var BPMavg = HrArrayTemp.reduce(0, combine: {$0 + $1}) / BPMlength
        
        for i in 0..<HrArrayTemp.count {
            if HrArrayTemp[i] > 1 {
                HrArray.append(HrArrayTemp[i])
            }else {
                HrArray.append(FixHR)
            }
        }
        
        
        Log.i(StressNManager.tag, msg:"*******************************************")
        Log.i(StressNManager.tag, msg:"보정된 심박개수\(HrArray.count)")
        Log.i(StressNManager.tag, msg:"보정 안된 심박개수\(HrArrayTemp.count)")
        Log.i(StressNManager.tag, msg:"*******************************************")
        Log.i(StressNManager.tag, msg:"보정된 심박\(HrArray)")
        Log.i(StressNManager.tag, msg:"보정 안된 심박\(HrArrayTemp)")
        Log.i(StressNManager.tag, msg:"*******************************************")
        
        var NNValue:[Double] = []
        let BPMavg = (HrArray.reduce(0, {$0 + $1}) / BPMlength).rountToDecimal(4)
        _ = HrArray.reduce(0, {$0 + $1})
        let maxHR = HrArray.max()!
        let minHR = HrArray.min()!
        
        for i in 0..<HrArray.count {
            NNValue.append((60000/HrArray[i]).rountToDecimal(4))
        }
        Log.i(StressNManager.tag, msg:"보정된 심박\(NNValue)")
        Log.i(StressNManager.tag, msg:"보정 안된 심박\(NNValue)")
        Log.i(StressNManager.tag, msg:"*******************************************")
        
        let length = Double(NNValue.count)
        _ = NNValue.reduce(0, {$0 + $1})
        let avg = NNValue.reduce(0, {$0 + $1}) / length
        var total2:Double = 0
        //var vari:Double = 0
        for i in NNValue{
            total2 += ((i-avg) * (i-avg))
        }
        //vari = total2/(length-1)
        
        let sumOfSquaredAvgDiff = NNValue.map{ pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        let std = sqrt(sumOfSquaredAvgDiff / length)
        
        
        let vAVNN = calAVNN(NNValue).rountToDecimal(4)
        let vSDNN = calSDNN(NNValue).rountToDecimal(4)
        let vRMSSD = calRMSSD(NNValue).rountToDecimal(4)
        let vPNN50 = calcPNN50(NNValue).rountToDecimal(4)
        
        
        
        
        
        /***** BPM *****/
        print("심박 아이템갯수 \(HrArray.count)")
        print("최고 심박수:\(maxHR)")
        print("최저 심박수:\(minHR)")
        //print("전체값:\(BPMtotal)")
        print("평균:\(BPMavg)")
        //print("심박 아이템갯수 \(NNValue.count)")
        //print("전체값:\(total) \(vari)")
        
        /***** NN *****/
        print("vAVNN:\(vAVNN) 평균:\(avg)")
        print("vSDNN:\(vSDNN) 표준편차:\(std)")
        print("vRMSSD:\(vRMSSD)")
        print("PNN50:\(vPNN50)")
        
        
        
        var sendStressNIndex:Int16 = 0;
        
        switch vSDNN {
        case 1..<20:
            sendStressNIndex = 4
        case 20..<40:
            sendStressNIndex = 3
        case 40..<60:
            sendStressNIndex = 2
        case 60..<200:
            sendStressNIndex = 1
        default:
             sendStressNIndex = 3
        }
        
        Log.i(StressNManager.tag, msg: "스트레스 인덱스 체크!!!! \(sendStressNIndex)")
        mDatabase.StressNResult = sendStressNIndex
        measureSteady = 0;
        //mDatabase.TotalScore = (score.duration, t_point, t_count_percent, t_accuracy_percent, t_comment)
        //mDatabase.StressNResult = (maxHR,minHR,BPMavg,vSDNN,vRMSSD)
        //stressHrArray.removeAll()
        //featuredNNLabel.text = String.init(format: "AVNN: \(vAVNN)\nSDNN: \(vSDNN)\nRMSSD: \(vRMSSD)")
        //btnPlay.hidden = false
        
    }
    
    func calAVNN(_ interval:[Double]) -> Double{
        var sum = 0.0
        
        for i in interval {
            sum += i
        }
        let size = interval.count
        return sum / Double(size)
    }
    
    func calSDNN(_ interval:[Double]) -> Double{
        let average = calAVNN(interval)
        var d = 0.0
        for i in interval {
            let v = i - average
            d += (v * v)
        }
        let size = interval.count
        return sqrt(d / Double(size))
    }
    
    
    func calRMSSD(_ interval:[Double]) -> Double{
        var d = 0.0
        let size = interval.count
        for i in 0 ..< size - 1 {
            let interval0 = interval[i]
            let interval1 = interval[i + 1]
            let diff = interval1 - interval0
            d += (diff * diff)
        }
        return sqrt(d / Double(size-1))
    }
    
    func calcPNN50(_ interval:[Double]) -> Double{
        var count:Int = 0
        let size = interval.count
        
        for i in 0..<interval.count - 1 {
            let interval0 = interval[i]
            let interval1 = interval[i + 1]
            var diff = interval1 - interval0
            if diff < 0.0 {
                diff = -diff
            }
            if diff > 50.0 {
                //grater than 50ms
                count += 1
            }
            
        }
        return  Double(count) / Double(size) * 100.0
    }
}
