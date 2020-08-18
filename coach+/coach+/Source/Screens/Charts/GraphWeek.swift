//
//  GraphStep.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 16..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare;
import Charts;

class GraphWeek: BaseViewController, ChartViewDelegate, IAxisValueFormatter, UIWebViewDelegate
{
    fileprivate let TAG = String(describing: GraphWeek.self)
    
    @IBOutlet weak var m_scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var m_scrollView: UIScrollView!
    @IBOutlet weak var m_scrollWidth: NSLayoutConstraint!

    @IBOutlet var m_comment: UIWebView!
    @IBOutlet var m_chart: BarChartView!
    
    fileprivate var m_datas = GraphData()
    
    //규창 --- 최하단 stringForValue()로 x-axis 캡션 넣기용 변수... 참고는 https://github.com/danielgindi/Charts/issues/1496
    var date = [String]()
    
    override func viewDidLoad() {
        print("Load: 그래프 Week");
        super.viewDidLoad();
        
        title = BaseViewController.SelectGraph.titleName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        navigationItem.rightBarButtonItem?.title = Common.ResString("next_year_chart")
        
        setHtml();
        setGraphAttribute();
        setGraphData();
        
        setDeviceWidth()
    }
    
    private func setDeviceWidth() {
        let rect = UIScreen.main.bounds;
        m_scrollWidth.constant = rect.size.width;
        print("Set Screen Width: \(rect.size.width)");
    }
    
    private func setContentHeight() {
        let m_frame = m_comment.frame;
        let m_org_height = m_frame.size.height;
        print("Comment Old Size: \(m_frame.size.width), \(m_frame.size.height)");
        
        let m_fit_size = m_comment.sizeThatFits(CGSize.zero);
        
        let m_inc_height = m_fit_size.height - m_org_height;
        print("Calc Inc Value: \(m_inc_height)");
        
        let m_new_height = m_scrollHeight.constant + m_inc_height;
        
        m_scrollHeight.constant = m_new_height;
        print("Set Comment Height: \(m_new_height)");

        m_comment.scrollView.isScrollEnabled = false;
        m_comment.scrollView.bounces = false;
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        setContentHeight();
    }

    override func viewDidAppear(_ animated: Bool) {
        //requestData();
        m_datas.Part = BaseViewController.SelectGraph.queryPart
        m_datas.executQuery(.WeekData, success: success, fail: nil)
    }
    
//    private var values_accuracy = [20,25,7,55,80,90,70]//[Int](count: 7, repeatedValue: 0);
//    private var values_exercise_count = [Int](count: 7, repeatedValue: 0);
//    private var values_calorie = [Int](count: 7, repeatedValue: 0);
//    private var values_heartrate = [20,25,7,55,80,90,70]
//    private var values_totalpoint = [Int](count: 7, repeatedValue: 0);
    
    fileprivate func setHtml() {
        let url = Bundle.main.url(forResource: BaseViewController.SelectGraph.htmlName, withExtension:"html")
        let request = URLRequest(url: url!)
        m_comment.loadRequest(request)
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
        
        // 규창 xAxis, yAxis label사라지는 문제로 최대 줌 제한. 참고 https://github.com/danielgindi/Charts/issues/1564
        m_chart.viewPortHandler.setMaximumScaleX(2.5)
        
        let xAxis = m_chart.xAxis;
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 11);
        //규창 --- 그래프 줌인할때 라벨 위치 잡는 테스트 코드들
        //xAxis.spaceBetweenLabels = 5;
        //granularity Default 1.0
        //xAxis.granularity = 1.01;
        
        //규창 --- 줌인 줌아웃시 여러개의 x축 라벨이 발생되지 않게함
        xAxis.granularityEnabled = true
        
        //규창 ---- Axis min과 max사이를 탐색하는데 0,1,2,3,4,5,6 이 날짜가 들은 인덱스.
        //이 범위를 벗어난 xAxis min, xAxis max 가 그래프의 빈공간으로 채워지게 ""스트링을 리턴
        xAxis.axisMinimum = -0.5
        xAxis.labelCount = 4
        xAxis.axisMaximum = 6.7
        
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false;
        xAxis.gridLineWidth = 0.5;
        
