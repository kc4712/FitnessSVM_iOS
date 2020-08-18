//
//  AART_Planner_Engine.swift
//  AART_Planner_Engine
//
//  Created by 심규창 on 2017. 6. 8..
//  Copyright © 2017년 심규창. All rights reserved.
//

import Foundation


open class AART_Planner_Engine {
    
    let threshold1_accVar:Double = 0.0008
    let threshold_pres:Double = 0.4
    //let threshold2_accVar:Double = 3
    let threshold2_accVar:Double = 0.8 // 2015.08.17 greencomm
    let threshold3_accVar:Double = 3.0 // 2015.08.17 greencomm add
    let threshold1_stepcount:Double = 40.0
    let threshold2_stepcount:Double = 20.0
    let threshold1_swingcount:Double = 20.0
    let large_swing_num_for_golf:Int = 1
    let min_large_swing_num_for_golf:Int = 1
    let max_large_swing_num_for_golf:Int = 3 // 2015.08.17 greencomm
    
    var present_1m_activity:Int = 0
    
    //Classifier Obtain Related
    /*
     const char file_pos_class_1[] = "model1"
     const char file_pos_class_2[] = "model2"
     const char file_pos_class_3[] = "model3"
     */
     /*@objc
     open static func Load_model1() -> NSString {
     var model1_path:NSString
     model1_path = Bundle.main.path(forResource: "model1",ofType: "")! as NSString
     return model1_path
     }
     open static func Load_model2() -> NSString {
     var model2_path:NSString
     model2_path = Bundle.main.path(forResource: "model2",ofType: "")! as NSString
     return model2_path
     }
     open static func Load_model3() -> NSString {
     var model3_path:NSString
     model3_path = Bundle.main.path(forResource: "model3",ofType: "")! as NSString
     return model3_path
     }*/
    /*
     struct svm_model * s_train_1 //=svm_load_model(file_pos_class_1)
     struct svm_model * s_train_2 //=svm_load_model(file_pos_class_2)
     struct svm_model * s_train_3 //=svm_load_model(file_pos_class_3)
     struct svm_node *node*/
    
    
    
    var s_train_1:UnsafeMutablePointer<svm_model>?// = svm_load_model(Load_model1())
    var s_train_2:UnsafeMutablePointer<svm_model>?// = svm_load_model(Load_model2())
    var s_train_3:UnsafeMutablePointer<svm_model>?// = svm_load_model(Load_model3())
    
    
    let n_ampl:Double = 8.7
    let n_fre:Double = 0.94
    
