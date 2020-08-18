//
//  LifeCycleViewController.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 2. 29..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit


class LifeCycleViewController : UIViewController
{
    //----------------------------------------------------------
    // 뷰의 생명 주기
    //----------------------------------------------------------
    
    override func loadView() {
        super.loadView();
        print("BVC: \(classNameSample) - loadView");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        print("BVC: \(classNameSample) - viewDidLoad");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        print("BVC: \(classNameSample) - viewWillAppear");
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        print("BVC: \(classNameSample) - viewDidAppear");
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        print("BVC: \(classNameSample) - viewWillDisappear");
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        print("BVC: \(classNameSample) - viewDidDisappear");
    }
    
    var classNameSample: String {
        get {
            let name = String(describing: type(of: self));
            return name;
        }
    }
}
