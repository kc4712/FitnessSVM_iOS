//
//  SettingWebViewScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 29..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

class SettingWebViewScreen: BaseViewController {
    var m_name: String = ""
    
    @IBOutlet var m_webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // 로컬에 저장된 웹 문서 로딩
        let url = (m_name.hasPrefix("http") ? URL(string: m_name) : Bundle.main.url(forResource: m_name, withExtension: "html"));
        let myRequest = URLRequest(url: url!);
        m_webView.loadRequest(myRequest);
    }
}
