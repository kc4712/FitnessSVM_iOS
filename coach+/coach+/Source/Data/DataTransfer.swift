//
//  DataTransfer.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 9..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class DataTransfer
{
    fileprivate static let TAG = String(describing: DataTransfer.self)
    
    fileprivate var coach_Data: CoachActivityData?
    fileprivate var activity_Data: ActivityData?
    
    fileprivate var m_thread: Thread?
    
    fileprivate var more_than_one_ExerData = false
    fileprivate var finish = false
    fileprivate var continues = false
    
    init() {
        m_thread = Thread(target: self, selector: #selector(run), object: nil)
    }
    
    func start() {
        m_thread?.start()
    }
    
    func cancel() {
        m_thread?.cancel()
        finish = true
        continues = false
    }
    
    @objc fileprivate func run() {
        repeat {
            Log.d(DataTransfer.TAG, msg: "Data Upload...")
            finish = checkData()
            if finish {
                Log.d(DataTransfer.TAG, msg: "no data. cancel.")
                if more_than_one_ExerData {
                    BaseViewController.getTodayData()
                }
                
                Thread.current.cancel()
                break
            }
            
            execUpload()
            
            while !continues {
                Thread.sleep(forTimeInterval: 1)
            }
            // 1초 마다 한번씩 완료 체크를 해서 총 10초 기다린뒤, 완료되지 않으면 그냥 쓰레드 종료
        } while !Thread.current.isCancelled
        Log.d(DataTransfer.TAG, msg: "exit upload..")
    }
    
    fileprivate func checkData() -> Bool {
        let sql = SQLHelper.getInstance()
        
        var flag = false
        
        if let data = sql?.getCoachActivityDataNeedUpload() {
            coach_Data = data
            flag = true
        }
        
        if let data = sql?.getActivityDataNeedUpload() {
            activity_Data = data
            flag = true
        }
        
        if flag {
            return false
        }
        
        return true
    }
    
    fileprivate func execUpload() {
        if let activity_Data = activity_Data {
            continues = false
            
            let parser = ExerciseInfo()
            parser.setActivityInfo(activity_Data)
            parser.setSuccess(success)
            parser.setFail(fail)
            
            let query = WebQuery(queryCode: .InsertFitness, request: parser, response: parser)
            query.start()
        }
        
        if let coach_Data = coach_Data {
            continues = false
            
            let parser = ExerciseInfo()
            parser.setExerciseInfo(coach_Data)
            parser.setSuccess(success)
            parser.setFail(fail)
            
            let query = WebQuery(queryCode: .InsertExercise, request: parser, response: parser)
            query.start()
        }
    }
    
    func success(_ queryCode: QueryCode) {
        Log.d(DataTransfer.TAG, msg: "datatransfer success..")
        let sql = SQLHelper.getInstance()
        
        if queryCode == .InsertExercise {
            coach_Data = nil
            more_than_one_ExerData = true
        } else if queryCode == .InsertFitness {
            _ = sql?.updateConsume(activity_Data!, flag: SQLHelper.SET_UPLOAD)
            activity_Data = nil
        }
        
        continues = true
    }
    
    func fail(_ queryStatus: QueryStatus) {
        Log.d(DataTransfer.TAG, msg: "datatransfer fail.. \(queryStatus)")
        if queryStatus == .ERROR_Web_Read {
            cancel()
            return
        }
        continues = true
    }
}
