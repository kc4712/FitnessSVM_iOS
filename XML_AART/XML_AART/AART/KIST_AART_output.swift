//
//  KIST_AART_output.swift
//  Swift_AART
//
//  Created by 심규창 on 2016. 6. 5..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

open class KIST_AART_output : Property, pActionData
{
    //private static let tag = KIST_AART_output.className
    
    open var peak_x:Int = 0
    open var time_index_x:Int = 0
    open var peak_value_x:Double = 0
    open var peak_to_peak_x:Int = 0
    open var surface_x:Double = 0
    open var amplitude_x:Double = 0
    open var cross_peak_to_peak_x:Int = 0
    open var acc_var_x:Double = 0
    open var acc_smooth_x:Double = 0
    open var acc_diff_x:Double = 0
    open var surface_x2:Double = 0
    
    open var peak_y:Int = 0
    open var time_index_y:Int = 0
    open var peak_value_y:Double = 0
    open var peak_to_peak_y:Int = 0
    open var surface_y:Double = 0
    open var amplitude_y:Double = 0
    open var cross_peak_to_peak_y:Int = 0
    open var acc_var_y:Double = 0
    open var acc_smooth_y:Double = 0
    open var acc_diff_y:Double = 0
    open var surface_y2:Double = 0
    
    open var peak_z:Int = 0
    open var time_index_z:Int = 0
    open var peak_value_z:Double = 0
    open var peak_to_peak_z:Int = 0
    open var surface_z:Double = 0
    open var amplitude_z:Double = 0
    open var cross_peak_to_peak_z:Int = 0
    open var acc_var_z:Double = 0
    open var acc_smooth_z:Double = 0
    open var acc_diff_z:Double = 0
    open var surface_z2:Double = 0
    
    open var peak_norm:Int = 0
    open var time_index_norm:Int = 0
    open var peak_value_norm:Double = 0
    open var peak_to_peak_norm:Int = 0
    open var surface_norm:Double = 0
    open var amplitude_norm:Double = 0
    open var cross_peak_to_peak_norm:Int = 0
    open var acc_var_norm:Double = 0
    open var acc_smooth_norm:Double = 0
    open var acc_diff_norm:Double = 0
    open var surface_norm2:Double = 0
    
    
    public override init()
    {
        //super.init()
        peak_x = 0
        time_index_x = 0
        peak_value_x = 0.0
        peak_to_peak_x = 0
        surface_x = 0.0
        amplitude_x = 0.0
        cross_peak_to_peak_x = 0
        acc_var_x = 0.0
        acc_smooth_x = 0.0
        acc_diff_x = 0.0
        surface_x2 = 0.0
        
        peak_y = 0
        time_index_y = 0
        peak_value_y = 0.0
        peak_to_peak_y = 0
        surface_y = 0.0
        amplitude_y = 0.0
        cross_peak_to_peak_y = 0
        acc_var_y = 0.0
        acc_smooth_y = 0.0
        acc_diff_y = 0.0
        surface_y2 = 0.0
        
        peak_z = 0
        time_index_z = 0
        peak_value_z = 0.0
        peak_to_peak_z = 0
        surface_z = 0.0
        amplitude_z = 0.0
        cross_peak_to_peak_z = 0
        acc_var_z = 0.0
        acc_smooth_z = 0.0
        acc_diff_z = 0.0
        surface_z2 = 0.0
        
        peak_norm = 0
        time_index_norm = 0
        peak_value_norm = 0.0
        peak_to_peak_norm = 0
        surface_norm = 0.0
        amplitude_norm = 0.0
        cross_peak_to_peak_norm = 0
        acc_var_norm = 0.0
        acc_smooth_norm = 0.0
        acc_diff_norm = 0.0
        surface_norm2 = 0.0
    }
    deinit{
        print("KIST_AART_output해제")
    }
    
