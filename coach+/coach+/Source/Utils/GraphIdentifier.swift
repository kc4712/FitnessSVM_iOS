//
//  GraphIdentifier.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 21..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

enum GraphIdentifier: Int {
    case accuracyGraph = 10, heartRateGraph, exerciseCount, calorieGraph, totalGraph
    
    var Unit: String {
        switch self {
        case .accuracyGraph:
            fallthrough
        case .heartRateGraph:
            fallthrough
        case .exerciseCount:
            fallthrough
        case .totalGraph:
            return "%"
        case .calorieGraph:
            return "kcal"
        }
    }
    
    var queryPart: String {
        switch self {
        case .accuracyGraph:
            return "1"
        case .heartRateGraph:
            return "2"
        case .exerciseCount:
            return "3"
        case .calorieGraph:
            return "4"
        case .totalGraph:
            return "5"
        }
    }
    
    var titleName: String {
        switch self {
        case .accuracyGraph:
            return Common.ResString("graph_title_accuracy")
        case .heartRateGraph:
            return Common.ResString("graph_title_heartrate")
        case .exerciseCount:
            return Common.ResString("graph_title_exer_count")
        case .calorieGraph:
            return Common.ResString("graph_title_calorie")
        case .totalGraph:
            return Common.ResString("graph_title_total")
        }
    }
    
    var htmlName: String {
        switch self {
        case .accuracyGraph:
            return Common.ResString("html_name_graph_comment_accuracy")
        case .heartRateGraph:
            return Common.ResString("html_name_graph_comment_heartrate")
        case .exerciseCount:
            return Common.ResString("html_name_graph_comment_exer_count")
        case .calorieGraph:
            return Common.ResString("html_name_graph_comment_calorie")
        case .totalGraph:
            return Common.ResString("html_name_graph_comment_total")
        }
    }
}
