//
//  SQLHeper.swift
//  planner-swift
//
//  Created by 심규창 on 2017. 10. 25..
//  Copyright © 2017년 심규창. All rights reserved.
//

import Foundation
import MiddleWare

private let mSQLHeper: SQLHelper = SQLHelper();

class SQLHelper {
    fileprivate static let tag = String(describing: SQLHelper.self);
    
    /** Thread **/
    fileprivate var thr: Thread?
    fileprivate let mCal = MWCalendar.getInstance()
    fileprivate var preDay: Int32 = -1
    fileprivate var deleteFlag = true
    fileprivate let loopTime: TimeInterval = 60
    
    // Database Version
    fileprivate static let DATABASE_VERSION = 1;
    
    // Database Name
    fileprivate static let DATABASE_NAME = "ibody.db";
    

    fileprivate static let TABLE_COACH_ACTIVITY_DATA = "coachActivityData";
    // Columns
    fileprivate static let KEY_CA_INDEX = "ca_index";
    fileprivate static let KEY_CA_VIDEO_IDX = "ca_video_idx";
    fileprivate static let KEY_CA_VIDEO_FULL_COUNT = "ca_video_full_count";
    fileprivate static let KEY_CA_EXER_IDX = "ca_exer_idx";
    fileprivate static let KEY_CA_EXER_COUNT = "ca_exer_count";
    fileprivate static let KEY_CA_START_TIME = "ca_start_time";
    fileprivate static let KEY_CA_END_TIME = "ca_end_time";
    fileprivate static let KEY_CA_CONSUME_CALORIE = "ca_consume_calorie";
    fileprivate static let KEY_CA_COUNT = "ca_count";
    fileprivate static let KEY_CA_COUNT_PERCENT = "ca_count_percent";
    fileprivate static let KEY_CA_PERFECT_COUNT = "ca_perfect_count";
    fileprivate static let KEY_CA_MIN_ACCURACY = "ca_min_accuracy";
    fileprivate static let KEY_CA_MAX_ACCURACY = "ca_max_accuracy";
    fileprivate static let KEY_CA_AVG_ACCURACY = "ca_avg_accuracy";
    fileprivate static let KEY_CA_MIN_HEARTRATE = "ca_min_heartrate";
    fileprivate static let KEY_CA_MAX_HEARTRATE = "ca_max_heartrate";
    fileprivate static let KEY_CA_AVG_HEARTRATE = "ca_avg_heartrate";
    fileprivate static let KEY_CA_CMP_HEARTRATE = "ca_compared_heartrate";
    fileprivate static let KEY_CA_POINT = "ca_point";
    fileprivate static let KEY_CA_EXER_RESERVED_1 = "ca_reserved_1";
    fileprivate static let KEY_CA_EXER_RESERVED_2 = "ca_reserved_2";
    
    fileprivate static let TABLE_ACTIVITY_DATA = "activityData";
    // Columns
    fileprivate static let KEY_AD_INDEX = "cd_index";
    fileprivate static let KEY_AD_LABEL = "cd_label";
    fileprivate static let KEY_AD_CALORIE = "cd_calorie";
    fileprivate static let KEY_AD_START_DATE = "cd_start_date";
    fileprivate static let KEY_AD_END_DATE = "cd_end_date";
    fileprivate static let KEY_AD_INTENSITY_L = "cd_intensity_L";
    fileprivate static let KEY_AD_INTENSITY_M = "cd_intensity_M";
    fileprivate static let KEY_AD_INTENSITY_H = "cd_intensity_H";
    fileprivate static let KEY_AD_INTENSITY_D = "cd_intensity_D";
    fileprivate static let KEY_AD_MAXHR = "cd_max_hr";
    fileprivate static let KEY_AD_MINHR = "cd_min_hr";
    fileprivate static let KEY_AD_AVGHR = "cd_avg_hr";
    fileprivate static let KEY_AD_UPLOAD = "cd_upload";
    
    
    
    //규창 171025 피쳐데이터 추가
    //(actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) {
    fileprivate static let TABLE_FEATURE_DATA = "featureData";
    // Columns
    fileprivate static let KEY_FD_INDEX = "cf_index";
    fileprivate static let KEY_FD_LABEL = "cf_label";
    fileprivate static let KEY_FD_ACT_INDEX = "cf_act_index";
    fileprivate static let KEY_FD_START_DATE = "cf_start_date";
    //fileprivate static let KEY_FD_END_DATE = "cf_end_date";
    fileprivate static let KEY_FD_INTENSITY = "cf_intensity";
    fileprivate static let KEY_FD_CALORIE = "cf_calorie";
    fileprivate static let KEY_FD_SPEED = "cf_speed";
    fileprivate static let KEY_FD_HEARTRATE = "cf_heartrate";
    fileprivate static let KEY_FD_STEP = "cf_step";
    fileprivate static let KEY_FD_SWING = "cf_swing";
    fileprivate static let KEY_FD_PRESS_VAR = "cf_press_var";
    fileprivate static let KEY_FD_COACH_INTENSITY = "cf_coach_intensity";
    fileprivate static let KEY_FD_UPLOAD = "cf_upload";
    
    
    
    fileprivate static let TABLE_INDEX_START_TIME = "indexStartTime";
    fileprivate static let KEY_IS_INDEX = "is_index";
    fileprivate static let KEY_IS_LABEL = "is_label";
    fileprivate static let KEY_IS_START_TIME = "is_start_time";
    fileprivate static let KEY_IS_END_TIME = "is_end_time";
    

    /**
    * 기본 DB 테이블이 존재합니다.
    */
    fileprivate static let EXIST_BASIC_TABLE = 10;
    
    fileprivate static let EXIST_BLUETOOTH_TABLE = 11;
    
    static let NEED_APPLY = 1;
    static let NONNEED_APPLY = 0;
    
    static let SET_UPLOAD: Int32 = 1;
    static let NONSET_UPLOAD: Int32 = 0;
    
    static let FAILED = -1
    static let SUCCESS = 1
    
    /**
    * Gloval variable
    */
    fileprivate var contactDB: FMDatabaseQueue?;
    fileprivate var databasePath: String;
    /****/
    init() {
        //애플리케이션이 실행되면 데이터베이스 파일이 존재하는지 체크한다. 존재하지 않으면 데이터베이스파일과 테이블을 생성한다.
        let filemgr = Foundation.FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as String
        databasePath = docsDir + "/\(SQLHelper.DATABASE_NAME)"
        
//        super.init();
        
//        dProtocol = self;
        
        contactDB = FMDatabaseQueue(path: databasePath as String)
//        if !filemgr.fileExists(atPath: databasePath as String) {
            // FMDB 인스턴스를 이용하여 DB 체크
            //let contactDB = FMDatabase(path:databasePath as String)
            
            contactDB?.inDatabase() {
                db in
                let sql_stmt = self.onCreate()
                for crt in sql_stmt {
                    if !db!.executeStatements(crt) {
                        print("[\(crt)] Error : \(db!.lastErrorMessage())")
                    }
                }
                
                db!.executeStatements("PRAGMA synchronous=OFF")
                db!.executeStatements("PRAGMA temp_store=2")
            }
//        }
            // DB 오픈
       /*     if contactDB!.open(){
                // 테이블 생성처리
                contactDB!.executeStatements("PRAGMA auto_vacuum=2")
                
                let sql_stmt = onCreate();
                for crt in sql_stmt {
                    if !contactDB!.executeStatements(crt) {
                        print("[\(crt)] Error : \(contactDB!.lastErrorMessage())")
                    }
                }
                
                contactDB!.executeStatements("PRAGMA synchronous=OFF")
                contactDB!.executeStatements("PRAGMA temp_store=2")
                //contactDB!.close()
            }else{
                print("[3] Error : \(contactDB!.lastErrorMessage())")
            }
        }else{
            contactDB!.open()
            print("[1] SQLite 파일 존재!!")
        } */
        
//        thr = NSThread(target: self, selector: #selector(monitoring), object: nil)
//        thr?.start()
    }
    
    deinit {
        if contactDB != nil {
            contactDB!.close()
        }
        dispose()
    }
    
