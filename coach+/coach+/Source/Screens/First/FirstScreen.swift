//
//  FirstScreen.swift
//  PlannerApp
//
//  Created by 김영일 이사 on 2016. 4. 28..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare;

// 앱이 시작되고 최초로 로딩되는 빈 화면
// 이때 자동로그인 등의 상태에 따라 필요한 스토리보드를 로딩하여
// 실질적인 시작화면을 표시한다.
class FirstScreen : BaseViewController
{
    override func viewDidLoad() {
        print("VC: 퍼스트 화면");
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NextScreen();
    }

    func NextScreen() {
        if (Preference.AutoLogin == true) {
            
            print("자동 로그인 처리");
            Common.changeScreen(self, story: "Main", view: "Main");
            return;
        }
        print("사용자 등록 처리");
        Common.changeScreen(self, story: "Main", view: "Load");
        //Common.changeScreen(self, story: "Register", view: "Plan");
    }
}
