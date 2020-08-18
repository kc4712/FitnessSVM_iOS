//
//  WebQuery.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 3. 28..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation
import MiddleWare


/*
 웹에서 데이터를 쿼리 하고 JSON 반환을 객체로 생성하는 서비스 클래스
 NSURLConnection 을 이용하는 방법은 9.0 부터 사용되지 않고
 NSURLSession 을 권고 하므로
 소스 서버 Rev. 74 에서 샘플 코드만 남긴다.
 */
open class WebQuery
{
    fileprivate static let tag = String(describing: WebQuery.self);
    
    open static let SERVER_ADDR = "http://ibody24.com/service/body.svc/";
    open static let VERSION_SERVER_ADDR = "http://ibody24.com/service/version.svc/";
    
    var maker: WebRequestDelegate;
    var parser: WebResponseDelegate;
    
    fileprivate var queryCode: QueryCode;
    open var requestString: String;
    
    public init(queryCode: QueryCode, request: WebRequestDelegate, response: WebResponseDelegate) {
        self.maker = request;
        self.parser = response;
        requestString = self.maker.makeRequest(queryCode);
        Log.d(WebQuery.tag, msg: "Query1: \(requestString)");
        
        self.queryCode = queryCode;
        Log.d(WebQuery.tag, msg: "Query2: \(queryCode.rawValue)");
    }

    open func completeCallback(_ data: Data?, response: URLResponse?, error: NSError?)  -> Void {
        Log.d(WebQuery.tag, msg: "Query: Callback");
        if error == nil && data != nil {
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                let result = self.parser.parse(json as NSDictionary, queryCode: self.queryCode);
//                if queryCode == QueryCode.AddAction200 && result != QueryStatus.ERROR_Non_Information {
//                    MWNotification.postNotification(queryCode.rawValue, info: ["result" : result.rawValue])
//                    return;
//                }
                // 기본 성공 알림
                if (result == QueryStatus.Success) {
                    parser.OnQuerySuccess(queryCode);
                }
                else {
                    parser.OnQueryFail(result);
                }
            }
            catch {
            }
        }
    }
    
    open func start() {
        let url = URL(string: requestString)!;
        let session = URLSession.shared;
        
        //NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
        /*
        let task = session.dataTaskWithURL(url) {
            (data, response, error) in
            if error == nil && data != nil {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                    self.parser.parse(json);
                }
                catch {
                }
            }
        }
        */
        
        //let task = session.dataTask(with: url, completionHandler: completeCallback) 
        
        //규창 아래의 형태로 SWIFT3에서 컨버팅 되어버리고 완료 핸들러에서 콜백할 방법이 없음??? 그냥 위에꺼 끌어다 아래로...
        //let task = session.dataTask(with: url, completionHandler: completeCallback as! (Data?, URLResponse?, Error?) -> Void)
        
        let task = session.dataTask(with: url) { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    let result = self.parser.parse(json as NSDictionary, queryCode: self.queryCode);
                    //                if queryCode == QueryCode.AddAction200 && result != QueryStatus.ERROR_Non_Information {
                    //                    MWNotification.postNotification(queryCode.rawValue, info: ["result" : result.rawValue])
                    //                    return;
                    //                }
                    // 기본 성공 알림
                    if (result == .Success) {
                        self.parser.OnQuerySuccess(self.queryCode);
                    }
                    else {
                        self.parser.OnQueryFail(result);
                    }
                }
                catch {
                    self.parser.OnQueryFail(.ERROR_Web_Read);
                }
            }
        }
        task.resume();
    }
    
    
    open static func Execut(_ code: QueryCode, request: WebRequestDelegate, response: WebResponseDelegate) {
        let query = WebQuery(queryCode: code, request: request, response: response);
        query.start();
    }
    
}