    func onCreate() -> [String] {
        let TABLE_COACH_ACTIVITY_DATA = "CREATE TABLE IF NOT EXISTS \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) (\(SQLHelper.KEY_CA_INDEX) INTEGER PRIMARY KEY, \(SQLHelper.KEY_CA_VIDEO_IDX) INTEGER,\(SQLHelper.KEY_CA_VIDEO_FULL_COUNT) INTEGER,\(SQLHelper.KEY_CA_EXER_IDX) INTEGER,\(SQLHelper.KEY_CA_EXER_COUNT) INTEGER,\(SQLHelper.KEY_CA_START_TIME) INTEGER,\(SQLHelper.KEY_CA_END_TIME) INTEGER,\(SQLHelper.KEY_CA_CONSUME_CALORIE) INTEGER,\(SQLHelper.KEY_CA_COUNT) INTEGER,\(SQLHelper.KEY_CA_COUNT_PERCENT) INTEGER,\(SQLHelper.KEY_CA_PERFECT_COUNT) INTEGER,\(SQLHelper.KEY_CA_MIN_ACCURACY) INTEGER,\(SQLHelper.KEY_CA_MAX_ACCURACY) INTEGER,\(SQLHelper.KEY_CA_AVG_ACCURACY) INTEGER,\(SQLHelper.KEY_CA_MIN_HEARTRATE) INTEGER,\(SQLHelper.KEY_CA_MAX_HEARTRATE) INTEGER,\(SQLHelper.KEY_CA_AVG_HEARTRATE) INTEGER,\(SQLHelper.KEY_CA_CMP_HEARTRATE) INTEGER,\(SQLHelper.KEY_CA_POINT) INTEGER,\(SQLHelper.KEY_CA_EXER_RESERVED_1) INTEGER,\(SQLHelper.KEY_CA_EXER_RESERVED_2) INTEGER)";
        
        let TABLE_ACTIVITY_DATA = "CREATE TABLE IF NOT EXISTS \(SQLHelper.TABLE_ACTIVITY_DATA) (\(SQLHelper.KEY_AD_INDEX) INTEGER PRIMARY KEY, \(SQLHelper.KEY_AD_LABEL) INTEGER,\(SQLHelper.KEY_AD_CALORIE) INTEGER,\(SQLHelper.KEY_AD_START_DATE) INTEGER,\(SQLHelper.KEY_AD_END_DATE) INTEGER,\(SQLHelper.KEY_AD_INTENSITY_L) INTEGER,\(SQLHelper.KEY_AD_INTENSITY_M) INTEGER,\(SQLHelper.KEY_AD_INTENSITY_H) INTEGER,\(SQLHelper.KEY_AD_INTENSITY_D) INTEGER,\(SQLHelper.KEY_AD_MAXHR) INTEGER,\(SQLHelper.KEY_AD_MINHR) INTEGER,\(SQLHelper.KEY_AD_AVGHR) INTEGER,\(SQLHelper.KEY_AD_UPLOAD) INTEGER)"
        
        /*fileprivate static let TABLE_FEATURE_DATA = "featureData";
        // Columns
        fileprivate static let KEY_FD_INDEX = "cf_index";
        fileprivate static let KEY_FD_LABEL = "cf_label";
        fileprivate static let KEY_FD_ACT_INDEX = "cf_act_index";
        fileprivate static let KEY_FD_START_DATE = "cf_start_date";
        //fileprivate static let KEY_FD_END_DATE = "cf_end_date";
        fileprivate static let KEY_FD_INTENSITY = "cf_intensity";
        fileprivate static let KEY_FD_CALORIE = "cf_calorie";
        fileprivate static let KEY_FD_SPEED = "cf_speed";
        fileprivate static let KEY_FD_HEARTRATE = "cf_heartrate";
        fileprivate static let KEY_FD_STEP = "cf_step";
        fileprivate static let KEY_FD_SWING = "cf_swing";
        fileprivate static let KEY_FD_PRESS_VAR = "cf_press_var";
        fileprivate static let KEY_FD_COACH_INTENSITY = "cf_coach_intensity";
        fileprivate static let KEY_FD_UPLOAD = "cf_upload";*/
        //(actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) {
        //규창 171025 피쳐 테이블 생성
        let TABLE_FEATURE_DATA = "CREATE TABLE IF NOT EXISTS \(SQLHelper.TABLE_FEATURE_DATA) (\(SQLHelper.KEY_FD_INDEX) INTEGER PRIMARY KEY, \(SQLHelper.KEY_FD_LABEL) INTEGER,\(SQLHelper.KEY_FD_ACT_INDEX) INTEGER,\(SQLHelper.KEY_FD_START_DATE) INTEGER, \(SQLHelper.KEY_FD_INTENSITY) REAL,\(SQLHelper.KEY_FD_CALORIE) REAL,\(SQLHelper.KEY_FD_SPEED) REAL,\(SQLHelper.KEY_FD_HEARTRATE) INTEGER,\(SQLHelper.KEY_FD_STEP) INTEGER,\(SQLHelper.KEY_FD_SWING) INTEGER,\(SQLHelper.KEY_FD_PRESS_VAR) REAL, \(SQLHelper.KEY_FD_COACH_INTENSITY) REAL,\(SQLHelper.KEY_FD_UPLOAD) INTEGER)"
        
        
        
        
        
        let TABLE_INDEX = "CREATE TABLE IF NOT EXISTS \(SQLHelper.TABLE_INDEX_START_TIME) (\(SQLHelper.KEY_IS_INDEX) INTEGER PRIMARY KEY, \(SQLHelper.KEY_IS_LABEL) INTEGER, \(SQLHelper.KEY_IS_START_TIME) INTEGER, \(SQLHelper.KEY_IS_END_TIME) INTEGER)"
        
        //규창 171025 피쳐 테이블 리턴
        return [TABLE_COACH_ACTIVITY_DATA, TABLE_ACTIVITY_DATA, TABLE_INDEX, TABLE_FEATURE_DATA];
    }
    
    fileprivate func dropAllTable() {
        // Drop older table if existed
//        return "DROP TABLE IF EXISTS \(SQLHeper.TABLE_COACH_ACTIVITY_DATA)";
//        return "DROP TABLE IF EXISTS \(SQLHeper.TABLE_ACTIVITY_DATA)";
    }
    
    @objc fileprivate func monitoring() {
        while !Thread.current.isCancelled {
            mCal.setTimeInMillis(MWCalendar.currentTimeMillis())
            let day = mCal.day
            
            Log.d(SQLHelper.tag, msg: "Run ActManager Thread(A Thread)");
            
            // thr 돌아갈때마다, 날짜가 바뀐 데이터를 찾는다?, 양이 겁나 많을수도 있음. 날짜 바뀔때마다 찾지말고,
            if day != preDay || !deleteFlag {
                Log.d(SQLHelper.tag, msg: "Run ActManager->DeleteTable");
                
                
//                mSQLHeper.execVacuum();
            }
            
            preDay = day;
            
            Thread.sleep(forTimeInterval: loopTime)
        }
    }
    
    class func getInstance() -> SQLHelper! {
        return mSQLHeper;
    }
    
    // 가장 마지막에 실행 필요.
    fileprivate func closeApp() {
        //SQLHeper.mSQLHeper = nil;
    }
    
    /** SQL **/
    func execVacuum() {
        Log.d(SQLHelper.tag, msg: "execVacuum");

//        contactDB!.executeStatements("PRAGMA incremental_vacuum=0")
//        let contactDB = FMDatabase(path: databasePath as String)
//        if contactDB.open() {
//            contactDB.executeStatements("PRAGMA incremental_vacuum=0")
//            contactDB.close()
//        }else{
//            print("[6] Error : \(contactDB.lastErrorMessage())")
//            
//        }
    }
    
    func addIndexTime(_ label: Int32, start_time: Int64) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let insertSQL = "INSERT INTO \(SQLHelper.TABLE_INDEX_START_TIME) (\(SQLHelper.KEY_IS_LABEL), \(SQLHelper.KEY_IS_START_TIME)) VALUES ('\(label)', '\(start_time)')"
            
