//
//  ChartMainScreen.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 21..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import Charts
import MiddleWare

class ChartMainScreen: BaseViewController {
    fileprivate let TAG = String(describing: ChartMainScreen.self)
    
    @IBOutlet var m_chart: RadarChartView!
    
    @IBOutlet var m_button_accuracy: UIButton!
    @IBOutlet var m_button_consume_calorie: UIButton!
    @IBOutlet var m_button_max_heartrate: UIButton!
    @IBOutlet var m_button_exercise_count: UIButton!
    @IBOutlet var m_button_total_point: UIButton!
    
    @IBOutlet var m_label_total_point: UILabel!
    
    fileprivate let mc: MWControlCenter = MWControlCenter.getInstance()
    
    fileprivate var m_datas = BaseViewController.HomeInfo
    
//    private var values_y_values = [100,200,300,100];
    
    override func viewDidLoad() {
//        m_datas.executQuery(.ExerciseToday, success: OnQuerySuccess, fail: OnQueryFail)
        BaseViewController.setWeekDataHandler(setGraphData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setChartProperties()
        setGraphData()
    }
    
    fileprivate func setChartProperties() {
        m_chart.rotationEnabled = false;
        m_chart.highlightPerTapEnabled = false;
//        m_chart.setHighlightEnabled(false);
        let xaxis = m_chart.xAxis;
        xaxis.labelFont = UIFont.systemFont(ofSize: 10)
        xaxis.drawLabelsEnabled = false
        xaxis.enabled = false
        let yaxis = m_chart.yAxis
//        yaxis.setDrawLabels(false);
        yaxis.setLabelCount(6, force: true);
//        yaxis.setLabelCount(5, false);
//        yaxis.axisMaximum = 100
        yaxis.axisMaximum = 100
        yaxis.axisMinimum = 0
//        yaxis.setAxisMaxValue(100f);
        yaxis.enabled = false
        yaxis.labelFont = UIFont.systemFont(ofSize: 10)
//        yaxis.setEnabled(false);
        let legend = m_chart.legend;
        legend.enabled = false
//        legend.setEnabled(false);
        m_chart.chartDescription?.text = "";
//        m_chart.setDescription(null);
        m_chart.drawMarkers = false
//        m_chart.setDrawMarkerViews(false);
    }

    fileprivate func setGraphData() {
//        ArrayList<String> xVals = new ArrayList<String>();
//        for (int i = 0; i < m_xDatas.length; i++) {
//            xVals.add(m_xDatas[i]);
//        }
        
        // 정확도
        var dat0 = Double(m_datas.week.Accuracy)
        // 운동횟수
        var dat1 = Double(m_datas.week.TotalCount == 0 ? 0 : Double(m_datas.week.MatchCount) * 100 / Double(m_datas.week.TotalCount))
        // 소모칼로리
        let dailyCal = mc.getCalorieConsumeDaily(BaseViewController.User.CurrentWeight, goalWeight: BaseViewController.User.TargetWeight, dietPeriod: Int32(BaseViewController.User.DietPeriod))
        var dat2 = Double(dailyCal == 0.0 ? 0 : Float(m_datas.week.Calorie) * 100 / dailyCal)
//        int dat2 = getDailyConsumeCalorie() == 0 ? 0 : DB_Today.Week.getCalorie() * 100 / getDailyConsumeCalorie();
        // 최대심박수
        var dat3 = CalculateBase.getHeartRateCompared(m_datas.week.HeartAvg, stable: Int32(m_datas.week.HeartMax), age: Int32(BaseViewController.User.GetAge()))

        m_label_total_point.text = String(format: "%dpts", m_datas.week.Point)
        
        if (dat0 > 100) {dat0 = 100}
        if (dat1 > 100) {dat1 = 100}
        if (dat2 > 100) {dat2 = 100}
        if (dat3 > 100) {dat3 = 100}
        if (dat3 < 0) {dat3 = 0}
        
        // 규창 ChartDataEntry -> RadarChartDataEntry변경
        //let val1 = ChartDataEntry(x: 0, y: dat0)
        //let val2 = ChartDataEntry(x: 1, y: dat1)
        //let val3 = ChartDataEntry(x: 2, y: dat2)
        //let val4 = ChartDataEntry(x: 3, y: dat3)
        let val1 = RadarChartDataEntry(value: dat0)
        let val2 = RadarChartDataEntry(value: dat1)
        let val3 = RadarChartDataEntry(value: dat2)
        let val4 = RadarChartDataEntry(value: Double(dat3))
        
        
        let yVals = [val1, val2, val3, val4]
        
        let set1 = RadarChartDataSet(values: yVals, label: nil)
        set1.lineWidth = 2
        set1.drawValuesEnabled = false
        
        let data = RadarChartData(dataSets: [set1])
        m_chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        m_chart.notifyDataSetChanged()
        m_chart.data = data
    }

    @IBAction func displayGraph(_ sender: UIButton) {
//        let tag: GraphIdentifier = GraphIdentifier(rawValue: sender.tag)!
//        switch tag {
//        case .AccuracyGraph:
//            
//        case .CalorieGraph:
//            
//        case .ExerciseCount:
//            
//        case .HeartRateGraph:
//            
//        case .TotalGraph:
//            
//        }
        
        BaseViewController.SelectGraph = GraphIdentifier(rawValue: sender.tag)!
        performSegue(withIdentifier: "SG_GraphWeek", sender: sender.tag)
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "SG_GraphDraw" {
//            if let dest = segue.destinationViewController as? GraphWeek {
//                if let graphId = sender as? Int {
//                    dest.SelectGraph = GraphIdentifier(rawValue: graphId)!
//                }
//            }
//        }
//    }
}
