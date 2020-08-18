//
//  MessageIndex.swift
//  Swift_MW_AART
//
//  Created by 양정은 on 2016. 6. 28..
//  Copyright © 2016년 심규창. All rights reserved.
//

import Foundation

public enum MessageIndex: Int {
    case random1 = 1001, random2, random3, random4
    case bad = 1011, move, rest
    case heart = 1021
    case all_100 = 1031, all_90_OVER, all_90_60_BETWEEN, all_60_30_BETWEEN, all_30_UNDER, all_10_UNDER, acc_90_OVER_COUNT_60_UNDER, acc_90_OVER_COUNT_90_60_BETWEEN,
    acc_90_OVER_COUNT_20_UNDER, acc_90_60_BETWEEN_COUNT_60_30_BETWEEN, acc_90_60_BETWEEN_COUNT_30_UNDER, acc_60_UNDER_COUNT_30_UNDER,
    acc_30_10_BETWEEN_COUNT_10_UNDER, count_90_OVER_ACC_60_UNDER, count_90_OVER_ACC_90_60_BETWEEN, count_90_OVER_ACC_20_UNDER,
    count_90_60_BETWEEN_ACC_60_30_BETWEEN, count_90_60_BETWEEN_ACC_30_UNDER, count_60_UNDER_ACC_30_UNDER, count_30_10_BETWEEN_ACC_10_UNDER
}