    /** 저작도구 작업 **/
    // Delegate
    open func GetValue(_ index:Int) -> Double {
        var value:Double = 0
        //print("Kist_Output_Index:\(index)")
        switch (index) {
        case X.peak:
            value = Double(peak_x)
            break
        case X.time_index:
            value = Double(time_index_x)
            break
        case X.peak_value:
            value = peak_value_x
            break
        case X.peak_to_peak:
            value = Double(peak_to_peak_x)
            break
        case X.surface:
            value = surface_x
            break
        case X.amplitude:
            value = amplitude_x
            break
        case X.cross_peak_to_peak:
            value = Double(cross_peak_to_peak_x)
            break
        case X.acc_var:
            value = acc_var_x
            break
        case X.acc_smooth:
            value = acc_smooth_x
            break
        case X.acc_diff:
            value = acc_diff_x
            break
        case X.surface_2:
            value = surface_x2
            break
            
        case Y.peak:
            value = Double(peak_y)
            break
        case Y.time_index:
            value = Double(time_index_y)
            break
        case Y.peak_value:
            value = peak_value_y
            break
        case Y.peak_to_peak:
            value = Double(peak_to_peak_y)
            break
        case Y.surface:
            value = surface_y
            break
        case Y.amplitude:
            value = amplitude_y
            break
        case Y.cross_peak_to_peak:
            value = Double(cross_peak_to_peak_y)
            break
        case Y.acc_var:
            value = acc_var_y
            break
        case Y.acc_smooth:
            value = acc_smooth_y
            break
        case Y.acc_diff:
            value = acc_diff_y
            break
        case Y.surface_2:
            value = surface_y2
            break
            
        case Z.peak:
            value = Double(peak_z)
            break
        case Z.time_index:
            value = Double(time_index_z)
            break
        case Z.peak_value:
            value = peak_value_z
            break
        case Z.peak_to_peak:
            value = Double(peak_to_peak_z)
            break
        case Z.surface:
            value = surface_z
            break
        case Z.amplitude:
            value = amplitude_z
            break
        case Z.cross_peak_to_peak:
            value = Double(cross_peak_to_peak_z)
            break
        case Z.acc_var:
            value = acc_var_z
            break
        case Z.acc_smooth:
            value = acc_smooth_z
            break
        case Z.acc_diff:
            value = acc_diff_z
            break
        case Z.surface_2:
            value = surface_z2
            break
            
        case N.peak:
            value = Double(peak_norm)
            break
        case N.time_index:
            value = Double(time_index_norm)
            break
        case N.peak_value:
            value = Double(peak_value_norm)
            break
        case N.peak_to_peak:
            value = Double(peak_to_peak_norm)
            break
        case N.surface:
            value = surface_norm
            break
        case N.amplitude:
            value = amplitude_norm
            break
        case N.cross_peak_to_peak:
            value = Double(cross_peak_to_peak_norm)
            break
        case N.acc_var:
            value = acc_var_norm
            break
        case N.acc_smooth:
            value = acc_smooth_norm
            break
        case N.acc_diff:
            value = acc_diff_norm
            break
        case N.surface_2:
            value = surface_norm2
            break
            
        case Calculate.Sub.amplitudeX_amplitudeZ:
            value = amplitude_x - amplitude_z
            break
        case Calculate.Add.amplitudeX_amplitudeZ:
            value = amplitude_x + amplitude_z
            break
        case Calculate.Add.peak_valueX_peak_valueZ:
            value = peak_value_x + peak_value_z
            break
        case Calculate.Mul.sqrt_acc_smoothX_pow2_acc_smoothZ_pow2:
            value = sqrt(acc_smooth_x * acc_smooth_x + acc_smooth_z * acc_smooth_z)
            break
        case Calculate.Mul.sqrt_amplitudeX_pow2_amplitudeZ_pow2:
            value = sqrt(amplitude_x * amplitude_x + amplitude_z * amplitude_z)
            break
        case Calculate.Special.V_6_2:
            value = v_6_2()
            break
        case Calculate.Special.V_8_3_1:
            value = v_8_3_1()
            break
        case Calculate.Special.V_8_3_2:
            value = v_8_3_2()
            break
        case Calculate.Special.V_8_5:
            value = v_8_5()
            break
        case Calculate.Special.V_8_7_1:
            value = v_8_7_1()
            break
        case Calculate.Special.V_8_7_2:
            value = v_8_7_2()
            break
        case Calculate.Special.V_9_7:
            value = v_9_7()
            break
        case Calculate.Special.bufferY:
            value = bufferY()
            break
        case Calculate.Special.V_6_2_PRE:
            v_6_2_pre()
            break
        case Calculate.Special.V_8_3_PRE:
            v_8_3_pre()
            break
        case Calculate.Special.V_8_5_PRE:
            v_8_5_pre()
            break
        case Calculate.Special.V_8_7_PRE:
            v_8_7_pre()
            break
        case Calculate.Special.V_9_7_PRE:
            v_9_7_pre()
            break
        default:
            break
        }
        
        return value;
    }
    
