//
//  Contact.swift
//  planner-swift
//
//  Created by 양정은 on 2016. 3. 9..
//  Copyright © 2017년 심규창. All rights reserved.
//

import Foundation

open class Contact {
    open class Profile {
        fileprivate var sex: Int32;
        fileprivate var job: Int32;
        fileprivate var age: Int32;
        fileprivate var height: Int32;
        fileprivate var weight: Float32;
        fileprivate var goalWeight: Float32;
        
        public init() {
            self.sex = 0;
            self.job = 0;
            self.age = 0;
            self.height = 0;
            self.weight = 0;
            self.goalWeight = 0;
        }
        
        public init(sex: Int32, job: Int32, age: Int32, height: Int32, weight: Float32, goalWeight: Float32) {
            self.sex = sex;
            self.job = job;
            self.age = age;
            self.height = height;
            self.weight = weight;
            self.goalWeight = goalWeight;
        }
        
        
        func getHeight() -> Int32 {return height;}
        func setHeight(_ height: Int32) {self.height = height;}
        
        func getWeight() -> Float32 {return weight;}
        func setWeight(_ weight: Float32) {self.weight = weight;}
        
        func getGoalWeight() -> Float32 {return goalWeight;}
        func setGoalWeight(_ goalWeight: Float32) {self.goalWeight = goalWeight;}
        
        func getAge() -> Int32 {return age;}
        func setAge(_ age: Int32) {self.age = age;}
        
        func getSex() -> Int32 {return sex;}
        func setSex(_ sex: Int32) {self.sex = sex;}
        
        func getJob() -> Int32 {return job;}
        func setJob(_ job: Int32) {self.job = job;}
    }
    
    open class SleepInfo {
        fileprivate var time: Int64;
        fileprivate var status: Int32;
        fileprivate var count: Int32;
        fileprivate var flag: Int32;
        
        public init() {
            time = 0;
            status = 0;
            count = 0;
            flag = 0;
        }
        
        public init(time: Int64, status: Int32, count: Int32) {
            self.time = time;
            self.status = status;
            self.count = count;
            self.flag = 0;
        }
        
        func getTime() -> Int64 {return time;}
        func setTime(_ time: Int64) {self.time = time;}
        
        func getStatus() -> Int32 {return status;}
        func setStatus(_ status: Int32) {self.status = status;}
        
        func getCount() -> Int32 {return count;}
        func setCount(_ count: Int32) {self.count = count;}
        
        func setFlag(flag: Int32) {
            self.flag = flag
        }
        
    }
    
    open class ActInfo {
        fileprivate var c_year_month_day: Int64;
        fileprivate var c_exercise: Int32;
        fileprivate var c_intensity: Float32;
        fileprivate var c_calorie: Float32;
        fileprivate var c_unit: Int32;
        fileprivate var c_intensity_number: Float32;
        fileprivate var c_heartrate: Int32;
        fileprivate var c_step: Int32;
        fileprivate var c_swing: Int32;
        fileprivate var c_press_variance: Float32;
        fileprivate var c_coach_intensity: Float32;
        fileprivate var c_flag: Int32;
        
        
        public init(c_year_month_day: Int64, c_exercise: Int32, c_intensity: Float32,
            c_calorie: Float32, c_unit: Int32, c_intensity_number: Float32, c_heartrate: Int32, c_step: Int32, c_swing: Int32, c_press_variance: Float32, c_coach_intensity: Float32,  c_flag: Int32) {
                self.c_year_month_day = c_year_month_day;
                self.c_exercise = c_exercise;
                self.c_intensity = c_intensity;
                self.c_calorie = c_calorie;
                self.c_unit = c_unit;
                self.c_intensity_number = c_intensity_number;
                self.c_heartrate = c_heartrate;
                self.c_step = c_step;
                self.c_swing = c_swing;
                self.c_press_variance = c_press_variance;
                self.c_coach_intensity = c_coach_intensity;
                self.c_flag = c_flag;
        }
        
        public init(act: ActInfo) {
            self.c_year_month_day = act.c_year_month_day;
            self.c_exercise = act.c_exercise;
            self.c_intensity = act.c_intensity;
            self.c_calorie = act.c_calorie;
            self.c_unit = act.c_unit;
            self.c_intensity_number = act.c_intensity_number;
            self.c_heartrate = act.c_heartrate;
            self.c_step = act.c_step;
            self.c_swing = act.c_swing;
            self.c_press_variance = act.c_press_variance;
            self.c_coach_intensity = act.c_coach_intensity;
            self.c_flag = act.c_flag;
        }
        
