//
//  TrainerCode.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 19..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

enum TrainerCode: Int {
    case 기초, 이주영, 홍두한, 권도예
    
    var photoNumber: Int {
        switch self {
        case .기초:
            return 0
        case .이주영:
            return 2
        case .홍두한:
            return 2
        case .권도예:
            return 3
        }
    }
    
    var trainerNumber: Int {
        return 3
    }
    
    var programList: [ProgramCode] {
        switch self {
        case .기초:
            return []
        case .이주영:
            return [ProgramCode.복근완성, ProgramCode.완벽뒤태]
        case .홍두한:
            return [ProgramCode.바디1, ProgramCode.바디2]
        case .권도예:
            return [ProgramCode.출산부1, ProgramCode.출산부2]
        }
    }
    
    var profileTrainerHtml: String {
        var name = ""
        switch self {
        case .기초:
            name = ""
        case .이주영:
            name = Common.ResString("html_lee_joo_young_profile_name")
        case .홍두한:
            name = Common.ResString("html_hong_doo_han_profile_name")
        case .권도예:
            name = Common.ResString("html_kwon_do_ye_profile_name")
        }
        
        return name
    }
}

enum ProgramCode: Int {
    case 기초 = 1, 전신, 매트, 액티브, 복근완성 = 101, 완벽뒤태, 바디1 = 201, 바디2, 출산부1 = 301, 출산부2
    
    var programName: String {
        var name = ""
        switch self {
        case .복근완성:
            name = Common.ResString("program_name_lee_joo_young_1")
        case .완벽뒤태:
            name = Common.ResString("program_name_lee_joo_young_2")
        case .바디1:
            name = Common.ResString("program_name_tbt1")
        case .바디2:
            name = Common.ResString("program_name_tbt2")
        case .출산부1:
            name = Common.ResString("program_name_baby_1")
        case .출산부2:
            name = Common.ResString("program_name_baby_2")
        default:
            break
        }
        
        return name
    }
    
    var htmlName: String {
        var name = ""
        switch self {
        case .기초:
            name = Common.ResString("html_name_prepare_exer")
        case .매트:
            name = Common.ResString("html_name_mat")
        case .액티브:
            name = Common.ResString("html_name_active")
        case .전신:
            name = Common.ResString("html_name_15min")
        case .복근완성:
            name = Common.ResString("html_name_lee_joo_young_1")
        case .완벽뒤태:
            name = Common.ResString("html_name_lee_joo_young_2")
        case .바디1:
            name = Common.ResString("html_name_tbt1")
        case .바디2:
            name = Common.ResString("html_name_tbt2")
        case .출산부1:
            name = Common.ResString("html_name_baby_1")
        case .출산부2:
            name = Common.ResString("html_name_baby_2")
        }
        
        return name
    }
    
    var xmlName: String {
        var name = ""
        switch self {
        case .매트:
            name = "Video_mat.xml"
        case .액티브:
            name = "Video_active.xml"
        case .전신:
            name = "Video_15min.xml"
        case .복근완성:
            name = "Video_lee_1.xml"
        case .완벽뒤태:
            name = "Video_lee_2.xml"
        case .바디1:
            name = "Video_hong_1.xml"
        case .바디2:
            name = "Video_hong_2.xml"
        case .출산부1:
            name = "Video_baby_1.xml"
        case .출산부2:
            name = "Video_baby_2.xml"
        default:
            break
        }
        
        return name
    }
    
    var xmlNameForVersion: String {
        var name = ""
        switch self {
        case .매트:
            name = "Video_002.xml"
        case .액티브:
            name = "Video_003.xml"
        case .전신:
            name = "Video_004.xml"
        case .복근완성:
            name = "Video_101.xml"
        case .완벽뒤태:
            name = "Video_102.xml"
        case .바디1:
            name = "Video_201.xml"
        case .바디2:
            name = "Video_202.xml"
        case .출산부1:
            name = "Video_301.xml"
        case .출산부2:
            name = "Video_302.xml"
        default:
            break
        }
        
        return name
    }
    
//    var queryCode: XmlVersionCode {
//        var code: XmlVersionCode = .Version002
//        switch self {
//        case .매트:
//            code = .Version002
//        case .액티브:
//            code = .Version003
//        case .전신:
//            code = .Version004
//        case .복근완성:
//            code = .Version101
//        case .완벽뒤태:
//            code = .Version102
//        case .바디1:
//            code = .Version201
//        case .바디2:
//            code = .Version202
//        case .출산부1:
//            code = .Version301
//        case .출산부2:
//            code = .Version302
//        default:
//            break
//        }
//        
//        return code
//    }
    
    enum BasicCode: Int {
        case 기초1 = 1, 기초2, 기초3, 기초4, 기초5, 기초6, 기초7, 기초8
    }
}