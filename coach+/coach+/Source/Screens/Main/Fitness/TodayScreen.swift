//
//  TodayScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 27..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare
import Charts

class TodayScreen: BaseViewController, ChartViewDelegate, UITextFieldDelegate, BaseProtocol {
    fileprivate let TAG = String(describing: TodayScreen.self)
    
    @IBOutlet var m_today_calorie: UITextField!
    @IBOutlet var m_sum_calorie: UILabel!
    @IBOutlet var m_percent: UILabel!
    
    @IBOutlet var m_chart: PieChartView!
    
    fileprivate var m_today_calorie_number = 0
    fileprivate var m_percent_number = 0
    fileprivate var m_sum_calorie_number: Double = 0
    
    fileprivate let mc = MWControlCenter.getInstance()
    
    fileprivate let MET_MAN: Float = 1.5
    fileprivate let MET_WOMAN: Float = 1.4
    
    fileprivate var m_pie_data: (Activity: Double, Coach: Double, Sleep: Double, Daily: Double) = (0, 0, 0, 0)
    var PieData: (Activity: Double, Coach: Double, Sleep: Double, Daily: Double) {
        get {
            return m_pie_data
        }
        set {
            m_pie_data = newValue
        }
    }
    
    // 임시 데이터 세트
    fileprivate let xVals = [Common.ResString("graph_legend_activity"), Common.ResString("graph_legend_coach"), Common.ResString("graph_legend_sleep"), Common.ResString("graph_legend_daily")]
    /* */
    fileprivate var values: [Double] = []
    