            let result = db!.executeUpdate(insertSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                Log.d(SQLHelper.tag, msg: "addIndexTimeinput label:\(label) time:\(start_time)");
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*
        contactDB?.beginTransaction()
        let insertSQL = "INSERT INTO \(SQLHelper.TABLE_INDEX_START_TIME) (\(SQLHelper.KEY_IS_LABEL), \(SQLHelper.KEY_IS_START_TIME)) VALUES ('\(label)', '\(start_time)')"
        
        let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
            contactDB?.rollback()
        }else{
            Log.d(SQLHelper.tag, msg: "addIndexTimeinput label:\(label) time:\(start_time)");
            ret = Int32(SQLHelper.SUCCESS);
            contactDB?.commit()
        }
        */
        print("addIndexTime ret suc:\(ret == 1)")
        return ret;
    }
    
    func updateIndexTime(_ start_time: Int64, end_time: Int64) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let updateSQL = "UPDATE \(SQLHelper.TABLE_INDEX_START_TIME) SET \(SQLHelper.KEY_IS_END_TIME)='\(end_time)' WHERE \(SQLHelper.KEY_IS_START_TIME)='\(start_time)'";
            
            let result = db!.executeUpdate(updateSQL, withArgumentsIn: nil)
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
                Log.d(SQLHelper.tag, msg: "updateIndexTime time:\(start_time) end:\(end_time)");
            }
        }
        
       /* contactDB?.beginTransaction()
        let updateSQL = "UPDATE \(SQLHelper.TABLE_INDEX_START_TIME) SET \(SQLHelper.KEY_IS_END_TIME)='\(end_time)' WHERE \(SQLHelper.KEY_IS_START_TIME)='\(start_time)'";
        
        let result = contactDB!.executeUpdate(updateSQL, withArgumentsIn: nil)
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
            contactDB?.rollback()
        }else{
            ret = Int32(SQLHelper.SUCCESS);
            Log.d(SQLHelper.tag, msg: "updateIndexTime time:\(start_time) end:\(end_time)");
            contactDB?.commit()
        }
        */
        print("updateIndexTime ret suc:\(ret == 1)")
        return ret;
    }
    
    func getIndexTime(_ start_time: Int64) -> (Int32, Int64, Int64) {
        var time: Int64 = 0
        var end_time: Int64 = 0
        var label: Int32 = 0
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_INDEX_START_TIME) WHERE \(SQLHelper.KEY_IS_START_TIME)='\(start_time)'";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_START_TIME))!
                end_time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_END_TIME))!
                label = (results?.int(forColumn: SQLHelper.KEY_IS_LABEL))!
            }
            
            results?.close()
        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_INDEX_START_TIME) WHERE \(SQLHelper.KEY_IS_START_TIME)='\(start_time)'";
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        if results?.next() == true {
            time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_START_TIME))!
            end_time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_END_TIME))!
            label = (results?.int(forColumn: SQLHelper.KEY_IS_LABEL))!
        }
        
        results?.close() */
        print("getIndexTime \(label) \(time) \(end_time)")
        return (label, time, end_time);
    }
    
    func getIndexTime() -> [(Int32, Int64, Int64)] {
        var timeArray: [(Int32, Int64, Int64)] = []
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_INDEX_START_TIME) ORDER BY \(SQLHelper.KEY_IS_START_TIME) ASC";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            while results?.next() == true {
                let time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_START_TIME))!
                let end_time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_END_TIME))!
                let label = (results?.int(forColumn: SQLHelper.KEY_IS_LABEL))!
                
                timeArray.append((label, time, end_time))
            }
            
            results?.close()
        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_INDEX_START_TIME) ORDER BY \(SQLHelper.KEY_IS_START_TIME) ASC";
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        while results?.next() == true {
            let time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_START_TIME))!
            let end_time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_END_TIME))!
            let label = (results?.int(forColumn: SQLHelper.KEY_IS_LABEL))!
            
            timeArray.append((label, time, end_time))
        }
        
        results?.close()*/
        print("getIndexTime timeArray size \(timeArray.count)")
        return timeArray
    }
    
    func getIndexTime(BLCmdLabel label: Int32) -> (Int32, Int64, Int64) {
        var ret: (Int32, Int64, Int64) = (0, 0, 0)
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_INDEX_START_TIME) WHERE \(SQLHelper.KEY_IS_LABEL)='\(label)' ORDER BY \(SQLHelper.KEY_IS_START_TIME) ASC LIMIT 1";
            
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                let time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_START_TIME))!
                let end_time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_END_TIME))!
                let label = (results?.int(forColumn: SQLHelper.KEY_IS_LABEL))!
                
                ret = (label, time, end_time)
            }
            
            results?.close()

        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_INDEX_START_TIME) WHERE \(SQLHelper.KEY_IS_LABEL)='\(label)' ORDER BY \(SQLHelper.KEY_IS_START_TIME) ASC LIMIT 1";
        
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        if results?.next() == true {
            let time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_START_TIME))!
            let end_time = (results?.longLongInt(forColumn: SQLHelper.KEY_IS_END_TIME))!
            let label = (results?.int(forColumn: SQLHelper.KEY_IS_LABEL))!
            
            ret = (label, time, end_time)
        }
        
        results?.close()*/
        print("getIndexTime \(ret.0) \(ret.1) \(ret.2)")
        return ret
    }
    
    func deleteIndexTime(_ start_time: Int64) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_INDEX_START_TIME) WHERE \(SQLHelper.KEY_IS_START_TIME)='\(start_time)'";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_INDEX_START_TIME) WHERE \(SQLHelper.KEY_IS_START_TIME)='\(start_time)'";
        let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
        }else{
            ret = Int32(SQLHelper.SUCCESS);
        }*/
        print("deleteIndexTime suc:\(ret == 1)")
        return ret;
    }
    
    func deleteIndexTime() -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_INDEX_START_TIME)";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_INDEX_START_TIME)";
        let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
        }else{
            ret = Int32(SQLHelper.SUCCESS);
        }*/
        print("deleteIndexTime suc:\(ret == 1)")
        return ret;
    }
    
    func addConsume(_ contact: ActivityData) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let insertSQL = "INSERT INTO \(SQLHelper.TABLE_ACTIVITY_DATA) (\(SQLHelper.KEY_AD_LABEL), \(SQLHelper.KEY_AD_CALORIE), \(SQLHelper.KEY_AD_START_DATE), \(SQLHelper.KEY_AD_END_DATE), \(SQLHelper.KEY_AD_INTENSITY_L), \(SQLHelper.KEY_AD_INTENSITY_M), \(SQLHelper.KEY_AD_INTENSITY_H), \(SQLHelper.KEY_AD_INTENSITY_D), \(SQLHelper.KEY_AD_MAXHR), \(SQLHelper.KEY_AD_MINHR), \(SQLHelper.KEY_AD_AVGHR), \(SQLHelper.KEY_AD_UPLOAD)) VALUES ('\(contact.Label)', '\(contact.Calorie)', '\(contact.StartDate)', '\(contact.EndDate)', '\(contact.IntensityL)', '\(contact.IntensityM)', '\(contact.IntensityH)', '\(contact.IntensityD)', '\(contact.MaxHR)', '\(contact.MinHR)', '\(contact.AvgHR)', '\(contact.Upload)')"
            
            let result = db!.executeUpdate(insertSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                Log.d(SQLHelper.tag, msg: "addConsume act data input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload)");
                ret = Int32(SQLHelper.SUCCESS);
            }

        }
        /*contactDB?.beginTransaction()
        let insertSQL = "INSERT INTO \(SQLHelper.TABLE_ACTIVITY_DATA) (\(SQLHelper.KEY_AD_LABEL), \(SQLHelper.KEY_AD_CALORIE), \(SQLHelper.KEY_AD_START_DATE), \(SQLHelper.KEY_AD_END_DATE), \(SQLHelper.KEY_AD_INTENSITY_L), \(SQLHelper.KEY_AD_INTENSITY_M), \(SQLHelper.KEY_AD_INTENSITY_H), \(SQLHelper.KEY_AD_INTENSITY_D), \(SQLHelper.KEY_AD_MAXHR), \(SQLHelper.KEY_AD_MINHR), \(SQLHelper.KEY_AD_AVGHR), \(SQLHelper.KEY_AD_UPLOAD)) VALUES ('\(contact.Label)', '\(contact.Calorie)', '\(contact.StartDate)', '\(contact.EndDate)', '\(contact.IntensityL)', '\(contact.IntensityM)', '\(contact.IntensityH)', '\(contact.IntensityD)', '\(contact.MaxHR)', '\(contact.MinHR)', '\(contact.AvgHR)', '\(contact.Upload)')"
        
        let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
            contactDB?.rollback()
        }else{
            Log.d(SQLHelper.tag, msg: "addConsume act data input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload)");
            ret = Int32(SQLHelper.SUCCESS);
            contactDB?.commit()
        }*/
        print("addConsume suc:\(ret == 1)")
        return ret;
    }
    
    func addConsume(_ contact: CoachActivityData) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let insertSQL = "INSERT INTO \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) (\(SQLHelper.KEY_CA_VIDEO_IDX), \(SQLHelper.KEY_CA_VIDEO_FULL_COUNT), \(SQLHelper.KEY_CA_EXER_IDX), \(SQLHelper.KEY_CA_EXER_COUNT), \(SQLHelper.KEY_CA_START_TIME), \(SQLHelper.KEY_CA_END_TIME), \(SQLHelper.KEY_CA_CONSUME_CALORIE), \(SQLHelper.KEY_CA_COUNT), \(SQLHelper.KEY_CA_COUNT_PERCENT), \(SQLHelper.KEY_CA_PERFECT_COUNT), \(SQLHelper.KEY_CA_MIN_ACCURACY), \(SQLHelper.KEY_CA_MAX_ACCURACY), \(SQLHelper.KEY_CA_AVG_ACCURACY), \(SQLHelper.KEY_CA_MIN_HEARTRATE), \(SQLHelper.KEY_CA_MAX_HEARTRATE), \(SQLHelper.KEY_CA_AVG_HEARTRATE), \(SQLHelper.KEY_CA_CMP_HEARTRATE), \(SQLHelper.KEY_CA_POINT), \(SQLHelper.KEY_CA_EXER_RESERVED_1), \(SQLHelper.KEY_CA_EXER_RESERVED_2)) VALUES ('\(contact.VideoIdx)', '\(contact.VideoFullCount)', '\(contact.ExerIdx)', '\(contact.ExerCount)', '\(contact.StartTime)', '\(contact.EndTime)', '\(contact.ConsumeCalorie)', '\(contact.Count)', '\(contact.CountPercent)', '\(contact.PerfectCount)', '\(contact.MinAccuracy)', '\(contact.MaxAccuracy)', '\(contact.AvgAccuracy)', '\(contact.MinHeartRate)', '\(contact.MaxHeartRate)', '\(contact.AvgHeartRate)', '\(contact.CmpHeartRate)', '\(contact.Point)', '\(contact.Reserv_1)', '\(contact.Reserv_2)')"
            
            let result = db!.executeUpdate(insertSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                Log.d(SQLHelper.tag, msg: "addConsume coach data input time:\(contact.StartTime)");
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*contactDB?.beginTransaction()
        let insertSQL = "INSERT INTO \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) (\(SQLHelper.KEY_CA_VIDEO_IDX), \(SQLHelper.KEY_CA_VIDEO_FULL_COUNT), \(SQLHelper.KEY_CA_EXER_IDX), \(SQLHelper.KEY_CA_EXER_COUNT), \(SQLHelper.KEY_CA_START_TIME), \(SQLHelper.KEY_CA_END_TIME), \(SQLHelper.KEY_CA_CONSUME_CALORIE), \(SQLHelper.KEY_CA_COUNT), \(SQLHelper.KEY_CA_COUNT_PERCENT), \(SQLHelper.KEY_CA_PERFECT_COUNT), \(SQLHelper.KEY_CA_MIN_ACCURACY), \(SQLHelper.KEY_CA_MAX_ACCURACY), \(SQLHelper.KEY_CA_AVG_ACCURACY), \(SQLHelper.KEY_CA_MIN_HEARTRATE), \(SQLHelper.KEY_CA_MAX_HEARTRATE), \(SQLHelper.KEY_CA_AVG_HEARTRATE), \(SQLHelper.KEY_CA_CMP_HEARTRATE), \(SQLHelper.KEY_CA_POINT), \(SQLHelper.KEY_CA_EXER_RESERVED_1), \(SQLHelper.KEY_CA_EXER_RESERVED_2)) VALUES ('\(contact.VideoIdx)', '\(contact.VideoFullCount)', '\(contact.ExerIdx)', '\(contact.ExerCount)', '\(contact.StartTime)', '\(contact.EndTime)', '\(contact.ConsumeCalorie)', '\(contact.Count)', '\(contact.CountPercent)', '\(contact.PerfectCount)', '\(contact.MinAccuracy)', '\(contact.MaxAccuracy)', '\(contact.AvgAccuracy)', '\(contact.MinHeartRate)', '\(contact.MaxHeartRate)', '\(contact.AvgHeartRate)', '\(contact.CmpHeartRate)', '\(contact.Point)', '\(contact.Reserv_1)', '\(contact.Reserv_2)')"
        
        let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
            contactDB?.rollback()
        }else{
            Log.d(SQLHelper.tag, msg: "addConsume coach data input time:\(contact.StartTime)");
            ret = Int32(SQLHelper.SUCCESS);
            contactDB?.commit()
        }
        */
        print("addConsume suc:\(ret == 1)")
        return ret;
    }
    
    
    func updateConsume(_ contact: ActivityData) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let updateSQL = "UPDATE \(SQLHelper.TABLE_ACTIVITY_DATA) SET \(SQLHelper.KEY_AD_LABEL)='\(contact.Label)', \(SQLHelper.KEY_AD_CALORIE)='\(contact.Calorie)', \(SQLHelper.KEY_AD_START_DATE)='\(contact.StartDate)', \(SQLHelper.KEY_AD_END_DATE)='\(contact.EndDate)', \(SQLHelper.KEY_AD_INTENSITY_L)='\(contact.IntensityL)', \(SQLHelper.KEY_AD_INTENSITY_M)='\(contact.IntensityM)', \(SQLHelper.KEY_AD_INTENSITY_H)='\(contact.IntensityH)', \(SQLHelper.KEY_AD_INTENSITY_D)='\(contact.IntensityD)', \(SQLHelper.KEY_AD_MAXHR)='\(contact.MaxHR)', \(SQLHelper.KEY_AD_MINHR)='\(contact.MinHR)', \(SQLHelper.KEY_AD_AVGHR)='\(contact.AvgHR)', \(SQLHelper.KEY_AD_UPLOAD)='\(contact.Upload)' WHERE \(SQLHelper.KEY_AD_START_DATE)='\(contact.StartDate)'";
            
            let result = db!.executeUpdate(updateSQL, withArgumentsIn: nil)
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
                Log.d(SQLHelper.tag, msg: "1. input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload) updateConsme ret:\(ret)");
            }
        }
        /*contactDB?.beginTransaction()
        let updateSQL = "UPDATE \(SQLHelper.TABLE_ACTIVITY_DATA) SET \(SQLHelper.KEY_AD_LABEL)='\(contact.Label)', \(SQLHelper.KEY_AD_CALORIE)='\(contact.Calorie)', \(SQLHelper.KEY_AD_START_DATE)='\(contact.StartDate)', \(SQLHelper.KEY_AD_END_DATE)='\(contact.EndDate)', \(SQLHelper.KEY_AD_INTENSITY_L)='\(contact.IntensityL)', \(SQLHelper.KEY_AD_INTENSITY_M)='\(contact.IntensityM)', \(SQLHelper.KEY_AD_INTENSITY_H)='\(contact.IntensityH)', \(SQLHelper.KEY_AD_INTENSITY_D)='\(contact.IntensityD)', \(SQLHelper.KEY_AD_MAXHR)='\(contact.MaxHR)', \(SQLHelper.KEY_AD_MINHR)='\(contact.MinHR)', \(SQLHelper.KEY_AD_AVGHR)='\(contact.AvgHR)', \(SQLHelper.KEY_AD_UPLOAD)='\(contact.Upload)' WHERE \(SQLHelper.KEY_AD_START_DATE)='\(contact.StartDate)'";
        
        let result = contactDB!.executeUpdate(updateSQL, withArgumentsIn: nil)
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
            contactDB?.rollback()
        }else{
            ret = Int32(SQLHelper.SUCCESS);
            Log.d(SQLHelper.tag, msg: "1. input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload) updateConsme ret:\(ret)");
            contactDB?.commit()
        }*/
        print("updateConsume suc:\(ret == 1)")
        return ret;
    }
    
    func updateConsume(_ contact: ActivityData, flag: Int32) -> Int32 {
        contact.Upload = flag;
        let ret = updateConsume(contact);
        Log.d(SQLHelper.tag, msg: "->2. input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload) updateConsme ret:\(ret)");
        
        return ret;
    }
    
    //규창 171025 피쳐 데이터 내부 DB로 업데이트
    func addConsume(_ contact: FeatureData) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let insertSQL = "INSERT INTO \(SQLHelper.TABLE_FEATURE_DATA) (\(SQLHelper.KEY_FD_LABEL), \(SQLHelper.KEY_FD_ACT_INDEX), \(SQLHelper.KEY_FD_START_DATE), \(SQLHelper.KEY_FD_INTENSITY), \(SQLHelper.KEY_FD_CALORIE), \(SQLHelper.KEY_FD_SPEED), \(SQLHelper.KEY_FD_HEARTRATE), \(SQLHelper.KEY_FD_STEP), \(SQLHelper.KEY_FD_SWING), \(SQLHelper.KEY_FD_PRESS_VAR), \(SQLHelper.KEY_FD_COACH_INTENSITY), \(SQLHelper.KEY_FD_UPLOAD)) VALUES ('\(contact.Label)', '\(contact.ActIndex)', '\(contact.StartDate)', '\(contact.Intensity)', '\(contact.Calorie)', '\(contact.Speed)', '\(contact.Heartrate)', '\(contact.Step)', '\(contact.Swing)', '\(contact.Press_var)', '\(contact.Coach_intensity)', '\(contact.Upload)')"
            //"CREATE TABLE IF NOT EXISTS \(SQLHelper.TABLE_FEATURE_DATA) (\(SQLHelper.KEY_FD_INDEX) INTEGER PRIMARY KEY, \(SQLHelper.KEY_FD_LABEL) INTEGER,\(SQLHelper.KEY_FD_ACT_INDEX) INTEGER,\(SQLHelper.KEY_FD_START_DATE) INTEGER, \(SQLHelper.KEY_FD_INTENSITY) REAL,\(SQLHelper.KEY_FD_CALORIE) REAL,\(SQLHelper.KEY_FD_SPEED) REAL,\(SQLHelper.KEY_FD_HEARTRATE) INTEGER,\(SQLHelper.KEY_FD_STEP) INTEGER,\(SQLHelper.KEY_FD_SWING) INTEGER,\(SQLHelper.KEY_FD_PRESS_VAR) REAL,\(SQLHelper.KEY_AD_UPLOAD) INTEGER)"
            
            let result = db!.executeUpdate(insertSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                Log.d(SQLHelper.tag, msg: "FeatureData addConsume FeatureData input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload)");
                ret = Int32(SQLHelper.SUCCESS);
            }
            
        }
        /*contactDB?.beginTransaction()
         let insertSQL = "INSERT INTO \(SQLHelper.TABLE_ACTIVITY_DATA) (\(SQLHelper.KEY_AD_LABEL), \(SQLHelper.KEY_AD_CALORIE), \(SQLHelper.KEY_AD_START_DATE), \(SQLHelper.KEY_AD_END_DATE), \(SQLHelper.KEY_AD_INTENSITY_L), \(SQLHelper.KEY_AD_INTENSITY_M), \(SQLHelper.KEY_AD_INTENSITY_H), \(SQLHelper.KEY_AD_INTENSITY_D), \(SQLHelper.KEY_AD_MAXHR), \(SQLHelper.KEY_AD_MINHR), \(SQLHelper.KEY_AD_AVGHR), \(SQLHelper.KEY_AD_UPLOAD)) VALUES ('\(contact.Label)', '\(contact.Calorie)', '\(contact.StartDate)', '\(contact.EndDate)', '\(contact.IntensityL)', '\(contact.IntensityM)', '\(contact.IntensityH)', '\(contact.IntensityD)', '\(contact.MaxHR)', '\(contact.MinHR)', '\(contact.AvgHR)', '\(contact.Upload)')"
         
         let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
         
         if !result {
         print("[4] Error : \(contactDB!.lastErrorMessage())")
         contactDB?.rollback()
         }else{
         Log.d(SQLHelper.tag, msg: "addConsume act data input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload)");
         ret = Int32(SQLHelper.SUCCESS);
         contactDB?.commit()
         }*/
        print("FeatureData addConsume suc:\(ret == 1)")
        return ret;
    }
    
    func updateConsume(_ contact: FeatureData) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let updateSQL = "UPDATE \(SQLHelper.TABLE_FEATURE_DATA) SET \(SQLHelper.KEY_FD_LABEL)='\(contact.Label)', \(SQLHelper.KEY_FD_ACT_INDEX)='\(contact.ActIndex)', \(SQLHelper.KEY_FD_START_DATE)='\(contact.StartDate)', \(SQLHelper.KEY_FD_INTENSITY)='\(contact.Intensity)', \(SQLHelper.KEY_FD_CALORIE)='\(contact.Calorie)', \(SQLHelper.KEY_FD_SPEED)='\(contact.Speed)', \(SQLHelper.KEY_FD_HEARTRATE)='\(contact.Heartrate)', \(SQLHelper.KEY_FD_STEP)='\(contact.Step)', \(SQLHelper.KEY_FD_SWING)='\(contact.Swing)', \(SQLHelper.KEY_FD_PRESS_VAR)='\(contact.Press_var)', \(SQLHelper.KEY_FD_COACH_INTENSITY)='\(contact.Coach_intensity)', \(SQLHelper.KEY_AD_UPLOAD)='\(contact.Upload)' WHERE \(SQLHelper.KEY_FD_START_DATE)='\(contact.StartDate)'";
            
            //let insertSQL = "INSERT INTO \(SQLHelper.TABLE_FEATURE_DATA) (\(SQLHelper.KEY_FD_LABEL), \(SQLHelper.KEY_FD_ACT_INDEX), \(SQLHelper.KEY_FD_START_DATE), \(SQLHelper.KEY_FD_INTENSITY), \(SQLHelper.KEY_FD_CALORIE), \(SQLHelper.KEY_FD_SPEED), \(SQLHelper.KEY_FD_HEARTRATE), \(SQLHelper.KEY_FD_STEP), \(SQLHelper.KEY_FD_SWING), \(SQLHelper.KEY_FD_PRESS_VAR), \(SQLHelper.KEY_FD_COACH_INTENSITY), \(SQLHelper.KEY_FD_UPLOAD)) VALUES ('\(contact.Label)', '\(contact.ActIndex)', '\(contact.StartDate)', '\(contact.Intensity)', '\(contact.Calorie)', '\(contact.Speed)', '\(contact.Heartrate)', '\(contact.Step)', '\(contact.Swing)', '\(contact.Press_var)', , '\(contact.Coach_intensity), '\(contact.Upload)')"
            
            
            
            let result = db!.executeUpdate(updateSQL, withArgumentsIn: nil)
            if !result {
                print("FeatureData [4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
                Log.d(SQLHelper.tag, msg: "FeatureData 1. input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload) updateConsme ret:\(ret)");
            }
        }
        /*contactDB?.beginTransaction()
         let updateSQL = "UPDATE \(SQLHelper.TABLE_ACTIVITY_DATA) SET \(SQLHelper.KEY_AD_LABEL)='\(contact.Label)', \(SQLHelper.KEY_AD_CALORIE)='\(contact.Calorie)', \(SQLHelper.KEY_AD_START_DATE)='\(contact.StartDate)', \(SQLHelper.KEY_AD_END_DATE)='\(contact.EndDate)', \(SQLHelper.KEY_AD_INTENSITY_L)='\(contact.IntensityL)', \(SQLHelper.KEY_AD_INTENSITY_M)='\(contact.IntensityM)', \(SQLHelper.KEY_AD_INTENSITY_H)='\(contact.IntensityH)', \(SQLHelper.KEY_AD_INTENSITY_D)='\(contact.IntensityD)', \(SQLHelper.KEY_AD_MAXHR)='\(contact.MaxHR)', \(SQLHelper.KEY_AD_MINHR)='\(contact.MinHR)', \(SQLHelper.KEY_AD_AVGHR)='\(contact.AvgHR)', \(SQLHelper.KEY_AD_UPLOAD)='\(contact.Upload)' WHERE \(SQLHelper.KEY_AD_START_DATE)='\(contact.StartDate)'";
         
         let result = contactDB!.executeUpdate(updateSQL, withArgumentsIn: nil)
         if !result {
         print("[4] Error : \(contactDB!.lastErrorMessage())")
         contactDB?.rollback()
         }else{
         ret = Int32(SQLHelper.SUCCESS);
         Log.d(SQLHelper.tag, msg: "1. input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload) updateConsme ret:\(ret)");
         contactDB?.commit()
         }*/
        print("FeatureData updateConsume suc:\(ret == 1)")
        return ret;
    }
    func updateConsume(_ contact: FeatureData, flag: Int32) -> Int32 {
        contact.Upload = flag;
        let ret = updateConsume(contact);
        Log.d(SQLHelper.tag, msg: "->FeatureData 2. input label:\(contact.Label) time:\(contact.StartDate) flag:\(contact.Upload) updateConsme ret:\(ret)");
        
        return ret;
    }
    
    
    
    
    
    
    
    func getCoachActivityData() -> [CoachActivityData]? {
        var consumeArray: [CoachActivityData] = [];
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) ORDER BY \(SQLHelper.KEY_CA_START_TIME) ASC";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            while results?.next() == true {
                let consume = CoachActivityData(index: results?.int(forColumn: SQLHelper.KEY_CA_INDEX), video_idx: results?.int(forColumn: SQLHelper.KEY_CA_VIDEO_IDX), video_full_count: results?.int(forColumn: SQLHelper.KEY_CA_VIDEO_FULL_COUNT), exer_idx: results?.int(forColumn: SQLHelper.KEY_CA_EXER_IDX), exer_count: results?.int(forColumn: SQLHelper.KEY_CA_EXER_COUNT), start_time: results?.longLongInt(forColumn: SQLHelper.KEY_CA_START_TIME), end_time: results?.longLongInt(forColumn: SQLHelper.KEY_CA_END_TIME), consume_calorie: results?.int(forColumn: SQLHelper.KEY_CA_CONSUME_CALORIE), count: results?.int(forColumn: SQLHelper.KEY_CA_COUNT), count_percent: results?.int(forColumn: SQLHelper.KEY_CA_COUNT_PERCENT), perfect_count: results?.int(forColumn: SQLHelper.KEY_CA_PERFECT_COUNT), min_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_MIN_ACCURACY), max_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_MAX_ACCURACY), avg_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_AVG_ACCURACY), min_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_MIN_HEARTRATE), max_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_MAX_HEARTRATE), avg_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_AVG_HEARTRATE), cmp_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_CMP_HEARTRATE), point: results?.int(forColumn: SQLHelper.KEY_CA_POINT), reserv_1: results?.int(forColumn: SQLHelper.KEY_CA_EXER_RESERVED_1), reserv_2: results?.int(forColumn: SQLHelper.KEY_CA_EXER_RESERVED_2))
                
                
                consumeArray.append(consume);
            }
            
            results?.close()
        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) ORDER BY \(SQLHelper.KEY_CA_START_TIME) ASC";
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        while results?.next() == true {
            let consume = CoachActivityData(index: results?.int(forColumn: SQLHelper.KEY_CA_INDEX), video_idx: results?.int(forColumn: SQLHelper.KEY_CA_VIDEO_IDX), video_full_count: results?.int(forColumn: SQLHelper.KEY_CA_VIDEO_FULL_COUNT), exer_idx: results?.int(forColumn: SQLHelper.KEY_CA_EXER_IDX), exer_count: results?.int(forColumn: SQLHelper.KEY_CA_EXER_COUNT), start_time: results?.longLongInt(forColumn: SQLHelper.KEY_CA_START_TIME), end_time: results?.longLongInt(forColumn: SQLHelper.KEY_CA_END_TIME), consume_calorie: results?.int(forColumn: SQLHelper.KEY_CA_CONSUME_CALORIE), count: results?.int(forColumn: SQLHelper.KEY_CA_COUNT), count_percent: results?.int(forColumn: SQLHelper.KEY_CA_COUNT_PERCENT), perfect_count: results?.int(forColumn: SQLHelper.KEY_CA_PERFECT_COUNT), min_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_MIN_ACCURACY), max_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_MAX_ACCURACY), avg_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_AVG_ACCURACY), min_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_MIN_HEARTRATE), max_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_MAX_HEARTRATE), avg_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_AVG_HEARTRATE), cmp_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_CMP_HEARTRATE), point: results?.int(forColumn: SQLHelper.KEY_CA_POINT), reserv_1: results?.int(forColumn: SQLHelper.KEY_CA_EXER_RESERVED_1), reserv_2: results?.int(forColumn: SQLHelper.KEY_CA_EXER_RESERVED_2))
            
            
            consumeArray.append(consume);
        }
        
        //print("--------- \(consumeArray.count)")
        results?.close()*/
        print("getCoachActivityData size \(consumeArray.count)")
        if consumeArray.count < 1 {
            return nil;
        } else {
            return consumeArray;
        }
    }
    
    func getCoachActivityDataNeedUpload() -> CoachActivityData? {
        var consume: CoachActivityData? = nil;
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) LIMIT 1";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                consume = CoachActivityData(index: results?.int(forColumn: SQLHelper.KEY_CA_INDEX), video_idx: results?.int(forColumn: SQLHelper.KEY_CA_VIDEO_IDX), video_full_count: results?.int(forColumn: SQLHelper.KEY_CA_VIDEO_FULL_COUNT), exer_idx: results?.int(forColumn: SQLHelper.KEY_CA_EXER_IDX), exer_count: results?.int(forColumn: SQLHelper.KEY_CA_EXER_COUNT), start_time: results?.longLongInt(forColumn: SQLHelper.KEY_CA_START_TIME), end_time: results?.longLongInt(forColumn: SQLHelper.KEY_CA_END_TIME), consume_calorie: results?.int(forColumn: SQLHelper.KEY_CA_CONSUME_CALORIE), count: results?.int(forColumn: SQLHelper.KEY_CA_COUNT), count_percent: results?.int(forColumn: SQLHelper.KEY_CA_COUNT_PERCENT), perfect_count: results?.int(forColumn: SQLHelper.KEY_CA_PERFECT_COUNT), min_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_MIN_ACCURACY), max_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_MAX_ACCURACY), avg_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_AVG_ACCURACY), min_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_MIN_HEARTRATE), max_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_MAX_HEARTRATE), avg_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_AVG_HEARTRATE), cmp_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_CMP_HEARTRATE), point: results?.int(forColumn: SQLHelper.KEY_CA_POINT), reserv_1: results?.int(forColumn: SQLHelper.KEY_CA_EXER_RESERVED_1), reserv_2: results?.int(forColumn: SQLHelper.KEY_CA_EXER_RESERVED_2))
            }
            
            results?.close()
        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) LIMIT 1";
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        if results?.next() == true {
            consume = CoachActivityData(index: results?.int(forColumn: SQLHelper.KEY_CA_INDEX), video_idx: results?.int(forColumn: SQLHelper.KEY_CA_VIDEO_IDX), video_full_count: results?.int(forColumn: SQLHelper.KEY_CA_VIDEO_FULL_COUNT), exer_idx: results?.int(forColumn: SQLHelper.KEY_CA_EXER_IDX), exer_count: results?.int(forColumn: SQLHelper.KEY_CA_EXER_COUNT), start_time: results?.longLongInt(forColumn: SQLHelper.KEY_CA_START_TIME), end_time: results?.longLongInt(forColumn: SQLHelper.KEY_CA_END_TIME), consume_calorie: results?.int(forColumn: SQLHelper.KEY_CA_CONSUME_CALORIE), count: results?.int(forColumn: SQLHelper.KEY_CA_COUNT), count_percent: results?.int(forColumn: SQLHelper.KEY_CA_COUNT_PERCENT), perfect_count: results?.int(forColumn: SQLHelper.KEY_CA_PERFECT_COUNT), min_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_MIN_ACCURACY), max_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_MAX_ACCURACY), avg_accuracy: results?.int(forColumn: SQLHelper.KEY_CA_AVG_ACCURACY), min_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_MIN_HEARTRATE), max_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_MAX_HEARTRATE), avg_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_AVG_HEARTRATE), cmp_heartrate: results?.int(forColumn: SQLHelper.KEY_CA_CMP_HEARTRATE), point: results?.int(forColumn: SQLHelper.KEY_CA_POINT), reserv_1: results?.int(forColumn: SQLHelper.KEY_CA_EXER_RESERVED_1), reserv_2: results?.int(forColumn: SQLHelper.KEY_CA_EXER_RESERVED_2))
        }
        
        results?.close()*/
        print("getCoachActivityDataNeedUpload \(String(describing: consume?.StartTime))")
        return consume;
    }
    
    func getActivityData() -> [ActivityData]? {
        var consumeArray: [ActivityData] = [];
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_ACTIVITY_DATA) ORDER BY \(SQLHelper.KEY_AD_START_DATE) DESC";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            while results?.next() == true {
                let consume = ActivityData(index: results?.int(forColumn: SQLHelper.KEY_AD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_AD_LABEL), calorie: results?.double(forColumn: SQLHelper.KEY_AD_CALORIE), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_START_DATE), end_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_END_DATE), intensityL: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_L), intensityM: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_M), intensityH: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_H), intensityD: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_D), maxHR: results?.int(forColumn: SQLHelper.KEY_AD_MAXHR), minHR: results?.int(forColumn: SQLHelper.KEY_AD_MINHR), avgHR: results?.int(forColumn: SQLHelper.KEY_AD_AVGHR), upload: results?.int(forColumn: SQLHelper.KEY_AD_UPLOAD))
                
                
                consumeArray.append(consume);
            }
            
            //print("--------- \(consumeArray.count)")
            results?.close()
        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_ACTIVITY_DATA) ORDER BY \(SQLHelper.KEY_AD_START_DATE) ASC";
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        while results?.next() == true {
            let consume = ActivityData(index: results?.int(forColumn: SQLHelper.KEY_AD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_AD_LABEL), calorie: results?.double(forColumn: SQLHelper.KEY_AD_CALORIE), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_START_DATE), end_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_END_DATE), intensityL: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_L), intensityM: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_M), intensityH: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_H), intensityD: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_D), maxHR: results?.int(forColumn: SQLHelper.KEY_AD_MAXHR), minHR: results?.int(forColumn: SQLHelper.KEY_AD_MINHR), avgHR: results?.int(forColumn: SQLHelper.KEY_AD_AVGHR), upload: results?.int(forColumn: SQLHelper.KEY_AD_UPLOAD))

            
            consumeArray.append(consume);
        }

        //print("--------- \(consumeArray.count)")
        results?.close()*/
        print("getActivityData size \(consumeArray.count)")
        if consumeArray.count < 1 {
            return nil;
        } else {
            return consumeArray;
        }
    }
    
    
    func getActivityData(_ start_date: Int64) -> ActivityData? {
        var consume: ActivityData? = nil;

        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_START_DATE)='\(start_date)'";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                consume = ActivityData(index: results?.int(forColumn: SQLHelper.KEY_AD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_AD_LABEL), calorie: results?.double(forColumn: SQLHelper.KEY_AD_CALORIE), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_START_DATE), end_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_END_DATE), intensityL: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_L), intensityM: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_M), intensityH: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_H), intensityD: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_D), maxHR: results?.int(forColumn: SQLHelper.KEY_AD_MAXHR), minHR: results?.int(forColumn: SQLHelper.KEY_AD_MINHR), avgHR: results?.int(forColumn: SQLHelper.KEY_AD_AVGHR), upload: results?.int(forColumn: SQLHelper.KEY_AD_UPLOAD))
            }
            print("getActivityData label:\(String(describing: consume?.Label)) start time:\(String(describing: consume?.StartDate)) end time:\(String(describing: consume?.EndDate))")
            
            results?.close()

        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_START_DATE)='\(start_date)'";
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        if results?.next() == true {
            consume = ActivityData(index: results?.int(forColumn: SQLHelper.KEY_AD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_AD_LABEL), calorie: results?.double(forColumn: SQLHelper.KEY_AD_CALORIE), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_START_DATE), end_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_END_DATE), intensityL: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_L), intensityM: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_M), intensityH: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_H), intensityD: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_D), maxHR: results?.int(forColumn: SQLHelper.KEY_AD_MAXHR), minHR: results?.int(forColumn: SQLHelper.KEY_AD_MINHR), avgHR: results?.int(forColumn: SQLHelper.KEY_AD_AVGHR), upload: results?.int(forColumn: SQLHelper.KEY_AD_UPLOAD))
        }
        print("getActivityData label:\(consume?.Label) start time:\(consume?.StartDate) end time:\(consume?.EndDate)")
        
        results?.close()*/
        print("getActivityData \(String(describing: consume?.StartDate))")
        return consume;
    }
    
    func getActivityData(Index index: Int32) -> ActivityData? {
        var consume: ActivityData? = nil;
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_INDEX)='\(index)'";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                consume = ActivityData(index: results?.int(forColumn: SQLHelper.KEY_AD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_AD_LABEL), calorie: results?.double(forColumn: SQLHelper.KEY_AD_CALORIE), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_START_DATE), end_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_END_DATE), intensityL: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_L), intensityM: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_M), intensityH: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_H), intensityD: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_D), maxHR: results?.int(forColumn: SQLHelper.KEY_AD_MAXHR), minHR: results?.int(forColumn: SQLHelper.KEY_AD_MINHR), avgHR: results?.int(forColumn: SQLHelper.KEY_AD_AVGHR), upload: results?.int(forColumn: SQLHelper.KEY_AD_UPLOAD))
            }
            
            results?.close()
        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_INDEX)='\(index)'";
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        if results?.next() == true {
            consume = ActivityData(index: results?.int(forColumn: SQLHelper.KEY_AD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_AD_LABEL), calorie: results?.double(forColumn: SQLHelper.KEY_AD_CALORIE), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_START_DATE), end_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_END_DATE), intensityL: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_L), intensityM: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_M), intensityH: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_H), intensityD: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_D), maxHR: results?.int(forColumn: SQLHelper.KEY_AD_MAXHR), minHR: results?.int(forColumn: SQLHelper.KEY_AD_MINHR), avgHR: results?.int(forColumn: SQLHelper.KEY_AD_AVGHR), upload: results?.int(forColumn: SQLHelper.KEY_AD_UPLOAD))
        }
        
        results?.close()*/
        print("getActivityData \(String(describing: consume?.StartDate))")
        return consume;
    }
    
    func getActivityDataNeedUpload() -> ActivityData? {
        var consume: ActivityData? = nil;
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_UPLOAD)='\(SQLHelper.NONSET_UPLOAD)' ORDER BY \(SQLHelper.KEY_AD_START_DATE) ASC LIMIT 1";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                consume = ActivityData(index: results?.int(forColumn: SQLHelper.KEY_AD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_AD_LABEL), calorie: results?.double(forColumn: SQLHelper.KEY_AD_CALORIE), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_START_DATE), end_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_END_DATE), intensityL: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_L), intensityM: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_M), intensityH: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_H), intensityD: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_D), maxHR: results?.int(forColumn: SQLHelper.KEY_AD_MAXHR), minHR: results?.int(forColumn: SQLHelper.KEY_AD_MINHR), avgHR: results?.int(forColumn: SQLHelper.KEY_AD_AVGHR), upload: results?.int(forColumn: SQLHelper.KEY_AD_UPLOAD))
            }
            
            results?.close()
        }
        /*let querySQL = "SELECT * FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_UPLOAD)='\(SQLHelper.NONSET_UPLOAD)' ORDER BY \(SQLHelper.KEY_AD_START_DATE) ASC LIMIT 1";
        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        if results?.next() == true {
            consume = ActivityData(index: results?.int(forColumn: SQLHelper.KEY_AD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_AD_LABEL), calorie: results?.double(forColumn: SQLHelper.KEY_AD_CALORIE), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_START_DATE), end_date: results?.longLongInt(forColumn: SQLHelper.KEY_AD_END_DATE), intensityL: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_L), intensityM: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_M), intensityH: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_H), intensityD: results?.int(forColumn: SQLHelper.KEY_AD_INTENSITY_D), maxHR: results?.int(forColumn: SQLHelper.KEY_AD_MAXHR), minHR: results?.int(forColumn: SQLHelper.KEY_AD_MINHR), avgHR: results?.int(forColumn: SQLHelper.KEY_AD_AVGHR), upload: results?.int(forColumn: SQLHelper.KEY_AD_UPLOAD))
        }
        
        results?.close()*/
        print("getActivityDataNeedUpload \(String(describing: consume?.StartDate))")
        return consume;
    }
    
