//
//  Common.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 9..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation
import UIKit

open class Common
{
    open class func IsValidEmail(_ email: String) -> Bool {
        // 참조: http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx);
        return emailTest.evaluate(with: email);
    }

    open class func IsValidPassword(_ password: String) -> Bool {
        if (password.length < 8 || password.length > 16) {
            return false;
        }
        let strNum = password.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "");
        let strLow = password.components(separatedBy: CharacterSet.lowercaseLetters.inverted).joined(separator: "");
        let strUp = password.components(separatedBy: CharacterSet.uppercaseLetters.inverted).joined(separator: "");
        if (strNum.length + strLow.length + strUp.length != password.length) {
            return false;
        }
        if (strNum.length == 0 || strLow.length + strUp.length == 0) {
            return false;
        }
        return true;
    }

    // 지정된 이름의 스토리보드에서 지정된 이름의 뷰 컨트롤러를 로딩한다.
    open class func changeScreen(_ cont: UIViewController, story storyName: String, view viewName: String) {
        let sb = UIStoryboard(name: storyName, bundle: nil);
        let vc = sb.instantiateViewController(withIdentifier: viewName);
        cont.present(vc, animated: true, completion: nil);
    }

    // 지정된 이름의 Segue를 찾아서 실행한다.
    open class func playSegue(_ cont: UIViewController, segue segueName: String) {
        cont.performSegue(withIdentifier: segueName, sender: cont);
    }
    
    // 네비게이션바 감추기
    open class func hideNavigationBar(_ cont: UIViewController) {
        if let nav = cont.navigationController {
            if (nav.isNavigationBarHidden == false) {
                print("BVC: 네비게이션 바 숨기기");
                nav.isNavigationBarHidden = true;
            }
        }
    }
    
    // 네비게이션바 보이기
    open class func showNavigationBar(_ cont: UIViewController) {
        if let nav = cont.navigationController {
            if (nav.isNavigationBarHidden == true) {
                print("BVC: 네비게이션 바 보이기");
                nav.isNavigationBarHidden = false;
            }
        }
    }

    open static func dialogConfirm(_ cont: UIViewController, msg: String, yesCall: (() -> ())?, noCall: (() -> ())?) {
        let alertController = UIAlertController(
            title: nil,
            message: msg,
            preferredStyle: UIAlertControllerStyle.alert);
        
        let yesCap = NSLocalizedString("yes", comment: "예");
        let confirmAction = UIAlertAction(title: yesCap, style: UIAlertActionStyle.default) {
            (action) in
            yesCall?();
        }
        
        let noCap = NSLocalizedString("no", comment: "아니요");
        let cancelAction = UIAlertAction(title: noCap, style: UIAlertActionStyle.destructive) {
            (action) in
            noCall?();
        }
        
        alertController.addAction(confirmAction);
        alertController.addAction(cancelAction);
        cont.present(alertController, animated: true, completion: nil);
    }

    open class func getDateString(_ date: Date) -> String {
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let dateFormatter = DateFormatter();
        dateFormatter.dateStyle = .long
        //dateFormatter.dateFormat = "yyyy년 MM월 dd일";
        let ret = dateFormatter.string(from: date);
        return ret;
    }
    
    open static func getDayOfWeek(_ date: Date) -> Int {
        //let formatter  = NSDateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd"
        //let todayDate = formatter.dateFromString(today)!
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian);
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: date);
        let weekDay = myComponents.weekday
        return weekDay!
    }
    
    open static func addingDay(_ now: Date, add_day: Int) -> Date {
        return now.addingTimeInterval(TimeInterval(add_day*24*60*60))
    }
    
    open static func addingMonth(_ now: Date, add_month: Int) -> Date {
        var dataComponent = DateComponents()
        dataComponent.month = add_month
        
        let cal = Calendar.current
        
        return (cal as NSCalendar).date(byAdding: dataComponent, to: now, options: NSCalendar.Options.wrapComponents)!
    }
    
    open class func getGenderString(_ gender: Int) -> String {
        if (gender == 1) {
            return Common.ResString("male");
        }
        if (gender == 2) {
            return Common.ResString("female");
        }
        return Common.ResString("select");
    }
    
    open class func makeColor(_ red: Int, _ green: Int, _ blue: Int) -> UIColor {
        let value_red = CGFloat(red) / 255.0;
        let value_green = CGFloat(green) / 255.0;
        let value_blue = CGFloat(blue) / 255.0;
        return UIColor(red: value_red, green: value_green, blue: value_blue, alpha: 1.0);
    }
    
    open static func ResString(_ key: String) -> String {
        return NSLocalizedString(key, comment: key);
    }
    
    open static func nextInt(_ range: Int) -> Int {
        return Int(arc4random_uniform(UInt32(range)))
    }
    
    open static var LanguageCode: String {
            let locale:Locale = Locale.current
            
            let languageCode:AnyObject = (locale as NSLocale).object(forKey: NSLocale.Key.languageCode)! as AnyObject
            return (languageCode as! String).uppercased()
    }
    
    open static func getSleepCalc(_ time: Int64) -> SleepIdentifier {
        if time > 420 {
            return SleepIdentifier.enough
        } else if time > 300 {
            return SleepIdentifier.normal
        } else if time > 180 {
            return SleepIdentifier.few
        } else {
            return SleepIdentifier.lack
        }
    }
}
