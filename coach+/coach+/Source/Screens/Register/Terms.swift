//
//  Terms.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 9..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;

class TermsScreen : BaseViewController
{
    @IBOutlet var m_webView: UIWebView!
    
    override func viewDidLoad() {
        print("VC: 이용약관 화면");
        super.viewDidLoad();
        
        // 로컬에 저장된 웹 문서 로딩
        let localfilePath = Bundle.main.url(forResource: Common.ResString("html_terms"), withExtension: "html");
        let myRequest = URLRequest(url: localfilePath!);
        m_webView.loadRequest(myRequest);

    }
}