        public init() {
            self.c_year_month_day = 0;
            self.c_exercise = 0;
            self.c_intensity = 0;
            self.c_calorie = 0;
            self.c_unit = 0;
            self.c_intensity_number = 0;
            self.c_heartrate = 0;
            self.c_step = 0;
            self.c_swing = 0;
            self.c_press_variance = 0;
            self.c_coach_intensity = 0;
            self.c_flag = 0;
        }
        
        func getC_coach_intensity() -> Float32 {return c_coach_intensity;}
        func setC_coach_intensity(_ c_coach_intensity: Float32) {self.c_coach_intensity = c_coach_intensity;}
        
        func getC_press_variance() -> Float32 {return c_press_variance;}
        func setC_press_variance(_ c_press_variance: Float32) {self.c_press_variance = c_press_variance;}
        
        func getC_swing() -> Int32 {return c_swing;}
        func setC_swing(_ c_swing: Int32) {self.c_swing = c_swing;}
        
        func getC_step() -> Int32 {return c_step;};
        func setC_step(_ c_step: Int32) {self.c_step = c_step;};
        
        func getC_heartrate() -> Int32 {return c_heartrate;}
        func setC_heartrate(_ c_heartrate: Int32)  {self.c_heartrate = c_heartrate;}
        
        func getC_intensity_number() -> Float32 {return c_intensity_number;}
        func setC_intensity_number(_ c_intensity_number: Float32) {self.c_intensity_number = c_intensity_number;}
        
        func getC_unit() -> Int32 {return c_unit;}
        func setC_unit(_ c_unit: Int32) {self.c_unit = c_unit;}
        
        func getC_calorie() -> Float32 {return c_calorie;}
        func setC_calorie(_ c_calorie: Float32) {self.c_calorie = c_calorie;}
        
        func getC_intensity() -> Float32 {return c_intensity;}
        func setC_intensity(_ c_intensity: Float32) {self.c_intensity = c_intensity;}
        
        func getC_Exercise() -> Int32 {return c_exercise;}
        func setC_Exercise(_ c_exercise: Int32) {self.c_exercise = c_exercise;}
        
        func getC_year_month_day() -> Int64 {return c_year_month_day;}
        func setC_year_month_day(_ c_year_month_day: Int64) {self.c_year_month_day = c_year_month_day;}
        
        func getC_flag() -> Int32 {return c_flag;}
        func setC_flag(_ c_flag: Int32) {self.c_flag = c_flag;}
        
        public init(json :NSDictionary) {
            //Log.d(Contact.ActInfo.tag, msg: "파싱: \(json)");
            self.c_year_month_day = 0;
            self.c_exercise = 0;
            self.c_intensity = 0;
            self.c_calorie = 0;
            self.c_unit = 0;
            self.c_intensity_number = 0;
            self.c_heartrate = 0;
            self.c_step = 0;
            self.c_swing = 0;
            self.c_press_variance = 0;
            self.c_coach_intensity = 0;
            self.c_flag = 0;
            
            
            if let rt = json["RT"] as? Int {
                self.c_year_month_day = Int64(rt);
            }
            
            if let ex = json["EX"] as? Int {
                self.c_exercise = Int32(ex);
            }
            
            if let un = json["UN"] as? Int {
                self.c_unit = Int32(un);
            }
            
            if let hr = json["HR"] as? Int {
               self.c_heartrate = Int32(hr);
            }
            
            if let st = json["ST"] as? Int {
                self.c_step = Int32(st);
            }
            
            if let sw = json["SW"] as? Int {
                self.c_swing = Int32(sw);
            }
            
            if let it = json["IT"] as? Int {
                self.c_intensity = Float32(it) / 100;
            }
            
            if let ca = json["CA"] as? Int {
                self.c_calorie = Float32(ca) / 100;
            }
            
            if let in_n = json["IN"] as? Int {
                self.c_intensity_number = Float32(in_n) / 100;
            }
            
            if let pv = json["PV"] as? Int {
                self.c_press_variance = Float32(pv) / 100;
            }
            
            if let ci = json["CI"] as? Int {
                self.c_coach_intensity = Float32(ci) / 100;
            }
            
            //self.c_flag = DBContactHelper.SET_UPDATED;
        }
    }
    /* 규창 파편화된 추천운동 클래스 분리 --> service/Recommend
    open class RecommendedStore {
        var time:Int64 = 0
        var flag:Int = 0
        
        public init(time:Int64, flag:Int) {
            self.time = time;
            self.flag = flag;
        }
        
        public init() {
            self.time = 0
            self.flag = 0
        }
        
        func getTime() -> Int64 {
            return self.time
        }
        func setTime(time:Int64) {
            self.time = time
        }
        func getFlag() -> Int {
            return flag
        }
        func setFlag(flag:Int) {
            self.flag = flag;
        }
    }*/
}
