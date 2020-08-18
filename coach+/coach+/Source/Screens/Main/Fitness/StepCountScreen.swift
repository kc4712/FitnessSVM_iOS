//
//  StepCountScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 27..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import Charts
import MiddleWare

class StepCountScreen: BaseViewController, ChartViewDelegate, BaseProtocol, IAxisValueFormatter {
    fileprivate let TAG = String(describing: StepCountScreen.self)
    
    //규창 170125 폰 별 사이즈 최적화 추가
    @IBOutlet weak var m_scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var m_scrollView: UIScrollView!
    @IBOutlet weak var m_scrollWidth: NSLayoutConstraint!
    
    @IBOutlet var m_descriptionTxt: UILabel!
    @IBOutlet var m_StepCountTxt: UILabel!
    @IBOutlet var m_RemainTxt: UILabel!
    //규창 17.01.18 기대소모칼로리 라벨연결
    @IBOutlet var m_RemainCalTxt: UILabel!
    
    @IBOutlet var m_selected_date: UILabel!
    @IBOutlet var m_selected_step: UILabel!
    
    fileprivate var m_datas = StepInfo()
    
    @IBOutlet var m_chart: BarChartView!
    
    //규창 --- 최하단 stringForValue로 x-axis 캡션 넣기용 변수... 참고는 https://github.com/danielgindi/Charts/issues/1496
    var date: [String]!
    
    fileprivate let mc: MWControlCenter = MWControlCenter.getInstance()
    
//    private var values_step_count = [Int](count: 7, repeatedValue: 0);
//    private var values_step_count = [100,200,300,100,200,300,400];
    
    fileprivate let Reference_Step = 10000
    
    fileprivate var m_current_Step: Int = 0
    fileprivate var m_current_StepViewTxt: String = "0"
    fileprivate var Current_Step: String {
        get {
            return m_current_StepViewTxt
        }
        set {
            if let current = Int(newValue) {
                m_current_Step = current
                if current > Reference_Step {
                    m_current_StepViewTxt = String(format: "+ %d", current - Reference_Step)
                    m_RemainTxt.isHidden = true
                } else {
                    m_current_StepViewTxt = String(abs(Reference_Step - current))
                    m_RemainTxt.isHidden = false
                }
                m_StepCountTxt.text = m_current_StepViewTxt
            }
        }
    }
    
    
    //규창 17.01.18 기대소모칼로리 프로퍼티 추가
    fileprivate var m_current_Step_to_Cal: Int = 0
    fileprivate var m_current_Step_to_CalViewTxt: String = "0"
    fileprivate var Current_Step_to_Cal: String {
        get {
            return m_current_Step_to_CalViewTxt
        }
        set {
            if let current = Int(newValue) {
                m_current_Step_to_Cal = current
                //규창 17.01.18 기대소모칼로리 추가
                if current > Reference_Step {
                    m_current_Step_to_CalViewTxt = calculateCal(step:current - Reference_Step)
                    m_RemainCalTxt.isHidden = true
                } else {
                    m_current_Step_to_CalViewTxt = calculateCal(step:abs(Reference_Step - current))
                    m_RemainCalTxt.isHidden = false
                }
                m_RemainCalTxt.text = m_current_Step_to_CalViewTxt
            }
        }
    }
    
    //규창 17.01.18 기대소모칼로리 계산 메서드 추가
    func calculateCal(step:Int) -> String {
        let result = Int(2.0 * Preference.getWeight() * Float(step/83) * 0.0175)
        return String(format: "%d", result)
    }
    
    
    fileprivate var m_descTxt: String = ""
    fileprivate var DescTxt: String {
        get {
            return m_descTxt
        }
        set {
            if m_current_Step >= Reference_Step {
                m_descTxt = Common.ResString("Step_Complete")
                m_descriptionTxt.textColor = Common.makeColor(224, 108, 44) // 댤성완료 크기 30
                m_descriptionTxt.font = UIFont.systemFont(ofSize: 30)
            } else {
                var comment = ""
                switch m_current_Step {
                case 0...2000:
                    switch Common.nextInt(5) {
                    case 0:
                        comment = Common.ResString("Step_0_2000_1")
                    case 1:
                        comment = Common.ResString("Step_0_2000_2")
                    case 2:
                        comment = Common.ResString("Step_0_2000_3")
                    case 3:
                        comment = Common.ResString("Step_0_2000_4")
                    case 4:
                        comment = getCommonComment()
                    default:
                        break
                    }
                case 2001...3000:
                    switch Common.nextInt(3) {
                    case 0:
                        comment = Common.ResString("Step_2001_3000_1")
                    case 1:
                        comment = Common.ResString("Step_2001_3000_2")
                    case 2:
                        comment = getCommonComment()
                    default:
                        break
                    }
                case 3001...5000:
                    comment = Common.ResString("Step_3001_5000_1")
                case 5001...7000:
                    comment = Common.ResString("Step_5001_7000_1")
                case 7001...8000:
                    comment = Common.ResString("Step_7001_8000_1")
                case 8001...9000:
                    comment = Common.ResString("Step_8001_9000_1")
                case 9001...9999:
                    switch Common.nextInt(4) {
                    case 0:
                        comment = Common.ResString("Step_9001_9999_1")
                    case 1:
                        comment = Common.ResString("Step_9001_9999_2")
                    case 2:
                        comment = Common.ResString("Step_9001_9999_3")
                    case 3:
                        comment = getCommonComment()
                    default:
                        break
                    }
                default:
                    break
                }
                m_descTxt = comment
                m_descriptionTxt.textColor = UIColor.black
                m_descriptionTxt.font = UIFont.systemFont(ofSize: 12)
            }
            
            m_descriptionTxt.text = m_descTxt
        }
    }
    