    /** 이하 메서드들은 나중에 정리가 필요함. 삭제하거나, 수정하여 재사용가능한 형태로 만들거나...**/
    open func v_6_2_pre() {
        //		System.out.println(String.format("6_2-> var z[%f] var x[%f] diffy[%f] smoothz[%f] smoothx[%f]",
        //				acc_var_z, acc_var_x, acc_diff_y, acc_smooth_z, acc_smooth_x));
        if ((acc_var_z + acc_var_x <= 100) && (acc_diff_y < 0) && (acc_smooth_z + acc_smooth_x > 6)) {
            Property.global[0] = (Property.global[1] + 1);
        } else if ((acc_smooth_z + acc_smooth_x <= 0) && (Property.global[2] + acc_smooth_x > 0)) {
            Property.global[0] = 0;
        } else {
            Property.global[0] = Property.global[1];
        }
        
        if ((Property.global[0] == 0) && (Property.global[1] > 0)) {
            Property.global[3] = Property.global[1];
        }
        
        Property.global[1] = Property.global[0];
        Property.global[2] = acc_smooth_z + acc_smooth_x;
    }
    
    open func v_6_2() -> Double {
        return Property.global[3];
    }
    
    /** 8_3_1 호출 뒤, 8_3_2 써야함 **/
    open func v_8_3_pre() {
        if (acc_smooth_z > 9) {
            Property.global[0] = Property.global[1] + 0.9;
            Property.global[2] = Property.global[3] + 1;
        } else if (acc_smooth_z > 8) {
            Property.global[0] = Property.global[1] + 0.8;
            Property.global[2] = Property.global[3] + 1;
        } else if (acc_smooth_z > 7) {
            Property.global[0] = Property.global[1] + 0.7;
            Property.global[2] = Property.global[3] + 1;
        } else if (acc_smooth_z > 6) {
            Property.global[0] = Property.global[1] + 0.6;
            Property.global[2] = Property.global[3] + 1;
        } else if ((acc_smooth_z > 0) && (Property.global[4] < 0)) {
            Property.global[0] = 0;
            Property.global[2] = 0;
        } else {
            Property.global[0] = Property.global[1];
            Property.global[2] = Property.global[3];
        }
        
        if ((Property.global[0] == 0) && (Property.global[1] > 0)) {
            Property.global[5] = Property.global[1];
            Property.global[6] = Property.global[3];
        }
        Property.global[1] = Property.global[0];
        Property.global[3] = Property.global[0];
        Property.global[4] = acc_smooth_z;
    }
    
    open func v_8_3_1() -> Double {
        return Property.global[5];
    }
    
    open func v_8_3_2() -> Double {
        return Property.global[6];
    }
    
    open func v_8_5_pre() {
        if ((acc_var_z <= 50) && (acc_diff_y < 0) && (acc_smooth_z > 3)) {
            Property.global[0] = (Property.global[1] + 1);
//            print("count[\(Property.global[0])] var z[\(acc_var_z)] diffy[\(acc_diff_y)] smoothz[\(acc_smooth_z)]")
        } else if ((acc_smooth_z <= 0) && (Property.global[2] > 0)) {
//            print("count[\(Property.global[0])] glo2[\(Property.global[2])] smoothz[\(acc_smooth_z)]");
            Property.global[0] = 0;
        } else {
            Property.global[0] = Property.global[1];
        }
        
        if ((Property.global[0] == 0) && (Property.global[1] > 0)) {
            Property.global[3] = Property.global[1];
        }
        
        Property.global[1] = Property.global[0];
        Property.global[2] = acc_smooth_z;
    }
    
