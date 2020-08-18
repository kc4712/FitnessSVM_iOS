//
//  AppDelegate.swift
//  coach+
//
//  Created by Company Green Comm on 2016. 6. 2..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import UIKit
import MiddleWare

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func receiveNotification(name: String) {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(end), name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    // disconnect 인경우, 백그라운드 프로세스를 종료한다. 아닌경우, 최대한 시간을 사용하고 시스템에 의해 자동종료.
    @objc func end() {
        print("---END---")
        let mc = MWControlCenter.getInstance()
        let status = mc.getConnectionState()
        print("status \(status)")
        if status != ConnectStatus.state_DISCONNECTED {
            return
        }
        
        let bg = Background.getInstance()
        bg.end()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarStyle = .lightContent
        
        // 자동 로그인 처리
        if (Preference.AutoLogin == true) {
            BaseViewController.User.Email = Preference.Email;
            BaseViewController.User.Password = Preference.Password;
            BaseViewController.User.executQuery(QueryCode.LoginUser, success: SuccessProc, fail: nil);
            
            print("자동 로그인 처리");
        }
        
        if Preference.Language == nil {
            Preference.Language = Common.LanguageCode
        } else {
            if Preference.Language != Common.LanguageCode {
                FileManager.deleteAllFile()
                Preference.Language = Common.LanguageCode
            }
        }
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        //noti
        receiveNotification(name: MWNotification.Bluetooth.RaiseConnectionState)
        
        return true
    }
    
    func SuccessProc() {
        print("로그인 성공");
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: "Main");
        //cont.presentViewController(vc, animated: true, completion: nil);
        self.window?.rootViewController = vc;
    }
    
    func getVisibleController(_ vc: UIViewController?) -> UIViewController? {
        var ret: UIViewController?
        if vc is UINavigationController {
            ret = (vc as! UINavigationController).visibleViewController
        } else if vc is UITabBarController {
            ret = (vc as! UITabBarController).selectedViewController
        } else {
            ret = vc?.presentedViewController
        }
        
        return ret
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if var topController = application.keyWindow?.rootViewController {
            while let presentedVC = getVisibleController(topController) {
                topController = presentedVC
            }
            
            if topController is VideoScreen {
                return UIInterfaceOrientationMask.landscapeRight
            }
        }
        
        return UIInterfaceOrientationMask.portrait
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("got background fetch--------------!")
        
        let bg = Background.getInstance()
        bg.begin()
        completionHandler(UIBackgroundFetchResult.noData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("go background")
        
        if (Preference.AutoLogin == true) {
            let bg = Background.getInstance()
            bg.begin()
            let mc = MWControlCenter.getInstance()
            mc.setIsLiveApplication(StateApp.state_EXIT)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        let mc = MWControlCenter.getInstance()
        if (Preference.AutoLogin == true) {
            let bg = Background.getInstance()
            bg.end()
            mc.setIsLiveApplication(StateApp.state_NORMAL)
        }
        
        if mc.getConnectionState() == .state_CONNECTED {
            let dat: BLSender = (.version, 0, .start, true, .empty)
            mc.appendSender(dat)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let nc = NotificationCenter.default
        nc.removeObserver(self)
        
        let mc = MWControlCenter.getInstance()
        mc.stopBluetooth()
    }
}

