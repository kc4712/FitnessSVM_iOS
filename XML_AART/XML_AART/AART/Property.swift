//
//  Property.swift
//  Swift_AART
//
//  Created by 심규창 on 2016. 6. 22..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

open class Property  {
    static let len:Int = 100
    static var counter:[Int] = Array(repeating: 0, count: len)
    static var flag = Array(repeating: Bool(), count: len)
    
    static var summary:[Double] = Array(repeating: 0, count: len)
    static var global:[Double] = Array(repeating: 0, count: len)
    
    public final class X {
        public static let peak:Int = 1;
        public static let time_index:Int = peak + 1;
        public static let peak_value:Int = time_index + 1;
        public static let peak_to_peak:Int = peak_value + 1;
        public static let surface:Int = peak_to_peak + 1;
        public static let amplitude:Int = surface + 1;
        public static let cross_peak_to_peak:Int = amplitude + 1;
        public static let acc_var:Int = cross_peak_to_peak + 1;
        public static let acc_smooth:Int = acc_var + 1;
        public static let acc_diff:Int = acc_smooth + 1;
        public static let surface_2:Int = acc_diff + 1;
    }
    
    public final class Y {
        public static let peak:Int = 21;
        public static let time_index:Int = peak + 1;
        public static let peak_value:Int = time_index + 1;
        public static let peak_to_peak:Int = peak_value + 1;
        public static let surface:Int = peak_to_peak + 1;
        public static let amplitude:Int = surface + 1;
        public static let cross_peak_to_peak:Int = amplitude + 1;
        public static let acc_var:Int = cross_peak_to_peak + 1;
        public static let acc_smooth:Int = acc_var + 1;
        public static let acc_diff:Int = acc_smooth + 1;
        public static let surface_2:Int = acc_diff + 1;
    }
    
    public final class Z {
        public static let peak:Int = 41;
        public static let time_index:Int = peak + 1;
        public static let peak_value:Int = time_index + 1;
        public static let peak_to_peak:Int = peak_value + 1;
        public static let surface:Int = peak_to_peak + 1;
        public static let amplitude:Int = surface + 1;
        public static let cross_peak_to_peak:Int = amplitude + 1;
        public static let acc_var:Int = cross_peak_to_peak + 1;
        public static let acc_smooth:Int = acc_var + 1;
        public static let acc_diff:Int = acc_smooth + 1;
        public static let surface_2:Int = acc_diff + 1;
    }
    
    public final class N {
        public static let peak:Int = 61;
        public static let time_index:Int = peak + 1;
        public static let peak_value:Int = time_index + 1;
        public static let peak_to_peak:Int = peak_value + 1;
        public static let surface:Int = peak_to_peak + 1;
        public static let amplitude:Int = surface + 1;
        public static let cross_peak_to_peak:Int = amplitude + 1;
        public static let acc_var:Int = cross_peak_to_peak + 1;
        public static let acc_smooth:Int = acc_var + 1;
        public static let acc_diff:Int = acc_smooth + 1;
        public static let surface_2:Int = acc_diff + 1;
    }
    
    public final class Calculate {
        public final class Div {
            
        }
        
        public final class Sub {
            public static let amplitudeX_amplitudeZ:Int = 141;
        }
        
        public final class Add {
            public static let amplitudeX_amplitudeZ:Int = 161;
            public static let peak_valueX_peak_valueZ:Int = amplitudeX_amplitudeZ + 1;
        }
        
        public final class Mul {
            public static let sqrt_amplitudeX_pow2_amplitudeZ_pow2:Int = 201;
            public static let sqrt_acc_smoothX_pow2_acc_smoothZ_pow2:Int = sqrt_amplitudeX_pow2_amplitudeZ_pow2 + 1;
        }
        
        public final class Special {
            public static let V_6_2:Int = 501;
            public static let V_8_3_1:Int = V_6_2 + 1;
            public static let V_8_3_2:Int = V_8_3_1 + 1;
            public static let V_8_5:Int = V_8_3_2 + 1;
            public static let V_8_7_1:Int = V_8_5 + 1;
            public static let V_8_7_2:Int = V_8_7_1 + 1;
            public static let V_9_7:Int = V_8_7_2 + 1;
            public static let bufferY:Int = V_9_7 + 1;
            
            public static let V_6_2_PRE:Int = bufferY + 1;
            public static let V_8_3_PRE:Int = V_6_2_PRE + 1;
            public static let V_8_5_PRE:Int = V_8_3_PRE + 1;
            public static let V_8_7_PRE:Int = V_8_5_PRE + 1;
            public static let V_9_7_PRE:Int = V_8_7_PRE + 1;
        }
    }
}
