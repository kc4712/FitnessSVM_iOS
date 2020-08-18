//
//  ConnectViewController.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 2. 29..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare;

class SelectScreen : BaseViewController
{
    override func viewDidLoad() {
        print("VC: 접속화면");
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 네비게이션바 감추기
        hideNavigationBar();
    }
}
