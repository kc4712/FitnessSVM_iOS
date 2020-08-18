//
//  DeviceEdit.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 20..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation
import UIKit;
import MiddleWare;

class DeviceEdit : UITableViewController
{
    fileprivate var m_mode = 0;
    @IBOutlet weak var Image_Delete: UIImageView!
    @IBOutlet weak var Label_Device_Name: UILabel!
    
    fileprivate var mc: MWControlCenter?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load: 설정 화면");
        
        mc = MWControlCenter.getInstance();
//        Image_Delete.image = UIImage(named: "기기등록_4.png");
        Label_Device_Name.text = BaseViewController.User.DeviceName;
//        if (BaseViewController.User.DeviceName == nil || BaseViewController.User.DeviceName!.isEmpty == true) {
//            m_mode = -1;
//            Image_Delete.hidden = true;
//            Label_Device_Name.hidden = true;
//        } else {
//            m_mode = 0;
//            Image_Delete.image = UIImage(named: "기기등록_4.png");
//            Label_Device_Name.text = BaseViewController.User.DeviceName;
//        }
        
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
    }
    
//    @IBAction func EditButtonTouch(sender: AnyObject) {
//        if (m_mode == 0) {
//            m_mode = 1;
//            Image_Delete.image = UIImage(named: "기기등록_3.png");
//        }
//    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.row == 2 && m_mode == 1) {
        if ((indexPath as NSIndexPath).row == 2) {
            let msg = Common.ResString("device_edit_delete")
            Common.dialogConfirm(self, msg: msg, yesCall: yesCallback, noCall: noCallback);
        }
    }
    
    func yesCallback() {
        print("YES~");
        let hex_firm = FirmInfo.NAME + "." + FirmInfo.EXTENTION_HEX
        let zip_firm = FirmInfo.NAME + "." + FirmInfo.EXTENTION_ZIP
        if FileManager.isExistFile(hex_firm) {
            print("디바이스 변경->펌웨어 파일 존재하므로 삭제함. -> HEX")
            let url = FileManager.getUrlPath(hex_firm)
            FileManager.deleteFile(url)
        }
        
        if FileManager.isExistFile(zip_firm) {
            print("디바이스 변경->펌웨어 파일 존재하므로 삭제함. -> ZIP")
            let url = FileManager.getUrlPath(zip_firm)
            FileManager.deleteFile(url)
        }
        
        BaseViewController.User.DeviceName = "";
        mc?.setScanMode(ScanMode.manual);
        mc?.stopBluetooth();
        Preference.putBluetoothName(nil);
        BaseViewController.User.executQuery(.SetDevice, success: nil, fail: nil);
        performSegue(withIdentifier: "DeleteSuccess", sender: self);
    }
    
    func noCallback() {
        print("NO~");
//        m_mode = 0;
//        Image_Delete.image = UIImage(named: "기기등록_4.png");
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeleteSuccess" {
            let backButtonItem = UIBarButtonItem()
            backButtonItem.title = Common.ResString("back")
            navigationItem.backBarButtonItem = backButtonItem
        }
    }
}
