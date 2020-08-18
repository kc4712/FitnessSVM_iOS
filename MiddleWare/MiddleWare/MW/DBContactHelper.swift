//
//  ContentManager.swift
//  Swift_Middleware
//
//  Created by 심규창 on 2016. 6. 8..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

private let mDBHelper: DBContactHelper = DBContactHelper();

class DBContactHelper:NSObject {
    fileprivate static let tag = DBContactHelper.className

    static let DO_NOT_USE_NULLDATA: Int32 = 1;
    static let INCORRECT_DATA: Int32 = 3;
    static let SUCCESS: Int32 = 0;
    static let FAILED = 1;
    
    
    /**
     * 직업군 별 INDEX:사무직 INDEX
     */
    static let JOB_OFFICE_JOB = 1;
    /**
     * 직업군 별 INDEX:현장 근로자 INDEX
     */
    static let JOB_SITE_WORKER = 2;
    /**
     * 직업군 별 INDEX:학생 INDEX
     */
    static let JOB_STUDENT = 3;
    /**
     * 직업군 별 INDEX:주부 INDEX
     */
    static let JOB_HOUSEWIFE = 4;
    
    
    
    class func getInstance() -> DBContactHelper! {
        return mDBHelper;
    }
    
    /**
     * 사용자 Profile 정보를 기본 DB에 작성한다. Parameter가 null 혹은 zero 값이 들어오면 DO_NOT_USE_NULLDATA 코드를 반환한다.
     * 허용되지 않는 데이터가 입력되면  INCORRECT_DATA 코드를 반환한다.
     * @param sex 사용자의 성별.
     * @param job 사용자의 직업군.
     * @param age 사용자의 나이.
     * @param height 사용자의 키.
     * @param weight 사용자의 체중.
     * @param goalWeight 사용자의 목표 체중.
     * @return 2:INCORRECT_DATA, 1:DO_NOT_USE_NULLDATA, 0:SUCCESS
     */
    func setUserProfile(_ age: Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32) -> Int32 {
        if age == 0 || height == 0 || weight == 0 {
            Log.e(DBContactHelper.tag, msg: "do not use null&zero data : setUserProfile");
            return DBContactHelper.DO_NOT_USE_NULLDATA;
        }
        
        if age < 2 {
            return DBContactHelper.INCORRECT_DATA;
        }
        
        if sex < 1 || sex > 2 {
            return DBContactHelper.INCORRECT_DATA;
        }
        
        Preference.putAge(age);
        Preference.putSex(sex);
        Preference.putHeight(height);
        Preference.putWeight(weight);
        Preference.putGoalWeight(goalWeight);
        
        return DBContactHelper.SUCCESS;
    }
    
    /**
     * 사용자 Profile 정보를 기본 DB에서 받아온다. Contact.Profile 클래스로 반환.
     * @return Contact.Profile 객체 반환.
     */
    func getUserProfile() -> (age :Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32) {
        let age = Preference.getAge();
        let sex = Preference.getSex();
        let height = Preference.getHeight();
        let weight = Preference.getWeight();
        let goalWeight = Preference.getGoalWeight();
        
        return (age, sex, height, weight, goalWeight);
    }
    
    
    /**
     * 사용자 Profile 정보를 기본 DB에서 받아온다. Contact.Profile 클래스로 반환.
     * @return Contact.Profile 객체 반환.
     */
    func PLgetUserProfile() -> Contact.Profile! {
        let age = Preference.getAge();
        let sex = Preference.getSex();
        let job = Preference.getJob();
        let height = Preference.getHeight();
        let weight = Preference.getWeight();
        let goalWeight = Preference.getGoalWeight();
        
        let profile = Contact.Profile(sex: sex, job: job, age: age, height: height, weight: weight, goalWeight: goalWeight);
        //    profile.setAge(age);
        //    profile.setSex(sex);
        //    profile.setJob(job);
        //    profile.setHeight(height);
        //    profile.setWeight(weight);
        //    profile.setGoalWeight(goalWeight);
        
        return profile;
    }
    
    
    
    /**
     * 사용자의 DietPeriod 정보를 기본 DB에 작성한다. 이 메서드가 호출되는 시점의 시간이 기본 DB에 저장된다.
     * Parameter가 null 혹은 zero 값이 들어오면 DO_NOT_USE_NULLDATA 코드를 반환한다.
     * @param dietPeriod 다이어트 기간 정보. (주 단위)
     * @return 1:DO_NOT_USE_NULLDATA, 0:SUCCESS
     */
    func setUserDietPeriod(_ dietPeriod: Int32) -> Int32 {
        if dietPeriod < 1 {
            Log.e(DBContactHelper.tag, msg: "do not use null&zero data : setUserDietPeriod");
            return DBContactHelper.DO_NOT_USE_NULLDATA;
        }
        
        Preference.putDietPeriod(dietPeriod);
        
        return DBContactHelper.SUCCESS;
    }
    
    /**
     * 사용자의 DietPeriod 정보를 기본 DB에서 받아온다. DietPeriod를 반환. (반환값은 주 단위)
     * @return DietPeriod 정보(주 단위).
     */
    func getUserDietPeriod() -> Int32 {
        let dietPeriod = Preference.getDietPeriod();
        
        return dietPeriod;
    }
}
