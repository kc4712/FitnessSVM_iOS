//
//  NavigationHome.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 18..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import MiddleWare

class NavigationMyCoach: UINavigationController {
    override func viewWillAppear(_ animated: Bool) {
        if let vc = selectMainView() {
            self.setViewControllers([vc], animated: false)
        }
    }
    
    private func selectMainView() -> UIViewController? {
        let name = Preference.getBluetoothName()
        if let prefix = name?.substringToIndex(ProductCode.coach.bluetoothDeviceName.length) {
            // 디버깅 루틴
            //prefix = "CF"
            switch prefix {
            case ProductCode.coach.bluetoothDeviceName:
                return BaseViewController.getViewController("Main", "MyCoach_Cup")
            case ProductCode.fitness.bluetoothDeviceName:
                return BaseViewController.getViewController("Main", "MyCoach_Today")
            default:
                return BaseViewController.getViewController("Main", "MyCoach_Cup")
            }
        } else {
            return BaseViewController.getViewController("Main", "MyCoach_Cup")
        }
    }
}
