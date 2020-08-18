//
//  DeviceRegister.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 20..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation
import UIKit;

class DeviceRegister : BaseViewController, UINavigationBarDelegate
{
    override func viewDidLoad() {
        print("Load: 기기설정하기(등록)");
        super.viewDidLoad();
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.delegate = self
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
//        performSegueWithIdentifier("unwindToSetting", sender: nil)
//        navigationController?.popToRootViewControllerAnimated(false)
        
        return false
    }
    
    @IBAction func ButtonRegisterTouchUp(_ sender: AnyObject) {
        performSegue(withIdentifier: "DeviceType", sender: self);
    }
}
