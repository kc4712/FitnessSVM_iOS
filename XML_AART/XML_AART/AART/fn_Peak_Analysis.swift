//
//  fn_Peak_Analysis.swift
//  Swift_AART
//
//  Created by 심규창 on 2016. 6. 5..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

open class fn_Peak_Analysis
{
    var acc_var_threshold:Double
    init()
    {
        acc_var_threshold = 0.3
    }
    //deinit{
        //print("fn_Peak_Analysis해제")
    //}
    func Peak_Analysis(_ peak:Int, peak_value:Double, time_index:Int, prev_local_upper_peak:[Double], prev_local_lower_peak:[Double]) -> peak_analysis_output
    {
        var peak_to_peak:Int = 0
        var cross_peak_to_peak:Int = 0;
        var surface:Double = 0.0
        var amplitude:Double = 0.0
        var surface2:Double = 0.0
        
        if(peak == 1)
        {
            peak_to_peak = time_index - Int(prev_local_upper_peak[0])
            cross_peak_to_peak = time_index - Int(prev_local_lower_peak[0])
            surface = abs(((Double(time_index) - prev_local_lower_peak[0]) * (peak_value - prev_local_lower_peak[1])) / 2)
            surface2 = abs(((Double(time_index) - prev_local_lower_peak[2]) * (peak_value - prev_local_lower_peak[3])) / 2)
            amplitude = abs(peak_value - prev_local_lower_peak[1])
        }
        else if(peak == 2)
        {
                peak_to_peak = -(time_index - Int(prev_local_lower_peak[0]))
                cross_peak_to_peak = -(time_index - Int(prev_local_upper_peak[0]))
                surface = -abs(((Double(time_index) - prev_local_upper_peak[0]) * (prev_local_upper_peak[1] - peak_value)) / 2);
                surface2 = -abs(((Double(time_index) - prev_local_upper_peak[2]) * (prev_local_upper_peak[3] - peak_value)) / 2);
                amplitude = -abs(peak_value - prev_local_upper_peak[1]);
        }
        let peak_analysis_output_in:peak_analysis_output = peak_analysis_output();
        peak_analysis_output_in.amplitude = amplitude;
        peak_analysis_output_in.cross_peak_to_peak = cross_peak_to_peak;
        peak_analysis_output_in.peak = peak;
        peak_analysis_output_in.peak_to_peak = peak_to_peak;
        peak_analysis_output_in.peak_value = peak_value;
        peak_analysis_output_in.surface = surface;
        peak_analysis_output_in.time_index = time_index;
        peak_analysis_output_in.surface2 = surface2;
        
        return peak_analysis_output_in;
    }
}
