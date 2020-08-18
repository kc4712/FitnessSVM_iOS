//
//  VideoScreen.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 20..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import MiddleWare

class VideoScreen: BaseViewController {
    fileprivate var m_Player: AVPlayer?
    fileprivate var m_Layer: AVPlayerLayer?
    fileprivate var m_Item: AVPlayerItem?
    fileprivate var m_TimeObserver: AnyObject?
    fileprivate let mc = MWControlCenter.getInstance()
    // 이미지뷰+라벨 합친 뷰로 생성 필요.
    @IBOutlet var m_totalMainView: UIView!
    
    @IBOutlet var m_accuracyBar_WidthConstraint: NSLayoutConstraint!
    @IBOutlet var m_countBar_WidthConstraint: NSLayoutConstraint!
    @IBOutlet var m_countBar: UIImageView!
    @IBOutlet var m_accuracyBar: UIImageView!
    @IBOutlet var m_commentView: UILabel!
    @IBOutlet var m_pointView: UILabel!
    
    @IBOutlet var m_warningView: UIView!
    
    @IBOutlet var m_activityNameView: UIView!
    @IBOutlet var m_activityNameTxt: UILabel!
    
    @IBOutlet var m_gaugeView: UIImageView!
    
    @IBOutlet var m_scoreBackgroundView: UIView!
    @IBOutlet var m_pointTxt: UILabel!
    @IBOutlet var m_calorieTxt: UILabel!
    @IBOutlet var m_heartPercentTxt: UILabel!
    @IBOutlet var m_countTxt: UILabel!
    
    @IBOutlet var m_bottomCommentView: UIView!
    @IBOutlet var m_bottomCommentTxt: UILabel!
    
    fileprivate var m_bottomCommentLock = false
    fileprivate var m_topCommentLock = false
    fileprivate var m_heartWarnningLock = false
    
    fileprivate var isPause = false
    
    fileprivate let default_popTime = 2.0
    
