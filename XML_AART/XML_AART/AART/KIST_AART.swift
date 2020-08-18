//
//  KIST_AART.swift
//  Swift_AART
//
//  Created by 심규창 on 2016. 6. 5..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation


open class KIST_AART:NSObject
{
    
    open var function_get_num:Int;
    var before_jumping:Bool;
    
    // Variabels
    var data_smoothing_window:Int
    
    //////////////////////////////////////
    // Local Peak related
    var chk_window_LP:Int
    var acc_var_x:Double
    var acc_var_y:Double
    var acc_var_z:Double
    var acc_var_norm:Double
    var buffer_LP:[[Double]]
    var buffer_index_in_LP:Int
    var buffer_length_LP:Int
    var diff_buffer:[[Double]]
    var smooth_buffer:[[Double]]
    var var_buffer:[[Double]]
    var buffer_index:Int
    var buffer_index2:Int
    var dt:Double;
    var noise_level_threshold:Double
    
    
    var threshold:Double
    var m_peak_detect_output:peak_detect_output
    var m_peak_analysis_output:peak_analysis_output
    var acc_raw = [Double]()
    var acc_norm:Double
    var acc_raw_smoothing:[Double]
    var acc_norm_smoothing:Double
    var acc_mean:Double
    var acc_var:Double
    var avg_acc_noise_threshold:[Double]
    var prev_local_upper_peak_x:[Double]
    var prev_local_lower_peak_x:[Double]
    var prev_local_upper_peak_y:[Double]
    var prev_local_lower_peak_y:[Double]
    var prev_local_upper_peak_z:[Double]
    var prev_local_lower_peak_z:[Double]
    var prev_local_upper_peak_norm:[Double]
    var prev_local_lower_peak_norm:[Double]
    var m_fn_peak_detect:fn_peak_detect
    var m_fn_peak_Analysis:fn_Peak_Analysis
    var m_KIST_AART_output:KIST_AART_output
    
