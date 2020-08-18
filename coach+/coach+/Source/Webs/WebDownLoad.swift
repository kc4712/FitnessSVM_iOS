//
//  WebDownLoad.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 22..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

class WebDownLoad: NSObject, URLSessionDownloadDelegate
{
    var task: URLSessionTask?
    var session: Foundation.URLSession?
    var url : URL?
    // will be used to do whatever is needed once download is complete
    
    var respDelegate: WebDownLoadDelegate?
    
//    init(delegate: WebResponseDelegate) {
//        respDelegate = delegate
//    }
    
    //is called once the download is complete
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        //copy downloaded data to your documents directory with same names as source file
        let mgr = Foundation.FileManager.default
        let documentsUrl =  mgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(url!.lastPathComponent)
        let dataFromURL = try? Data(contentsOf: location)
        try? dataFromURL?.write(to: destinationUrl, options: [.atomic])
        
        //now it is time to do what is needed to be done after the download
        print("location:\(location) destinationUrl:\(destinationUrl)")
        
        do {
            try mgr.removeItem(at: location)
        } catch {

        }
        
        respDelegate?.getDestinationURL(destinationUrl)
        respDelegate?.OnQuerySuccess(QueryCode.DownLoadFile) // 수정 필요.
    }
    
    //this is to track progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        let percent = (Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        print("downloading........ down:\(totalBytesWritten) total:\(totalBytesExpectedToWrite) loading:\(percent*100)%")
        
        DispatchQueue.main.async(execute: {
            self.respDelegate?.OnProgressPercent(Int(percent*100))
        })
    }
    
    // if there is an error during download this will be called
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        if(error != nil)
        {
            //handle the error
            print("Download completed with error: \(error!.localizedDescription)");
            respDelegate?.OnQueryFail(QueryStatus.Catch_Error)
        }
    }
    
    //method to be called to download
    func download(_ url: URL)
    {
        self.url = url
        print("url : \(url)")
        
        //download identifier can be customized. I used the "ulr.absoluteString"
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: url.absoluteString)
        session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        task = session!.downloadTask(with: url)
        task?.resume()
    }
    
    func cancelTask() {
        if task?.state == URLSessionTask.State.running {
            task?.cancel()
            session?.invalidateAndCancel()
        }
    }
}
