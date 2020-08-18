//
//  CalculateBase.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 7. 1..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

public class CalculateBase {
    static var main_HrArray:[Int] = [0,0,0,0,0]
    
    fileprivate static var sumInterval:Int = 2; // 초단위
    
    fileprivate static var mDatabase = Database.getInstance()

    //---구현
    // 심박수 zone을 계산.
    static func getHeartRateDangerZone(_ profile: (age: Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32))->[Float] {
        let age: Int32 = profile.age;
        let maxHR: Float = 220 - Float(age);
        let largeHR: Float = maxHR*0.8;
        
        return [maxHR,largeHR]
    }
    
    //--- 최대 심박수 대비 현재 심박수 계산(%)
    static func avgHeartRate(_ hr:Int) -> Int  {
        var ret:Int = 0
        var count:Int = 0
        
        for i in 0..<(main_HrArray.count - 1) {
            main_HrArray[i] = main_HrArray[i + 1];
        }
        main_HrArray[4] = hr;
        
        for i in main_HrArray {
            if (i != 0) {
                ret += i;
                count += 1;
            }
        }
        
        return count == 0 ? 0 : ret / count;
    }
    
    static func reset() {
        for i in 0..<main_HrArray.count {
            main_HrArray[i] = 0
        }
    }
    
    public static func getConsumeCalorie(weight: Float, MET: Float) -> Float {
        return (weight * MET * 0.0175 * 1440)
    }
    
    //--- 최대 심박수 대비 현재 심박수를 반환.(%)
    //--- @param hr 현재 심박수
    //--- @return 반환하는 심박수(%)
    static func getHeartRateCompared(_ hr: Int, profile: (age: Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32)) -> Int {
        var stable = mDatabase.HeartRateStable
        if stable == 0 {
           stable = 60
        }
        
        var ret: Float = Float(hr - Int(stable))
        ret = ret / Float(220 - profile.age - Int32(stable)) * 100
        
        return ret < 0 ? 0 : Int(ret)
    }
    
    public static func getHeartRateCompared(_ hr: Int, stable: Int32, age: Int32) -> Int {
        var stable = stable
        if stable == 0 {
            stable = 60
        }
        
        var ret: Float = Float(hr - Int(stable))
        ret = ret / Float(220 - age - Int32(stable)) * 100
        
        return ret < 0 ? 0 : Int(ret)
    }
    
    //--- point 계산. 정확도의 횟수의 평균치를 계산한다.
    //--- @param videoID
    //--- @param accuracy
    //--- @param count
    //--- @return
    static func getPoint(_ count: Int, accuracy: Int) -> Int {
        // 카운트와 정확도는 항상 100%를 넘을 수 있음. 넘으면 100%로 계산.
        Log.d("CalculateBase", msg: "getPoint : \((accuracy * count)/100) count:\(count) acc:\(accuracy)");
        return (accuracy * count) / 100;
    }
    
    
    //--- sumInterval 간격으로 칼로리를 합산.
    //--- @param pulseRate
    //---            sumInterval 간격의 평균 값으로 계산된 심박수.
    //--- @return 계산된 소비 칼로리.(kcal)
    
    static func formulaHeartRate(_ pulseRate: Int, profile: (age: Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32)) -> Float {
        var calorie: Float = 0
        let weight = profile.weight
        
        let metabolic_rate_per_sec = getMetabolicRate(profile) / 86400
        
        if (profile.sex == 1) {
            calorie = (-8477.604 + (weight * 6.481) + (Float(pulseRate) * 51.426) + (weight * Float(pulseRate) * 1.018)) * (Float(sumInterval) / 60 / 1000)
            if (metabolic_rate_per_sec * Float(sumInterval) > calorie) {
                calorie = metabolic_rate_per_sec * Float(sumInterval)
            }
            
            return calorie
        }
        else {
            calorie = (100.127 + (weight * -106.729) + (Float(pulseRate) * 12.580) + (weight * Float(pulseRate) * 1.251)) * (Float(sumInterval) / 60 / 1000)
            if (metabolic_rate_per_sec * Float(sumInterval) > calorie) {
                calorie = metabolic_rate_per_sec * Float(sumInterval)
            }
            
            return calorie;
        }
    }
    
    public static func getMetabolicRate(age: Int, sex: Int, height: Int, weight: Float) -> Float {
        var rate: Float = 0
        
        if (sex == 1) {
            rate = 88.362 + (13.397 * weight)
            rate += (4.799 * Float(height)) - (5.677 * Float(age))
        } else {
            rate = 447.593 + (9.247 * weight)
            rate += (3.098 * Float(height)) - (4.330 * Float(age))
        }
        
        return rate
    }
    
    static func getMetabolicRate(_ profile: (age: Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32)) -> Float32 {
        var rate: Float32 = 0
        let weight = profile.weight
        let height = profile.height
        let age = profile.age
        
        if (profile.sex == 1) {
            rate = 88.362 + (13.397 * weight)
            rate += (4.799 * Float(height)) - (5.677 * Float(age))
        } else {
            rate = 447.593 + (9.247 * weight)
            rate += (3.098 * Float(height)) - (4.330 * Float(age))
        }
        
        return rate
    }
}
