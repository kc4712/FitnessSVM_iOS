//
//  Preference.swift
//  planner-swift
//
//  Created by 양정은 on 2016. 3. 11..
//  Copyright © 2016년 이효문. All rights reserved.
//

/*
안드로이드의 Preference에 해당하는 부분으로 NSUserDefaults 코드를 작성한다.
*/
import Foundation

open class Preference : NSObject {
    static let userDefault = UserDefaults.standard;
    
    static func removeAll() {
        putSex(0);
        putAge(0);
        putJob(0);
        putHeight(0);
        putWeight(0);
        putDietPeriod(0);
        putGoalWeight(0);
        putBluetoothMac(nil);
        putBluetoothName(nil);
        putUrlUsercode(nil);
        putFirmVersion(nil);
        putConnectedTime(0);
        putDisconnectedTime(0);
        AutoLogin = false
        Email = nil
        Password = nil
        TodayCalorie = 0
        ActivityState = 0
        SleepState = 0
        SleepTime = 0
        SleepAwaken = 0
        SleepRolled = 0
        SleepStabilityHR = 0
        StressState = 0
        PeripheralState = 0
        ProductCode = 0
        NoticePhoneONOFF = false
        NoticeSmsONOFF = false
        MainStep = 0
        MainCalorieActivity = 0
        MainCalorieCoach = 0
        MainCalorieSleep = 0
        MainCalorieDaily = 0
    }
    
    open static func removeForFirmUp() {
        ActivityState = 0
        SleepState = 0
        StressState = 0
        SleepTime = 0
        SleepAwaken = 0
        SleepRolled = 0
        SleepStabilityHR = 0
        StressState = 0
        PeripheralState = 0
    }
    
    open static func getSharedPreferences() -> UserDefaults {
        return userDefault;
    }
    
    open static func putString(_ key: String, value: String?) {
        let user = getSharedPreferences();
        user.setValue(value, forKey: key);
    }
    
    open static func getString(_ key: String, defValue: String? = nil) -> String? {
        let prefs = getSharedPreferences();
        if let value = prefs.string(forKey: key) {
            return value;
        } else {
            return defValue;
        }
    }
    
    /*
    public static func getString(key: String) -> String? {
        return getString(key, defValue: nil);
    }
    */
    
    open static func putInt(_ key: String, value: Int32) {
        let prefs = getSharedPreferences();
        prefs.setValue(NSNumber(value: value as Int32), forKey: key);
    }
    
    open static func getInt(_ key: String, defValue: Int32 = 0) -> Int32 {
        let prefs = getSharedPreferences();
        return Int32(prefs.integer(forKey: key));
    }
    
    /*
    public static func getInt(key: String) -> Int32 {
        return getInt(key, defValue: 0);
    }
    */
    
    open static func putLong(_ key: String, value: Int64) {
        let prefs = getSharedPreferences();
        prefs.setValue(NSNumber(value: value as Int64), forKey: key);
    }
    
    open static func getLong(_ key: String, defValue: Int64 = 0) -> Int64 {
        let prefs = getSharedPreferences();
        return Int64(prefs.integer(forKey: key));
    }
    
    /*
    public static func getLong(key: String) -> Int64 {
        return getLong(key, defValue: 0);
    }
    */
    
    open static func putFloat(_ key: String, value: Float32) {
        let prefs = getSharedPreferences();
        prefs.setValue(NSNumber(value: value as Float), forKey: key);
    }
    
    open static func getFloat(_ key: String, defValue: Float32 = 0) -> Float32 {
        let prefs = getSharedPreferences();
        return prefs.float(forKey: key);
    }
    
    /*
    public static func getFloat(key: String) -> Float32 {
        return getFloat(key, defValue: 0);
    }
    */
    
    open static func putBoolean(_ key: String, value: Bool) {
        let prefs = getSharedPreferences();
        prefs.setValue(value, forKey: key);
    }
    
    open static func getBoolean(_ key: String, defValue: Bool = false) -> Bool {
        let prefs = getSharedPreferences();
        return prefs.bool(forKey: key);
    }
    
    /*
    public static func getBoolean(key: String) -> Bool {
        return getBoolean(key, defValue: false);
    }
    */
    
    // ---------------------------------------------------------------------
    
    open static let KEY_CONNECTED_TIME = "ConnectedTime";
    open static let KEY_DISCONNECTED_TIME = "DisconnectedTime";

    
    open static let KEY_SEX = "sex";
    open static let KEY_AGE = "age";
    open static let KEY_JOB = "job";
    open static let KEY_HEIGHT = "height";
    open static let KEY_WEIGHT = "weight";
    
