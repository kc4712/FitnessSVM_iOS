//
//  PLGraphDetailScreen.swift
//  CoachPlus
//
//  Created by 심규창 on 2017. 10. 26..
//  Copyright © 2017년 Company Green Comm. All rights reserved.
//

import Foundation

//
//  PLGraphDetail.swift
//  CoachPlus
//
//  Created by 심규창 on 2017. 10. 26..
//  Copyright © 2017년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import Charts
import MiddleWare

class PLGraphDetailScreen : BaseViewController, BaseProtocol, ChartViewDelegate, IAxisValueFormatter   {
    fileprivate let tag = String(describing: PLGraphDetailScreen.self)
    
    @IBOutlet var m_chart: BarChartView!
    @IBOutlet var m_pick_date: UIDatePicker!
    
    // 시간, 활동, 강도, 칼로리
    @IBOutlet weak var m_info_time: UILabel!
    @IBOutlet weak var m_info_action: UILabel!
    
    @IBOutlet weak var m_info_intencity: UILabel!
    @IBOutlet weak var m_info_calorie: UILabel!
    
    @IBOutlet weak var ButtonPriv: UIButton!
    @IBOutlet weak var ButtonNext: UIButton!
    
    @IBOutlet weak var ButtonSync: UIButton!
    @IBOutlet weak var ButtonDBDelete: UIButton!
    
    @IBOutlet weak var Remain:UILabel!
    
    var m_calendar = MWCalendar.getInstance();
    fileprivate var mc: MWControlCenter?
    let sql = SQLHelper.getInstance()
    
    
    fileprivate var list_action = [FeatureData?](repeating: nil, count: 144);
    fileprivate var table_Intensity = [String]();
    fileprivate var m_select = 0;
    
    fileprivate var remainFeatureNum:[Int] = []
    
    var strYear:String = ""
    var strMonth:String = ""
    var strDay:String = ""
    
