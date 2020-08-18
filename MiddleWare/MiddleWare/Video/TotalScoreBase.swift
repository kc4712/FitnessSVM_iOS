//
//  TotalScoreBase.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 7. 1..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

class TotalScoreBase: PeripheralBase {
    var TotalScoreDic: [Int : String] = [:]
    
    func getCommentSection(_ count_percent:Int, accuracy_percent:Int) -> String{
        let comment:String = "";
        var set:Int32 = 0;
        
        if(count_percent == 100 && accuracy_percent == 100){
            return TotalScoreDic[MessageIndex.all_100.rawValue]!
        }
        
        if(count_percent >= 90) { // 100~90
            set = 0x01;
        } else if(count_percent >= 60) { // 90~60
            set = 0x02;
        } else if(count_percent >= 30) { // 60~30
            set = 0x04;
        } else if(count_percent >= 20) { // 30~20
            set = 0x08;
        } else if(count_percent >= 10) { // 20~10
            set = 0x10;
        } else { // 10~
            set = 0x20;
        }
        
        if(accuracy_percent >= 90) { // 100~90
            set |= 0x40;
        } else if(accuracy_percent >= 60) { // 90~60
            set |= 0x80;
        } else if(accuracy_percent >= 30) { // 60~30
            set |= 0x100;
        } else if(accuracy_percent >= 20) { // 30~20
            set |= 0x200;
        } else if(accuracy_percent >= 10) { // 20~10
            set |= 0x400;
        } else { // 10~
            set |= 0x800;
        }
        set &= 0xffff;
        
        switch(set) {
        case Int32(0x41): // 양쪽다 90 이상.
            return TotalScoreDic[MessageIndex.all_90_OVER.rawValue]!
        case Int32(0x82): // 양쪽다 90~60.
            return TotalScoreDic[MessageIndex.all_90_60_BETWEEN.rawValue]!
        case Int32(0x104): // 양쪽다 60~30.
            return TotalScoreDic[MessageIndex.all_60_30_BETWEEN.rawValue]!
        case Int32(0x208),Int32(0x210),Int32(0x408),Int32(0x410): // 양쪽다 30~20, 20~10
            return TotalScoreDic[MessageIndex.all_30_UNDER.rawValue]!
        case Int32(0x820): // 양쪽다 10미만
            return TotalScoreDic[MessageIndex.all_10_UNDER.rawValue]!
        case Int32(0x101), Int32(0x201): // 횟수 90이상, 정확도 60미만.
            return TotalScoreDic[MessageIndex.count_90_OVER_ACC_20_UNDER.rawValue]!
        case Int32(0x81): // 횟수 90이상, 정확도 90~60.
            return TotalScoreDic[MessageIndex.count_90_OVER_ACC_90_60_BETWEEN.rawValue]!
        case Int32(0x401), Int32(0x801): // 횟수 90이상, 정확도 20미만.
            return TotalScoreDic[MessageIndex.count_90_OVER_ACC_20_UNDER.rawValue]!
        case Int32(0x102): // 횟수 90~60, 정확도 60~30.
            return TotalScoreDic[MessageIndex.count_90_60_BETWEEN_ACC_60_30_BETWEEN.rawValue]!
        case Int32(0x202), Int32(0x402), Int32(0x802):// 횟수 90~60, 정확도 30미만.
            return TotalScoreDic[MessageIndex.count_90_60_BETWEEN_ACC_30_UNDER.rawValue]!
        case Int32(0x204), Int32(0x404), Int32(0x804):// 횟수 60~30, 정확도 30미만.
            return TotalScoreDic[MessageIndex.count_60_UNDER_ACC_30_UNDER.rawValue]!
        case Int32(0x808), Int32(0x810): // 횟수 30~10, 정확도 10미만.
            return TotalScoreDic[MessageIndex.count_30_10_BETWEEN_ACC_10_UNDER.rawValue]!
        case Int32(0x44), Int32(0x48): // 정확도 90이상, 횟수 60미만.
            return TotalScoreDic[MessageIndex.acc_90_OVER_COUNT_60_UNDER.rawValue]!
        case Int32(0x42): // 정확도 90이상, 횟수 90~60.
            return TotalScoreDic[MessageIndex.acc_90_OVER_COUNT_90_60_BETWEEN.rawValue]!
        case Int32(0x50), Int32(0x60): // 정확도 90이상, 횟수 20미만.
            return TotalScoreDic[MessageIndex.acc_90_OVER_COUNT_20_UNDER.rawValue]!
        case Int32(0x84): // 정확도 90~60, 횟수 60~30.
            return TotalScoreDic[MessageIndex.acc_90_60_BETWEEN_COUNT_60_30_BETWEEN.rawValue]!
        case Int32(0x88), Int32(0x90), Int32(0xa0): // 정확도 90~60, 횟수 30미만.
            return TotalScoreDic[MessageIndex.acc_90_60_BETWEEN_COUNT_30_UNDER.rawValue]!
        case Int32(0x108), Int32(0x110), Int32(0x120):// 정확도 60~30, 횟수 30미만.
            return TotalScoreDic[MessageIndex.acc_60_UNDER_COUNT_30_UNDER.rawValue]!
        case Int32(0x220), Int32(0x420):// 정확도 30~10, 횟수 10미만.
            return TotalScoreDic[MessageIndex.acc_30_10_BETWEEN_COUNT_10_UNDER.rawValue]!
        default:
            break;
        }
        
        return comment;
    }
}
