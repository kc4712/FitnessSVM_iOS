//
//  SelectExercise.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 19..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import MiddleWare

class SelectExercise: BaseViewController,
        UICollectionViewDelegate,
        UICollectionViewDataSource,
        UICollectionViewDelegateFlowLayout,
        UIWebViewDelegate,
        WebDownLoadDelegate,
        MCPercentageDoughnutViewDataSource {
    fileprivate static let tag = SelectExercise.className

    /** MiddleWare **/
    fileprivate let mc: MWControlCenter = MWControlCenter.getInstance()
    
    fileprivate var preparePlay = false
    
    fileprivate let DownLoader = WebDownLoad()
    fileprivate var current_loading = 0

    @IBOutlet var m_background_progress: UIView!
    @IBOutlet var m_progressMainView: UIView!
    @IBOutlet var progressView: MCPercentageDoughnutView!
    
    @IBOutlet var mWebView: UIWebView!
    @IBOutlet var m_collectionView: UICollectionView!
    
    @IBOutlet weak var height_web: NSLayoutConstraint!
    @IBOutlet weak var height_button: NSLayoutConstraint!
    @IBOutlet weak var height_line: NSLayoutConstraint!
    
    @IBOutlet weak var scroll_width: NSLayoutConstraint!
    @IBOutlet weak var scroll_height: NSLayoutConstraint!
    
    @IBOutlet var ButtonDownLoad: UIButton!
    
    fileprivate var isWait = false
    fileprivate var success = false
    
    fileprivate var mDispatchQ: DispatchQueue?
    fileprivate var mDispatchWorkItem: DispatchWorkItem?
    
    fileprivate func createDispatchforLoading() {
        mDispatchQ = DispatchQueue.global(qos: .background)
        mDispatchWorkItem = DispatchWorkItem {
            self.success = self.mc.getConnectionState() == .state_DISCONNECTED ? false : true
            self.dismissLoadingPopup(self.dismissCallback)
        }
    }
    
    fileprivate func cancelDispatch() {
        if mDispatchQ != nil && mDispatchWorkItem != nil {
            mDispatchWorkItem?.cancel()
        }
    }
    
    fileprivate func dismissCallback() {
        if success {
            showPopup(Common.ResString("success_connect"))
        } else {
            showPopup(Common.ResString("fail_connect_device_confirm"))
        }
        isWait = false
    }
    
    @IBAction func ActionButton(_ sender: UIButton) {
        if preparePlay {
            if isConnect() { // 실제 동작시키는 경우, 풀어야함.
                
                //규창 이 시점에서 읽는 Preference.PeripheralState는 0?....Int32(StatePeripheral.idle.rawValue)...1?
                Log.i("TabbarCenter idle Check", msg: "Preference.PeripheralState = \(Preference.PeripheralState)  Int32(StatePeripheral.idle.rawValue)=\(Int32(StatePeripheral.idle.rawValue))")
                if mc.getSelectedProduct() == .fitness {
                    if Preference.PeripheralState != Int32(StatePeripheral.idle.rawValue) {
                        showPopup(Common.ResString("state_not_idle"))
                        return
                    }
                }
                
                if isBusy() {
                    return
                }
                
                if !FileManager.isExistFile(BaseViewController.XmlFileName) {
                    let parser = VersionService()
                    parser.setHandler(completeXmlDownload)
                    
                    let query = WebQuery(queryCode: .CheckVersion, request: parser, response: parser)
                    query.start()
                }
                performSegue(withIdentifier: "PlayScreen", sender: nil)
            }
        } else {
            let msg = Common.ResString("warnning_download")
            dialogConfirm(msg, yesCall: yesCallback, noCall: noCallback);
        }
    }
    
    func yesCallback() {
        var lang = Common.LanguageCode
        if lang != "KO" && lang != "JA" && lang != "EN" && lang != "ZH"{
            lang = "KO"
        }
        if lang == "JA" {
            lang = "JP"
        }
        
        let url = URL(string: String(format: "http://ibody24.com/down/%@/%@", lang, BaseViewController.VideoFileName))!
        DownLoader.download(url)
        
        showAnimate()
    }
    
    func noCallback() {
        // do nothing
    }
    
    private var m_coll_height = CGFloat(302);
    
    fileprivate var viewDataArray: [VideoViewData] = []
    
    private func setDeviceWidth() {
        let rect = UIScreen.main.bounds;
        scroll_width.constant = rect.size.width;
        print("Set Screen Width: \(rect.size.width)");
        mWebView.scrollView.isScrollEnabled = false;
        mWebView.scrollView.bounces = false;
        m_collectionView.isScrollEnabled = false;
    }
    
    private func setContentHeight() {
        //let m_coll_view_size = m_collectionView.frame.size;
        //print("Collection View Size: \(m_coll_view_size.width), \(m_coll_view_size.height)");
        m_coll_height = m_collectionView.contentSize.height;
        //print("Collection Content Size: \(m_coll_cont_size.width), \(m_coll_cont_size.height)");
        let cal_height = height_web.constant + height_button.constant + height_line.constant + m_coll_height;
        scroll_height.constant = cal_height;
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let m_web_size = mWebView.sizeThatFits(CGSize.zero);
        print("WebView Fit Size: \(m_web_size.width), \(m_web_size.height)");
        height_web.constant = m_web_size.height;
        let cal_height = height_web.constant + height_button.constant + height_line.constant + m_coll_height;
        scroll_height.constant = cal_height;
    }

    override func viewWillDisappear(_ animated: Bool) {
        DownLoader.cancelTask()
        progressView.percentage = 0
        displayProgress(false)
        preparePlay = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DownLoader.respDelegate = self
        
        if BaseViewController.program != ProgramCode.기초 {
            if FileManager.isExistFile(BaseViewController.VideoFileName) {
                ButtonDownLoad.setTitle("START", for: UIControlState())
                preparePlay = true
            } else {
                preparePlay = false
            }
            
            m_collectionView.allowsSelection = false
            // 기초가 아니면, 파일 재생 형식.
        }
    }
    
    override func viewDidLoad() {
        createDispatchforLoading()
        if mc.getSelectedProduct() == .fitness {
            mc.sendRequestState()
        }
        setDeviceWidth();
        
        setViewData()
        setProgressBar()

        setHtml()
//        let dispMsg = "<div style='background-color: #ddd;'>우리는 민족 중흥의 역사적 <font color=red>사명을</font> 띠고 이땅에 태어났다. 조상의 빛난 얼을 오늘에 되살려 안으로 자주 독립의 자세를 확립하고 밖으로 인류 공영에 이바지 할 때다.</div>";
//        mWebView.loadHTMLString(dispMsg, baseURL: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        m_collectionView.reloadData()
        setContentHeight();
    }
    
    @IBAction func unwindToSelectExerciseScreen(_ segue: UIStoryboardSegue) {
    }
    
    fileprivate func completeXmlDownload() {
        print("xml 다운완료")
    }
    
    fileprivate func setHtml() {
        let url = Bundle.main.url(forResource: BaseViewController.program.htmlName, withExtension:"html")
        let request = URLRequest(url: url!)
        mWebView.loadRequest(request)
    }
    
    fileprivate func isBusy() -> Bool {
        if mc.isBusySender {
            showPopup(Common.ResString("device_initial_wating"))
            return true
        }
        
        return false
    }
    
    fileprivate func isConnect() -> Bool {
//        if mc.getConnectionState() == ConnectStatus.state_DISCONNECTED {
//            showPopup(Common.ResString("device_not_connected"))
//            return false
//        }
        if mc.getConnectionState() == ConnectStatus.state_DISCONNECTED {
            mc.tryConnectionBluetooth()
            showLoadingPopup(Common.ResString("connecting_device"))
            isWait = true
            if mDispatchQ != nil && mDispatchWorkItem != nil {
                let popTime = DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                mDispatchQ?.asyncAfter(deadline: popTime, execute: mDispatchWorkItem!)
            }
            return false
        }
        
        return true
    }
    
    func run(_ notification: Notification) {
        print("\(className) ************************ \(notification.name)")
        switch notification.name.rawValue {
        case MWNotification.Bluetooth.RaiseConnectionState:
            if isWait {
                if mc.getConnectionState() == .state_CONNECTED {
                    cancelDispatch()
                    createDispatchforLoading()
                    success = true
                    dismissLoadingPopup(dismissCallback)
                    return
                }
            }
        default:
            break
        }
    }
    
    fileprivate func setProgressBar() {
        //let rect = CGRect(x: 0, y: 100, width: 100, height: 100)
        // 프로그레스바 위치, 크기 결정.
        //let perView = MCPercentageDoughnutView(frame: progressView.bounds)
//        progressView.dataSource = self
        progressView.initialPercentage = 0
        progressView.percentage = 0
        progressView.linePercentage = 0.3
        progressView.animatesBegining = true
        progressView.unfillColor = Common.makeColor(0xf7, 0xf7, 0xf7)
        progressView.fillColor = Common.makeColor(230, 86, 34)
//        progressView.enableGradient = true // 문제 있음.
//        progressView.gradientColor1 = UIColor.greenColor()
//        progressView.gradientColor2 = UIColor.clearColor()
        displayProgress(false)
        
        
//        view.addSubview(perView)
    }
    
    // 도넛 내부의 View를 편집해서 사용하고자할때 필요한 delegate
    func viewForCenter(of pecentageDoughnutView: MCPercentageDoughnutView!, withCenter centerView: UIView!) -> UIView! {
        let label = UILabel(frame: centerView.bounds)
        
        return label
    }
    
    fileprivate func setViewData() {
        switch BaseViewController.program {
        case .기초:
            viewDataArray = VideoViewData.program001
            ButtonDownLoad.isHidden = true
        case .전신:
            viewDataArray = VideoViewData.program002
        case .매트:
            viewDataArray = VideoViewData.program003
        case .액티브:
            viewDataArray = VideoViewData.program004
        case .복근완성:
            viewDataArray = VideoViewData.program101
        case .완벽뒤태:
            viewDataArray = VideoViewData.program102
        case .바디1:
            viewDataArray = VideoViewData.program201
        case .바디2:
            viewDataArray = VideoViewData.program202
        case .출산부1:
            viewDataArray = VideoViewData.program301
        case .출산부2:
            viewDataArray = VideoViewData.program302
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds;
        let screenWidth = screenRect.width;
        //let screenWidth = collectionView.bounds.width;
        let cellWidth = (screenWidth - 10) / 2;
        let siz = CGSize(width: cellWidth, height: cellWidth * 0.85);
        print("Cell Size: \(siz.width), \(siz.height)");
        return siz;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let icon = cell.viewWithTag(21) as? UIImageView {
            icon.image = UIImage(named: viewDataArray[(indexPath as NSIndexPath).row].ImageFileName)
        }
        if let name = cell.viewWithTag(22) as? UILabel {
            name.text = viewDataArray[(indexPath as NSIndexPath).row].CourseName;
        }
        
        return cell
    }
    
    var HighlightColor: UIColor {
        get { return UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1); }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        cell.backgroundColor = HighlightColor
        
        if BaseViewController.trainer == .기초 {
            // 기초 운동의 경우, 이곳에서 선택된 것에따라 streaming 수행. 서버의 url 전달. http://ibody24.com/video/NAME.mp4
            BaseViewController.basic = ProgramCode.BasicCode(rawValue: (indexPath as NSIndexPath).row + 1)!
        } else {
            // 다른 운동은 선택 안됨. 애초에 선택 불가능 창으로 설정했기 때문 여기는 오지 않는다.
            return
        }
        
        cell.isSelected = false
        collectionView.reloadData()
        
        performSegue(withIdentifier: "PlayScreen", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        cell.backgroundColor = UIColor.clear
    }
    
    fileprivate func showAnimate() {
        displayProgress(true)
        
        m_progressMainView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        m_progressMainView.alpha = 0.0
        m_background_progress.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        m_background_progress.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.m_background_progress.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.m_background_progress.alpha = 0.5
            self.m_progressMainView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.m_progressMainView.alpha = 1
        })
    }
    
    fileprivate func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.m_background_progress.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.m_background_progress.alpha = 0.0
            self.m_progressMainView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.m_progressMainView.alpha = 0.0
            }, completion: { finish in
                if finish {
                    self.displayProgress(false)
                }
        })
    }
    
    func displayProgress(_ display: Bool) {
        let disp = display == false ? true : false
        
        m_background_progress.isHidden = disp
        progressView.isHidden = disp
        m_progressMainView.isHidden = disp
    }
    
    override func OnQuerySuccess(_ queryCode: QueryCode) {
        print("다운로드 성공!!!")
        DispatchQueue.main.async(execute: {
            if BaseViewController.program != ProgramCode.기초 {
                if FileManager.isExistFile(BaseViewController.VideoFileName) {
                    self.ButtonDownLoad.setTitle("START", for: UIControlState())
                    self.preparePlay = true
                } else {
                    self.ButtonDownLoad.setTitle("DOWNLOAD", for: UIControlState())
                    self.preparePlay = false
                }
            }
            
            self.removeAnimate()
        })
    }
    
    override func OnQueryFail(_ queryStatus: QueryStatus) {
        
    }
    
    func OnProgressPercent(_ percent: Int) {
        if current_loading != percent {
            self.progressView.percentage = CGFloat(percent)/100
            current_loading = percent
        }
    }
    
    override func parse(_ json: NSDictionary, queryCode: QueryCode) -> QueryStatus {
        return QueryStatus.OK
    }
    
    func getDestinationURL(_ url: URL) {
        
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
}