    //규창 --- 최하단 stringForValue로 x-axis 캡션 넣기용 변수... 참고는 https://github.com/danielgindi/Charts/issues/1496
    var date: [String]!
    
    
    static let startnowDayTIME:String = " " + "00" + ":" + "00"
    static let startnowMonthDayTime:String = String(MWCalendar.getInstance().month) + "/" + String(MWCalendar.getInstance().day) + PLGraphDetailScreen.startnowDayTIME
    let nowDay:String = String(MWCalendar.getInstance().year) + "/" + PLGraphDetailScreen.startnowMonthDayTime
    var format = DateFormatter()
    var startnowDay:Date = Date()
    var unixstartnowDay:Int64 = 0
    
    
    
    
    override func viewDidLoad() {
        print("VC: 상세내역 그래프");
        super.viewDidLoad();
        mc = MWControlCenter.getInstance()
        mc?.setStateFeatureSync(state: true)
        format.dateFormat = "yyyy/MM/dd HH:mm"
        startnowDay = format.date(from: nowDay)!
        unixstartnowDay = Int64(startnowDay.timeIntervalSince1970) * 1000
        let test = Preference.getLong(Preference.KEY_REQ_FEATURE_SYNC_TIME)
        if (test > unixstartnowDay) {
            Preference.putLong(Preference.KEY_REQ_FEATURE_SYNC_TIME, value: unixstartnowDay)
        }
        MiddleWare.sendRequestState()
        Common.showNavigationBar(self);
        
        // 최대 선택 가능한 날짜를 오늘로
        m_pick_date.maximumDate = Date();
        
        table_Intensity = [String]();
        table_Intensity.append(NSLocalizedString("strength_unit_low", comment: ""));
        table_Intensity.append(NSLocalizedString("strength_unit_middle", comment: ""));
        table_Intensity.append(NSLocalizedString("strength_unit_high", comment: ""));
        
        setGraphAttribute();
        setGraphData();
        
        /*let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            self.updateFeature()
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        TabBarCenter.selecter = self
        //requestData();
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TabBarCenter.selecter = nil
        mc?.setStateFeatureSync(state: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func ButtonPrivClick(_ sender: UIButton) {
        if (m_select <= 0) {
            ButtonPriv.isEnabled = false;
            m_select = 0;
        }
        else {
            ButtonNext.isEnabled = true;
            m_select -= 1;
        }
        //규창...?
        //m_chart.highlightValue(xIndex: m_select, dataSetIndex: 0, callDelegate: true);
        m_chart.highlightValue(x: Double(m_select), dataSetIndex: 0, callDelegate: true)
    }
    
    @IBAction func ButtonNextClick(_ sender: AnyObject) {
        if (m_select >= 143) {
            ButtonNext.isEnabled = false;
            m_select = 143;
        }
        else {
            ButtonPriv.isEnabled = true;
            m_select += 1;
        }
        //규창...?
        //m_chart.highlightValue(xIndex: m_select, dataSetIndex: 0, callDelegate: true);
        m_chart.highlightValue(x: Double(m_select), dataSetIndex: 0, callDelegate: true)
    }
    
    @IBAction func ButtonSync(_ sender: UIButton) {
        Log.i(tag, msg:"동기화 시작")
        ButtonSync.isEnabled = false
        
        updateFeatureRemain()
    }
    
    
    @IBAction func ButtonDBDelete(_ sender: UIButton) {
        Log.i(tag, msg:"DB삭제")
        ButtonDBDelete.isEnabled = false
        let sql = SQLHelper.getInstance()
        sql?.deleteFeatureData()
        guard let feature3 = sql?.getFeatureData() else {
            setGraphData()
            return
        }
        for feat in feature3{
            Log.i(tag, msg: "내부 데이터 베이스에 기록된 데이터들 \(feat.ActIndex) \(feat.StartDate) \(feat.Index)")
        }
        setGraphData()
        ButtonDBDelete.isEnabled = true
        
    }
    
    
    func setGraphAttribute() {
        print("그래프 특성 설정");
        
        m_chart.delegate = self;
        m_chart.drawBarShadowEnabled = false;
        m_chart.drawBordersEnabled = true;
        m_chart.drawValueAboveBarEnabled = false;
        //m_chart.descriptionText = "";
        m_chart.chartDescription?.text = ""
        //규창...?
        //m_chart.maxVisibleValueCount = 60;
        m_chart.maxVisibleCount = 60;
        m_chart.drawGridBackgroundEnabled = false;
        m_chart.pinchZoomEnabled = false;
        m_chart.doubleTapToZoomEnabled = false;
        m_chart.setScaleEnabled(false);
        m_chart.scaleXEnabled = true;
        m_chart.drawMarkers = false;
        //m_chart.setHighlightEnabled(true);
        
        let xAxis = m_chart.xAxis;
        //규창...?
        /*xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom;
         xAxis.labelFont = UIFont.systemFontOfSize(11);
         xAxis.spaceBetweenLabels = 5;*/
        xAxis.labelPosition = .bottom;
        xAxis.labelFont = UIFont.systemFont(ofSize: 11);
        
        //줌인 줌아웃시 중복된 x축이 발생되지 않게함
        xAxis.granularityEnabled = true
        
        //규창 ---- Axis min과 max사이를 탐색하는데 0,1,2,3,4,5,6 이 날짜가 들은 인덱스.
        //이 범위를 벗어난 xAxis min, xAxis max 가 그래프의 빈공간으로 채워지게 ""스트링을 리턴
        xAxis.axisMinimum = 0
        //xAxis.labelCount = 4
        xAxis.axisMaximum = 144
        
        xAxis.drawAxisLineEnabled = false;
        xAxis.drawGridLinesEnabled = false;
        xAxis.gridLineWidth = 0.5;
        
        
        xAxis.valueFormatter = self
        
        
        
        
        
        
        let al = m_chart.leftAxis;
        al.drawGridLinesEnabled = true;
        al.drawAxisLineEnabled = true;
        //al.setInverted(true);
        //al.setEnabled(false);
        al.labelFont = UIFont.systemFont(ofSize: 11);
        let fom = NumberFormatter();
        fom.maximumFractionDigits = 0;
        fom.minimumIntegerDigits = 1;
        //fom.negativeSuffix = "";
        fom.positiveSuffix = "";
        //규창...?
        //al.valueFormatter = fom;
        al.valueFormatter = DefaultAxisValueFormatter(formatter: fom)
        al.labelPosition = .outsideChart;
        //al.startAtZeroEnabled = true;
        
        let ar = m_chart.rightAxis;
        //ar.setTextSize(12f);
        //ar.setDrawAxisLine(true);
        //ar.setDrawGridLines(true);
        ar.enabled = false;
        
        m_chart.legend.enabled = false;
    }
    
