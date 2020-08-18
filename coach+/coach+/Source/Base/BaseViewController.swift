//
//  BaseViewController.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 2. 29..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare;

class BaseViewController : LifeCycleViewController, WebResponseDelegate
{
    // 네비게이션바 감추기
    func hideNavigationBar() {
        let cont = self.navigationController;
        if (cont?.isNavigationBarHidden == false) {
            print("BVC: 네비게이션 바 숨기기");
            cont?.isNavigationBarHidden = true;
        }
    }

    // 네비게이션바 보이기
    func showNavigationBar() {
        let cont = self.navigationController;
        if (cont?.isNavigationBarHidden == true) {
            print("BVC: 네비게이션 바 보이기");
            cont?.isNavigationBarHidden = false;
        }
    }
    
    // 사용자 기본값 읽기
    func GetDefaultValue(_ key: String) -> String {
        let rep = UserDefaults.standard;
        let ret = rep.string(forKey: key);
        return ret!;
    }
    
    // 사용자 기본값 저장
    func SetDefaultValue(_ key: String, _ value: String) {
        let rep = UserDefaults.standard;
        rep.setValue(value, forKey: key);
        rep.synchronize();
    }
    
    var MiddleWare : MWControlCenter {
        return MWControlCenter.getInstance();
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    static func getStoryboard(_ name: String) -> UIStoryboard? {
        let storyboard = UIStoryboard(name: name, bundle: nil);
        return storyboard;
    }
    
    static func getViewController(_ storyName: String, _ viewName: String) -> UIViewController? {
        let story = getStoryboard(storyName);
        return story?.instantiateViewController(withIdentifier: viewName);
    }
    
    fileprivate static var m_skip_mode = false
    static var SkipMode: Bool {
        get {
            return m_skip_mode
        }
        set {
            m_skip_mode = newValue
        }
    }
    
    static func changeScreenUserValid() -> UIViewController {
        if !User.isValidDevice && !SkipMode {
            let vc = getViewController("Main", "ProductSelect")
            return vc!
        } else if !User.isValidProfile {
            let vc = getViewController("Main", "Profile")
            return vc!
        } else if !User.isValidTarget {
            let vc = getViewController("Main", "Weight")
            return vc!
        }
        
        let transfer = DataTransfer()
        transfer.start()
        
        let vc = getViewController("Main", "Main")
        return vc!
    }
    
    static var trainer: TrainerCode = TrainerCode.기초
    static var program: ProgramCode = ProgramCode.기초
    static var basic: ProgramCode.BasicCode = ProgramCode.BasicCode.기초1
    
    fileprivate static var m_select_graph: GraphIdentifier = .accuracyGraph
    static var SelectGraph: GraphIdentifier {
        get {
            return m_select_graph
        }
        set {
            m_select_graph = newValue
        }
    }
    
    static var VideoFileName: String {
        let fName = "prog_" + String(format: "%03d", BaseViewController.program.rawValue) + (BaseViewController.program == .기초 ? String(format: "_%02d", BaseViewController.basic.rawValue) : "") + ".mp4";
        return fName
    }
    
    static var XmlFileName: String {
        return String(format: "Video_%03d.xml", BaseViewController.program.rawValue)
    }
    
    let Graph_Color_Week_Year = Common.makeColor(0x65, 0xb2, 0xe9)
    let Graph_Color_Step = Common.makeColor(0xf0, 0xa4, 0x7e)
    
    static var HomeInfo = MainInfo()
    static var User = UserRecord();
    static var MainMode = false;

    func call_OK(_ action: UIAlertAction) {
        
    }
    
    func showMessage(_ title: String?, message: String, buttonCaption: String, viewController: UIViewController,
                     callback: (() -> ())? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert);
        
        let confirmAction = UIAlertAction(title: buttonCaption, style: UIAlertActionStyle.default) {
            (action) in
            if callback != nil {
                callback!()
            }
        }

        /*
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) {
            (action) in
        }
        */
        
        alertController.addAction(confirmAction);
        viewController.present(alertController, animated: true, completion: nil);
    }
    
    func dismissLoadingPopup(_ callback: @escaping () -> ()) {
        alert?.dismiss(animated: true, completion: callback)
        alert?.removeFromParentViewController()
    }