    open static let KEY_DIETPERIOD = "diet_Period";
    open static let KEY_GOALWEIGHT = "goal_weight";
    
    open static let KEY_BLUETOOTH_MAC = "bluetooth_mac";
    open static let KEY_BLUETOOTH_NAME = "bluetooth_name";
    
    open static let KEY_URL_USERCODE = "url_usercode";
    
    open static let KEY_FIRM_VERSION = "firm_version";
    
    open static let KEY_REQ_FEATURE_SYNC_TIME = "KEY_REQ_FEATURE_SYNC_TIME";
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //규창 171023 플래너 피쳐용...???? 
    open static let KEY_SLEEP_PRE_START_FLAG_TIME = "sleep_pre_start_flag_time";
    open static let KEY_SLEEP_PRE_START_FLAG_STATUS = "sleep_pre_start_flag_status";
    open static let KEY_SLEEP_PRE_END_FLAG_TIME = "sleep_pre_end_flag_time";
    open static let KEY_SLEEP_PRE_END_FLAG_STATUS = "sleep_pre_end_flag_status";
    open static let KEY_SLEEP_FLAG_TIME = "sleep_flag_time";
    open static let KEY_SLEEP_FLAG_STATUS = "sleep_flag_status";
    open static let KEY_CLIMBING_FLAG_START_TIME = "climbing_flag_start_time";
    open static let KEY_CLIMBING_FLAG_END_TIME = "climbing_flag_end_time";
    open static let KEY_CLIMBING_FLAG_STATUS = "climbing_flag_status";
    open static let KEY_CLIMBING_FLAG_COUNT = "climbing_flag_count";
    open static let KEY_GOLF_FLAG_START_TIME = "golf_flag_start_time";
    open static let KEY_GOLF_FLAG_END_TIME = "golf_flag_end_time";
    open static let KEY_GOLF_FLAG_STATUS = "golf_flag_status";
    open static let KEY_GOLF_FLAG_COUNT = "golf_flag_count";
    open static let KEY_GOLF_PRE_ACTIVITY = "golf_pre_activity";
    open static let KEY_FEATURE_PRESS = "feature_press";
    open static let KEY_CLIMBING_PRESS = "climbing_press";
    
    
    open static let KEY_CLIMBING_PRE_PRESS_1 = "climbing_pre_press_1";
    open static let KEY_CLIMBING_PRE_PRESS_2 = "climbing_pre_press_2";
    open static let KEY_CLIMBING_PRE_PRESS_3 = "climbing_pre_press_3";
    open static let KEY_CLIMBING_PRE_ACTIVITY_1 = "golf_pre_activity_1";
    open static let KEY_CLIMBING_PRE_ACTIVITY_2 = "golf_pre_activity_2";
    open static let KEY_CLIMBING_PRE_ACTIVITY_3 = "golf_pre_activity_3";
    
