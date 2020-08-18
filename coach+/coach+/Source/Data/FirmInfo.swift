//
//  FirmInfo.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 23..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

/*
 220000 ~ 239999 = zip
 200000 ~ 219999 = hex
 */
class FirmInfo: BaseJsonParser, WebRequestDelegate, WebDownLoadDelegate
{
    fileprivate let TAG = String(describing: FirmInfo.self)
    
    fileprivate let downloader = WebDownLoad()
    
    static let NAME = "firmware"
    static let EXTENTION_HEX = "hex"
    static let EXTENTION_ZIP = "zip"
    
    fileprivate var m_dest: URL?
    
    fileprivate var m_main = "0"
    fileprivate var m_sub = "0"
    fileprivate var m_build = "1"
    fileprivate var m_rev = "1"
    
    fileprivate var new_version = ""
    
    fileprivate let mc = MWControlCenter.getInstance()
    
    init(version: String) {
        super.init()
        setVersion(version)
    }
    
    fileprivate func setVersion(_ version: String) {
        if version.contains(".") {
            let arr_version = version.components(separatedBy: ".")
            
            m_main = arr_version[0]
            m_sub = arr_version[1]
            m_build = arr_version[2]
            m_rev = arr_version[3]
        }
    }
    
    func makeRequest(_ queryCode: QueryCode) -> String {
        var ret = "";
        ret += WebQuery.VERSION_SERVER_ADDR;
        ret += QueryCode.CheckVersion.rawValue;
        ret += "?Code=\(mc.getSelectedProduct().productCode)";
        ret += "&Main=\(m_main)";
        ret += "&Sub=\(m_sub)";
        ret += "&Build=\(m_build)";
        ret += "&Rev=\(m_rev)"
        
        //let url = ret.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding);
        let url = ret.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed);
        return url!;
    }
    
    func parse(_ json: NSDictionary, queryCode: QueryCode) -> QueryStatus {
        Log.d(TAG, msg: "=====================================================");
        Log.d(TAG, msg: "웹 반환 값 파싱");
        Log.d(TAG, msg: "=====================================================");
        //Log.d(TAG, msg: "Query Code = \(queryCode), Result Json = \(json)");
        Log.d(TAG, msg:"Query Code = \(queryCode)");
        
        let result = json["Result"] as! Int?;
        
        if (result == nil) {
            return QueryStatus.ERROR_Result_Parse;
        }
        
        print("Result = \(result!)");
        
        if (result != 1) {
            return QueryStatus.Non_Upgrade;
        } else {
            let sts = getBoolean(json, "UpdateStat")
            if sts {
                let new_version = String(format: "%d.%d.%d.%d", getInt(json, "VersionMain"), getInt(json, "VersionSub"),
                                     getInt(json, "VersionBuild"), getInt(json, "VersionRevision"))
                print("firm new version -> \(new_version)")
                
                if let uri = getString(json, "Uri") {
                    // download start...
                    downloader.respDelegate = self
                    downloader.download(URL(string: uri)!)
                }
            } else {
                return QueryStatus.Non_Upgrade
            }
        }
        
        return QueryStatus.Next_Upgrade
    }
    
    fileprivate func moveFile() {
        let name = m_dest!.lastPathComponent
        let name_extention = name.components(separatedBy: ".")
        
        let extension_name = FirmInfo.NAME + ("." + name_extention[1].lowercased())
        
        print("dest->\(String(describing: m_dest)) last->\(name)")
        if FileManager.isExistFile(name) {
            m_dest = FileManager.moveFileName(m_dest!, rename: extension_name)
            print("move xml file-> dest:\(String(describing: m_dest)) rename:\(extension_name)")
        }
    }
    
    fileprivate var m_handler: ((_ success: Bool) -> ())?
    func setHandler(_ handler: @escaping (_ success: Bool) -> ()) {
        m_handler = handler
    }
    
    func restartFirmUp(_ url: URL) {
        print("firmware 재시작")
        /** firmware upgrade 수행 **/
        // m_dest에 펌웨어 저장됨. 업그레이드 끝나면, 펌웨어 파일 삭제 수행. -> 파일이 남아있으면 펌웨어 업그레이드가 안된것이므로 재수행.
        // 위의 핸들러를 set하여 사용해도 됨.
        
        //규창 16.12.23 펌웨어 업데이트 전 진행/취소 팝업
        if mc.FlagDFU() == false {
            print("Firm UP go!")
            m_dest = url
            let msg = Common.ResString("notice_firmup")
            Common.dialogConfirm( (UIApplication.shared.keyWindow?.rootViewController)! , msg: msg, yesCall: yesCallback, noCall: noCallback);
        }
    }
    
    func OnQuerySuccess(_ queryCode: QueryCode) {
        // 다운로드 완료되면, 사용하려는 파일 이름으로 교체.
        moveFile()
//        storeVersion = new_version
        
        print("firmware 실제 다운 성공")
        /** firmware upgrade 수행 **/
        // m_dest에 펌웨어 저장됨. 업그레이드 끝나면, 펌웨어 파일 삭제 수행. -> 파일이 남아있으면 펌웨어 업그레이드가 안된것이므로 재수행.
        // 위의 핸들러를 set하여 사용해도 됨.
        
        //규창 16.12.23 펌웨어 업데이트 전 진행/취소 팝업
        if mc.FlagDFU() == false && m_dest != nil {
            print("Firm UP go!")
            let msg = Common.ResString("notice_firmup")
            Common.dialogConfirm( (UIApplication.shared.keyWindow?.rootViewController)! , msg: msg, yesCall: yesCallback, noCall: noCallback);
        }
    }
    
    func OnQueryFail(_ queryStatus: QueryStatus) {
        if m_handler != nil {
            m_handler!(false)
        }
        print("firmware 실제 다운 실패")
    }
    
    func OnProgressPercent(_ percent: Int) {
        
    }
    
    func getDestinationURL(_ url: URL) {
        m_dest = url
    }
    
    func yesCallback() {
        print("YES~ mc.sendFirmwareUrl(self.m_dest!)");
        if m_handler != nil {
            m_handler!(true)
            mc.sendFirmwareUrl(self.m_dest!)
        }
        
    }
    
    func noCallback() {
        print("NO~ File Delete");
        if mc.getSelectedProduct() == .coach {
            let hex_firm = FirmInfo.NAME + "." + FirmInfo.EXTENTION_HEX
            if FileManager.isExistFile(hex_firm) {
                print("펌웨어 파일 존재! -> HEX")
                let url = FileManager.getUrlPath(hex_firm)
                FileManager.deleteFile(url)
                return
            }
        }
            
        else if mc.getSelectedProduct() == .fitness {
            let zip_firm = FirmInfo.NAME + "." + FirmInfo.EXTENTION_ZIP
            if FileManager.isExistFile(zip_firm) {
                print("펌웨어 파일 존재! -> ZIP")
                let url = FileManager.getUrlPath(zip_firm)
                FileManager.deleteFile(url)
                return
            }
        }
        //        m_mode = 0;
        //        Image_Delete.image = UIImage(named: "기기등록_4.png");
    }
}
