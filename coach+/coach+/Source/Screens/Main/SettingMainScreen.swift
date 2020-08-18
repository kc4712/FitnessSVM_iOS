//
//  SettingMainScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 29..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class SettingMainScreen: UITableViewController {
    @IBOutlet weak var label_manual: UILabel!
    @IBOutlet weak var label_glossary: UILabel!
    
    fileprivate let mc = MWControlCenter.getInstance()
    
    fileprivate var html_name_glossary = Common.ResString("html_glossary")
    fileprivate var html_name_manual = Common.ResString("html_manual")
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        
        let product = mc.getSelectedProduct()
        switch product {
        case .coach:
            label_manual.text = Common.ResString("title_manual")
            label_glossary.text = Common.ResString("title_glossary")
            html_name_glossary = Common.ResString("html_glossary")
            html_name_manual = Common.ResString("html_manual")
        case .fitness:
            label_manual.text = Common.ResString("title_manual_fit")
            label_glossary.text = Common.ResString("title_glossary_fit")
            html_name_glossary = Common.ResString("html_glossary_fit")
            html_name_manual = Common.ResString("html_manual_fit")
        }
    }

    @IBAction func unwindToSettingScreen(_ segue: UIStoryboardSegue) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 // ??
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case 0:
            performSegue(withIdentifier: "SG_Setting_WebView", sender: html_name_glossary)
        case 1:
            performSegue(withIdentifier: "SG_Setting_WebView", sender: html_name_manual)
        case 2:
            break
        case 3:
            performSegue(withIdentifier: "SG_Setting_WebView", sender: Common.ResString("html_event"))
        case 4:
            break
        case 5:
            break
        case 6:
            if (BaseViewController.User.DeviceName == nil || BaseViewController.User.DeviceName!.isEmpty == true) {
                performSegue(withIdentifier: "DeviceAdd", sender: self);
            }
            else {
                performSegue(withIdentifier: "DeviceEdit", sender: self);
            }
        case 7:
            let msg = NSLocalizedString("confirm_logout", comment: "로그아웃 하시겠습니까?");
            Common.dialogConfirm(self, msg: msg, yesCall: yesCallback, noCall: noCallback);
        default:
            break
        }
        tableView.reloadData()
    }
    
    fileprivate func yesCallback() {
        print("YES~");
        BaseViewController.MainMode = false;
        //Preference.AutoLogin = false;
        MWControlCenter.getInstance().logout();
        let sql = SQLHelper.getInstance()
        _ = sql?.deleteActivityData()
        _ = sql?.deleteCoachActivityData()
        _ = sql?.deleteIndexTime()
        Common.changeScreen(self, story: "Main", view: "Load");
    }
    
    fileprivate func noCallback() {
        print("NO~");
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SG_Setting_WebView" {
            if let dest = segue.destination as? SettingWebViewScreen {
                if let name = sender as? String {
                    dest.m_name = name
                }
            }
        }
//        else if segue.identifier == "DeviceAdd" {
//            let backButtonItem = UIBarButtonItem()
//            backButtonItem.title = "뒤로"
//            navigationItem.backBarButtonItem = backButtonItem
//        }
    }
}
