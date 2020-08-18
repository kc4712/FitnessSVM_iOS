//
//  FitnessHomeScreen.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 7. 27..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit
import MiddleWare

class FitnessHomeScreen: UITableViewController, BaseProtocol {
    fileprivate static let tag = FitnessHomeScreen.className
    
    @IBOutlet var m_StepCountTxt: UILabel!
    @IBOutlet var m_CalorieTxt: UILabel!
    @IBOutlet var m_ActivityTxt: UILabel!
    @IBOutlet var m_SleepStateTxt: UILabel!
    @IBOutlet var m_StressStateTxt: UILabel!
    
    @IBOutlet var m_activityNoTxt: UILabel!
    @IBOutlet var m_sleepNoTxt: UILabel!
    @IBOutlet var m_stressNoTxt: UILabel!
    
    fileprivate let parser = ExerciseInfo()
    fileprivate var step_datas = StepInfo()
    
    fileprivate var mc: MWControlCenter?
    fileprivate var calendar: MWCalendar?
    
    fileprivate let sql = SQLHelper.getInstance()
    
    fileprivate var saveCount = 0
    
    fileprivate var gearView: UIActivityIndicatorView?
    
    @IBOutlet var m_loadingView: UIView!
    
    @IBOutlet var m_cell_Loading: UITableViewCell!
    @IBOutlet var m_cell_Step: UITableViewCell!
    @IBOutlet var m_cell_Calorie: UITableViewCell!
    @IBOutlet var m_cell_Act: UITableViewCell!
    @IBOutlet var m_cell_Sleep: UITableViewCell!
    @IBOutlet var m_cell_Stress: UITableViewCell!
    
    
    @IBOutlet var m_BehaviorNoTxt: UILabel!
    @IBOutlet var m_BehaviorInformNoTxt: UILabel!
    @IBOutlet var m_cell_Behavior: UITableViewCell!
    
    fileprivate var now: Date?
    //규창 --- 디스패치 블록문을 대치 못하여 주석으로 남김
    //dispatch_block_t 을 자동변환하면 ()->()으로 바뀜 
    //fileprivate var block: dispatch_block_t?
    
    fileprivate let delay: TimeInterval = 0.5
    
    fileprivate var moveFlag = false
    fileprivate var cellArray: [UITableViewCell] = []
    
    fileprivate var mDispatchWorkItem: DispatchWorkItem?
    
    fileprivate func createDispatchforLoading() {
        mDispatchWorkItem = DispatchWorkItem {
            self.delete()
            self.gearView?.stopAnimating()
        }
    }
    
    fileprivate func cancelDispatch() {
        if mDispatchWorkItem != nil {
            mDispatchWorkItem?.cancel()
        }
    }
    
    // 미들웨어 또는 각종 갱신되고자 하는 부분 처리
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("새로고침");
        mc?.sendForceRefresh()
        reloadStepNCalorie()
        reloadSleep()
        reloadStress()
        reloadActivity()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        parser.setSuccess(success)
        parser.setFail(fail)
        
        let image = UIImage(named: "메인_상단_로고.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        //규창 171011 Swift4 마이그레이션 iOS11 헤더로고 크기 달라짐 문제
        // https://stackoverflow.com/questions/46408510/header-logo-is-wrong-size-on-swift-4-xcode-9-ios-11
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true;
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true;
        
        self.navigationItem.titleView = imageView
        
        
        if !Preference.AutoLogin {
            Preference.AutoLogin = true
        }
        
        BaseViewController.MainMode = true;
        
        Preference.Email = BaseViewController.User.Email;
        Preference.Password = BaseViewController.User.Password;
        
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        
        mc = MWControlCenter.getInstance()
        calendar = MWCalendar.getInstance()
        calendar?.setTimeZone(NSTimeZone.default)
        mc!.setIsLiveApplication(StateApp.state_NORMAL)
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged);
        
        setLoadingView()
        