    /** ActInfo **/
    open static let KEY_ACT_INFO = "act_info";
    open static let KEY_ACT_INFO_TO_WEB = "act_info_to_web";
    open static func putSleepPreEndFlagTime(_ slp_flag_time: Int64) {
        putLong(KEY_SLEEP_PRE_END_FLAG_TIME, value: slp_flag_time);
    }
    open static func getSleepPreEndFlagTime() -> Int64 {
        return getLong(KEY_SLEEP_PRE_END_FLAG_TIME);
    }
    open static func putSleepPreEndFlagStatus(_ slp_flag_status: Int32) {
        putInt(KEY_SLEEP_PRE_END_FLAG_STATUS, value: slp_flag_status);
    }
    open static func getSleepPreEndFlagStatus() -> Int32 {
        return getInt(KEY_SLEEP_PRE_END_FLAG_STATUS);
    }
    open static func putSleepPreStartFlagTime(_ slp_flag_time: Int64){
        putLong(KEY_SLEEP_PRE_START_FLAG_TIME, value: slp_flag_time);
    }
    open static func getSleepPreStartFlagTime() -> Int64 {
        return getLong(KEY_SLEEP_PRE_START_FLAG_TIME);
    }
    open static func putSleepPreStartFlagStatus(_ slp_flag_status: Int32){
        putInt(KEY_SLEEP_PRE_START_FLAG_STATUS, value: slp_flag_status);
    }
    open static func getSleepPreStartFlagStatus() -> Int32 {
        return getInt(KEY_SLEEP_PRE_START_FLAG_STATUS);
    }
    open static func putSleepFlagTime(_ slp_flag_time: Int64){
        putLong(KEY_SLEEP_FLAG_TIME, value: slp_flag_time);
    }
    open static func getSleepFlagTime() -> Int64 {
        return getLong(KEY_SLEEP_FLAG_TIME);
    }
    open static func putSleepFlagStatus(_ slp_flag_status: Int32) {
        putInt(KEY_SLEEP_FLAG_STATUS, value: slp_flag_status);
    }
    open static func getSleepFlagStatus() -> Int32 {
        return getInt(KEY_SLEEP_FLAG_STATUS);
    }
    open static func putClimbingFlagStartTime(_ slp_flag_time: Int64) {
        putLong(KEY_CLIMBING_FLAG_START_TIME , value: slp_flag_time);
    }
    open static func getClimbingFlagStartTime() -> Int64 {
        return getLong(KEY_CLIMBING_FLAG_START_TIME );
    }
    open static func putClimbingFlagEndTime(_ slp_flag_time: Int64){
        putLong(KEY_CLIMBING_FLAG_END_TIME , value: slp_flag_time);
    }
    open static func getClimbingFlagEndTime() -> Int64 {
        return getLong(KEY_CLIMBING_FLAG_END_TIME );
    }
    open static func putClimbingFlagStatus(_ slp_flag_status: Int32){
        putInt(KEY_CLIMBING_FLAG_STATUS, value: slp_flag_status);
    }
    open static func getClimbingFlagStatus() -> Int32 {
        return getInt(KEY_CLIMBING_FLAG_STATUS);
    }
    open static func putClimbingFlagCount(_ slp_flag_status: Int32){
        putInt(KEY_CLIMBING_FLAG_COUNT, value: slp_flag_status);
    }
    open static func getClimbingFlagCount() -> Int32 {
        return getInt(KEY_CLIMBING_FLAG_COUNT);
    }
    open static func putGolfFlagStartTime(_ slp_flag_time: Int64){
        putLong(KEY_GOLF_FLAG_START_TIME, value: slp_flag_time);
    }
    open static func getGolfFlagStartTime() -> Int64 {
        return getLong(KEY_GOLF_FLAG_START_TIME);
    }
    open static func putGolfFlagEndTime(_ slp_flag_time: Int64){
        putLong(KEY_GOLF_FLAG_END_TIME, value: slp_flag_time);
    }
    open static func getGolfFlagEndTime() -> Int64 {
        return getLong(KEY_GOLF_FLAG_END_TIME);
    }
    open static func putGolfFlagStatus(_ slp_flag_status: Int32){
        putInt(KEY_GOLF_FLAG_STATUS, value: slp_flag_status);
    }
    open static func getGolfFlagStatus() -> Int32 {
        return getInt(KEY_GOLF_FLAG_STATUS);
    }
    open static func putGolfFlagCount(_ slp_flag_status: Int32){
        putInt(KEY_GOLF_FLAG_COUNT, value: slp_flag_status);
    }
    open static func getGolfFlagCount() -> Int32 {
        return getInt(KEY_GOLF_FLAG_COUNT);
    }
    open static func putGolfPreActivity(_ slp_flag_status: Int32){
        putInt(KEY_GOLF_PRE_ACTIVITY, value: slp_flag_status);
    }
    open static func getGolfPreActivity() -> Int32 {
        return getInt(KEY_GOLF_PRE_ACTIVITY);
    }
    open static func putFeaturePressPerStep(_ slp_flag_time: Float32){
        putFloat(KEY_FEATURE_PRESS, value: slp_flag_time);
    }
    open static func getFeaturePressPerStep() -> Float32 {
        return getFloat(KEY_FEATURE_PRESS);
    }
    open static func putClimbingPress(_ slp_flag_time: Float32){
        putFloat(KEY_CLIMBING_PRESS, value: slp_flag_time);
    }
    open static func getClimbingPress() -> Float32 {
        return getFloat(KEY_CLIMBING_PRESS);
    }
    