//    func getConsumeCalorieContact(actInfo: [Contact.ActInfo]) -> [Contact.ActInfo] {
//        var date: [Int64] = []
//        for d in actInfo {
//            date.append(d.getC_year_month_day())
//        }
//        
//        var consumeArray: [Contact.ActInfo] = [];
//
//        var dateStr = "";
//        for i in 0..<date.count {
//            dateStr += String(date[i]);
//            if i < date.count-1 {
//                dateStr += ", ";
//            };
//        };
//        
//        let querySQL = "SELECT * FROM \(SQLHeper.TABLE_CONSUME_CALORIE) WHERE \(SQLHeper.KEY_C_YEAR_MONTH_DAY) IN(\(dateStr))";
//        print(querySQL)
//
//        let results: FMResultSet? = contactDB!.executeQuery(querySQL, withArgumentsInArray: nil)
//        while results?.next() == true {
//            let consume = Contact.ActInfo(c_year_month_day: results?.longLongIntForColumn(SQLHeper.KEY_C_YEAR_MONTH_DAY), c_exercise: results?.intForColumn(SQLHeper.KEY_C_EXERCISE), c_intensity: Float32((results?.doubleForColumn(SQLHeper.KEY_C_INTENSITY))!), c_calorie: Float32((results?.doubleForColumn(SQLHeper.KEY_C_CALORIE))!), c_unit: results?.intForColumn(SQLHeper.KEY_C_UNIT), c_intensity_number: Float32((results?.doubleForColumn(SQLHeper.KEY_C_INTENSITY_NUMBER))!), c_heartrate: results?.intForColumn(SQLHeper.KEY_C_HEARTRATE), c_step: results?.intForColumn(SQLHeper.KEY_C_STEP), c_swing: results?.intForColumn(SQLHeper.KEY_C_SWING), c_press_variance: Float32((results?.doubleForColumn(SQLHeper.KEY_C_PRESS_VARIANCE))!), c_coach_intensity: Float32((results?.doubleForColumn(SQLHeper.KEY_C_COACH_INTENSITY))!), c_flag: results?.intForColumn(SQLHeper.KEY_C_FLAG));
//            
//            consumeArray.append(consume);
//        }
//        
//        results?.close()
//        return consumeArray;
//    }
    
    //규창 171025 피쳐데이터 DB호출 함수 오픈
    func getFeatureData() -> [FeatureData]? {
        var consumeArray: [FeatureData] = [];
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_FEATURE_DATA) ORDER BY \(SQLHelper.KEY_FD_START_DATE) DESC";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            while results?.next() == true {
                //(index: Int32?, label: Int32?, actIndex: Int32?, start_date: Int64?, intensity: Double?, calorie: Double?, speed: Double?, heartrate: Int32?, step: Int32?, swing: Int32?, press_var: Double?, coach_intensity: Double?, upload:Int32?)
                let consume = FeatureData(index: results?.int(forColumn: SQLHelper.KEY_FD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_FD_LABEL), actIndex: results?.int(forColumn: SQLHelper.KEY_FD_ACT_INDEX), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_FD_START_DATE), intensity: results?.double(forColumn: SQLHelper.KEY_FD_INTENSITY), calorie: results?.double(forColumn: SQLHelper.KEY_FD_CALORIE), speed: results?.double(forColumn: SQLHelper.KEY_FD_SPEED), heartrate: results?.int(forColumn: SQLHelper.KEY_FD_HEARTRATE), step: results?.int(forColumn: SQLHelper.KEY_FD_STEP), swing: results?.int(forColumn: SQLHelper.KEY_FD_SWING), press_var: results?.double(forColumn: SQLHelper.KEY_FD_PRESS_VAR), coach_intensity: results?.double(forColumn: SQLHelper.KEY_FD_COACH_INTENSITY), upload: results?.int(forColumn: SQLHelper.KEY_FD_UPLOAD))
                consumeArray.append(consume)
            }
            //print("--------- \(consumeArray.count)")
            results?.close()
        }
        //print("getFeatureData size \(consumeArray.count)")
        if consumeArray.count < 1 {
            return nil;
        } else {
            return consumeArray;
        }
    }
    
    
    func getFeatureData(_ start_date: Int64) -> FeatureData? {
        var consume: FeatureData? = nil;
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_FEATURE_DATA) WHERE \(SQLHelper.KEY_FD_START_DATE)='\(start_date)'";
            let results: FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                //(index: Int32?, label: Int32?, actIndex: Int32?, start_date: Int64?, intensity: Double?, calorie: Double?, speed: Double?, heartrate: Int32?, step: Int32?, swing: Int32?, press_var: Double?, coach_intensity: Double?, upload:Int32?)
                consume = FeatureData(index: results?.int(forColumn: SQLHelper.KEY_FD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_FD_LABEL), actIndex: results?.int(forColumn: SQLHelper.KEY_FD_ACT_INDEX), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_FD_START_DATE), intensity: results?.double(forColumn: SQLHelper.KEY_FD_INTENSITY), calorie: results?.double(forColumn: SQLHelper.KEY_FD_CALORIE), speed: results?.double(forColumn: SQLHelper.KEY_FD_SPEED), heartrate: results?.int(forColumn: SQLHelper.KEY_FD_HEARTRATE), step: results?.int(forColumn: SQLHelper.KEY_FD_STEP), swing: results?.int(forColumn: SQLHelper.KEY_FD_SWING), press_var: results?.double(forColumn: SQLHelper.KEY_FD_PRESS_VAR), coach_intensity: results?.double(forColumn: SQLHelper.KEY_FD_COACH_INTENSITY), upload: results?.int(forColumn: SQLHelper.KEY_FD_UPLOAD))
            }
            //print("getFeatureData label:\(String(describing: consume?.Label)) start time:\(String(describing: consume?.StartDate)) end time:)")
            
            results?.close()
        }
        //print("getFeatureData \(String(describing: consume?.StartDate))")
        return consume
    }
    
    
    
    func getFeatureData(Index index: Int32) -> FeatureData? {
        var consume: FeatureData? = nil;
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_FEATURE_DATA) WHERE \(SQLHelper.KEY_FD_INDEX)='\(index)'"
            let results:FMResultSet? = db!.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                //(index: Int32?, label: Int32?, actIndex: Int32?, start_date: Int64?, intensity: Double?, calorie: Double?, speed: Double?, heartrate: Int32?, step: Int32?, swing: Int32?, press_var: Double?, coach_intensity: Double?, upload:Int32?)
                consume = FeatureData(index: results?.int(forColumn: SQLHelper.KEY_FD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_FD_LABEL), actIndex: results?.int(forColumn: SQLHelper.KEY_FD_ACT_INDEX), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_FD_START_DATE), intensity: results?.double(forColumn: SQLHelper.KEY_FD_INTENSITY), calorie: results?.double(forColumn: SQLHelper.KEY_FD_CALORIE), speed: results?.double(forColumn: SQLHelper.KEY_FD_SPEED), heartrate: results?.int(forColumn: SQLHelper.KEY_FD_HEARTRATE), step: results?.int(forColumn: SQLHelper.KEY_FD_STEP), swing: results?.int(forColumn: SQLHelper.KEY_FD_SWING), press_var: results?.double(forColumn: SQLHelper.KEY_FD_PRESS_VAR), coach_intensity: results?.double(forColumn: SQLHelper.KEY_FD_COACH_INTENSITY), upload: results?.int(forColumn: SQLHelper.KEY_FD_UPLOAD))
            }
            results?.close()
        }
        //print("getFeatureData \(String(describing: consume?.StartDate))")
        return consume
    }
    func getFeatureDataNeedUpload() -> FeatureData? {
        var consume: FeatureData? = nil;
        
        contactDB?.inDatabase() {
            db in
            let querySQL = "SELECT * FROM \(SQLHelper.TABLE_FEATURE_DATA) WHERE \(SQLHelper.KEY_FD_UPLOAD)='\(SQLHelper.NONSET_UPLOAD)' ORDER BY \(SQLHelper.KEY_FD_START_DATE) ASC LIMIT 1"
            let results:FMResultSet? = db?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                consume = FeatureData(index: results?.int(forColumn: SQLHelper.KEY_FD_INDEX), label: results?.int(forColumn: SQLHelper.KEY_FD_LABEL), actIndex: results?.int(forColumn: SQLHelper.KEY_FD_ACT_INDEX), start_date: results?.longLongInt(forColumn: SQLHelper.KEY_FD_START_DATE), intensity: results?.double(forColumn: SQLHelper.KEY_FD_INTENSITY), calorie: results?.double(forColumn: SQLHelper.KEY_FD_CALORIE), speed: results?.double(forColumn: SQLHelper.KEY_FD_SPEED), heartrate: results?.int(forColumn: SQLHelper.KEY_FD_HEARTRATE), step: results?.int(forColumn: SQLHelper.KEY_FD_STEP), swing: results?.int(forColumn: SQLHelper.KEY_FD_SWING), press_var: results?.double(forColumn: SQLHelper.KEY_FD_PRESS_VAR), coach_intensity: results?.double(forColumn: SQLHelper.KEY_FD_COACH_INTENSITY), upload: results?.int(forColumn: SQLHelper.KEY_FD_UPLOAD))
            }
            results?.close()
        }
        print("getFeatureDataNeedUpload \(String(describing: consume?.StartDate))")
        return consume;
    }
    
    
    
    func deleteCoachActivityData(_ index: Int32) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_CA_INDEX)='\(index)'";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_COACH_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_CA_INDEX)='\(index)'";
        let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
        }else{
            ret = Int32(SQLHelper.SUCCESS);
        }*/
        print("deleteCoachActivityData ret suc: \(ret == 1)")
        return ret;
    }
    
    func deleteCoachActivityData() -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_COACH_ACTIVITY_DATA)";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_COACH_ACTIVITY_DATA)";
        let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
        }else{
            ret = Int32(SQLHelper.SUCCESS);
        }*/
        print("deleteCoachActivityData ret suc: \(ret == 1)")
        return ret;
    }
    
    func deleteActivityData(_ index: Int32) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_INDEX)='\(index)'";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_INDEX)='\(index)'";
        let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
        }else{
            ret = Int32(SQLHelper.SUCCESS);
        }*/
        print("deleteActivityData ret suc: \(ret == 1)")
        return ret;
    }
    
    func deleteActivityData() -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_ACTIVITY_DATA)";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_ACTIVITY_DATA)";
        let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
        
        if !result {
            print("[4] Error : \(contactDB!.lastErrorMessage())")
        }else{
            ret = Int32(SQLHelper.SUCCESS);
        }*/
        print("deleteActivityData ret suc: \(ret == 1)")
        return ret;
    }
    
    
    //규창 171025 피쳐데이터 삭제 명령
    //인덱스로 삭제
    func deleteFeatureData(_ index: Int32) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_FEATURE_DATA) WHERE \(SQLHelper.KEY_FD_INDEX)='\(index)'";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_INDEX)='\(index)'";
         let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
         
         if !result {
         print("[4] Error : \(contactDB!.lastErrorMessage())")
         }else{
         ret = Int32(SQLHelper.SUCCESS);
         }*/
        print("deleteFeatureData ret suc: \(ret == 1)")
        return ret;
    }
    
    //규창 171026 시간으로 검색해 삭제
    func deleteFeatureData(time: Int64) -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_FEATURE_DATA) WHERE \(SQLHelper.KEY_FD_START_DATE)='\(time)'";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_ACTIVITY_DATA) WHERE \(SQLHelper.KEY_AD_INDEX)='\(index)'";
         let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
         
         if !result {
         print("[4] Error : \(contactDB!.lastErrorMessage())")
         }else{
         ret = Int32(SQLHelper.SUCCESS);
         }*/
        print("deleteFeatureData ret suc: \(ret == 1)")
        return ret;
    }
    
    
    
    func deleteFeatureData() -> Int32 {
        var ret = Int32(SQLHelper.FAILED);
        
        contactDB?.inTransaction() {
            db, rollback in
            let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_FEATURE_DATA)";
            let result = db!.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            if !result {
                print("[4] Error : \(db!.lastErrorMessage())")
                rollback?.initialize(to: true)
            }else{
                ret = Int32(SQLHelper.SUCCESS);
            }
        }
        /*let deleteSQL = "DELETE FROM \(SQLHelper.TABLE_ACTIVITY_DATA)";
         let result = contactDB!.executeUpdate(deleteSQL, withArgumentsIn: nil)
         
         if !result {
         print("[4] Error : \(contactDB!.lastErrorMessage())")
         }else{
         ret = Int32(SQLHelper.SUCCESS);
         }*/
        print("deleteFeatureData ret suc: \(ret == 1)")
        return ret;
    }
    
    
    fileprivate func closeApplication() {
        //ActManager.getInstace(getContext()).closeApp();
        //BluetoothLEManager.getInstace(getContext()).closeApp();
//        thr?.cancel()
        closeApp();
    }
    
    func dispose() {
        closeApplication();
    }
}