    let SL_0_walking:Double = 68
    let SL_0_hiking:Double = 60
    let SL_0_run:Double = 98
    
    
    //	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //	% Definition of Activity_Index %
    //	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //	% % Activity_Index=2 :: 수면 --> 0
    //	% % Activity_Index=4 :: 안정 --> 1
    //	% % Activity_Index=6 :: 자전거 --> 2
    //	% % Activity_Index=8 :: 사이클 --> 2
    //	% % Activity_Index=10 :: 줄넘기 --> 3
    //	% % Activity_Index=12 :: 걷기 스윙 --> 4
    //	% % Activity_Index=14 :: 걱기 물건 --> 4
    //	% % Activity_Index=16 :: 걷기 주머니 --> 4
    //	% % Activity_Index=18 :: 걷기 --> 4
    //	% % Activity_Index=20 :: 걷기 --> 4
    //	% % Activity_Index=22 :: 안정 --> 1
    //	% % Activity_Index=24 :: 걷기 --> 4
    //	% % Activity_Index=26 :: 달리기 --> 5
    //	% % Activity_Index=28 :: 달리기 --> 5
    //	% % Activity_Index=30 :: 등산 --> 6
    //	% % Activity_Index=32 :: 계단 --> 7
    //	% % Activity_Index=34 :: 계단 --> 7
    //	% % Activity_Index=36 :: 계단 --> 7
    //	% % Activity_Index=38 :: 계단 --> 7
    //	% % Activity_Index=40 :: 테니스 --> 8
    //	% % Activity_Index=42 :: 탁구 --> 9
    //	% % Activity_Index=44 :: 골프--> 10
    public init(){
        /*
        s_train_1 = svm_load_model(Load_model1())
        s_train_2 = svm_load_model(Load_model2())
        s_train_3 = svm_load_model(Load_model3())*/
    }
    
    
    
    
    //double* ActivityOut(double feature_data[]) -> Array<Double>
    open func ActivityOut(feature_data:[Double]) -> [Double]
    {
        s_train_1 = svm_load_model(Load_model1())
        s_train_2 = svm_load_model(Load_model2())
        s_train_3 = svm_load_model(Load_model3())
        //s_train_1 = svm_load_model(Load_model1())
        //s_train_2 = svm_load_model(Load_model2())
        //s_train_3 = svm_load_model(Load_model3())
        
        
        
        /*var s_train_1 = svm_load_model(Load_model1())
        var s_train_2 = svm_load_model(Load_model2())
        var s_train_3 = svm_load_model(Load_model3())
        */
        var svm_estimated_label:Double = 0
        
        //Real Time Step Length Estimation
        let step_parameter_scale:Double = 3.5
        let alpha:Double = 0.32 * step_parameter_scale
        let beta:Double = 0.72 * step_parameter_scale
        let n_min:Double = 9.0
        let n_max:Double = 13.0
        let x_min1:Double = -2.2
        let x_max1:Double = 3.1
        let y_min1:Double = -8.2
        let y_max1:Double = -4.2
        let z_min1:Double = 5.6
        let z_max1:Double = 9.5
        let x_min2:Double = 6.9
        let x_max2:Double = 10.1
        let y_min2:Double = -7.2
        let y_max2:Double = -3.3
        let z_min2:Double = 0.0
        let z_max2:Double = 5.0
        let x_min3:Double = 3.8
        let x_max3:Double = 6.3
        let y_min3:Double = -8.7
        let y_max3:Double = -6.6
        let z_min3:Double = 2.6
        let z_max3:Double = 6.4
        
        var i:Int = 0
        
        var estimated_activity = [Double](repeating: 0, count : 8)
        
        //node = (struct svm_node *) malloc(sizeof(struct svm_node))
        
        
        
        
        /***********************
         ** Classifying Start **
         ***********************/
        
        if ( feature_data[3] < threshold1_accVar ){
            //
            present_1m_activity = 2
            
        }else if ( feature_data[3] < threshold2_accVar && feature_data[11] == 0){ // 2015.08.17 greencomm add
    
            //
            present_1m_activity = 4
        } else{
            if ((feature_data[3] > threshold3_accVar || feature_data[11] != 0) && (feature_data[3] > threshold3_accVar || fabs(feature_data[12]) < 5)) {
                if(feature_data[11] >= Double(large_swing_num_for_golf) && feature_data[10] <= 2.0 && feature_data[9] == 0.0) {
                    present_1m_activity = 44;
                } else {
                    //var svm_feature = [Double](repeating: 0, count : 3)
                    //svm_feature[0] = feature_data[4]
                    //svm_feature[1] = feature_data[5]
                    //svm_feature[2] = feature_data[6]
                    /*wrap.act_index = Int(tmpActData[0])
                    wrap.variance = tmpActData[1]
                    wrap.press_variance = tmpActData[2]
                    wrap.step = Int(tmpActData[3])
                    wrap.swing = Int(tmpActData[4])
                    wrap.small_swing = Int(tmpActData[5])
                    wrap.large_swing = Int(tmpActData[6])
                    wrap.hr = hrArray[i]
                    wrap.disp_step = dispStepArray[i]*/
                    var svm_feature:[Double] = [feature_data[0] / 20.0, feature_data[3] / 20.0, feature_data[8] / 20.0, feature_data[9] / 20.0, feature_data[8] / (feature_data[9] + 1.0) / 20.0, feature_data[4], feature_data[5], feature_data[6], feature_data[7]]
                    var x = Array(repeating: svm_node(), count : 9)
            //node = (struct svm_node *) realloc(node,3*sizeof(struct svm_node))
                    for i in 0..<9 {
                        x[i].index = Int32(i + 1)
                        x[i].value = svm_feature[i]
                    }
            
                    svm_estimated_label=svm_predict(s_train_3,x)
                    if(svm_estimated_label == 1.0) {
                        present_1m_activity = 6;
                    } else if(svm_estimated_label == 2.0) {
                        present_1m_activity = 6;
                    } else if(svm_estimated_label == 3.0) {
                        present_1m_activity = 10;
                    } else if(svm_estimated_label == 4.0) {
                        present_1m_activity = 12;
                    } else if(svm_estimated_label == 5.0) {
                        present_1m_activity = 14;
                    } else if(svm_estimated_label == 6.0) {
                        present_1m_activity = 16;
                    } else if(svm_estimated_label == 7.0) {
                        present_1m_activity = 18;
                    } else if(svm_estimated_label == 8.0) {
                        present_1m_activity = 20;
                    } else if(svm_estimated_label == 9.0) {
                        present_1m_activity = 22;
                    } else if(svm_estimated_label == 10.0) {
                        present_1m_activity = 24;
                    } else if(svm_estimated_label == 11.0) {
                        present_1m_activity = 26;
                    } else if(svm_estimated_label == 12.0) {
                        present_1m_activity = 28;
                    } else if(svm_estimated_label == 13.0) {
                        present_1m_activity = 40;
                    } else if(svm_estimated_label == 14.0) {
                        present_1m_activity = 42;
                    }
                }
            } else {
                var svm_feature:[Double] = [feature_data[4], feature_data[5], feature_data[6]]
                var x = Array(repeating: svm_node(), count : 3)
                for i in 0..<3 {
                    x[i].index = Int32(i + 1)
                    x[i].value = svm_feature[i];
                }
                svm_estimated_label=svm_predict(s_train_1,x)
                if(svm_estimated_label == 1.0) {
                    present_1m_activity = 4;
                } else if(svm_estimated_label == 2.0) {
                    present_1m_activity = 6;
                }
            }
        }
        
        // v5.3.6 start
        if (present_1m_activity == 6){
            if((feature_data[4] >= x_min1) && (feature_data[4] <= x_max1) && (feature_data[5] >= y_min1) && (feature_data[5] <= y_max1) && (feature_data[6] >= z_min1) && (feature_data[6] <= z_max1) && (feature_data[7] >= n_min) && (feature_data[7] <= n_max)){
                present_1m_activity = 6;
            }
            else if((feature_data[4] >= x_min2) && (feature_data[4] <= x_max2) && (feature_data[5] >= y_min2) && (feature_data[5] <= y_max2) && (feature_data[6] >= z_min2) && (feature_data[6] <= z_max2) && (feature_data[7] >= n_min) && (feature_data[7] <= n_max)){
                present_1m_activity = 6;
            }
            else if((feature_data[4] >= x_min3) && (feature_data[4] <= x_max3) && (feature_data[5] >= y_min3) && (feature_data[5] <= y_max3) && (feature_data[6] >= z_min3) && (feature_data[6] <= z_max3) && (feature_data[7] >= n_min) && (feature_data[7] <= n_max)){
                present_1m_activity = 6;
            }
            else if((feature_data[8] < 10) && (feature_data[10] > 30)){
                present_1m_activity = 4;
            }
            else if(feature_data[8] > 20){
                present_1m_activity = 12;
            }
            else{
                present_1m_activity = 4;
            }
        }
        // v5.3.6 end
        /*********************
         ** Classifying End **
         *********************/
        //        0 acc_var_x_axis(epoch,1)
        //        1 acc_var_y_axis(epoch,1)
        //        2 acc_var_z_axis(epoch,1)
        //        3 acc_var_norm(epoch,1)
        //        4 acc_mean_x_axis(epoch,1)
        //        5 acc_mean_y_axis(epoch,1)
        //        6 acc_mean_z_axis(epoch,1)
        //        7 acc_norm_mean(epoch,1)
        //        8 step_count
        //        9 jumping_rope_count
        //        10 small_swing_count
        //        11 large_swing_count
        //        12 pre_diff
        //        13 sum ampulitude_rtsl
        //        14 stepfrequency_rtsl
        
        //Final index setting
        /*****************************
         ** Protocol activity index **
         *****************************/
        //		0
        //		1
        //		2
        //		3
        //		4
        //		5
        //		6
        //		7
        //		10
        //		20
        //		21
        //		Unknown Activity	22
        
        
        if(present_1m_activity==2){
            estimated_activity[0] = 0.0
        }else if(present_1m_activity==4){
            estimated_activity[0] = 1.0
        }else if(present_1m_activity==6){
            estimated_activity[0] = 2.0
        }else if(present_1m_activity==8){
            estimated_activity[0] = 2.0
        }else if(present_1m_activity==10){
            estimated_activity[0] = 3.0
        }else if(present_1m_activity==12){
            estimated_activity[0] = 4.0
        }else if(present_1m_activity==14){
            estimated_activity[0] = 4.0
        }else if(present_1m_activity==16){
            estimated_activity[0] = 4.0
        }else if(present_1m_activity==18){
            estimated_activity[0] = 4.0
        }else if(present_1m_activity==20){
            estimated_activity[0] = 4.0
        }else if(present_1m_activity==22){
            estimated_activity[0] = 4.0
        }else if(present_1m_activity==24){
            estimated_activity[0] = 4.0
        }else if(present_1m_activity==26){
            estimated_activity[0] = 5.0
        }else if(present_1m_activity==28){
            estimated_activity[0] = 5.0
        }else if(present_1m_activity==30){
            estimated_activity[0] = 6.0
        }else if(present_1m_activity==32){
            estimated_activity[0] = 7.0
        }else if(present_1m_activity==34){
            estimated_activity[0] = 7.0
        }else if(present_1m_activity==36){
            estimated_activity[0] = 7.0
        }else if(present_1m_activity==38){
            estimated_activity[0] = 7.0
        }else if(present_1m_activity==40){
            estimated_activity[0] = 21.0
        }else if(present_1m_activity==42){
            estimated_activity[0] = 20.0
        }else if(present_1m_activity==44){
            estimated_activity[0] = 10.0
        }
        
        if(estimated_activity[0] == 1.0 && feature_data[8] >= 60.0){ // 2015.10.01 greencomm add 367line(15.12.23)
            estimated_activity[0] = 4.0
        }
        
        if(estimated_activity[0] == 4.0 && feature_data[12] >= -3.5 && feature_data[12] <= -1.0 && feature_data[8] >= 40.0){ // 2015.08.17 greencomm add
            estimated_activity[0] = 7.0
        }
        
        if(estimated_activity[0] == 2.0 && feature_data[8] >= 20.0){ // 2015.08.17 greencomm add
            estimated_activity[0] = 4.0
        }
        
        if(estimated_activity[0] == 3.0 && feature_data[8] >= 80.0){ // 2015.08.17 greencomm add
            estimated_activity[0] = 4.0
        }
        
        //
        estimated_activity[1] = feature_data[3]
        
        //
        estimated_activity[2] = feature_data[12]
        
        //
        estimated_activity[3] = feature_data[8]
        
        //
        estimated_activity[4] = feature_data[9]
        
        //small swing count
        estimated_activity[5] = feature_data[10]
        
        //large swing count
        estimated_activity[6] = feature_data[11]
        
        if(estimated_activity[3] > 0.0) {
            if(estimated_activity[0] == 4.0) {
                estimated_activity[7] = alpha * (feature_data[13] - n_ampl) + beta * (feature_data[14] - n_fre) + SL_0_walking;
            } else if(estimated_activity[0] == 6.0 && estimated_activity[0] == 7.0) {
                estimated_activity[7] = alpha * (feature_data[13] - n_ampl) + beta * (feature_data[14] - n_fre) + SL_0_hiking;
            } else if(estimated_activity[0] == 5.0 && estimated_activity[4] > 0.0) {
                estimated_activity[7] = SL_0_run;
            } else {
                estimated_activity[7] = alpha * (feature_data[13] - n_ampl) + beta * (feature_data[14] - n_fre) + SL_0_walking;
            }
        } else if(estimated_activity[0] == 5.0 && estimated_activity[4] > 0.0) {
            estimated_activity[7] = SL_0_run;
        } else {
            estimated_activity[7] = 0.0;
        }
        
        //printf("activity= %d, ",present_1m_activity)
        //printf("fin_activity= %.0f, ",estimated_activity[0])
        
        svm_free_and_destroy_model(&s_train_1)
        svm_free_and_destroy_model(&s_train_2)
        svm_free_and_destroy_model(&s_train_3)
        //free(node)
        return estimated_activity
    }
}
