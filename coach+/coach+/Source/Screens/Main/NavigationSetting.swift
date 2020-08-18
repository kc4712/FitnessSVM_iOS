//
//  NavigationSetting.swift
//  CoachPlus
//
//  Created by 김영일 이사 on 2016. 8. 4..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import MiddleWare

class NavigationSetting: UINavigationController {
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        print("@@@@@@@@@@@ \(String(describing: self.topViewController?.className))");
        // 하고픈 일을 해야 할 상태라면
        if (self.topViewController?.className == "DeviceRegister")
        {
            self.popToRootViewController(animated: true)
            // 하고픈 일을 한다.
            return false;
        }
        else
        {
            self.popViewController(animated: true);
            return true;
        }
    }
    
}