    @IBAction func ChangedDate() {
        let sel = m_pick_date.date;
        //m_calendar.date = sel;
        
        Log.i(tag, msg: "\(sel)")
        //requestData();
        setGraphDataChangeDatePicker(changeDate: sel)
        //setGraphData()
    }
    
    func requestData() {
        unSelect();
        let sql = SQLHelper.getInstance()
        list_action = (sql?.getFeatureData())!
        //WebQuery.Execut(QueryCode.GetActionBasicWorld, request: self, response: self);
    }
    
    func makeRequest(_ queryCode: QueryCode) -> String {
        var ret = WebQuery.SERVER_ADDR;
        ret += queryCode.rawValue;
        //sb.append(QueryCode.GetActionBasicWorld.name());
        ret += "?user=\(BaseViewController.User.Code!)";
        ret += "&year=\(m_calendar.year)";
        ret += "&month=\(m_calendar.month)";
        ret += "&day=\(m_calendar.day)";
        return ret;
    }
    
    func setGraphDataChangeDatePicker(changeDate: Date) {
        let sql = SQLHelper.getInstance()
        //list_action = (sql?.getFeatureData())!
        var list_value = [BarChartDataEntry]();
        var list_label = [String]();
        var list_color = [UIColor]();
        let startnowDayTIME:String = " " + "00" + ":" + "00"
        var calendar = Calendar.current
        //calendar.timeZone = TimeZone.current
        //calendar.timeZone = nCalendar.timeZone;
        
        list_action = [FeatureData?](repeating: nil, count: 144);
        let startnowMonthDayTime:String = String(calendar.component(.month, from: changeDate)) + "/" + String(calendar.component(.day, from: changeDate)) + startnowDayTIME
        let nowDay:String = String(calendar.component(.year, from: changeDate)) + "/" + startnowMonthDayTime
        strYear  = String(calendar.component(.year, from: changeDate))
        strMonth = String(calendar.component(.month, from: changeDate))
        strDay = String(calendar.component(.day, from: changeDate))
        
        let format = DateFormatter()
        //format.timeZone = TimeZone(identifier: "UTC")
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let startnowDay:Date = format.date(from: nowDay)!
        let unixstartnowDay:Int64 = Int64(startnowDay.timeIntervalSince1970) * 1000// + 32400000
        var i=0;
        var min10:Int64 = 0
        while (i<144) {
            if i == 0 {
                min10 = 0
            }
            else {
                min10 += 600000
            }
            list_action[i] = sql?.getFeatureData(unixstartnowDay+min10)
            let rec = list_action[i];
            let val: Double = (rec == nil ? 0 : rec!.Calorie);
            //if rec == nil {
            //    remainFeatureNum.append(i)
            //}
            //규창...?
            //let entry = BarChartDataEntry(value: val, xIndex: i);
            let entry = BarChartDataEntry(x: Double(i) , y: val)
            list_value.append(entry);
            //Log.i("PLGraphDetailScreen", msg: "i값????? \(i) \(unixstartnowDay+min10) \(rec?.Calorie)");
            
            let hour = (i + 1) / 6;
            let min = ((i + 1) % 6) * 10;
            let lab = String(format: "%02d:%02d", hour, min);
            list_label.append(lab);
            date = list_label
            
            // 액션에 따른 컬러 적용
            let aidx: Int = (rec == nil ? 0 : Int(rec!.ActIndex));
            let col: UIColor = getActionColor(aidx);
            list_color.append(col);
            
            i += 1;
        }
        
        //let set1 = BarChartDataSet(yVals: list_value, label: "DataSet");
        let set1 = BarChartDataSet(values: list_value, label: "DataSet")
        set1.setColors(list_color, alpha: 1);
        set1.drawValuesEnabled = false;
        set1.highlightEnabled = true;
        
        var dataSets = [BarChartDataSet]();
        dataSets.append(set1);
        
        //let data = BarChartData(xVals: list_label, dataSets: dataSets);
        let data = BarChartData(dataSets: dataSets)
        data.barWidth = 0.6
        //m_chart.fitBars = true
        //m_chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        m_chart.notifyDataSetChanged()
        m_chart.data = data;
        min10 = 0
        //let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        //DispatchQueue.main.asyncAfter(deadline: popTime){
        //    self.updateFeatureRemain()
        //}
        
    }
    
    
    