    public override init()
    {
        function_get_num = 0;
        before_jumping = false;
        data_smoothing_window = 10;
        chk_window_LP = 5;
        acc_var_x = 0.0
        acc_var_y = 0.0
        acc_var_z = 0.0
        acc_var_norm = 0.0
        buffer_LP = Array(repeating: Array(repeating: 0, count: 4), count: 2 * chk_window_LP + 1)
        //buffer_LP = new double[2 * chk_window_LP + 1][4]
        buffer_index_in_LP = 1;
        buffer_length_LP = 2 * chk_window_LP + 1;
        diff_buffer = Array(repeating: Array(repeating: 0, count: 4), count: buffer_length_LP)
        //diff_buffer = new double[buffer_length_LP][4];
        
        smooth_buffer = Array(repeating: Array(repeating: 0, count: 4), count: buffer_length_LP)
        //smooth_buffer = new double[buffer_length_LP][4];
        
        var_buffer = Array(repeating: Array(repeating: 0, count: 4), count: buffer_length_LP)
        //var_buffer = new double[buffer_length_LP][4];
        
        buffer_index = buffer_length_LP - 4;
        buffer_index2 = buffer_index - 2;
        dt = 0.05
        noise_level_threshold = 0.03;
        threshold = 10.3;
        
        m_peak_detect_output = peak_detect_output();
        m_peak_analysis_output = peak_analysis_output();
        
        acc_raw = Array(repeating: 0, count: 3)
        //acc_raw = new double[3];
        acc_norm = 0.0
        
        acc_raw_smoothing = Array(repeating: 0, count: 3)
        //acc_raw_smoothing = new double[3];
        acc_norm_smoothing = 0.0;
        acc_mean = 0.0;
        acc_var = 0.0;
        avg_acc_noise_threshold = Array(repeating: 0, count: 2)
        prev_local_upper_peak_x = Array(repeating: 0, count: 4)
        prev_local_lower_peak_x = Array(repeating: 0, count: 4)
        prev_local_upper_peak_y = Array(repeating: 0, count: 4)
        prev_local_lower_peak_y = Array(repeating: 0, count: 4)
        prev_local_upper_peak_z = Array(repeating: 0, count: 4)
        prev_local_lower_peak_z = Array(repeating: 0, count: 4)
        prev_local_upper_peak_norm = Array(repeating: 0, count: 4)
        prev_local_lower_peak_norm = Array(repeating: 0, count: 4)
        m_fn_peak_detect = fn_peak_detect();
        m_fn_peak_Analysis = fn_Peak_Analysis();
        m_KIST_AART_output = KIST_AART_output()
    }
    //deinit{
        //print("KIST_AART해제")
    //}
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    //Function start
    open func fn_AART_Cal_parameter(_ acc_data:[Double]) -> KIST_AART_output
    {
        function_get_num += 1;
        //print("엔진 안이래요 \(acc_data)")
        //acc_raw.insert(acc_data[0], atIndex: 0)
        //acc_raw.insert(acc_data[1], atIndex: 1)
        //acc_raw.insert(acc_data[2], atIndex: 2)
        acc_raw = acc_data
        //print("엔진 안이래요")
        
        //Acc. Norm Calculation
        acc_norm = sqrt(acc_raw[0] * acc_raw[0] + acc_raw[1] * acc_raw[1] + acc_raw[2] * acc_raw[2]);
        
        //Acc. data smoothing
        if(function_get_num < data_smoothing_window)
        {
            acc_raw_smoothing[0] = (acc_raw_smoothing[0] * Double(function_get_num - 1)) / Double(function_get_num) + acc_raw[0] / Double(function_get_num);
            acc_raw_smoothing[1] = (acc_raw_smoothing[1] * Double(function_get_num - 1)) / Double(function_get_num) + acc_raw[1] / Double(function_get_num)
            acc_raw_smoothing[2] = (acc_raw_smoothing[2] * Double(function_get_num - 1)) / Double(function_get_num) + acc_raw[2] / Double(function_get_num)
            acc_norm_smoothing = (acc_norm_smoothing * Double(function_get_num - 1)) / Double(function_get_num) + acc_norm / Double(function_get_num)
        }
        else
        {
            acc_raw_smoothing[0] = (acc_raw_smoothing[0] * Double(data_smoothing_window - 1)) / Double(data_smoothing_window) + acc_raw[0] / Double(data_smoothing_window)
            acc_raw_smoothing[1] = (acc_raw_smoothing[1] * Double(data_smoothing_window - 1)) / Double(data_smoothing_window) + acc_raw[1] / Double(data_smoothing_window)
            acc_raw_smoothing[2] = (acc_raw_smoothing[2] * Double(data_smoothing_window - 1)) / Double(data_smoothing_window) + acc_raw[2] / Double(data_smoothing_window)
            acc_norm_smoothing = (acc_norm_smoothing * Double(data_smoothing_window - 1)) / Double(data_smoothing_window) + acc_norm / Double(data_smoothing_window)
        }
        
        //Acc mean and variance
        acc_mean = (acc_mean * Double(buffer_length_LP - 1)) / Double(buffer_length_LP) + acc_norm / Double(buffer_length_LP)
        acc_var = (acc_var * Double(buffer_length_LP - 1)) / Double(buffer_length_LP) + ((acc_mean - acc_norm) * (acc_mean - acc_norm)) / Double(buffer_length_LP)
        
        //Update buffer index
        if(buffer_index_in_LP > buffer_length_LP){
            buffer_index_in_LP = 1;
        }
        
        //data buffer save
        buffer_LP[buffer_index_in_LP - 1][0] = acc_raw_smoothing[0];
        buffer_LP[buffer_index_in_LP - 1][1] = acc_raw_smoothing[1];
        buffer_LP[buffer_index_in_LP - 1][2] = acc_raw_smoothing[2];
        buffer_LP[buffer_index_in_LP - 1][3] = acc_norm_smoothing;
        if(buffer_index > buffer_length_LP){
            buffer_index = 1;
        }
        if(buffer_index - 2 < 0){
            buffer_index2 = buffer_length_LP - 1;
        }
        else{
            buffer_index2 = buffer_index - 2;
        }
        
        //buffer var
        var_buffer[buffer_index_in_LP - 1][0] = (acc_var_x * Double(buffer_length_LP - 1)) / Double(buffer_length_LP) + ((acc_raw_smoothing[0] - acc_raw[0]) * (acc_raw_smoothing[0] - acc_raw[0])) / Double(buffer_length_LP)
        
        var_buffer[buffer_index_in_LP - 1][1] = (acc_var_y * Double(buffer_length_LP - 1)) / Double(buffer_length_LP) + ((acc_raw_smoothing[1] - acc_raw[1]) * (acc_raw_smoothing[1] - acc_raw[1])) / Double(buffer_length_LP)
        
        var_buffer[buffer_index_in_LP - 1][2] = (acc_var_z * Double(buffer_length_LP - 1)) / Double(buffer_length_LP) + ((acc_raw_smoothing[2] - acc_raw[2]) * (acc_raw_smoothing[2] - acc_raw[2])) / Double(buffer_length_LP)
        
        var_buffer[buffer_index_in_LP - 1][3] = (acc_var_norm * Double(buffer_length_LP - 1)) / Double(buffer_length_LP) + ((acc_norm_smoothing - acc_norm) * (acc_norm_smoothing - acc_norm)) / Double(buffer_length_LP)
        
        //buffer smooth
        smooth_buffer[buffer_index_in_LP - 1][0] = acc_raw_smoothing[0];
        smooth_buffer[buffer_index_in_LP - 1][1] = acc_raw_smoothing[1];
        smooth_buffer[buffer_index_in_LP - 1][2] = acc_raw_smoothing[2];
        smooth_buffer[buffer_index_in_LP - 1][3] = acc_norm_smoothing;
        if(function_get_num > 4)
        {
            //data var
            m_KIST_AART_output.acc_var_x = var_buffer[buffer_index - 1][0];
            m_KIST_AART_output.acc_var_y = var_buffer[buffer_index - 1][1];
            m_KIST_AART_output.acc_var_z = var_buffer[buffer_index - 1][2];
            m_KIST_AART_output.acc_var_norm = var_buffer[buffer_index - 1][3];
            //data smooth
            m_KIST_AART_output.acc_smooth_x = smooth_buffer[buffer_index - 1][0];
            m_KIST_AART_output.acc_smooth_y = smooth_buffer[buffer_index - 1][1];
            m_KIST_AART_output.acc_smooth_z = smooth_buffer[buffer_index - 1][2];
            m_KIST_AART_output.acc_smooth_norm = smooth_buffer[buffer_index - 1][3];
            //data diff
            m_KIST_AART_output.acc_diff_x = (smooth_buffer[buffer_index - 1][0] - smooth_buffer[buffer_index2][0]) / dt;
            m_KIST_AART_output.acc_diff_y = (smooth_buffer[buffer_index - 1][1] - smooth_buffer[buffer_index2][1]) / dt;
            m_KIST_AART_output.acc_diff_z = (smooth_buffer[buffer_index - 1][2] - smooth_buffer[buffer_index2][2]) / dt;
            m_KIST_AART_output.acc_diff_norm = (smooth_buffer[buffer_index - 1][3] - smooth_buffer[buffer_index2][3]) / dt;
        }
        noise_level_threshold = 0.01
        
        //after specific delay
        if(function_get_num > buffer_length_LP)
        {
            /////////////////////////////////////////////////////////////////////////////////////
            //Upper peak related START
            /////////////////////////////////////////////////////////////////////////////////////
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //initialization of peak detection X case
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
            m_peak_detect_output = m_fn_peak_detect.peak_detect(function_get_num, buffer: buffer_LP, buffer_index_in: buffer_index_in_LP, chk_window: chk_window_LP, acc_order: 0, noise_level_threshold: noise_level_threshold)
            //m_peak_detect_output = m_fn_peak_detect.peak_detect(function_get_num, buffer_LP, buffer_index_in_LP, chk_window_LP, 0, noise_level_threshold);
            m_peak_analysis_output = m_fn_peak_Analysis.Peak_Analysis(m_peak_detect_output.peak, peak_value: m_peak_detect_output.peak_value, time_index: m_peak_detect_output.time_index, prev_local_upper_peak: prev_local_upper_peak_x, prev_local_lower_peak: prev_local_lower_peak_x);
            //m_peak_analysis_output = m_fn_peak_Analysis.Peak_Analysis(m_peak_detect_output.peak, m_peak_detect_output.peak_value, m_peak_detect_output.time_index, prev_local_upper_peak_x, prev_local_lower_peak_x);
            if(m_peak_detect_output.peak == 1)
            {
                prev_local_upper_peak_x[2] = prev_local_upper_peak_x[0]
                prev_local_upper_peak_x[3] = prev_local_upper_peak_x[1]
                
                prev_local_upper_peak_x[0] = Double(m_peak_detect_output.time_index);
                prev_local_upper_peak_x[1] = m_peak_detect_output.peak_value;
            }
            else if(m_peak_detect_output.peak == 2)
            {
                prev_local_lower_peak_x[2] = prev_local_lower_peak_x[0]
                prev_local_lower_peak_x[3] = prev_local_lower_peak_x[1]
                
                prev_local_lower_peak_x[0] = Double(m_peak_detect_output.time_index);
                prev_local_lower_peak_x[1] = m_peak_detect_output.peak_value;
            }
            m_KIST_AART_output.peak_x = m_peak_analysis_output.peak;
            m_KIST_AART_output.time_index_x = m_peak_analysis_output.time_index;
            m_KIST_AART_output.peak_value_x = m_peak_analysis_output.peak_value;
            m_KIST_AART_output.peak_to_peak_x = m_peak_analysis_output.peak_to_peak;
            m_KIST_AART_output.surface_x = m_peak_analysis_output.surface;
            m_KIST_AART_output.amplitude_x = m_peak_analysis_output.amplitude;
            m_KIST_AART_output.cross_peak_to_peak_x = m_peak_analysis_output.cross_peak_to_peak;
            m_KIST_AART_output.surface_x2 = m_peak_analysis_output.surface2;
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //initialization of peak detection Y case
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
            m_peak_detect_output = m_fn_peak_detect.peak_detect(function_get_num, buffer: buffer_LP, buffer_index_in: buffer_index_in_LP, chk_window: chk_window_LP, acc_order: 1, noise_level_threshold: noise_level_threshold);
            //m_peak_detect_output = m_fn_peak_detect.peak_detect(function_get_num, buffer_LP, buffer_index_in_LP, chk_window_LP, 1, noise_level_threshold);
            m_peak_analysis_output = m_fn_peak_Analysis.Peak_Analysis(m_peak_detect_output.peak, peak_value: m_peak_detect_output.peak_value, time_index: m_peak_detect_output.time_index, prev_local_upper_peak: prev_local_upper_peak_y, prev_local_lower_peak: prev_local_lower_peak_y);
            //m_peak_analysis_output = m_fn_peak_Analysis.Peak_Analysis(m_peak_detect_output.peak, m_peak_detect_output.peak_value, m_peak_detect_output.time_index, prev_local_upper_peak_y, prev_local_lower_peak_y);
            
            
            if(m_peak_detect_output.peak == 1)
            {
                prev_local_upper_peak_y[2] = prev_local_upper_peak_y[0]
                prev_local_upper_peak_y[3] = prev_local_upper_peak_y[1]
                
                prev_local_upper_peak_y[0] = Double(m_peak_detect_output.time_index)
                prev_local_upper_peak_y[1] = m_peak_detect_output.peak_value;
            }
            else if(m_peak_detect_output.peak == 2)
            {
                prev_local_lower_peak_y[2] = prev_local_lower_peak_y[0]
                prev_local_lower_peak_y[3] = prev_local_lower_peak_y[1]
                
                prev_local_lower_peak_y[0] = Double(m_peak_detect_output.time_index)
                prev_local_lower_peak_y[1] = m_peak_detect_output.peak_value;
            }
            m_KIST_AART_output.peak_y = m_peak_analysis_output.peak;
            m_KIST_AART_output.time_index_y = m_peak_analysis_output.time_index;
            m_KIST_AART_output.peak_value_y = m_peak_analysis_output.peak_value;
            m_KIST_AART_output.peak_to_peak_y = m_peak_analysis_output.peak_to_peak;
            m_KIST_AART_output.surface_y = m_peak_analysis_output.surface;
            m_KIST_AART_output.amplitude_y = m_peak_analysis_output.amplitude;
            m_KIST_AART_output.cross_peak_to_peak_y = m_peak_analysis_output.cross_peak_to_peak;
            m_KIST_AART_output.surface_y2 = m_peak_analysis_output.surface2;
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //initialization of peak detection Z case
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
            m_peak_detect_output = m_fn_peak_detect.peak_detect(function_get_num, buffer: buffer_LP, buffer_index_in: buffer_index_in_LP, chk_window: chk_window_LP, acc_order: 2, noise_level_threshold: noise_level_threshold)
            //m_peak_detect_output = m_fn_peak_detect.peak_detect(function_get_num, buffer_LP, buffer_index_in_LP, chk_window_LP, 2, noise_level_threshold);
            m_peak_analysis_output = m_fn_peak_Analysis.Peak_Analysis(m_peak_detect_output.peak, peak_value: m_peak_detect_output.peak_value, time_index: m_peak_detect_output.time_index, prev_local_upper_peak: prev_local_upper_peak_z, prev_local_lower_peak: prev_local_lower_peak_z);
            //m_peak_analysis_output = m_fn_peak_Analysis.Peak_Analysis(m_peak_detect_output.peak, m_peak_detect_output.peak_value, m_peak_detect_output.time_index, prev_local_upper_peak_z, prev_local_lower_peak_z);
            if(m_peak_detect_output.peak == 1)
            {
                prev_local_upper_peak_z[2] = prev_local_upper_peak_z[0]
                prev_local_upper_peak_z[3] = prev_local_upper_peak_z[1]
                
                prev_local_upper_peak_z[0] = Double(m_peak_detect_output.time_index)
                prev_local_upper_peak_z[1] = m_peak_detect_output.peak_value;
            }
            else if(m_peak_detect_output.peak == 2)
            {
                prev_local_lower_peak_z[2] = prev_local_lower_peak_z[0]
                prev_local_lower_peak_z[3] = prev_local_lower_peak_z[1]
                
                prev_local_lower_peak_z[0] = Double(m_peak_detect_output.time_index)
                prev_local_lower_peak_z[1] = m_peak_detect_output.peak_value;
            }
            m_KIST_AART_output.peak_z = m_peak_analysis_output.peak;
            m_KIST_AART_output.time_index_z = m_peak_analysis_output.time_index;
            m_KIST_AART_output.peak_value_z = m_peak_analysis_output.peak_value;
            m_KIST_AART_output.peak_to_peak_z = m_peak_analysis_output.peak_to_peak;
            m_KIST_AART_output.surface_z = m_peak_analysis_output.surface;
            m_KIST_AART_output.amplitude_z = m_peak_analysis_output.amplitude;
            m_KIST_AART_output.cross_peak_to_peak_z = m_peak_analysis_output.cross_peak_to_peak;
            m_KIST_AART_output.surface_z2 = m_peak_analysis_output.surface2
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //initialization of peak detection Norm case
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
            m_peak_detect_output = m_fn_peak_detect.peak_detect(function_get_num, buffer: buffer_LP, buffer_index_in: buffer_index_in_LP, chk_window: chk_window_LP, acc_order: 3, noise_level_threshold: noise_level_threshold);
            //m_peak_detect_output = m_fn_peak_detect.peak_detect(function_get_num, buffer_LP, buffer_index_in_LP, chk_window_LP, 3, noise_level_threshold);
            m_peak_analysis_output = m_fn_peak_Analysis.Peak_Analysis(m_peak_detect_output.peak, peak_value: m_peak_detect_output.peak_value, time_index: m_peak_detect_output.time_index, prev_local_upper_peak: prev_local_upper_peak_norm, prev_local_lower_peak: prev_local_lower_peak_norm);
            //m_peak_analysis_output = m_fn_peak_Analysis.Peak_Analysis(m_peak_detect_output.peak, m_peak_detect_output.peak_value, m_peak_detect_output.time_index, prev_local_upper_peak_norm, prev_local_lower_peak_norm);
            if(m_peak_detect_output.peak == 1)
            {
                prev_local_upper_peak_norm[2] = prev_local_upper_peak_norm[0]
                prev_local_upper_peak_norm[3] = prev_local_upper_peak_norm[1]
                
                prev_local_upper_peak_norm[0] = Double(m_peak_detect_output.time_index)
                prev_local_upper_peak_norm[1] = m_peak_detect_output.peak_value;
            }
            else if(m_peak_detect_output.peak == 2)
            {
                prev_local_lower_peak_norm[2] = prev_local_lower_peak_norm[0]
                prev_local_lower_peak_norm[3] = prev_local_lower_peak_norm[1]
                
                prev_local_lower_peak_norm[0] = Double(m_peak_detect_output.time_index)
                prev_local_lower_peak_norm[1] = m_peak_detect_output.peak_value;
            }
            m_KIST_AART_output.peak_norm = m_peak_analysis_output.peak;
            m_KIST_AART_output.time_index_norm = m_peak_analysis_output.time_index;
            m_KIST_AART_output.peak_value_norm = m_peak_analysis_output.peak_value;
            m_KIST_AART_output.peak_to_peak_norm = m_peak_analysis_output.peak_to_peak;
            m_KIST_AART_output.surface_norm = m_peak_analysis_output.surface;
            m_KIST_AART_output.amplitude_norm = m_peak_analysis_output.amplitude;
            m_KIST_AART_output.cross_peak_to_peak_norm = m_peak_analysis_output.cross_peak_to_peak;
            m_KIST_AART_output.surface_norm2 = m_peak_analysis_output.surface2;
            
        }//GetFeaturedata End
        
        buffer_index_in_LP += 1;
        buffer_index += 1;
        buffer_index2 = buffer_index + 1;
        return m_KIST_AART_output;
    }
}
