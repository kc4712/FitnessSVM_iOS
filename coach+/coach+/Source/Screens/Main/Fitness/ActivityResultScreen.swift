//
//  ActivityResultScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 28..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import Charts
import MiddleWare

class ActivityResultScreen: UITableViewController {
    @IBOutlet var m_calorie: UILabel!
    @IBOutlet var m_activity_date: UILabel!
    @IBOutlet var m_activity_time: UILabel!
    
    @IBOutlet var m_warnningView: UITableViewCell!
    @IBOutlet var m_HRmax: UILabel!
    @IBOutlet var m_HRmin: UILabel!
    @IBOutlet var m_HRavg: UILabel!
    // 약, 중, 강, 위험 구간  색깔 받아야함.
    // 이미 만들어져있는 그래프를 넣을 부모뷰 라고 가정.
    @IBOutlet var m_graphView: UIStackView!
    
    @IBOutlet var m_width_1: NSLayoutConstraint!
    @IBOutlet var m_width_2: NSLayoutConstraint!
    @IBOutlet var m_width_3: NSLayoutConstraint!
    @IBOutlet var m_width_4: NSLayoutConstraint!
    
    fileprivate let html_name_question = Common.ResString("html_workout_measure")
    
    var m_Index: Int32 = 0
    var m_start_date: Int64 = 0
    fileprivate var values: [CGFloat] = [1,2,3,4]
    
    @IBAction func m_btn_question(_ sender: UIButton) {
        performSegue(withIdentifier: "SG_Setting_WebView", sender: html_name_question)
    }
    
    override func viewDidLoad() {
        setGraphData()
    }
    
    fileprivate func setGraphData() {
        //m_warnningView.isHidden = true
        m_graphView.axis = UILayoutConstraintAxis.horizontal
        let totalWidth = CGFloat(m_graphView.frame.width)
        
        var datas: ActivityData?
        if m_start_date != 0 {
            datas = getActivityDataFromSQL(m_start_date)
            m_start_date = 0
        } else if m_Index != 0 {
            datas = getActivityDataFromSQL(Index: m_Index)
            m_Index = 0
        } else {
            return
        }
        
        print("datas :: \(String(describing: datas?.StartDate)), \(String(describing: datas?.EndDate))")
//        var datas: ActivityData?
//        datas = ActivityData()
//        datas?.IntensityL = 10
//        datas?.IntensityM = 20
//        datas?.IntensityH = 15
//        datas?.IntensityD = 50
//        datas?.StartDate = 1470991000000
//        datas?.EndDate = 1470991656000
//        datas?.MaxHR = 120
//        datas?.AvgHR = 80
//        datas?.MinHR = 60
        
        if datas == nil {
            m_width_1.constant = 0
            m_width_2.constant = 0
            m_width_3.constant = 0
            m_width_4.constant = 0
            
            return
        }
        
        let inten_datas = [datas?.IntensityL, datas?.IntensityM, datas?.IntensityH, datas?.IntensityD]
        print(inten_datas)
        
        var sum: CGFloat = 0.0
        for val in inten_datas {
            sum += CGFloat(val!)
        }

        for i in 0..<inten_datas.count {
            values[i] = totalWidth * CGFloat(inten_datas[i]!) / sum
            if values[i].isInfinite || values[i].isNaN {
               values[i] = 0
            }
        }
        
        m_width_1.constant = values[0]
        m_width_2.constant = values[1]
        m_width_3.constant = values[2]
        m_width_4.constant = values[3]
        
//        if (values[3] / totalWidth * 100) > 20 {
//            m_warnningView.isHidden = false
//        }
        
        m_calorie.text = String(Int(datas!.Calorie))
        
        let start_date = datas?.StartDate
        let end_date = datas?.EndDate
        let dateString = getDateString(start_date!)
        
        let start_TimeString = getTimeString(start_date!)
        let end_TimeString = getTimeString(end_date!)
        
        m_activity_date.text = dateString
        m_activity_time.text = String(format: "%@ ~ %@", start_TimeString, end_TimeString)
        
        m_HRmax.text = String(datas!.MaxHR)
        m_HRmin.text = String(datas!.MinHR)
        m_HRavg.text = String(datas!.AvgHR)
    }
    
    fileprivate func getDateString(_ date: Int64) -> String {
        let millisec = date
        let date = Date(timeIntervalSince1970: TimeInterval(millisec/1000));
        
        let fmt = DateFormatter()
        fmt.dateStyle = .long
        let str = fmt.string(from: date)
        
        return str
    }
    
    fileprivate func getTimeString(_ date: Int64) -> String {
        let millisec = date
        let date = Date(timeIntervalSince1970: TimeInterval(millisec/1000));
        
        let fmt = DateFormatter()
        var str = ""
        
        fmt.dateStyle = .none
        fmt.dateFormat = "HH:mm"
        str += fmt.string(from: date)
        
        return str
    }
    
    fileprivate func getActivityDataFromSQL(Index index: Int32) -> ActivityData? {
        let sql = SQLHelper.getInstance()
        
        return sql?.getActivityData(Index: index)
    }
    
    fileprivate func getActivityDataFromSQL(_ start_date: Int64) -> ActivityData? {
        let sql = SQLHelper.getInstance()
        
        return sql?.getActivityData(start_date)
    }
    
    fileprivate func getActivityIntensity() -> [Double] {
        // SQL 에서 가져온 데이터.
        return [1, 2, 3, 4]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SG_Setting_WebView" {
            if let dest = segue.destination as? SettingWebViewScreen {
                if let name = sender as? String {
                    dest.m_name = name
                }
            }
        }
    }
}