    func setGraphData() {
        list_action = [FeatureData?](repeating: nil, count: 144);
        let sql = SQLHelper.getInstance()
        //list_action = (sql?.getFeatureData())!
        var list_value = [BarChartDataEntry]();
        var list_label = [String]();
        var list_color = [UIColor]();
        let startnowDayTIME:String = " " + "00" + ":" + "00"
        let startnowMonthDayTime:String = String(MWCalendar.getInstance().month) + "/" + String(MWCalendar.getInstance().day) + startnowDayTIME
        let nowDay:String = String(MWCalendar.getInstance().year) + "/" + startnowMonthDayTime
        strYear  = String(MWCalendar.getInstance().year)
        strMonth = String(MWCalendar.getInstance().month)
        strDay = String(MWCalendar.getInstance().day)
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let startnowDay:Date = format.date(from: nowDay)!
        let unixstartnowDay:Int64 = Int64(startnowDay.timeIntervalSince1970) * 1000
        var i=0;
        var min10:Int64 = 0
        while (i<144) {
            if i == 0 {
                min10 = 0
            }
            else {
                min10 += 600000
            }
            list_action[i] = sql?.getFeatureData(unixstartnowDay+min10)
            let rec = list_action[i];
            let val: Double = (rec == nil ? 0 : rec!.Calorie);
            if rec == nil {
                remainFeatureNum.append(i)
            }
            //규창...?
            //let entry = BarChartDataEntry(value: val, xIndex: i);
            let entry = BarChartDataEntry(x: Double(i) , y: val)
            list_value.append(entry);
            //Log.i("PLGraphDetailScreen", msg: "i값????? \(i) \(unixstartnowDay+min10) \(rec?.Calorie)");
            
            let hour = (i + 1) / 6;
            let min = ((i + 1) % 6) * 10;
            let lab = String(format: "%02d:%02d", hour, min);
            list_label.append(lab);
            date = list_label
            
            // 액션에 따른 컬러 적용
            let aidx: Int = (rec == nil ? 0 : Int(rec!.ActIndex));
            let col: UIColor = getActionColor(aidx);
            list_color.append(col);
            
            i += 1;
        }
        
        //let set1 = BarChartDataSet(yVals: list_value, label: "DataSet");
        let set1 = BarChartDataSet(values: list_value, label: "DataSet")
        set1.setColors(list_color, alpha: 1);
        set1.drawValuesEnabled = false;
        set1.highlightEnabled = true;
        
        var dataSets = [BarChartDataSet]();
        dataSets.append(set1);
        
        //let data = BarChartData(xVals: list_label, dataSets: dataSets);
        let data = BarChartData(dataSets: dataSets)
        data.barWidth = 0.6
        //m_chart.fitBars = true
        //m_chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        m_chart.notifyDataSetChanged()
        m_chart.data = data;
        
        /*
        let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            self.updateFeatureRemain()
        }*/
    }
    
    
    