    func getCommonComment() -> String {
        var comment = ""
        switch Common.nextInt(4) {
        case 0:
            comment = Common.ResString("Step_Extra_1")
        case 1:
            comment = Common.ResString("Step_Extra_2")
        case 2:
            comment = Common.ResString("Step_Extra_3")
        case 3:
            comment = Common.ResString("Step_Extra_4")
        default:
            break
        }
        
        return comment
    }
    
    override func viewDidLoad() {
        m_datas.setSuccess(success)
        m_datas.setFail(fail)
        
        let query = WebQuery(queryCode: .ListStep, request: m_datas, response: m_datas)
        query.start()
        
        initValue();
        setGraphAttribute();
        setGraphData();
        
        //규창 170125 폰 별 사이즈 최적화 추가
        setDeviceWidth()
        
        TabBarCenter.selecter = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TabBarCenter.selecter = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TabBarCenter.selecter = nil
    }
    
    fileprivate func initValue() {
        setValue(Int16(Preference.MainStep))
        m_selected_date.text = ""
        m_selected_step.text = ""
        //m_RemainCalTxt.text = ""
    }
    
    //규창 170125 폰 별 사이즈 최적화 추가
    private func setDeviceWidth() {
        let rect = UIScreen.main.bounds;
        m_scrollWidth.constant = rect.size.width;
        print("Set Screen Width: \(rect.size.width)");
    }
    
    
    //규창 170125 걸음수 페이지 내 UI아이템 들의 높이 관련한 문제 발생하면 수정
    private func setContentHeight() {
        /*let m_frame = m_comment.frame;
        let m_org_height = m_frame.size.height;
        print("Comment Old Size: \(m_frame.size.width), \(m_frame.size.height)");
        
        let m_fit_size = m_comment.sizeThatFits(CGSize.zero);
        
        let m_inc_height = m_fit_size.height - m_org_height;
        print("Calc Inc Value: \(m_inc_height)");
        
        let m_new_height = m_scrollHeight.constant + m_inc_height;
        
        m_scrollHeight.constant = m_new_height;
        print("Set Comment Height: \(m_new_height)");
        
        m_comment.scrollView.isScrollEnabled = false;
        m_comment.scrollView.bounces = false;*/
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        setContentHeight();
    }
    
    
    fileprivate func setValue(_ step: Int16) {
        Current_Step = String(step)
        Current_Step_to_Cal = String(step)
        DescTxt = "" // 셋만 해주면 자동으로 프로퍼티가 등록됨.
    }
    
    func run(_ notification: Notification) {
        print("\(className) ************************ \(notification.name)")
        switch notification.name.rawValue {
        case MWNotification.Bluetooth.StepCountNCalorie:
            let step = mc.Step
            
            /*if Int32(step) == Preference.MainStep {
                return
            }
            
            let current = Int64((Date().timeIntervalSince1970 * 1000))
            
            m_datas.Reg = current
            m_datas.Step = Int32(step)
            Log.i(TAG, msg: "current\(current) // Int32(step)\(Int32(step))");
            let query2 = WebQuery(queryCode: .InsertStep, request: m_datas, response: m_datas)
            query2.start()*/
            
            setValue(step)
        default:
            break
        }
    }
    
