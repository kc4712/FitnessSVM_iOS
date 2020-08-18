//
//  VersionService.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 2..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import MiddleWare

class VersionService: BaseJsonParser, WebRequestDelegate, WebDownLoadDelegate {
    fileprivate let TAG = String(describing: VersionService.self)
    
    fileprivate let mc = MWControlCenter.getInstance()
    
    fileprivate var m_uri: String = ""
    
    fileprivate let downloader = WebDownLoad()
    
    fileprivate var m_dest: URL?
    
    fileprivate var m_main = "1"
    fileprivate var m_sub = "0"
    fileprivate var m_build = "1"
    fileprivate var m_rev = "1"
    
    fileprivate var new_version = ""
    
    var storeVersion: String? {
        get {
            var version: String?
            switch BaseViewController.program {
            case .전신:
                version = Preference.XmlVersion002
            case .매트:
                version = Preference.XmlVersion003
            case .액티브:
                version = Preference.XmlVersion004
            case .복근완성:
                version = Preference.XmlVersion101
            case .완벽뒤태:
                version = Preference.XmlVersion102
            case .바디1:
                version = Preference.XmlVersion201
            case .바디2:
                version = Preference.XmlVersion202
            case .출산부1:
                version = Preference.XmlVersion301
            case .출산부2:
                version = Preference.XmlVersion302
            default:
                break
            }
            
            return version
        }
        set {
            switch BaseViewController.program {
            case .전신:
                Preference.XmlVersion002 = newValue
            case .매트:
                Preference.XmlVersion003 = newValue
            case .액티브:
                Preference.XmlVersion004 = newValue
            case .복근완성:
                Preference.XmlVersion101 = newValue
            case .완벽뒤태:
                Preference.XmlVersion102 = newValue
            case .바디1:
                Preference.XmlVersion201 = newValue
            case .바디2:
                Preference.XmlVersion202 = newValue
            case .출산부1:
                Preference.XmlVersion301 = newValue
            case .출산부2:
                Preference.XmlVersion302 = newValue
            default:
                break
            }
        }
    }
  
    override init() {
        super.init()
        checkVersion()
    }
    
    fileprivate func checkVersion() {
        if let store_version = storeVersion {
            print("store_version -> \(store_version)")
            if store_version.contains(".") {
                let arr_version = store_version.components(separatedBy: ".")
                
                m_main = arr_version[0]
                m_sub = arr_version[1]
                m_build = arr_version[2]
                m_rev = arr_version[3]
            }
        }
    }
    
    fileprivate func moveFile() {
        let name = BaseViewController.XmlFileName
        print("dest->\(String(describing: m_dest)) last->\(m_dest!.lastPathComponent)")
        if FileManager.isExistFile(m_dest!.lastPathComponent) {
            _ = FileManager.moveFileName(m_dest!, rename: name)
            print("move xml file-> dest:\(String(describing: m_dest)) rename:\(name)")
        }
    }
    
    func makeRequest(_ queryCode: QueryCode) -> String {
        var ret = "";
        ret += WebQuery.VERSION_SERVER_ADDR;
        ret += queryCode.rawValue;
        
        switch queryCode {
        case .CheckVersion:
            ret += "?Code=\(mc.getCourseCodeForQuery(BaseViewController.program.rawValue))"
            ret += "&Main=\(m_main)";
            ret += "&Sub=\(m_sub)";
            ret += "&Build=\(m_build)";
            ret += "&Rev=\(m_rev)";
        default:
            break;
        }
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
                new_version = String(format: "%d.%d.%d.%d", getInt(json, "VersionMain"), getInt(json, "VersionSub"),
                                     getInt(json, "VersionBuild"), getInt(json, "VersionRevision"))
                
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
    
    fileprivate var m_handler: (() -> ())?
    func setHandler(_ handler: @escaping () -> ()) {
        m_handler = handler
    }
    
    func OnQuerySuccess(_ queryCode: QueryCode) {
        // 다운로드 완료되면, 사용하려는 파일 이름으로 교체.
        moveFile()
        storeVersion = new_version
        
        m_handler!()
        print("xml 실제 다운 성공")
    }
    
    func OnQueryFail(_ queryStatus: QueryStatus) {
        m_handler!()
        print("xml 실제 다운 실패")
    }
    
    func OnProgressPercent(_ percent: Int) {
        
    }
    
    func getDestinationURL(_ url: URL) {
        m_dest = url
    }
}