    func setGraphDataUpdate() {
        list_action = [FeatureData?](repeating: nil, count: 144);
        let sql = SQLHelper.getInstance()
        //list_action = (sql?.getFeatureData())!
        var list_value = [BarChartDataEntry]();
        var list_label = [String]();
        var list_color = [UIColor]();
        let startnowDayTIME:String = " " + "00" + ":" + "00"
        let startnowMonthDayTime:String = String(MWCalendar.getInstance().month) + "/" + String(MWCalendar.getInstance().day) + startnowDayTIME
        let nowDay:String = String(MWCalendar.getInstance().year) + "/" + startnowMonthDayTime
        strYear  = String(MWCalendar.getInstance().year)
        strMonth = String(MWCalendar.getInstance().month)
        strDay = String(MWCalendar.getInstance().day)
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let startnowDay:Date = format.date(from: nowDay)!
        let unixstartnowDay:Int64 = Int64(startnowDay.timeIntervalSince1970) * 1000
        var i=0;
        var min10:Int64 = 0
        while (i<144) {
            if i == 0 {
                min10 = 0
            }
            else {
                min10 += 600000
            }
            list_action[i] = sql?.getFeatureData(unixstartnowDay+min10)
            let rec = list_action[i];
            let val: Double = (rec == nil ? 0 : rec!.Calorie);
            //if rec == nil {
            //    remainFeatureNum.append(i)
            //}
            //규창...?
            //let entry = BarChartDataEntry(value: val, xIndex: i);
            let entry = BarChartDataEntry(x: Double(i) , y: val)
            list_value.append(entry);
            //Log.i("PLGraphDetailScreen", msg: "i값????? \(i) \(unixstartnowDay+min10) \(rec?.Calorie)");
            
            let hour = (i + 1) / 6;
            let min = ((i + 1) % 6) * 10;
            let lab = String(format: "%02d:%02d", hour, min);
            list_label.append(lab);
            date = list_label
            
            // 액션에 따른 컬러 적용
            let aidx: Int = (rec == nil ? 0 : Int(rec!.ActIndex));
            let col: UIColor = getActionColor(aidx);
            list_color.append(col);
            
            i += 1;
        }
        
        //let set1 = BarChartDataSet(yVals: list_value, label: "DataSet");
        let set1 = BarChartDataSet(values: list_value, label: "DataSet")
        set1.setColors(list_color, alpha: 1);
        set1.drawValuesEnabled = false;
        set1.highlightEnabled = true;
        
        var dataSets = [BarChartDataSet]();
        dataSets.append(set1);
        
        //let data = BarChartData(xVals: list_label, dataSets: dataSets);
        let data = BarChartData(dataSets: dataSets)
        data.barWidth = 0.6
        //m_chart.fitBars = true
        //m_chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        m_chart.notifyDataSetChanged()
        m_chart.data = data;
        
    }

    
    
    
    func displayHighlightInfo() {
        let hour = (m_select + 1) / 6;
        let min = ((m_select + 1) % 6) * 10;
        
        let dispTime = String(format: "%02d:%02d", hour, min);
        m_info_time.text = dispTime;
        let sql = SQLHelper.getInstance()
        //list_action = (sql?.getFeatureData())!
        let startnowDayTIME:String = " " + "00" + ":" + "00"
        let startnowMonthDayTime:String = strMonth + "/" + strDay + startnowDayTIME
        let nowDay:String = strYear + "/" + startnowMonthDayTime
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let startnowDay:Date = format.date(from: nowDay)!
        let unixstartnowDay:Int64 = Int64(startnowDay.timeIntervalSince1970) * 1000
        
        //Log.i("PLGraphDetailScreen", msg:"클릭 클릭 \(m_select)")
        let min10:Int64 = Int64(600000 * m_select)
        if let rec = sql?.getFeatureData(unixstartnowDay+min10) {
            let actName = Action.getActionName(Int(rec.ActIndex));
            m_info_action.text = actName;
            var inten = "";
            switch (Int(rec.Intensity)) {
            case Action.UNIT_HEARTRATE:
                inten = "\(rec.Heartrate) bpm";
            case Action.UNIT_SPEED:
                inten = "\(rec.Speed) " + Common.ResString("unit_speed");
            case Action.UNIT_STAIR:
                inten = "\(rec.Speed) " + Common.ResString("unit_stair");
            case Action.UNIT_SWING:
                inten = "\(rec.Speed) " + Common.ResString("unit_swing");
            case Action.UNIT_STRENGTH:
                let val = Int(rec.Speed);
                if (val >= 1 && val <= 3) {
                    inten = table_Intensity[val - 1];
                }
                else {
                    inten = "ER";
                }
            default:
                break;
            }
            m_info_intencity.text = inten;
            m_info_calorie.text = "\(Int(rec.Calorie)) kcal";
        }
        else {
            m_info_action.text = "";
            m_info_intencity.text = "";
            m_info_calorie.text = "";
        }
    }
    