        //규창 --- IAxisValueFormatter 델리게이트 이용 https://github.com/danielgindi/Charts/issues/1496
        xAxis.valueFormatter = self
        
        
        let fom = NumberFormatter();
        fom.numberStyle = .decimal
        fom.maximumFractionDigits = 0;
        fom.minimumIntegerDigits = 1;
        //fom.negativeSuffix = "";
        //Log.d(TAG, msg: "BaseViewController.SelectGraph.Unit\(BaseViewController.SelectGraph.Unit)")
        fom.positiveSuffix = BaseViewController.SelectGraph.Unit;
        
        let al = m_chart.leftAxis;
        if BaseViewController.SelectGraph != GraphIdentifier.calorieGraph {
            al.axisMaximum = 100
        }
        if BaseViewController.SelectGraph == GraphIdentifier.heartRateGraph {
            let lim1 = ChartLimitLine(limit: 100);
            lim1.lineWidth = 4;
            
            let lim2 = ChartLimitLine(limit: 80);
            lim2.lineWidth = 4;
            al.removeAllLimitLines();
            al.addLimitLine(lim1);
            al.addLimitLine(lim2);
            al.drawLimitLinesBehindDataEnabled = true;
        }
        
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
    
    func success() {
        setGraphData();
    }
    
    func setGraphData() {
        var list_value1 = [BarChartDataEntry]();
        var list_label = [String]();
        
        let fmt = DateFormatter()
        fmt.dateFormat = "MM/d"
        for i in 0..<m_datas.m_week_datas.count {
            list_value1.append(BarChartDataEntry(x: Double(i), y: Double(m_datas.m_week_datas[i])));
//            if BaseViewController.SelectGraph == GraphIdentifier.calorieGraph {
//                list_value1.append(BarChartDataEntry(x: Double(i), y: Double(m_datas.m_week_datas[i] / 100)));
//            } else {
//                list_value1.append(BarChartDataEntry(x: Double(i), y: Double(m_datas.m_week_datas[i])));
//            }
            let date = fmt.string(from: Common.addingDay(Date(), add_day: i-6))
            list_label.append(date);
        }
        
        let set1 = BarChartDataSet(values: list_value1, label: Common.ResString("week_last"));
        set1.setColor(Graph_Color_Week_Year, alpha: 1);
        set1.drawValuesEnabled = false;
        set1.highlightEnabled = true;
//        let set2 = BarChartDataSet(yVals: list_value2, label: Common.ResString("week_this"));
//        set2.setColor(Common.makeColor(0x71, 0x95, 0x01), alpha: 1);
//        set2.drawValuesEnabled = false;
//        set2.highlightEnabled = true;
        
        var dataSets = [BarChartDataSet]();
        dataSets.append(set1)
        //        dataSets.append(set2);
        
        //규창 --- 위쪽 for문에서 설정한 list_label을 date에 넣어 xaxis를 날짜로 교체..
        date = list_label
        let data = BarChartData(dataSets: dataSets);
        //let data = BarChartData(xVals: list_label, dataSets: dataSets);
       
        data.barWidth = 0.6
        //m_chart.fitBars = true
        //set1.barSpace를 쓰고 아래의 함수를 호출해야한다고 나옴
        m_chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        m_chart.notifyDataSetChanged()
        m_chart.data = data;
    }
    
    // 챠트 데이터 항목 선택 이벤트 처리
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
//        let dset = highlight.dataSetIndex;
//        let index = highlight.xIndex;
//        let old = (dset == 0 ? 13 : 6) - index;
//        let pos = dset * 7 + index;
//        
//        let cal = NSDate().dateByAddingTimeInterval(Double(-old) * 60 * 60 * 24);
//        
//        let fmt = NSDateFormatter();
//        fmt.dateStyle = .ShortStyle;
//        let info1 = Common.ResString("title_date") + fmt.stringFromDate(cal);
//        
//        let info2 = Common.ResString("count_step11") + " \(values_step11[pos])";
//        let info3 = Common.ResString("count_step99") + " \(values_step99[pos])";
//        
//        let info_fmt = Common.ResString("step_info_format");
//        let msg = String(format: info_fmt, info1, info2, info3);
//        m_info.text = msg;
//    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        //m_info.text = "";
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SG_Year" {
            let backButtonItem = UIBarButtonItem()
            backButtonItem.title = Common.ResString("back")
            navigationItem.backBarButtonItem = backButtonItem
        }
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

