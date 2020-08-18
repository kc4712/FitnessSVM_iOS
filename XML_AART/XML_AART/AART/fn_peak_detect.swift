//
//  fn_peak_detect.swift
//  Swift_AART
//
//  Created by 심규창 on 2016. 6. 5..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

open class fn_peak_detect
{
    var acc_var_threshold:Double
    init()
    {
        acc_var_threshold = 0.3
    }
    //deinit{
        //print("fn_peak_detect해제")
    //}
    
    func peak_detect(_ function_get_num:Int , buffer:[[Double]], buffer_index_in:Int, chk_window:Int, acc_order:Int, noise_level_threshold:Double) -> peak_detect_output
    {
        var peak:Int = 0
        var peak_value:Double = 0.0
        var time_index:Int = 0;
        var buffer_length:Int = 0;
        var peak_candidate:Int = 0;
        
        buffer_length = 2 * chk_window + 1;
        peak_candidate = buffer_index_in - chk_window;
        
        if(peak_candidate < 1){
            peak_candidate = peak_candidate + 2 * chk_window + 1;
        }
        for jj in 0..<buffer_length
        {
            if(buffer[peak_candidate - 1][acc_order] < buffer[jj][acc_order]){
                break;
            }
            if(jj == buffer_length - 1)
            {
                peak = 1;
                peak_value = buffer[peak_candidate - 1][acc_order];
                time_index = function_get_num - chk_window;
            }
        }
        
        for jj in 0..<buffer_length
        {
            if(buffer[peak_candidate - 1][acc_order] > buffer[jj][acc_order]){
                break;
            }
            if(jj == buffer_length - 1)
            {
                peak = 2;
                peak_value = buffer[peak_candidate - 1][acc_order];
                time_index = function_get_num - chk_window;
            }
        }
        
        let peak_detect_output_in_fn = peak_detect_output();
        peak_detect_output_in_fn.peak = peak;
        peak_detect_output_in_fn.peak_value = peak_value;
        peak_detect_output_in_fn.time_index = time_index;
        return peak_detect_output_in_fn;
    }
}