    func unSelect() {
        //m_chart.highlightValue(xIndex: -1, dataSetIndex: 0, callDelegate: true);
        //규창...?;
        m_chart.highlightValue(x: Double(-1), dataSetIndex: 0, callDelegate: true)
        m_select = 0;
        m_info_time.text = "";
        m_info_action.text = "";
        m_info_intencity.text = "";
        m_info_calorie.text = "";
    }
    
    // 챠트 데이터 항목 선택 이벤트 처리
   // func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
    //규창 ChartViewDelegate Swift3에서 변경
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = Int(highlight.x)
        print("Selected chart index: \(index)");
        if (index >= 0 && index < 144) {
            m_select = index;
            displayHighlightInfo();
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
    }
    
    //func OnQueryFail(_ queryStatus: QueryStatus) {
    //}
    
    func run(_ notification: Notification) {
        print("\(className) ************************ \(notification.name)")
        switch notification.name.rawValue {
        
         case MWNotification.Bluetooth.FeatureDataComplete:
            let feature = mc!.FeatureData
            
            let data = FeatureData(index: 0, label: CourseLabel.feature.rawValue, actIndex: feature.actIndex, start_date: feature.start_date, intensity: feature.intensity, calorie: feature.calorie, speed: feature.speed, heartrate: feature.heartrate, step: feature.step, swing: feature.swing, press_var: feature.press_var, coach_intensity: feature.coach_intensity, upload: SQLHelper.NONSET_UPLOAD)
            //String.init(format: "%0.2f", input)
            let start_time = feature.start_date
            if start_time == 0{
                return
            }
            if start_time == sql?.getFeatureData(start_time)?.StartDate {
                Log.i(tag, msg: "이미 DB에 현재 시간 피쳐 기록됨")
            } else {
                Log.i(tag, msg: "DB기록")
                sql?.addConsume(data)
            }
        case MWNotification.Bluetooth.PastFeatureDataComplete:
            Log.i(tag, msg: "PastFeatureDataComplete")
            Log.i(tag, msg: "PastFeatureDataComplete")
            Log.i(tag, msg: "PastFeatureDataComplete")
            Log.i(tag, msg: "PastFeatureDataComplete")
            Log.i(tag, msg: "PastFeatureDataComplete")
            let feature = mc!.FeatureData
            
            let data = FeatureData(index: 0, label: CourseLabel.feature.rawValue, actIndex: feature.actIndex, start_date: feature.start_date, intensity: feature.intensity, calorie: feature.calorie, speed: feature.speed, heartrate: feature.heartrate, step: feature.step, swing: feature.swing, press_var: feature.press_var, coach_intensity: feature.coach_intensity, upload: SQLHelper.NONSET_UPLOAD)
            //String.init(format: "%0.2f", input)
            let start_time = feature.start_date
            if start_time == 0{
                return
            }
            if start_time == sql?.getFeatureData(start_time)?.StartDate {
                Log.i(tag, msg: "이미 DB에 현재 시간 피쳐 기록됨")
            } else {
                Log.i(tag, msg: "DB기록")
                let format = DateFormatter()
                format.dateFormat = "MM월dd일 HH시"
                let formatTime = Date(timeIntervalSince1970: TimeInterval(data.StartDate/1000))
                var timeString = format.string(from: formatTime as Date) + "동기화 중"
                Remain.text = timeString
                sql?.addConsume(data)
            }
            setGraphAttribute()
            setGraphDataUpdate()
        case MWNotification.Bluetooth.FeatureDataError:
            let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                let test = Preference.getLong(Preference.KEY_REQ_FEATURE_SYNC_TIME)
                Log.i(self.tag, msg: "????????? \(test)")
                MWControlCenter.getInstance().requestFeature(time: test)
                Preference.putLong(Preference.KEY_REQ_FEATURE_SYNC_TIME, value: test+600000)
            }
        case MWNotification.Bluetooth.PastFeatureDataALLComplete:
            Log.i(tag, msg: "PastFeatureDataALLComplete")
            Remain.text = "동기화 완료"
            ButtonSync.isEnabled = true
            
         default:
         break
         }
    }
    /*
    func parse(_ json: NSDictionary, queryCode: QueryCode) -> QueryStatus {
        Log.d(TAG, msg: "웹 쿼리 반환 값 파싱");
        Log.d(TAG, msg: "Query Result Json: \(json)");
        
        let result = json["Result"] as! Int?;
        
        if result == nil {
            return QueryStatus.ERROR_Result_Parse;
        }
        
        if result != 1 {
            return QueryStatus.Service_Error;
        }
        
        if let arr = json["Actions"] as! NSArray? {
            var i = 0;
            while (i < arr.count) {
                let item = arr[i];
                if String(describing: item) != "<null>" {
                    if let dic = item as? NSDictionary {
                        let rec = ActionRecord(json: dic);
                        list_action[i] = rec;
                    }
                }
                else {
                    list_action[i] = nil;
                }
                i += 1;
            }
        }
        return QueryStatus.Success;
    }
    
    func OnQuerySuccess(_ queryCode: QueryCode) {
        DispatchQueue.main.async(execute: {
            self.setGraphData();
        })
    }*/
    
    
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
    
    
    
    //규창 --- IAxisValueFormatter 델리게이트와 연동하여 포맷 변경하는 함수 참고는 https://github.com/danielgindi/Charts/issues/1496
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        //Log.i(tag, msg: "value \(value)")
        //Axis min과 max사이를 탐색하는데 0,1,2,3,4,5,6 이 날짜가 들은 인덱스.
        //이 범위를 벗어난 xAxis min, xAxis max 가 그래프의 빈공간으로 채워지게 ""스트링을 리턴
        let ArrayCount = value
        //if 0 > value{
         //   return ""
        //}
        //else if 6.0 < value {
        //    return ""
        //}else {
            return date[Int(ArrayCount) % date.count]
        //}
    }
    
    func updateFeature() {
        print("쓰레드 가동?")
        let sql = SQLHelper.getInstance()
        print("unixstartnowDay")
        if let feature2 = sql?.getFeatureData(unixstartnowDay) {
            let formatTime = Date(timeIntervalSince1970: TimeInterval((feature2.StartDate)/1000))
            
            let test = Preference.getLong(Preference.KEY_REQ_FEATURE_SYNC_TIME)
            Log.i(tag, msg: "쓰레드 가동? unixstartnowDay:\(unixstartnowDay)")
            print("unixstartnowDay 강도:\(feature2.Intensity), 속도:\(feature2.Speed), 스텝:\(feature2.Step), 심박:\(feature2.Heartrate), cal:\(feature2.Calorie) unixstartnowDay:\(unixstartnowDay) 시간:\(format.string(from: formatTime as Date))")
        } else {
            let test = Preference.getLong(Preference.KEY_REQ_FEATURE_SYNC_TIME)
            Log.i(tag, msg: "쓰레드 가동? test:\(test)")
            Preference.putLong(Preference.KEY_REQ_FEATURE_SYNC_TIME, value: test+600000)
            Log.i(tag, msg: "쓰레드 가동? test:\(test)")
            //unixstartnowDay = unixstartnowDay + 600000;
            MWControlCenter.getInstance().requestFeature(time: test)
        }
        let test = Preference.getLong(Preference.KEY_REQ_FEATURE_SYNC_TIME)
        if (test < MWCalendar.getInstance().getTimeInMillis()){
            let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime){
                self.updateFeature()
            }
        }else {
            Log.i(tag, msg: "업데이트 종료")
            setGraphData()
        }
    }
    func getDBPastFeature() -> Int64 {
        guard let feature3 = sql?.getFeatureData() else {
            return 0
        }
        if(feature3.first?.StartDate == nil) {
            return 0
        }else {
            return (feature3.first?.StartDate)!
        }
        
    }
        
    func updateFeatureRemain(){
        Log.i(tag, msg: "first \(remainFeatureNum.first), first \(remainFeatureNum.last)")
        //mc?.appendSender(<#T##data: BLSender##BLSender#>)
        //for arr in remainFeatureNum{
            //Log.i(tag, msg: "arr \(arr)")
            //list_action = [FeatureData?](repeating: nil, count: 144);
            //list_action = (sql?.getFeatureData())!
        let getLastDBTime = MWCalendar.getInstance().convert10MIN(time: getDBPastFeature())
        Log.i(tag, msg: "getLastDBTime \(getLastDBTime)");
            let startnowDayTIME:String = " " + "00" + ":" + "00"
            let startnowMonthDayTime:String = String(MWCalendar.getInstance().month) + "/" + String(MWCalendar.getInstance().day) + startnowDayTIME
            let nowDay:String = String(MWCalendar.getInstance().year) + "/" + startnowMonthDayTime
            let format = DateFormatter()
            format.timeZone = TimeZone.current
            format.dateFormat = "yyyy/MM/dd HH:mm"
            let startnowDay:Date = format.date(from: nowDay)!
            let unixstartnowDay:Int64 = Int64(startnowDay.timeIntervalSince1970) * 1000
            //var i=0;
            //var min10:Int64 = 0
        
        
        
            if remainFeatureNum[0] == 0{
                //mc?.sendpastFeatureReq(unixstartnowDay + Int64(remainFeatureNum[0]), MWCalendar.getInstance().convert10MIN(time: MWCalendar.currentTimeMillis()))
                mc?.sendpastFeatureReq(getLastDBTime, MWCalendar.getInstance().convert10MIN(time: MWCalendar.currentTimeMillis()))
            }else {
                mc?.sendpastFeatureReq(getLastDBTime, MWCalendar.getInstance().convert10MIN(time: MWCalendar.currentTimeMillis()))
                //mc?.sendpastFeatureReq(unixstartnowDay + Int64(remainFeatureNum[0]*600000), MWCalendar.getInstance().convert10MIN(time: MWCalendar.currentTimeMillis()))//Int64(remainFeatureNum[remainFeatureNum.last!]*600000))
            }
            //while (i<144) {
            /*if i == 0 {
                min10 = 0
            }
            else {
                min10 += 600000
            }
            if (unixstartnowDay + min10 > MWCalendar.getInstance().getTimeInMillis()){
                Log.i(tag, msg: "arr \(unixstartnowDay + min10) \(MWCalendar.getInstance().getTimeInMillis())")
                break
            }*/
            /*if arr == 0 {
                MWControlCenter.getInstance().requestFeature(time: unixstartnowDay)
                remainFeatureNum.removeFirst()
                let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: popTime){
                    self.updateFeatureRemain()
                }
                
                break
            } else {
                MWControlCenter.getInstance().requestFeature(time: unixstartnowDay + Int64(arr*600000))
                remainFeatureNum.removeFirst()
                let popTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: popTime){
                    self.updateFeatureRemain()
                }
                
                break
            }*/
            //}
            
        //}
    }
    
    
}