    fileprivate func setGraphAttribute() {
        print("그래프 특성 설정");
        
        m_chart.delegate = self;
        m_chart.drawBarShadowEnabled = false;
        m_chart.drawBordersEnabled = true;
        m_chart.drawValueAboveBarEnabled = false;
        m_chart.chartDescription?.text = "";
        m_chart.maxVisibleCount = 60;
        m_chart.drawGridBackgroundEnabled = false;
        m_chart.pinchZoomEnabled = false;
        m_chart.doubleTapToZoomEnabled = false;
        m_chart.setScaleEnabled(false);
        m_chart.scaleXEnabled = true;
        m_chart.drawMarkers = false;
        
        //m_chart.setHighlightEnabled(true);
        
        //규창 --- xAxis, yAxis label사라지는 문제로 최대 줌 제한. 참고 https://github.com/danielgindi/Charts/issues/1564
        m_chart.viewPortHandler.setMaximumScaleX(2.5)
        
        let xAxis = m_chart.xAxis;
        xAxis.labelPosition = XAxis.LabelPosition.bottom;
        xAxis.drawLabelsEnabled = false
        xAxis.labelFont = UIFont.systemFont(ofSize: 11);
        
        //규창  --- 그래프 줌인시 라벨 위치잡는 테스트코드들
        //xAxis.spaceBetweenLabels = 5;
        //granularity Default 1.0
        //xAxis.granularity = 1.01;
        
        //줌인 줌아웃시 중복된 x축이 발생되지 않게함
        xAxis.granularityEnabled = true
        
        //규창 ---- Axis min과 max사이를 탐색하는데 0,1,2,3,4,5,6 이 날짜가 들은 인덱스.
        //이 범위를 벗어난 xAxis min, xAxis max 가 그래프의 빈공간으로 채워지게 ""스트링을 리턴
        xAxis.axisMinimum = -0.5
        xAxis.labelCount = 4
        xAxis.axisMaximum = 6.7
        

        xAxis.drawAxisLineEnabled = false;
        xAxis.drawGridLinesEnabled = false;
        xAxis.gridLineWidth = 0.5;
        
        ////IAxisValueFormatter 델리게이트 이용 https://github.com/danielgindi/Charts/issues/1496
        xAxis.valueFormatter = self
        
        let fom = NumberFormatter();
        fom.numberStyle = .decimal
        fom.maximumFractionDigits = 0;
        fom.minimumIntegerDigits = 1;
        //fom.negativeSuffix = "";
        //fom.positiveSuffix = BaseViewController.SelectGraph.Unit;
        
        let al = m_chart.leftAxis;
        al.drawGridLinesEnabled = true;
        al.drawAxisLineEnabled = true;
        //al.setInverted(true);
        //al.setEnabled(false);
        al.labelFont = UIFont.systemFont(ofSize: 11);
        al.valueFormatter = DefaultAxisValueFormatter(formatter: fom)
        al.labelPosition = YAxis.LabelPosition.outsideChart;
        al.axisMinimum = 0
        
        let ar = m_chart.rightAxis;
        //ar.setTextSize(12f);
        //ar.setDrawAxisLine(true);
        //ar.setDrawGridLines(true);
        ar.enabled = false;
        
        let legend = m_chart.legend;
        legend.horizontalAlignment = Legend.HorizontalAlignment.right
        legend.verticalAlignment = Legend.VerticalAlignment.top
        legend.enabled = false;
    }
    
    func setGraphData() {
        var list_value1 = [BarChartDataEntry]();
        var list_label = [String]();
        
        let fmt = DateFormatter()
        fmt.dateFormat = "MM/d"
        
        let datas = m_datas.StepArray
        
        for i in 0..<datas.count {
            list_value1.append(BarChartDataEntry(x: Double(i), y: Double(datas[i])));
            let date = fmt.string(from: Common.addingDay(Date(), add_day: i-6))
            list_label.append(date);
        }
        
        let set1 = BarChartDataSet(values: list_value1, label: Common.ResString("week_last"));
        set1.setColor(Graph_Color_Step, alpha: 1);
        set1.drawValuesEnabled = false;
        set1.highlightEnabled = true;
        //        let set2 = BarChartDataSet(yVals: list_value2, label: Common.ResString("week_this"));
        //        set2.setColor(Common.makeColor(0x71, 0x95, 0x01), alpha: 1);
        //        set2.drawValuesEnabled = false;
        //        set2.highlightEnabled = true;
        
        var dataSets = [BarChartDataSet]();
        dataSets.append(set1);
        //        dataSets.append(set2);
        
        //규창 위쪽 for문에서 설정한 list_label을 date에 넣어 xaxis를 날짜로 교체..
        date = list_label
        
        let data = BarChartData(dataSets: dataSets);
        data.barWidth = 0.6
        //m_chart.fitBars = true
        m_chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        m_chart.notifyDataSetChanged()
        m_chart.data = data;
        
    }
    
    // 챠트 데이터 항목 선택 이벤트 처리
    

    //규창 ChartViewDelegate Swift3에서 변경
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = highlight.x;
        let fmt = DateFormatter()
        fmt.dateStyle = .long
        let date = fmt.string(from: Common.addingDay(Date(), add_day: Int(index) - 6))
        m_selected_date.text = date
        m_selected_step.text = String(format: "%d %@", m_datas.StepArray[Int(index)], Common.ResString("graph_bottom_step"))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //m_info.text = "";
    }
    
    func success(_ queryCode: QueryCode) {
        DispatchQueue.main.async(execute: {
            self.setGraphData();
        })
    }
    
    func fail() {
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
    
    
    //규창 --- IAxisValueFormatter 델리게이트와 연동하여 포맷 변경하는 함수 참고는 https://github.com/danielgindi/Charts/issues/1496
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        //Log.i(TAG, msg: "value \(value)")
        //Axis min과 max사이를 탐색하는데 0,1,2,3,4,5,6 이 날짜가 들은 인덱스.
        //이 범위를 벗어난 xAxis min, xAxis max 가 그래프의 빈공간으로 채워지게 ""스트링을 리턴
        let ArrayCount = value
        if 0 > value{
            return ""
        }
        else if 6.0 < value {
            return ""
        }else {
            return date[Int(ArrayCount) % date.count]
        }
    }
}
