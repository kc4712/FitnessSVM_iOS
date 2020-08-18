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

class NavigationHome: UINavigationController {
    override func viewDidLoad() {
        let vc = BaseViewController.changeScreenUserValid()
        if vc.restorationIdentifier != "Main" {
            pushViewController(vc, animated: true)
            return
        }
        
        BaseViewController.SkipMode = false
        moveMainView()
    }
    
    static func selectMainView() -> String {
        let name = Preference.getBluetoothName()
        if let prefix = name?.substringToIndex(ProductCode.coach.bluetoothDeviceName.length) {
            // 디버깅 루틴
            //prefix = "CF"
            switch prefix {
            case ProductCode.coach.bluetoothDeviceName:
                return "SG_Home_Normal"
            case ProductCode.fitness.bluetoothDeviceName:
                return "SG_Home_Plus"
            default:
                return "SG_Home_Normal"
            }
        } else {
            return "SG_Home_Normal"
        }
    }
    
    func moveMainView() {
        let view = NavigationHome.selectMainView()
        performSegue(withIdentifier: view, sender: nil)
    }
    
    @IBAction func unwindToNavigationScreen(_ segue: UIStoryboardSegue) {
        print("unwindToNavigationScreen")
        for vc in tabBarController!.viewControllers! {
            if let nc = vc as? UINavigationController {
                nc.popToRootViewController(animated: false)
            }
        }

        moveMainView()
    }
}
