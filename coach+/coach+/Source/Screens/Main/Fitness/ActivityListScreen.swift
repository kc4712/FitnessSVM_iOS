//
//  ActivityListScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 28..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class ActivityListScreen: UITableViewController {
    fileprivate var values: [ActivityData] = []
    fileprivate let cal = MWCalendar.getInstance()
    
    override func viewWillAppear(_ animated: Bool) {
        let data = getActivityDataFromSQL()
        values = data
    }
    
//    override func viewDidAppear(animated: Bool) {
//        performSegueWithIdentifier("SG_Result_Measure", sender: 0)
//    }
    
    fileprivate func getActivityDataFromSQL() -> [ActivityData] {
        var ret: [ActivityData] = []
        let sql = SQLHelper.getInstance()
        
        if let data = sql?.getActivityData() {
            for dat in data {
                if dat.Label == .activity {
                    ret.append(dat)
                }
            }
        }
        
        return ret
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count // 몇개지???
//        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        
        func getDateString(_ date: Int64) -> String {
            let millisec = date
            let date = Date(timeIntervalSince1970: TimeInterval(millisec/1000));
            
            let fmt = DateFormatter()
            fmt.dateStyle = .long
            var str = fmt.string(from: date)
            
            fmt.dateStyle = .none
            fmt.dateFormat = " HH:mm"
            str += fmt.string(from: date)
            
            return str
        }
        
        let label = cell.viewWithTag(51) as! UILabel
        label.text = getDateString(values[(indexPath as NSIndexPath).row].StartDate)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 Row의 데이터를 SQL에서 찾아서 주던가.. 데이터를 찾기 위한 인덱스를 줘야함. Result screen쪽에...
        tableView.reloadData()
        
        performSegue(withIdentifier: "SG_Result_Measure", sender: Int(values[(indexPath as NSIndexPath).row].Index))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SG_Result_Measure" {
            if let dest = segue.destination as? ActivityResultScreen {
                if let index = sender as? Int {
                    dest.m_Index = Int32(index)
                }
            }
        }
    }
}
