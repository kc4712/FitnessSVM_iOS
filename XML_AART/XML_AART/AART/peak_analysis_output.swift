//
//  peak_analysis_output.swift
//  Swift_AART
//
//  Created by 심규창 on 2016. 6. 5..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

open class peak_analysis_output
{
    var peak:Int
    var time_index:Int
    var peak_value:Double
    var peak_to_peak:Int
    var surface:Double
    var amplitude:Double
    var cross_peak_to_peak:Int
    var surface2:Double
    
    init()
    {
        peak = 0;
        time_index = 0;
        peak_value = 0.0
        peak_to_peak = 0
        surface = 0.0
        surface2 = 0.0
        amplitude = 0.0
        cross_peak_to_peak = 0;
    }
    //deinit{
        //print("peak_analysis_output해제")
    //}
}