        // table view TEST
        cellArray.append(m_cell_Loading) //0
        cellArray.append(m_cell_Step) //1
        cellArray.append(m_cell_Calorie) //2
        cellArray.append(m_cell_Act) //3
        cellArray.append(m_cell_Sleep) //4
        cellArray.append(m_cell_Stress) //5
        cellArray.append(m_cell_Behavior) //6
    }
    
    fileprivate func setLoadingView() {
        //동기화 로딩 뷰
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        gearView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        gearView?.transform = transform
        gearView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        gearView?.stopAnimating()
        m_loadingView.addSubview(gearView!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if moveFlag {
            switch (indexPath as NSIndexPath).row {
            case 1:
                cell = cellArray[0]
            case 2:
                cell = cellArray[1]
            case 3:
                cell = cellArray[2]
            case 4:
                cell = cellArray[3]
            case 5:
                cell = cellArray[4]
            case 6:
                cell = cellArray[5]
            case 7:
                cell = cellArray[6]
            default:
                break
            }
        } else {
            switch (indexPath as NSIndexPath).row {
            case 1:
                cell = cellArray[1]
            case 2:
                cell = cellArray[2]
            case 3:
                cell = cellArray[3]
            case 4:
                cell = cellArray[4]
            case 5:
                cell = cellArray[5]
            case 6:
                cell = cellArray[6]
            default:
                break
            }
        }
        
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        TabBarCenter.selecter = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TabBarCenter.selecter = self
        createDispatchforLoading()
        
        if moveFlag {
            delete()
        }
        
        let main_step = Preference.MainStep
        let main_calorie = Preference.MainCalorieActivity + Preference.MainCalorieCoach + Preference.MainCalorieSleep + Preference.MainCalorieDaily
        
        m_StepCountTxt.text = String(main_step)
        m_CalorieTxt.text = String(main_calorie)
        
        reloadSleep()
        reloadStress()
        reloadActivity()
    }
    
    fileprivate func queryStep() {
        if Int32(mc!.Step) == Preference.MainStep {
            return
        }
        let current = Int64((Date().timeIntervalSince1970 * 1000))
        
        step_datas.Reg = current
        step_datas.Step = Int32(mc!.Step)
        
        let query = WebQuery(queryCode: .InsertStep, request: step_datas, response: step_datas)
        query.start()
    }
    
    func run(_ notification: Notification) {
        let sql = SQLHelper.getInstance()
        
        print("\(className) ************************ \(notification.name)")
        switch notification.name.rawValue {
        case MWNotification.Bluetooth.StressInform:
            let stress = StressIdentifier(rawValue: mc!.Stress)
            Preference.StressState = Int32((stress?.rawValue)!)
            performSelector(onMainThread: #selector(reloadStress), with: nil, waitUntilDone: true)
        case MWNotification.Bluetooth.StepCountNCalorie:
            performSelector(onMainThread: #selector(reloadStepNCalorie), with: nil, waitUntilDone: true)
        case MWNotification.Bluetooth.SleepInform:
            // 현재 수면 정보를 요청하는 부분은 수면 페이지 하나뿐인데, 메인페이지에 수면 노티가 온다면...노티를 받기전에 수면페이지를 빠져나왔을 가능성 존재함.
            // 그때는 그 시간을 종료시간이라고 가정하고 수면을 계산하여 저장하고 메인화면에 뿌린다.
            let sql = SQLHelper.getInstance()
            
            let save_time = sql?.getIndexTime(BLCmdLabel: Int32(BluetoothCommand.sleep.rawValue))
            now = Date(timeIntervalSince1970: Double((save_time?.1)!)/1000)
            _ = sql?.deleteIndexTime((save_time?.1)!)
            
            let interval = ((save_time?.2)! - (save_time?.1)!) / Int64(60000)
            print("main page sleep 2 end:\(String(describing: save_time?.2)) start:\(String(describing: save_time?.1))")
            
            let sleep = mc!.SleepData
            let idfier = Common.getSleepCalc(Int64(interval))
            Preference.SleepState = Int32(idfier.rawValue)
            Preference.SleepTime = Int32(interval)
            Preference.SleepAwaken = Int32(sleep.awaken)
            Preference.SleepRolled = Int32(sleep.rolled)
            Preference.SleepStabilityHR = Int32(sleep.stabilityHR)

            performSelector(onMainThread: #selector(reloadSleep), with: nil, waitUntilDone: true)
        case MWNotification.Bluetooth.ActivityInform:
            let act = mc!.ActivityData
            let data = ActivityData(index: 0, label: CourseLabel.activity.rawValue, calorie: act.act_calorie, start_date: 1, end_date: 2, intensityL: Int32(act.intensityL), intensityM: Int32(act.intensityM), intensityH: Int32(act.intensityH), intensityD: Int32(act.intensityD), maxHR: Int32(act.maxHR), minHR: Int32(act.minHR), avgHR: Int32(act.avgHR), upload: SQLHelper.NONSET_UPLOAD)
            
            let start_time = confirm(.activity, userInfo: notification.userInfo)
            if start_time == 0 {
                return
            }
            
            let sql_data = sql?.getIndexTime(start_time)
            data.StartDate = ((sql_data?.1)!/1000*1000)
            data.EndDate = ((sql_data?.2)!/1000*1000)
            
            _ = sql?.addConsume(data)
            _ = sql?.deleteIndexTime((sql_data?.1)!)
            
            let Low = (1, act.intensityL)
            let Mid = (2, act.intensityM)
            let High = (3, act.intensityH)
            let Danger = (4, act.intensityD)
            let arr = [Low, Mid, High, Danger]
            let result = arr.sorted(by: {$0.1 > $1.1})
            
            Preference.ActivityState = Int32(result[0].0)
            
            let transfer = DataTransfer()
            transfer.start()

            performSelector(onMainThread: #selector(reloadActivity), with: nil, waitUntilDone: true)
        case MWNotification.Bluetooth.RaiseConnectionState:
            // 연결될때마다 Q 갱신
            if mc!.getConnectionState() == .state_CONNECTED {
                for data in (sql?.getIndexTime())! {
                    if data.2 == 0 {
                        continue
                    }
                    
                    if let cmd = BluetoothCommand(rawValue: UInt16(data.0)) {
                        if cmd == .activity {
                            print("Input connect append-> cmd:\(cmd) time:\(data.1)")
                            mc!.appendSender((cmd, data.1, .inform, true, .empty))
                        }
                    }
                }
            }
        case MWNotification.Bluetooth.DataSync:
            if let isSync = notification.userInfo![MWNotification.Bluetooth.DataSync] as? Bool {
                if isSync && !moveFlag {
                    now = Date()
                    
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            // 이유는 모르겠지만, 큐를 중복하여 쓰면 정상 동작함.
                            self.gearView?.center = CGPoint(x: self.m_loadingView.bounds.size.width / 2, y: self.m_loadingView.bounds.size.height / 2)
                        }
                        self.insert()
                        self.gearView?.startAnimating()
                    }
                } else if !isSync && moveFlag {
                    let interval = Date().timeIntervalSince(now!)
                    
                    cancelDispatch()
                    
                    if interval < delay {
                        if mDispatchWorkItem != nil {
                            createDispatchforLoading()
                            let popTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//                            let popTime = DispatchTime.now() + .milliseconds(500) // delay 와 맞춰야함.
                            DispatchQueue.main.asyncAfter(deadline: popTime, execute: mDispatchWorkItem!)
                        }
                        
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.delete()
                        self.gearView?.stopAnimating()
                    }
                }
            }
        case MWNotification.Bluetooth.StatePeripheral:
            Preference.PeripheralState = Int32(mc!.State.rawValue)
        case MWNotification.Bluetooth.FeatureDataComplete:
            let feature = mc!.FeatureData
            
            let data = FeatureData(index: 0, label: CourseLabel.feature.rawValue, actIndex: feature.actIndex, start_date: feature.start_date, intensity: feature.intensity, calorie: feature.calorie, speed: feature.speed, heartrate: feature.heartrate, step: feature.step, swing: feature.swing, press_var: feature.press_var, coach_intensity: feature.coach_intensity, upload: SQLHelper.NONSET_UPLOAD)
            //String.init(format: "%0.2f", input)
            let start_time = feature.start_date
            if start_time == 0{
                return
            }
            //let sql_data = sql?.getIndexTime(start_time)
            //data.StartDate = ((sql_data?.1)!/1000*1000)
            
            
            //sql?.deleteFeatureData(Int32(37))
            
            //sql?.deleteIndexTime()
            /*Log.i(FitnessHomeScreen.tag, msg: "???????????\(MWCalendar.getInstance().year) \(MWCalendar.getInstance().month) \(MWCalendar.getInstance().day)")
            let startnowDayTIME:String = " " + "00" + ":" + "00"
            let startnowMonthDayTime:String = String(MWCalendar.getInstance().month) + "/" + String(MWCalendar.getInstance().day) + startnowDayTIME
            let nowDay:String = String(MWCalendar.getInstance().year) + "/" + startnowMonthDayTime
            let format = DateFormatter()
            format.dateFormat = "yyyy/MM/dd HH:mm"
            let startnowDay:Date = format.date(from: nowDay)!
            let unixstartnowDay:Int64 = Int64(startnowDay.timeIntervalSince1970) * 1000
            
            
            
            for i in 0..<144 {
                var min10:Int64 = 0
                if i == 0 {
                    min10 = 0
                }
                else {
                    min10 = 600000
                }
             
                guard let feature2 = sql?.getFeatureData(unixstartnowDay+min10) else {
                    mc?.requestFeature(time: unixstartnowDay+min10);
                    Log.i(FitnessHomeScreen.tag, msg: "피쳐 데이터가 없어서 요청하고 리턴")
                    return
                }
                if feature2.StartDate == 0 {
                    mc?.requestFeature(time: unixstartnowDay+min10)
                } else {
                    let formatTime = Date(timeIntervalSince1970: TimeInterval((feature2.StartDate)/1000))
                    Log.i(FitnessHomeScreen.tag, msg: "강도:\(feature2.Intensity), 속도:\(feature2.Speed), 스텝:\(feature2.Step), 심박:\(feature2.Heartrate), cal:\(feature2.Calorie) 시간:\(format.string(from: formatTime as Date))")
                }
            }*/
            /*
            guard let feature3 = sql?.getFeatureData() else {
                return
            }
            for feat in feature3{
                Log.i(FitnessHomeScreen.tag, msg: "내부 데이터 베이스에 기록된 데이터들 \(feat.ActIndex) \(feat.StartDate) \(feat.Index)")
            }*/
            
            m_BehaviorNoTxt.text = Action.getActionName(Int(data.ActIndex))
            m_BehaviorInformNoTxt.text = "강도:\(data.Intensity), 속도:\(data.Speed), 스텝:\(data.Step), 심박:\(data.Heartrate), cal:\(data.Calorie)"
            /*let format = DateFormatter()
            //format.dateFormat = "yyyy/MM/dd HH:mm"
            format.dateFormat = "yyyy/MM/dd HH:mm"
 
            //let formatTime = Date(timeIntervalSince1970: TimeInterval(time[i]))
            let formatTime = Date(timeIntervalSince1970: TimeInterval(feature2.StartDate/1000))
            Log.i(FitnessHomeScreen.tag, msg: "강도:\(feature2.Intensity), 속도:\(feature2.Speed), 스텝:\(feature2.Step), 심박:\(feature2.Heartrate), cal:\(feature2.Calorie) 시간:\(format.string(from: formatTime as Date))")
             */
 
            if start_time == sql?.getFeatureData(start_time)?.StartDate {
                Log.i(FitnessHomeScreen.tag, msg: "이미 DB에 현재 시간 피쳐 기록됨")
            } else {
                Log.i(FitnessHomeScreen.tag, msg: "DB기록")
                //sql?.addConsume(data)
            }
            
            
            /*let act = mc!.ActivityData
            let data = ActivityData(index: 0, label: CourseLabel.activity.rawValue, calorie: act.act_calorie, start_date: 1, end_date: 2, intensityL: Int32(act.intensityL), intensityM: Int32(act.intensityM), intensityH: Int32(act.intensityH), intensityD: Int32(act.intensityD), maxHR: Int32(act.maxHR), minHR: Int32(act.minHR), avgHR: Int32(act.avgHR), upload: SQLHelper.NONSET_UPLOAD)
            
            let start_time = confirm(.activity, userInfo: notification.userInfo)
            if start_time == 0 {
                return
            }
            
            let sql_data = sql?.getIndexTime(start_time)
            data.StartDate = ((sql_data?.1)!/1000*1000)
            data.EndDate = ((sql_data?.2)!/1000*1000)
            
            _ = sql?.addConsume(data)
            _ = sql?.deleteIndexTime((sql_data?.1)!)
            
            let Low = (1, act.intensityL)
            let Mid = (2, act.intensityM)
            let High = (3, act.intensityH)
            let Danger = (4, act.intensityD)
            let arr = [Low, Mid, High, Danger]
            let result = arr.sorted(by: {$0.1 > $1.1})
            
            Preference.ActivityState = Int32(result[0].0)
            
            let transfer = DataTransfer()
            transfer.start()*/
            
            
            
        default:
            break
        }
    }
    
    fileprivate func insert() {
        moveFlag = true
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .right)
        tableView.endUpdates()
    }
    
    fileprivate func delete() {
        moveFlag = false
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
    fileprivate func confirm(_ in_cmd: BluetoothCommand, userInfo: [AnyHashable: Any]?) -> Int64 {
        var cmd: BluetoothCommand = .activity
        var start_time: Int64 = 0
        
        if let dic = userInfo {
            if let dic_cmd = dic["cmd"] as? NSNumber {
                if let tmp = BluetoothCommand(rawValue: dic_cmd.uint16Value) {
                    cmd = tmp
                }
            }
            if let dic_start_time = dic["start_time"] as? NSNumber {
                start_time = dic_start_time.int64Value
            }
        }
        
        if in_cmd != cmd {
            return 0
        }
        
        return start_time
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if moveFlag {
            return cellArray.count + 1
        } else {
            return cellArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !moveFlag {
            switch ((indexPath as NSIndexPath).row) {
            case 1:
                performSegue(withIdentifier: "Home_StepCount", sender: self);
            case 2:
                performSegue(withIdentifier: "Home_Today", sender: self);
            case 3:
                performSegue(withIdentifier: "Home_Start_Measure", sender: self);
            case 4:
                performSegue(withIdentifier: "Home_Sleep", sender: self);
            case 5:
                performSegue(withIdentifier: "Home_Stress", sender: self);
            case 6:
                performSegue(withIdentifier: "Home_Detail", sender: self);
            default:
                break;
            }
        } else {
            switch ((indexPath as NSIndexPath).row) {
            case 2:
                performSegue(withIdentifier: "Home_StepCount", sender: self);
            case 3:
                performSegue(withIdentifier: "Home_Today", sender: self);
            case 4:
                performSegue(withIdentifier: "Home_Start_Measure", sender: self);
            case 5:
                performSegue(withIdentifier: "Home_Sleep", sender: self);
            case 6:
                performSegue(withIdentifier: "Home_Stress", sender: 1);
            case 5:
                performSegue(withIdentifier: "Home_Detail", sender: 1);
            default:
                break;
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func BarButtonTouch(_ sender: AnyObject) {
        performSegue(withIdentifier: "Home_Device", sender: self);
    }
    
    
    @objc func reloadStress() {
        let lvl = Preference.StressState
        if let id = StressIdentifier(rawValue: Int16(lvl)) {
            m_StressStateTxt.text = id.toString
            m_StressStateTxt.isHidden = false
            m_stressNoTxt.isHidden = true
        } else {
            m_StressStateTxt.isHidden = true
            m_stressNoTxt.isHidden = false
        }
    }
    
    @objc func reloadSleep() {
        let lvl = Preference.SleepState
        if let id = SleepIdentifier(rawValue: Int16(lvl)) {
            m_SleepStateTxt.text = id.toString
            m_SleepStateTxt.isHidden = false
            m_sleepNoTxt.isHidden = true
        } else {
            m_SleepStateTxt.isHidden = true
            m_sleepNoTxt.isHidden = false
        }
    }
    
    @objc func reloadActivity() {
        let lvl = Preference.ActivityState
        if let id = ActivityIdentifier(rawValue: Int16(lvl)) {
            m_ActivityTxt.text = id.toString
            m_ActivityTxt.isHidden = false
            m_activityNoTxt.isHidden = true
        } else {
            m_ActivityTxt.isHidden = true
            m_activityNoTxt.isHidden = false
        }
    }
    
    @objc fileprivate func reloadStepNCalorie() {
        let total = Int(mc!.TotalDailyCalorie + mc!.TotalCoachCalorie + mc!.TotalSleepCalorie + mc!.TotalActivityCalorie)
        
        m_StepCountTxt.text = String(mc!.Step)
        
        m_CalorieTxt.text = String(total)
        queryStep()
    }
    
    fileprivate func getLevel(_ point: Int) -> Int {
        if(point < 50) {
            return 1
        } else if(point < 90) {
            return 2
        } else if(point < 160) {
            return 3
        } else {
            return 4
        }
    }
    
    func success(_ queryCode: QueryCode) {
        saveCount += 1
        
        var label = CourseLabel.daily.rawValue
        var cal = mc!.TotalDailyCalorie
        
        switch saveCount {
        case 0:
            label = CourseLabel.daily.rawValue
            cal = mc!.TotalDailyCalorie
        case 1:
            label = CourseLabel.activity.rawValue
            cal = mc!.TotalActivityCalorie
        case 2:
            label = CourseLabel.sleep.rawValue
            cal = mc!.TotalSleepCalorie
        default:
            saveCount = 0
            return
        }
        
        let data = ActivityData(index: 0, label: label, calorie: cal, start_date: 1, end_date: 2, intensityL: 0, intensityM: 0, intensityH: 0, intensityD: 0, maxHR: 0, minHR: 0, avgHR: 0, upload: SQLHelper.NONSET_UPLOAD)
        parser.setActivityInfo(data)
        
        let query = WebQuery(queryCode: .InsertFitness, request: parser, response: parser)
        query.start()
    }
    
    func fail(_ queryStatus: QueryStatus) {
        
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Home_Stress" {
            if let dest = segue.destination as? StressScreen {
                if let mode = sender as? Int {
                    dest.select_mode = mode
                }
            }
        }
    }
}