    @IBOutlet weak var m_back_button: UIButton!
    @IBAction func ButtonBack(_ sender: UIButton) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        
        performSegue(withIdentifier: "UnWindVideoScreen", sender: nil)
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override func viewDidLoad() {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTouch))
        self.view.addGestureRecognizer(tapGesture)
        
        displayAllUI(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setPlayer()
        play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        receiveNotification(MWNotification.Bluetooth.RaiseConnectionState)
        receiveNotification(MWNotification.Video.ShowUI)
        receiveNotification(MWNotification.Video.MainUI)
        receiveNotification(MWNotification.Video.HeartWarnning)
        receiveNotification(MWNotification.Video.BottomComment)
        receiveNotification(MWNotification.Video.TopComment)
        receiveNotification(MWNotification.Video.TotalScore)
        
        m_totalMainView.isHidden = false
        totalScore()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stop()
    }
    
    fileprivate func receiveNotification(_ name: String) {
        let nc = NotificationCenter.default;
        nc.addObserver(self, selector: #selector(run), name: NSNotification.Name(rawValue: name), object: nil);
    }
    
    @objc fileprivate func run(_ notification: Notification) {
        print("\(className) ************************ \(notification.name)")
        switch notification.name.rawValue {
        case MWNotification.Bluetooth.RaiseConnectionState:
            performSelector(onMainThread: #selector(raiseConnectionState), with: nil, waitUntilDone: true)
        case MWNotification.Video.ShowUI: // 백그라운드 뷰의 내용들. + 게이지 뷰
            let isShowUI = notification.userInfo![MWNotification.Video.ShowUI] as! Bool
            DispatchQueue.main.async(execute: {
                () -> () in
                self.showUI(isShowUI)
            })
        case MWNotification.Video.MainUI: // 백그라운드 뷰의 내용들. + 게이지 뷰
            performSelector(onMainThread: #selector(mainUI), with: nil, waitUntilDone: true)
        case MWNotification.Video.HeartWarnning: // 현재 뷰 없음. 만들어야함
            performSelector(onMainThread: #selector(heartWarnning), with: nil, waitUntilDone: true)
        case MWNotification.Video.BottomComment: // 현재 뷰 없음. 만들어야함
            performSelector(onMainThread: #selector(bottomComment), with: nil, waitUntilDone: true)
        case MWNotification.Video.TopComment:
            performSelector(onMainThread: #selector(topComment), with: nil, waitUntilDone: true)
        case MWNotification.Video.TotalScore:
            performSelector(onMainThread: #selector(totalScore), with: nil, waitUntilDone: true)
        default:
            break
        }
    }
    
    @objc fileprivate func onTouch() {
        if !isPause {
            m_Player?.pause()
        } else {
            m_Player?.play()
        }
        isPause = !isPause
    }
    
    @objc fileprivate func raiseConnectionState() {
        if mc.getConnectionState() == ConnectStatus.state_DISCONNECTED {
            // 끊어지면, 바로 종료.
            //규창 Rssi디버깅용
            //guard let rssi = mc.RssiResult() else { return }
            //showPopup("BT신호:\(rssi)\(Common.ResString("raise_disconnect"))")
            stop()
            showPopup(Common.ResString("raise_disconnect")) {
                self.ButtonBack(self.m_back_button)
            }
        }
    }
    
    @objc fileprivate func showUI(_ isShowUI: Bool) {
        // 백그라운드 뷰의 내용들. + 게이지 뷰
        let disp = isShowUI == false ? true : false
        
        m_scoreBackgroundView.isHidden = disp
        m_gaugeView.isHidden = disp
        if !isShowUI {
            m_bottomCommentView.isHidden = disp
        }
    }
    
    @objc fileprivate func mainUI() {
        // 백그라운드 뷰의 내용들. + 게이지 뷰
        if isPause {
           return
        }
        setPoint(mc.Point)
        setCalorie(mc.VideoCalorie)
        setHeartPercent(mc.HRCmp)
        setCount(mc.Count.count)
        setGauge(mc.Accuracy)
    }
    
    @objc fileprivate func heartWarnning() {
        if isPause {
            return
        }
        if m_heartWarnningLock {
            return
        }
        
        setBottomComment(mc.HRWarnning)
        // 경고!! 문구 있음. 따로 뷰.. 얼마나 표시하지?? 2초???
        m_heartWarnningLock = true
        m_warningView.isHidden = false
        m_bottomCommentView.isHidden = false
        
        let popTime = DispatchTime.now() + Double(Int64(default_popTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            self.m_heartWarnningLock = false
            self.m_warningView.isHidden = true
            self.m_bottomCommentView.isHidden = true
        }
    }
    
    @objc fileprivate func bottomComment() {
        if isPause {
            return
        }
        if m_bottomCommentLock {
            return
        }
        
        setBottomComment(mc.BottomComment)
        
        m_bottomCommentView.isHidden = false
        m_bottomCommentLock = true
        
        let popTime = DispatchTime.now() + Double(Int64(default_popTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            self.m_bottomCommentLock = false
            self.m_bottomCommentView.isHidden = true
        }
    }
    
    @objc fileprivate func topComment() {
        if isPause {
            return
        }
        if m_topCommentLock {
            return
        }
        
        let comment = mc.ActivityName
        m_topCommentLock = true
        m_activityNameView.isHidden = false
        m_activityNameTxt.text = comment
        
        let popTime = DispatchTime.now() + Double(Int64(default_popTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            self.m_topCommentLock = false
            self.m_activityNameView.isHidden = true
        }
    }
    
    @objc fileprivate func totalScore() {
        // 총점 데이터 발생함. 총점은 그냥 다 사라지면 됨. 중복 발생하지도 않음.
        if isPause {
            return
        }
        m_totalMainView.isHidden = false
        let tScore = mc.TotalScore
//        var tScore = mc.TotalScore
//        tScore.duration = 5
//        tScore.point = 10
//        tScore.count_percent = 50
//        tScore.accuracy_percent = 100
//        tScore.comment = "???????"
        
        m_back_button.isHidden = true
        m_commentView.text = tScore.comment
        m_pointView.text = String(tScore.point)
        m_countBar_WidthConstraint.constant = getPercentWidth(m_countBar, percent: tScore.count_percent)
        m_accuracyBar_WidthConstraint.constant = getPercentWidth(m_accuracyBar, percent: tScore.accuracy_percent)
        
        let popTime = DispatchTime.now() + Double(Int64(tScore.duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime){
            self.m_totalMainView.isHidden = true
            self.m_back_button.isHidden = false
        }
    }
    
    fileprivate func getPercentWidth(_ view: UIView, percent: Int) -> CGFloat {
        let width = (m_totalMainView.frame.width / 2 - 100) / 100 * CGFloat(percent)
        
        return width
    }
    
    fileprivate func makePercentRect(_ view: UIView, percent: Int) -> CGRect {
        var rect = view.frame
        let width = (m_totalMainView.frame.width / 2 - 100) / 100 * CGFloat(percent)
        rect.origin = view.frame.origin
        rect.size = CGSize(width: width, height: view.frame.size.height)
        
        return rect
    }

    fileprivate func displayAllUI(_ display: Bool) {
        let disp = display == false ? true : false
        
        m_warningView.isHidden = disp
        m_activityNameView.isHidden = disp
        m_scoreBackgroundView.isHidden = disp
        m_bottomCommentView.isHidden = disp
        m_gaugeView.isHidden = disp
    }
    
    fileprivate func setGauge(_ accuracy: Int) {
        switch accuracy {
        case 1..<20:
            m_gaugeView.image = UIImage(named: "video_precision_01.png")
        case 20..<40:
            m_gaugeView.image = UIImage(named: "video_precision_02.png")
        case 40..<60:
            m_gaugeView.image = UIImage(named: "video_precision_03.png")
        case 60..<80:
            m_gaugeView.image = UIImage(named: "video_precision_04.png")
        case 80...100:
            m_gaugeView.image = UIImage(named: "video_precision_05.png")
        default:
            m_gaugeView.image = UIImage(named: "video_precision_00.png")
        }
    }
    
    fileprivate func setBottomComment(_ comment: String) {
        m_bottomCommentTxt.text = comment
    }
    
    fileprivate func setPoint(_ point: Int) {
        m_pointTxt.text = String(point)
    }
    
    fileprivate func setCalorie(_ calorie: Float) {
        m_calorieTxt.text = String(String(format: "%.2f", calorie))
    }
    
    fileprivate func setHeartPercent(_ percent: Int) {
        m_heartPercentTxt.text = String(percent)
    }
    
    fileprivate func setCount(_ count: Int) {
        //규창 Rssi디버깅용
        m_countTxt.text = String(count)
        //guard let rssi = mc.RssiResult() else { return }
        //m_countTxt.text = "BT신호:\(rssi)/\(count)"
    }
    
    fileprivate func play() {
        mc.play()
        m_Player?.play()
        let interval = CMTimeMakeWithSeconds(1, Int32(NSEC_PER_SEC))
        m_TimeObserver = m_Player?.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: getCurrentTime) as AnyObject?
    }
    
    fileprivate func getCurrentTime(_ time: CMTime) {
        let sec = Int(CMTimeGetSeconds(time))
        mc.setCurrentTimePosition(sec)
        print("sec->\(sec)")
    }
    
    deinit {
        m_Item?.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
        m_Item?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
    }
    
    fileprivate func stop() {
        mc.end()
        let nc = NotificationCenter.default
        nc.removeObserver(self)
        
        m_Player?.removeTimeObserver(m_TimeObserver!)
        m_Player?.pause()
        m_Player?.replaceCurrentItem(with: nil)
        m_Layer?.removeFromSuperlayer()
        m_Player = nil
        
        let transfer = DataTransfer()
        transfer.start()
    }
    
    fileprivate func setPlayer() {
        var videoURL: URL
        if BaseViewController.program == .기초 {
            videoURL = URL(string: String(format: "http://ibody24.com/down/%@", BaseViewController.VideoFileName))!
            // 쓰레드를 만들어서 AVPlayerItemStatus.ReadyToPlay 상태 체크???
        } else {
            videoURL = FileManager.getUrlPath(BaseViewController.VideoFileName)
            var xmlURL: URL
            if !FileManager.isExistFile(BaseViewController.XmlFileName) {
                print("1. xml not exist")
                xmlURL = FileManager.getXmlUrlForRes(BaseViewController.XmlFileName.components(separatedBy: ".")[0])
            } else {
                print("2. xml exist")
                xmlURL = FileManager.getUrlPath(BaseViewController.XmlFileName)
            }
            let data = try! Data(contentsOf: xmlURL)
            mc.setXmlProgram(data)
            
        }
        
        m_Item = AVPlayerItem(url: videoURL)
        m_Player = AVPlayer(playerItem: m_Item!)
        m_Layer = AVPlayerLayer(player: m_Player)
        m_Layer!.frame = self.view.frame
        self.view.layer.insertSublayer(m_Layer!, at: 0)

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(videoStop), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime , object: nil)
        
        m_Item!.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
        m_Item!.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    @objc fileprivate func videoStop() {
        DispatchQueue.main.async(execute: {
            self.stop()
            self.ButtonBack(self.m_back_button)
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let obj = object as? AVPlayerItem
        
        if m_Player == nil || obj != m_Item {
            return
        }
        
        if keyPath! == "playbackBufferEmpty" {
            if m_Item!.isPlaybackBufferEmpty {
                print("playbackBufferEmpty")
                m_Player?.play()
            }
        } else if keyPath! == "playbackLikelyToKeepUp" {
            if m_Item!.isPlaybackLikelyToKeepUp {
                print("playbackLikelyToKeepUp")
            }
        }
    }
}