    fileprivate var alert: UIAlertController?
    fileprivate func showNoButtonMsg(_ title: String?, message: String, viewController: UIViewController) {
        alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert);
        
        viewController.present(alert!, animated: true, completion: nil);
    }
    
    func showLoadingPopup(_ msg: String) {
        showNoButtonMsg(nil, message: msg, viewController: self);
    }

    func showPopup(_ msg: String) {
        let buttCap = NSLocalizedString("OK", comment: "확인");
        showMessage(nil, message: msg, buttonCaption: buttCap, viewController: self);
    }
    
    func showPopup(_ msg: String, callback: @escaping () -> ()) {
        let buttCap = NSLocalizedString("OK", comment: "확인");
        showMessage(nil, message: msg, buttonCaption: buttCap, viewController: self, callback: callback);
    }
    
    func dialogConfirm(_ msg: String, yesCall: (() -> ())?, noCall: (() -> ())?) {
        let alertController = UIAlertController(
            title: title,
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
        self.present(alertController, animated: true, completion: nil);
    }

   
    func getActionColorList() -> [UIColor] {
        return [
            Common.makeColor(0xdb, 0xac, 0x6d),    // 수면 / 바뀜
            Common.makeColor(0xff, 0xa1, 0x2d),    // 안정 / ff a1 2d
            Common.makeColor(0x00, 0xb1, 0xac),    // 일상활동 / 00 b1 ac
            Common.makeColor(0x00, 0xb3, 0x8a),    // 강한활동 / 00 b3 8a
            Common.makeColor(0xa3, 0xd8, 0x69),    // 걷기 / a3 d8 69
            Common.makeColor(0x66, 0xbc, 0x29),    // 빨리걷기 / 66 bc 29
            Common.makeColor(0x39, 0x89, 0x2f),    // 경사걷기 / 39 89 2f
            Common.makeColor(0xf0, 0x52, 0x83),    // 계단 / f0 52 83
            Common.makeColor(0xe3, 0x04, 0x50),    // 달리기 / e3 04 50
            Common.makeColor(0x72, 0x85, 0x74),    // 등산 / 72 85 74
            Common.makeColor(0x5a, 0x7e, 0x92),    // 자전거 / 5a 7e 92
            Common.makeColor(0x87, 0x5f, 0x7f),    // 골프 / 87 5f 7f
            Common.makeColor(0xb5, 0xb7, 0xb4),    // 미착용 / b5 b7 b4
            Common.makeColor(0x9f, 0x18, 0x88),    // 스포츠 / 9f 18 88
        ];
    }
    
    func getActionColor(_ actionIndex: Int) -> UIColor {
        switch (actionIndex) {
        // 수면
        case 201:
            return Common.makeColor(0xdb, 0xac, 0x6d);
        // 안정
        case 202:
            return Common.makeColor(0xff, 0xa1, 0x2d);
        // 일상활동
        case 203:
            return Common.makeColor(0x00, 0xb1, 0xac);
        // 강한활동
        case 204:
            return Common.makeColor(0x00, 0xb3, 0x8a);
        // 걷기
        case 205:
            return Common.makeColor(0xa3, 0xd8, 0x69);
        // 빨리걷기
        case 206:
            return Common.makeColor(0x66, 0xbc, 0x29);
        // 경사걷기
        case 207:
            return Common.makeColor(0x39, 0x89, 0x2f);
        // 계단
        case 208:
            return Common.makeColor(0xf0, 0x52, 0x83);
        // 달리기
        case 209:
            return Common.makeColor(0xe3, 0x04, 0x50);
        // 등산
        case 210:
            return Common.makeColor(0x72, 0x85, 0x74);
        // 자전거
        case 211:
            return Common.makeColor(0x5a, 0x7e, 0x92);
        // 골프
        case 212:
            return Common.makeColor(0x87, 0x5f, 0x7f);
        // 미착용
        case 241:
            return Common.makeColor(0xb5, 0xb7, 0xb4);
        // 기타 스포츠
        //case 291:
        default:
            return Common.makeColor(0x9f, 0x18, 0x88);
        }
    }
    
    // [네비게이션 뷰 컨트롤러]
    // 뷰를 스택으로 관리한다.
    // 기본이 되는 Root View Controller가 있다.
    // Push하면 스택에 쌓여 위에 노출되고, Pop하면 화면이 제거됨
    // 참조: http://mobicon.tistory.com/category/Languages/Swift
    
    
    func nextNavigationView(_ ctrlName: String, transition: UIModalTransitionStyle) {
        // 두번째 화면의 인스턴스를 만든다
        let uvc: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: ctrlName))! as UIViewController
        // 화면 전환 스타일을 지정한다
        uvc.modalTransitionStyle = transition;
        // 화면을 호출한다
        //self.presentViewController(uvc, animated: true, completion: nil)
        self.navigationController?.pushViewController(uvc, animated: true);
    }
    
    func dismissNavigationView() {
        //self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // [세그 (Segue)]
    // 화면 연결 처리 전용 객체
    // Source : 자신이 있는 곳
    // Destination : 목적지
    // 연결 방법
    // + 첫번째 화면(Source) 버튼을 Ctrl 누른 상태에서 두번째 화면(Destination)으로 드래그 앤 드롭을 하면 Segue 연결 팝업창이 나옴
    // + 두번째 화면을 선택하고 오른쪽 상단의 마지막 아이콘 (->) 을 선택하고
    // + Presenting Segues 에서 Present modally를 선택하고 첫번째 화면으로 드래그 앤 드롭해 연결
    // 값 전달하기
    // 직접 전달: 두번째 화면 컨트롤러로 캐스팅
    // segue를 연결해서 전달: prepareForSegue 재정의 내역에 segue. destinationViewController를 두번째 화면 컨트롤러로 캐스팅
    
    // source 화면에서 버튼을 추가하고 destination 화면으로 이동할 때 값을 전달하는 방법
    
    
    @IBAction
    func nextPresentation(_ sender: AnyObject) {
        let uvc = self.storyboard?.instantiateViewController(withIdentifier: "secondViewController");
        //uvc.param = "Direct Parameter";
        self.present(uvc!, animated: true, completion: nil);
    }
    
    // segue로 연결해서 값을 전달하는 경우
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "SG_Result_Measure" {
//            if let dest = segue.destinationViewController as? ActivityResultScreen {
//                if let date = sender as? Int {
//                    dest.m_start_date = Int64(date)
//                }
//            }
//        }
//    }
    
    // 병렬 프로그래밍을 위한 대표적인 방법
    // 참고 - http://seorenn.blogspot.kr/2014/06/swift-nsoperationqueue.html
    // 1. 스레드 - NSThread
    // 2. NSOperationQueue - 참고 http://seorenn.blogspot.kr/2014/06/swift-nsoperationqueue.html
    // 3. GCD (Grand Centeral Dispatch) - http://bartysways.net/?p=514
    
    // 스레드를 만들어 바로 시작
    //NSThread.detachNewThreadSelector("runLoop", toTarget: self, withObject: nil)
    // 스레드를 만들고 시작
    //let thread = NSThread(target: self, selector: "runLoop", object: nil)
    //thread.start()
    
    func threadMethod01() {
        // 취소 되기 전까지 무한 루프
        while (Thread.current.isCancelled == false) {
            print("쓰레드 메서드 실행");
            // 1초간 휴식
            Thread.sleep(forTimeInterval: 1);
        }
    }
    
    static func getTodayData() {
        BaseViewController.HomeInfo.executQuery(.ExerciseToday, success: success, fail: fail)
    }
    
    func parse(_ json: NSDictionary, queryCode: QueryCode) -> QueryStatus {
        return QueryStatus.OK
    }
    
    fileprivate static var m_today_handler: (() -> ())?
    fileprivate static var m_week_handler: (() -> ())?
    
    static func setTodayDataHandler(_ handler: @escaping ()->()) {
        m_today_handler = handler
    }
    
    static func setWeekDataHandler(_ handler: @escaping ()->()) {
        m_week_handler = handler
    }
    
    func OnQuerySuccess(_ queryCode: QueryCode) {
        
    }
    
    func OnQueryFail(_ queryStatus: QueryStatus) {
        
    }

    fileprivate static func success() {
        if BaseViewController.m_today_handler != nil {
            BaseViewController.m_today_handler!()
        }
        if BaseViewController.m_week_handler != nil {
            BaseViewController.m_week_handler!()
        }
    }
    
    static func fail(_ queryStatus: QueryStatus) {
        
    }
}
