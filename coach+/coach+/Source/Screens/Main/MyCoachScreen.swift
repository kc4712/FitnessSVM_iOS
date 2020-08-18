//
//  MyCoachScreen.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 21..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import MiddleWare

class MyCoachScreen: BaseViewController {
    
    @IBOutlet var m_cup: UIImageView!
    @IBOutlet var m_percentLabel: UILabel!
    
    @IBOutlet var m_calorie: UILabel!
    @IBOutlet var m_recommend_name: UILabel!
    
    fileprivate var today_calorie: Int32 = 0
    
    fileprivate let fillView = CALayer();
    fileprivate let fillColor = UIColor(red: 65 / 255.0, green: 182 / 255.0, blue: 178 / 255.0, alpha: 1);
    
    override func viewDidLoad() {
        fillView.backgroundColor = fillColor.cgColor;
        m_cup.superview?.layer.insertSublayer(fillView, at: 0);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //fillView.frame = m_cup.frame;
        today_calorie = Preference.TodayCalorie
        
        setPercent(getPercent())
    }
    
    fileprivate func getSumCalorieFromSQL() -> Int {
        let sql = SQLHelper.getInstance()
        
        let cal = MWCalendar.getInstance()
        let today: Today = (cal.year, cal.month, cal.day)
        
        var sum = 0
        
        if let datas = sql?.getActivityData() {
            for dat in datas {
                let date = dat.StartDate
                cal.setTimeInMillis(date)
                let dat_today: Today = (cal.year, cal.month, cal.day)
                
                if dat_today == today {
                    sum += Int(dat.Calorie)
                }
            }
        }
        
        return sum
    }
    
    fileprivate func getPercent() -> Int {
        // SQL에서 데이터를 읽어서, 이곳에 넣어준다.
        let mc = MWControlCenter.getInstance()
        
        var today: Int32 = 0
        var sum = 0
        switch mc.getSelectedProduct() {
        case .coach:
            let user = BaseViewController.User
            let current = Float32(user.CurrentWeight)
            let target = Float32(user.TargetWeight)
            let period = Int32(user.DietPeriod)
            today = Int32(mc.getCalorieConsumeDaily(current, goalWeight: target, dietPeriod: period))
            sum = BaseViewController.HomeInfo.today.Calorie
        case .fitness:
            sum = getSumCalorieFromSQL()
            today = today_calorie
        }
        
        m_calorie.text = String(sum)
        // 데이터가 들어오면 달성도 계산 가능.
        var percent = Double(sum) / Double(today) * 100.0
        if percent.isInfinite || percent.isNaN {
            percent = 0
        }
        
        if percent > 100 {percent = 100.0}
        
        return Int(percent)
    }
    
    fileprivate func setPercent(_ percent: Int) {
        let rect = m_cup.frame;
        let surplus = CGFloat(rect.size.height/305.0 * 14.0)
        let calc_height = (rect.size.height - surplus*2) * CGFloat(percent) / 100;
        let ypos = rect.origin.y - surplus + rect.size.height - calc_height;
        let viewRect = CGRect(x: rect.origin.x, y: ypos, width: rect.size.width, height: calc_height);
        fillView.frame = viewRect;
        
        m_percentLabel.text = String(percent)
    }
}