    override func viewDidLoad() {
        setGraphAttribute()
        
        //m_today_calorie.text = String(Preference.TodayCalorie)
        //setViewer(Int(Preference.TodayCalorie), sum: PieData)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)
        m_chart.addGestureRecognizer(tapGesture2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cal = getTodayCalorie()
        m_today_calorie.text = String(cal)
        
        let main_calorie = (Double(Preference.MainCalorieActivity), Double(Preference.MainCalorieCoach), Double(Preference.MainCalorieSleep), Double(Preference.MainCalorieDaily))
        PieData = main_calorie
        //setPieData()
        setViewer(cal, sum: PieData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TabBarCenter.selecter = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TabBarCenter.selecter = nil
    }
    
    fileprivate func getTodayCalorie() -> Int {
        var pref_cal = Int(Preference.TodayCalorie)
        if pref_cal == 0 {
            var metabolic: Float = 0
            if BaseViewController.User.Gender == UserRecord.SEX_MAN {
                metabolic = CalculateBase.getConsumeCalorie(weight: BaseViewController.User.CurrentWeight, MET: MET_MAN)
            } else {
                metabolic = CalculateBase.getConsumeCalorie(weight: BaseViewController.User.CurrentWeight, MET: MET_WOMAN)
            }
            
            let daily = mc.getCalorieConsumeDaily(BaseViewController.User.CurrentWeight, goalWeight: BaseViewController.User.TargetWeight, dietPeriod: Int32(BaseViewController.User.DietPeriod))
            print("metabolic \(metabolic) daily \(daily)")
            pref_cal = Int(metabolic + daily)
        }
        
        return pref_cal
    }
    
    func run(_ notification: Notification) {
        print("\(className) ************************ \(notification.name)")
        switch notification.name.rawValue {
        case MWNotification.Bluetooth.StepCountNCalorie:
            let cal = getTodayCalorie()
            m_today_calorie.text = String(cal)
            
            setPieData()
            
            setViewer(cal, sum: PieData)
        default:
            break
        }
    }
    
    fileprivate func setPieData() {
        PieData = (mc.TotalActivityCalorie, mc.TotalCoachCalorie, mc.TotalSleepCalorie, mc.TotalDailyCalorie)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        setViewer(getTodayCalorie(textField), sum: PieData)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setViewer(getTodayCalorie(textField), sum: PieData)
    }
    
    fileprivate func setViewer(_ today: Int, sum: (Activity: Double, Coach: Double, Sleep: Double, Daily: Double)) {
        let sum_cal = sum.0 + sum.1 + sum.2 + sum.3
        
        if m_sum_calorie_number == sum_cal && m_today_calorie_number == today {
            return
        }
        
        Preference.TodayCalorie = Int32(today)
        m_today_calorie_number = today
        m_sum_calorie_number = sum_cal
        m_sum_calorie.text = String(Int(m_sum_calorie_number))
        // 데이터가 들어오면 달성도 계산 가능.
        var percent = Double(m_sum_calorie_number) / Double(m_today_calorie_number) * 100.0
        if percent.isInfinite || percent.isNaN{
            percent = 0
        }
        
        if percent > 100 {percent = 100.0}
        
        // 누적 갈로리가 변경되던가, 오늘의 목표가 변하면 텍스트뷰를 새로 그려야함.
        if m_percent_number != Int(percent) {
            m_percent_number = Int(percent)
            m_percent.text = String(m_percent_number)
        }
        
        values = getGraphData(sum)
        setGraphData()
    }
    
    fileprivate func getTodayCalorie(_ textField: UITextField) -> Int {
        var cal = 0
        if (textField.text != nil && textField.text!.isEmpty == false) {
            if let num = Int(textField.text!) {
                cal = num;
            }
        }
        
        return cal
    }
    
    @objc fileprivate func dismissKeyboard() {
        self.view.endEditing(true);
    }
    
    fileprivate func getGraphData(_ data: (Activity: Double, Coach: Double, Sleep: Double, Daily: Double)) -> [Double] {
//        let values = [10,20,30,20] // 임시로 이런 데이터가 들어왔다고 가정함. (분단위)
        
        // 5개 요소의 전체 사용 시간을 합산해서, 어느 정도의 비율을 차지하고 있는지 계산.
        // 1.활동, 2.코치, 3.수면, 4.일상
        let sum_cal = data.0 + data.1 + data.2 + data.3
//        var sum = 0.0
//        for val in values {
//            sum += Double(val)
//        }
//        
//        var ret: [Double] = []
//        for val in values {
//            ret.append(Double(val) / sum * 100)
//        }
        let dat1 = data.0 / sum_cal * 100
        let dat2 = data.1 / sum_cal * 100
        let dat3 = data.2 / sum_cal * 100
        let dat4 = data.3 / sum_cal * 100
        
        return [dat1, dat2, dat3, dat4]
    }
    

    fileprivate func setGraphAttribute() {
        print("그래프 특성 설정");
        
        m_chart.delegate = self;
        m_chart.drawHoleEnabled = true
        m_chart.chartDescription?.text = "";
        m_chart.maxAngle = 360
        m_chart.drawMarkers = false
        m_chart.usePercentValuesEnabled = true
        m_chart.drawSlicesUnderHoleEnabled = false
        m_chart.holeRadiusPercent = 0.58
        m_chart.transparentCircleRadiusPercent = 0.61
        m_chart.extraLeftOffset = 5
        m_chart.extraTopOffset = 10
        m_chart.extraRightOffset = 5
        m_chart.extraBottomOffset = 5
        m_chart.rotationAngle = 0
        m_chart.rotationEnabled = false
        m_chart.highlightPerTapEnabled = true
        m_chart.drawEntryLabelsEnabled = false
        
        let legend = m_chart.legend;
        legend.horizontalAlignment = Legend.HorizontalAlignment.center
        legend.verticalAlignment = Legend.VerticalAlignment.bottom
        legend.font = NSUIFont.systemFont(ofSize: 13)
//        legend.enabled = false;
    }
    
    func setGraphData() {
        //규창  --- BarChartDataEntry에서 PieChartDataEntry로 변경
        //var list_value1 = [BarChartDataEntry]();
        var list_value1 = [PieChartDataEntry]();
        
        for i in 0..<values.count {
            //list_value1.append(BarChartDataEntry(x:Double(i) , y:values[i] ));
            list_value1.append(PieChartDataEntry(value: values[i], label: xVals[i]));
            
        }
        
        
        let set1 = PieChartDataSet(values: list_value1, label: nil);
        
//        let col1 = Common.makeColor(0xb5, 0x8a, 0xbd) // 걸음
        let col2 = Common.makeColor(0xb6, 0xd8, 0x8e) // 활동
        let col3 = Common.makeColor(0x59, 0xbf, 0xc4) // 코치 운동
        let col4 = Common.makeColor(0xf5, 0xe5, 0x84) // 수면
        let col5 = Common.makeColor(0xe7, 0x60, 0x66) // 일상 생활
        
//        set1.colors = [col1, col2, col3, col4, col5]
        set1.colors = [col2, col3, col4, col5]
        set1.drawValuesEnabled = false;
        set1.highlightEnabled = true;
        set1.sliceSpace = 2.0
        var dataSets = [PieChartDataSet]();
        dataSets.append(set1);
        let data = PieChartData(dataSets: dataSets);
        m_chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        m_chart.notifyDataSetChanged()
        m_chart.data = data;
    }

    // 챠트 데이터 항목 선택 이벤트 처리
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
//        let index = highlight.xIndex;
//        let fmt = NSDateFormatter()
//        fmt.dateStyle = .LongStyle
//        let date = fmt.stringFromDate(Common.addingDay(NSDate(), add_day: index-6))
//        m_selected_date.text = date
//        m_selected_step.text = String(format: "%d %@", values_step_count[index], "걸음")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //m_info.text = "";
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
}
