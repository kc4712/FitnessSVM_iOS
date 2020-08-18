//
//  pVideoBase.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 7. 1..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

protocol pVideoBase {
    func initInstance()
    
//    var onActivityName: String? { get set }
//    var onBottomComment: String? { get set }
//    var onExerData: (videoID:Int, video_full_count:Int, exer_idx:Int, exer_count:Int, start_time:Int64, end_time:Int64, consume_calorie:Int, count:Int, count_percent:Int, perfect_count:Int, minAccuracy:Int, maxAccuracy:Int, avgAccuracy:Int, minHeartRate:Int, maxHeartRate:Int, avgHeartRate:Int , cmpHeartRate:Int, point:Int) { get set }
    
    func setTotalScore(_ point:Int, count_percent:Int, accuracy_percent:Int, comment:String)
}
