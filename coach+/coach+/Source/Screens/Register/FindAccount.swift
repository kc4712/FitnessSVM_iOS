//
//  FindAccount.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 27..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;

class FindAccount : BaseViewController
{
    @IBOutlet var m_webView: UIWebView!
    
    override func viewDidLoad() {
        print("VC: 이메일 비밀번호 찾기");
        super.viewDidLoad();
        
        // 로컬에 저장된 웹 문서 로딩
        //let localfilePath = NSBundle.mainBundle().URLForResource("terms", withExtension: "html");
        let url = URL(string: Common.ResString("find_account_url"));
        let myRequest = URLRequest(url: url!);
        m_webView.loadRequest(myRequest);
    }
}
