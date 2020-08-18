//
//  FileManager.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 26..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

class FileManager {
    fileprivate static let mgr = Foundation.FileManager.default
    
    static func getUrlPath(_ name: String) -> URL {
        let documentsUrl =  mgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(name)
        
        return destinationUrl
    }
    
    static func getXmlUrlForRes(_ name: String) -> URL {
        let xmlPath = Bundle.main.path(forResource: name, ofType: "xml")
        
        return URL(fileURLWithPath: xmlPath!)
    }
    
    static func isExistFile(_ name: String) -> Bool {
        let documentsUrl =  mgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(name)
        
        
        //return destinationUrl.path == nil ? false : mgr.fileExists(atPath: destinationUrl.path)
        return mgr.fileExists(atPath: destinationUrl.path);
    }
    
    static func getHttpXmlPath(_ programCode: ProgramCode) -> URL {
        let name = programCode.xmlName
        
        let videoURL = URL(string: String(format: "http://ibody24.com/down/%@", name))!
        
        return videoURL
    }
    
    static func moveFileName(_ url: URL, rename: String) -> URL {
        let dest = url.deletingLastPathComponent()
        let destUrl = dest.appendingPathComponent(rename)
        do {
            try mgr.moveItem(at: url, to: destUrl)
        } catch {
            print("Error!!! file RENAME!! \(url) -> r:\(rename) d:\(destUrl)")
        }
        
        return destUrl
    }
    
    static func deleteFile(_ url: URL) {
        do {
            try mgr.removeItem(at: url)
        } catch {
            
        }
    }
    
    static func deleteAllFile() {
        if let documentsUrl =  mgr.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                try mgr.removeItem(at: documentsUrl)
            } catch {
                
            }
        }
    }
}