    open func v_8_5() -> Double {
        return Property.global[3];
    }
    
    open func v_8_7_pre() {
        if ((sqrt(acc_smooth_x * acc_smooth_x + acc_smooth_z * acc_smooth_z) > 6) && (acc_smooth_y > 4)) {
            Property.global[0] = (Property.global[1] + 1);
        } else if (acc_smooth_y < 0) {
            Property.global[0] = 0;
        } else {
            Property.global[0] = Property.global[1];
        }
        
        if ((Property.global[0] == 0) && (Property.global[1] > 0)){
            Property.global[2] = Property.global[1];
        }
        else {
            Property.global[2] = Property.global[3];
        }
        Property.global[3] = Property.global[2];
        Property.global[1] = Property.global[0];
        
        if (peak_y == 1 && amplitude_y >= 6) {
            Property.global[4] = amplitude_y;
        }
    }
    
    open func v_8_7_1() -> Double {
        /** 로직을 그냥 넣음 **/
        return Property.global[4] == 0 ? 5 : Property.global[4] / 20;
    }
    
    open func v_8_7_2() -> Double {
        return Property.global[2];
    }
    
    open func v_9_7_pre() {
        if (acc_smooth_y > 2) {
            Property.global[0] = Property.global[1] + 1;
        } else {
            Property.global[0] = 0;
        }
        if (Property.global[0] == 0 && Property.global[1] > 0) {
            Property.global[2] = Property.global[1];
        }
        Property.global[1] = Property.global[0];
    }
    
    open func v_9_7() -> Double {
        return Property.global[2];
    }
    
    open func bufferY() -> Double {
        let pre_acc_smooth_y = Property.global[99];
        Property.global[99] = acc_smooth_y;
        return pre_acc_smooth_y;
    }
    
    
    open func ResetGlobal() {
        for i in 0..<Property.len {
            Property.global[i] = 0;
        }
    }
    /** 메서드 끝 **/
    
    fileprivate func valid(_ index:Int) -> Bool {
        if (index > Property.len - 1 || index < 0){
            return false
        }
        return true
    }
    
    //Delegate
    open func SetFlag(_ index:Int, flag:Bool) {
        if (!valid(index)){
            return
        }
        Property.flag[index] = flag;
    }
    
    //Delegate
    open func GetFlag(_ index:Int) -> Double {
        if (!valid(index)){
            return 0
        }
        
        return Property.flag[index] == true ? 1 : 0
    }
    
    
    open func IncCounter(_ index:Int) {
        if (!valid(index)){
            return
        }
        
        Property.counter[index] += 1
    }
    
    
    open func GetCounter(_ index:Int) -> Double {
        if (!valid(index)){
            return 0
        }
        
        return Double(Property.counter[index])
    }
    
    
    open func GetExtend(_ index:Int) -> Double {
        /*
         * if(!valid(index)) return 0;
         */
        return 0;
    }
    
    //Delegate
    open func ResetFlag() {
        for i in 0..<Property.len {
            Property.flag[i] = false
        }
    }
    
    
    open func ResetCounter() {
        for i in 0..<Property.len {
            Property.counter[i] = 0;
        }
    }
    
    //Delegate
    open func Reset() {
        //print("delegate@@@@@call")
        ResetCounter();
        ResetFlag();
        ResetSummary();
        //ResetGlobal();
    }
    
    //Delegate
    open func ResetSummary() {
        for i in 0..<Property.len {
            Property.summary[i] = 0
        }
    }
    
    //Delegate
    open func Summary(_ index:Int, val:Double) {
        if (!valid(index)){
            return
        }
        
        Property.summary[index] += val
    }
    
    open func GetSummary(_ index:Int) -> Double {
        if (!valid(index)){
            return 0
        }
    
        return Property.summary[index]
    }
    
}