    open static func putClimbingPrePress1(_ slp_flag_time: Float32){
        putFloat(KEY_CLIMBING_PRE_PRESS_1, value: slp_flag_time);
    }
    open static func getClimbingPrePress1() -> Float32 {
        return getFloat(KEY_CLIMBING_PRE_PRESS_1);
    }
    open static func putClimbingPrePress2(_ slp_flag_time: Float32){
        putFloat(KEY_CLIMBING_PRE_PRESS_2, value: slp_flag_time);
    }
    open static func getClimbingPrePress2() -> Float32 {
        return getFloat(KEY_CLIMBING_PRE_PRESS_2);
    }
    open static func putClimbingPrePress3(_ slp_flag_time: Float32){
        putFloat(KEY_CLIMBING_PRE_PRESS_3, value: slp_flag_time);
    }
    open static func getClimbingPrePress3() -> Float32 {
        return getFloat(KEY_CLIMBING_PRE_PRESS_3);
    }
    open static func putClimbingPreActivity1(_ slp_flag_status: Int32){
        putInt(KEY_CLIMBING_PRE_ACTIVITY_1, value: slp_flag_status);
    }
    open static func getClimbingPreActivity1() -> Int32 {
        return getInt(KEY_CLIMBING_PRE_ACTIVITY_1);
    }
    open static func putClimbingPreActivity2(_ slp_flag_status: Int32){
        putInt(KEY_CLIMBING_PRE_ACTIVITY_2, value: slp_flag_status);
    }
    open static func getClimbingPreActivity2() -> Int32 {
        return getInt(KEY_CLIMBING_PRE_ACTIVITY_2);
    }
    open static func putClimbingPreActivity3(_ slp_flag_status: Int32){
        putInt(KEY_CLIMBING_PRE_ACTIVITY_3, value: slp_flag_status);
    }
    open static func getClimbingPreActivity3() -> Int32 {
        return getInt(KEY_CLIMBING_PRE_ACTIVITY_3);
    }
    /////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    open static func putSex(_ input: Int32){
        putInt(KEY_SEX, value: input);
    }
    open static func getSex() -> Int32 {
        return getInt(KEY_SEX);
    }
    open static func putAge(_ input: Int32){
        putInt(KEY_AGE, value: input);
    }
    open static func getAge() -> Int32 {
        return getInt(KEY_AGE);
    }
    open static func putJob(_ input: Int32){
        putInt(KEY_JOB, value: input);
    }
    open static func getJob() -> Int32 {
        return getInt(KEY_JOB);
    }
    open static func putHeight(_ input: Int32){
        putInt(KEY_HEIGHT, value: input);
    }
    open static func getHeight() -> Int32 {
        return getInt(KEY_HEIGHT);
    }
    open static func putWeight(_ input: Float32){
        putFloat(KEY_WEIGHT, value: input);
    }
    open static func getWeight() -> Float32 {
        return getFloat(KEY_WEIGHT);
    }
    open static func putDietPeriod(_ input: Int32){
        putInt(KEY_DIETPERIOD, value: input);
    }
    open static func getDietPeriod() -> Int32 {
        return getInt(KEY_DIETPERIOD);
    }
    open static func putGoalWeight(_ input: Float32){
        putFloat(KEY_GOALWEIGHT, value: input);
    }
    open static func getGoalWeight() -> Float32 {
        return getFloat(KEY_GOALWEIGHT);
    }
    open static func putBluetoothMac(_ input: String?){
        putString(KEY_BLUETOOTH_MAC, value: input);
    }
    open static func getBluetoothMac() -> String? {
        return getString(KEY_BLUETOOTH_MAC);
    }
    open static func putBluetoothName(_ input: String?){
        putString(KEY_BLUETOOTH_NAME, value: input);
    }
    open static func getBluetoothName() -> String? {
        return getString(KEY_BLUETOOTH_NAME);
    }


    open static func putUrlUsercode(_ input: String?){
        putString(KEY_URL_USERCODE, value: input);
    }
    open static func getUrlUsercode() -> String? {
        return getString(KEY_URL_USERCODE);
    }
    
    open static func putFirmVersion(_ input: String?){
        putString(KEY_FIRM_VERSION, value: input);
    }
    open static func getFirmVersion() -> String? {
        return getString(KEY_FIRM_VERSION);
    }
    
    
    open static func putConnectedTime(_ time: Int32){
        putInt(KEY_CONNECTED_TIME, value: time);
    }
    
    open static func getConnectedTime() -> Int32 {
        return getInt(KEY_CONNECTED_TIME);
    }
    
    open static func putDisconnectedTime(_ time: Int32){
        putInt(KEY_DISCONNECTED_TIME, value: time);
    }
    
    open static func getDisconnectedTime() -> Int32 {
        return getInt(KEY_DISCONNECTED_TIME);
    }
    
    //--------------------------------------------------------------
    // UI 에서 사용하는 환경 설정
    //--------------------------------------------------------------

    fileprivate static let KEY_MAIN_AUTO_LOGIN = "MAIN_AUTO_LOGIN";
    fileprivate static let KEY_USER_EMAIL = "USER_EMAIL";
    fileprivate static let KEY_USER_PASSWORD = "USER_PASSWORD";
    
    fileprivate static let KEY_TODAY_CALORIE = "TODAY_CALORIE";
    
    fileprivate static let KEY_PERIPHERAL_STATE = "KEY_PERIPHERAL_STATE";
    fileprivate static let KEY_ACTIVITY_STATE = "ACTIVITY_STATE";
    fileprivate static let KEY_SLEEP_STATE = "SLEEP_STATE";
    fileprivate static let KEY_SLEEP_TIME = "SLEEP_TIME";
    fileprivate static let KEY_SLEEP_ROLLED = "SLEEP_ROLLED";
    fileprivate static let KEY_SLEEP_AWAKEN = "SLEEP_AWAKEN";
    fileprivate static let KEY_SLEEP_STABILITY_HR = "SLEEP_STABILITY_HR";
    fileprivate static let KEY_STRESS_STATE = "STRESS_STATE";
    fileprivate static let KEY_PRODUCT_CODE = "PRODUCT_CODE";
    
    fileprivate static let KEY_XML_VERSION_002 = "XML_VERSION_002";
    fileprivate static let KEY_XML_VERSION_003 = "XML_VERSION_003";
    fileprivate static let KEY_XML_VERSION_004 = "XML_VERSION_004";
    fileprivate static let KEY_XML_VERSION_101 = "XML_VERSION_101";
    fileprivate static let KEY_XML_VERSION_102 = "XML_VERSION_102";
    fileprivate static let KEY_XML_VERSION_201 = "XML_VERSION_201";
    fileprivate static let KEY_XML_VERSION_202 = "XML_VERSION_202";
    fileprivate static let KEY_XML_VERSION_301 = "XML_VERSION_301";
    fileprivate static let KEY_XML_VERSION_302 = "XML_VERSION_302";
    
    fileprivate static let KEY_LANGUAGE = "LANGUAGE"
    
    fileprivate static let KEY_NOTICE_PHONE_ONOFF = "NOTICE_PHONE_ONOFF";
    fileprivate static let KEY_NOTICE_SMS_ONOFF = "NOTICE_SMS_ONOFF";
    
    fileprivate static let KEY_MAIN_STEP = "MAIN_STEP";
    fileprivate static let KEY_MAIN_CALORIE_ACTIVITY = "MAIN_CALORIE_ACTIVITY";
    fileprivate static let KEY_MAIN_CALORIE_COACH = "MAIN_CALORIE_COACH";
    fileprivate static let KEY_MAIN_CALORIE_SLEEP = "MAIN_CALORIE_SLEEP";
    fileprivate static let KEY_MAIN_CALORIE_DAILY = "MAIN_CALORIE_DAILY";
    
    open static var AutoLogin: Bool {
        get { return getBoolean(KEY_MAIN_AUTO_LOGIN); }
        set { putBoolean(KEY_MAIN_AUTO_LOGIN, value: newValue); }
    }
    
    open static var Email: String? {
        get { return getString(KEY_USER_EMAIL); }
        set { putString(KEY_USER_EMAIL, value: newValue); }
    }
    
    open static var Password: String? {
        get { return getString(KEY_USER_PASSWORD); }
        set { putString(KEY_USER_PASSWORD, value: newValue); }
    }
    
    open static var TodayCalorie: Int32 {
        get { return getInt(KEY_TODAY_CALORIE); }
        set { putInt(KEY_TODAY_CALORIE, value: newValue); }
    }
    
    open static var PeripheralState: Int32 {
        get { return getInt(KEY_PERIPHERAL_STATE); }
        set { putInt(KEY_PERIPHERAL_STATE, value: newValue); }
    }
    
    open static var ActivityState: Int32 {
        get { return getInt(KEY_ACTIVITY_STATE); }
        set { putInt(KEY_ACTIVITY_STATE, value: newValue); }
    }
    
    open static var SleepState: Int32 {
        get { return getInt(KEY_SLEEP_STATE); }
        set { putInt(KEY_SLEEP_STATE, value: newValue); }
    }
    
    open static var SleepTime: Int32 {
        get { return getInt(KEY_SLEEP_TIME); }
        set { putInt(KEY_SLEEP_TIME, value: newValue); }
    }
    
    open static var SleepRolled: Int32 {
        get { return getInt(KEY_SLEEP_ROLLED); }
        set { putInt(KEY_SLEEP_ROLLED, value: newValue); }
    }
    
    open static var SleepAwaken: Int32 {
        get { return getInt(KEY_SLEEP_AWAKEN); }
        set { putInt(KEY_SLEEP_AWAKEN, value: newValue); }
    }
    
    open static var SleepStabilityHR: Int32 {
        get { return getInt(KEY_SLEEP_STABILITY_HR); }
        set { putInt(KEY_SLEEP_STABILITY_HR, value: newValue); }
    }
    
    open static var StressState: Int32 {
        get { return getInt(KEY_STRESS_STATE); }
        set { putInt(KEY_STRESS_STATE, value: newValue); }
    }
    
    open static var ProductCode: Int32 {
        get { return getInt(KEY_PRODUCT_CODE); }
        set { putInt(KEY_PRODUCT_CODE, value: newValue); }
    }
    
    open static var XmlVersion002: String? {
        get { return getString(KEY_XML_VERSION_002); }
        set { putString(KEY_XML_VERSION_002, value: newValue); }
    }
    
    open static var XmlVersion003: String? {
        get { return getString(KEY_XML_VERSION_003); }
        set { putString(KEY_XML_VERSION_003, value: newValue); }
    }
    
    open static var XmlVersion004: String? {
        get { return getString(KEY_XML_VERSION_004); }
        set { putString(KEY_XML_VERSION_004, value: newValue); }
    }
    
    open static var XmlVersion101: String? {
        get { return getString(KEY_XML_VERSION_101); }
        set { putString(KEY_XML_VERSION_101, value: newValue); }
    }
    
    open static var XmlVersion102: String? {
        get { return getString(KEY_XML_VERSION_102); }
        set { putString(KEY_XML_VERSION_102, value: newValue); }
    }
    
    open static var XmlVersion201: String? {
        get { return getString(KEY_XML_VERSION_201); }
        set { putString(KEY_XML_VERSION_201, value: newValue); }
    }
    
    open static var XmlVersion202: String? {
        get { return getString(KEY_XML_VERSION_202); }
        set { putString(KEY_XML_VERSION_202, value: newValue); }
    }
    
    open static var XmlVersion301: String? {
        get { return getString(KEY_XML_VERSION_301); }
        set { putString(KEY_XML_VERSION_301, value: newValue); }
    }
    
    open static var XmlVersion302: String? {
        get { return getString(KEY_XML_VERSION_302); }
        set { putString(KEY_XML_VERSION_302, value: newValue); }
    }
    
    open static var Language: String? {
        get { return getString(KEY_LANGUAGE); }
        set { putString(KEY_LANGUAGE, value: newValue); }
    }
    
    open static var NoticePhoneONOFF: Bool {
        get { return getBoolean(KEY_NOTICE_PHONE_ONOFF); }
        set { putBoolean(KEY_NOTICE_PHONE_ONOFF, value: newValue); }
    }
    
    open static var NoticeSmsONOFF: Bool {
        get { return getBoolean(KEY_NOTICE_SMS_ONOFF); }
        set { putBoolean(KEY_NOTICE_SMS_ONOFF, value: newValue); }
    }
    
    open static var MainStep: Int32 {
        get { return getInt(KEY_MAIN_STEP); }
        set { putInt(KEY_MAIN_STEP, value: newValue); }
    }
    
    open static var MainCalorieActivity: Int32 {
        get { return getInt(KEY_MAIN_CALORIE_ACTIVITY); }
        set { putInt(KEY_MAIN_CALORIE_ACTIVITY, value: newValue); }
    }
    
    open static var MainCalorieCoach: Int32 {
        get { return getInt(KEY_MAIN_CALORIE_COACH); }
        set { putInt(KEY_MAIN_CALORIE_COACH, value: newValue); }
    }
    
    open static var MainCalorieSleep: Int32 {
        get { return getInt(KEY_MAIN_CALORIE_SLEEP); }
        set { putInt(KEY_MAIN_CALORIE_SLEEP, value: newValue); }
    }
    
    open static var MainCalorieDaily: Int32 {
        get { return getInt(KEY_MAIN_CALORIE_DAILY); }
        set { putInt(KEY_MAIN_CALORIE_DAILY, value: newValue); }
    }
}
