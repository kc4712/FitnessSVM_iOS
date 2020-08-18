//
//  SuccessCreate.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 10..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare

class SuccessCreate : BaseViewController
{
    override func viewDidLoad() {
        print("VC: 회원등록 성공 화면");
        super.viewDidLoad();
        
        // 블루투스 장치 초기화를 위한 객체 호출. 회원가입만 먼저 호출. 다른 부분은 메인화면에서 호출.
        // MWControlCenter.getInstance();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 네비게이션 바 보이기
        showNavigationBar();
        // 네비게이션 아이템 - 백 버튼 감추기
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
}
