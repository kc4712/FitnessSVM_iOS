//
//  Wrapper.swift
//  CoachMiddleWare
//
//  Created by 심규창 on 2016. 6. 4..
//  Copyright © 2016년 심규창. All rights reserved.
//
import Foundation

private let mWrapper:MWControlCenter = MWControlCenter()

open class MWControlCenter: NSObject {
    fileprivate static let tag = MWControlCenter.className
    
    static var m_productCode: ProductCode = .fitness
    
    fileprivate let BMI_LOW_WEIGHT: Float32 = 18.5
    fileprivate let BMI_NORMAL_WEIGHT: Float32 = 24.9
    
    static var thisRSSI:NSNumber?
    
    //private var mWrapper:Wrapper
    fileprivate let mBleManager = BluetoothLEManager.getInstance()
    fileprivate let mVideoManager = VideoManager.getInstance()
    fileprivate let mDatabase = Database.getInstance()
    fileprivate let mDBHelper = DBContactHelper.getInstance()
    fileprivate let mSender = CommSender.getInstance()
    //private let mFirmManager = FirmManager.getInstance()
    
    //규창 --- 코치 노말 스트레스
    fileprivate var mStressNManager = StressNManager.getInstance()
    
    //규창 171020 행동인지 클래스
    fileprivate var mBehaviorManager = BehaviorManager.getInstance()
    
    fileprivate var PL_Result = Contact.ActInfo()
    
    
    //규창 ---  펌웨어 업데이트 플래그로 BLEManager와 UI단 Firmwareinfo에서 이용중
    static var flagDFU = false
    
    static var stateFeatureSync = false
    
    override init() {
        super.init()
        setNotification()
        
        if let code = ProductCode(rawValue: Int(Preference.ProductCode)) {
            MWControlCenter.m_productCode = code
        }
        
        mBleManager.setTimeZoneOffset(Init: getTzOffset());
        //mBleManager?.nNF = mVideoManager
        
        //규창 --- 코치 노말 스트레스 델리게이트
        mBleManager.pStress_N = mStressNManager
        
        
        mVideoManager.LanguageCode = "LANG"
    }
    
    deinit {
        Log.i(MWControlCenter.tag, msg: "Wrapper 해제")
        TimeZoneChange.removeNotification()
    }
    
    
    
    open class func getInstance() -> MWControlCenter {
        Log.i(MWControlCenter.tag, msg: "래퍼 인스턴스 리턴");
        return mWrapper
    }
    
    /** coach+ 추가 기능 **/
    fileprivate var scanList: [DeviceRecord]? = []
    fileprivate let mCal = MWCalendar.getInstance()
    
    /** Notification **/
    fileprivate let TimeZoneChange = MWNotification.getInstance()
    
    func setNotification() {
        TimeZoneChange.receiveNotification(NSNotification.Name.NSSystemTimeZoneDidChange.rawValue) { _ in
            self.timeZoneChange()
        }
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 현재 페어링된 아이바디 장치가 있는지 확인.
     */
    open func isRetrieveConnectedPeripherals() -> Bool {
        return mBleManager.isRetrieveConnectedPeripherals()
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 밴드 현재 상태 요청 메시지.
     */
    open func sendRequestState() {
        mSender.append((.state, 0, .start, true, .empty))
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : Sender Thread busy flag.
     */
    open var isBusySender: Bool {
        return mSender.isBusy
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : Sender Thread data append!!.
     */
    open func appendSender(_ data: BLSender) {
        mSender.append(data)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 현재 장치의 User 밴드로 전달.
     */
    open func sendUserData() {
        mSender.append((.userData, 0, .start, false, .empty))
//        sendBluetoothCmd(.UserData)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 현재 입력된 프로그램의 쿼리 코스 코드 번호.
     */
    open func getCourseCodeForQuery(_ programCode: Int) -> String {
        return mVideoManager.getCourseCodeForQuery(programCode)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 미들웨어에서 현재 사용할 제품 코드 입력 받음.
     */
    open func selectProduct(_ code: ProductCode) {
        MWControlCenter.m_productCode = code
        Preference.ProductCode = Int32(code.rawValue)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 미들웨어에서 현재 사용할 제품 코드 입력 받음.
     */
    open func getSelectedProduct() -> ProductCode {
        return MWControlCenter.m_productCode
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 베터리 정보 요청 전달
     */
    open func sendBatteryRequest() {
        mSender.append((.battery, 0, .start, true, .empty))
//        sendBluetoothCmd(.Battery)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 활동 측정 명령 전달
     */
    open func sendActivityMeasure(_ send: Bool, time: Int64 = 0) {
        if send {
            mSender.append((.activity, time, .start, false, .empty))
//            sendBluetoothCmd(.Activity, action: .Start, time: time)
        } else {
            mSender.append((.activity, 0, .end, false, .empty))
//            sendBluetoothCmd(.Activity, action: .End)
        }
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 활동 측정 정보 요청
     */
    open func sendActivityInfo(_ time: Int64) {
        mSender.append((.activity, time, .inform, true, .empty))
//        sendBluetoothCmd(.Activity, action: .Inform, time: time)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 수면 측정 명령 전달
     */
    open func sendSleepMeasure(_ send: Bool, time: Int64 = 0) {
        if send {
            mSender.append((.sleep, time, .start, false, .empty))
//            sendBluetoothCmd(.Sleep, action: .Start, time: time)
        } else {
            mSender.append((.sleep, 0, .end, false, .empty))
//            sendBluetoothCmd(.Sleep, action: .End)
        }
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 수면 측정 정보 요청
     */
    open func sendSleepInfo(_ time: Int64) {
        mSender.append((.sleep, time, .inform, true, .empty))
//        sendBluetoothCmd(.Sleep, action: .Inform, time: time)
    }
    
    
    
    
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 스트레스 측정 명령 전달
     */
    //규창 --- 16.10.24 fitness스트레스 측정 Firm -> App 대치
    //open func sendStressMeasure(_ send: Bool, time: Int64 = 0) {
    open func sendStressMeasure(_ send: Bool) {
        if send {
            mStressNManager?.play()
            //mSender.append((.stress, time, .start, false))
            mSender.append((.stress, 0, .start, false, .empty))
//            sendBluetoothCmd(.Stress, action: .Start, time: time)
        } else {
            mSender.append((.stress, 0, .end, false, .empty))
            mStressNManager?.end()
//            sendBluetoothCmd(.Stress, action: .End)
        }
    }
    
    
    
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 스트레스 측정 정보 요청
     */
    open func sendStressInfo(_ time: Int64) {
        mSender.append((.stress, time, .inform, true, .empty))
//        sendBluetoothCmd(.Stress, action: .Inform, time: time)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 영상 play!!!
     */
    open func play() {
        mVideoManager.play()
        mSender.append((.acc, 0, .start, false, .empty))
//        sendBluetoothCmd(.Acc, action: .Start)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 영상 end!!!. play를 했으면 꼭 해줘야한다.
     */
    open func end() {
//        sendBluetoothCmd(.Acc, action: .End)
        mSender.append((.acc, 0, .end, false, .empty))
        mVideoManager.end()
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 영상의 현재 포지션. (sec)
     */
    open func setCurrentTimePosition(_ position: Int) {
        mVideoManager.setCurrentTimePosition(position)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : xml 운동 데이터 설정.
     */
    open func setXmlProgram(_ xml: Data) {
        mVideoManager.LanguageCode = "LANG"
        mVideoManager.setProgram(xml)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 앱의 Logout을 미들웨어에 알림. MW의 DB를 초기화하고, 블루투스 접속을 종료한다.
     */
    open func logout() {
        mBleManager.setIsLiveApp(false)
        mBleManager.stopBluetooth()
        //clearVariable()
        Preference.removeAll()
        Preference.AutoLogin = false
    }
    
    /**
     * @Parameter : enum  StateApp (0:무응답, 1:앱 준비중, 2:앱 정상 시작, 3:앱 종료)
     * @return :
     * @Description : 앱의 생존 상태를 미들웨어로 입력한다.
     */
    open func setIsLiveApplication(_ state: StateApp) {
        mBleManager.setIsLiveApp(state == StateApp.state_NORMAL)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 앱의 블루투스 접속 시도 요청. 회원 가입 절차에서 밴드를 찾는 동작에서 수행.
     * 					5초간 근처의 밴드를 찾고 연결을 수행하며, 연결에 성공하면 블루투스 장치 정보를 저장한다.
     * 					기본 사용자 정보가 입력되어 있지 않다면 시작을 실패한다. 최초 연결 시, 주변에 같은 종류의 밴드가 복수 존재하면 시작을 실패한다.
     */
    open func tryConnectionBluetooth() {
        mBleManager.tryBluetooth()
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 접속 종료.
     */
    open func stopBluetooth() {
        mBleManager.stopBluetooth()
    }
    
    /**
     * @Parameter :
     * @return : enum ConnectStatus
     * @Description : MW의 블루투스 연결 상태 정보를 얻는다.
     */
    open func getConnectionState() -> ConnectStatus {
        return mBleManager.getConnectionState()
    }
    
    /**
     * @Parameter : scanMode (enum ScanMode)
     * @return :
     * @Description : 블루투스의 스캔 모드를 설정한다. Auto: 자동 스캔(이미 생성된 DB를 바탕으로 자동 접속. 리스트 자동 삭제)
     , MANUAL: 수동 접속(사용자의 접속할 기기를 선택. 리스트를 삭제하지 않음). 기본은 AUTO.
     */
    open func setScanMode(_ scanMode: ScanMode) {
        mBleManager.setScanMode(scanMode)
    }
    
    /**
     * @Parameter : String name (블루투스 장치명)
     * @return : 성공 여부.
     * @Description : 블루투스 장치에 접속한다. 없는 장치 이거나, 접속할수 없는 경우 false 반환.
     */
    open func connect(_ name: String) -> Bool {
        return mBleManager.requestConnect(name)
    }
    
    /**
     * @Parameter :
     * @return : Set<DeviceRecord> (DeviceRecord class의 Set)
     * @Description : 장치 스캔 리스트를 얻는다.
     */
    open func getScanList() -> [DeviceRecord] {
        scanList!.removeAll()
        for dev in mBleManager.arList {
            let name = dev.getName.substringToIndex(DeviceBaseScan.SELECTED_DEVICE_NAME.length);
            if name != DeviceBaseScan.SELECTED_DEVICE_NAME {
                continue
            }
            scanList!.append(dev)
        }
        return scanList!
    }
    
    /**
     * @Parameter : Float32 weight(현재 체중)
     * 				 Float32 goal_weight(목표체중)
     * 				 Int32 diet_period(주 단위 감량기간))
     * @return : Float32 daily_calorie (일일소모 칼로리)
     * @Description : 일일소비칼로리를 얻는다.
     */
    open func getCalorieConsumeDaily(_ weight: Float32, goalWeight: Float32, dietPeriod: Int32) -> Float32 {
        return Weight.getCalorieConsumeDaily(weight, goalWeight: goalWeight, dietPeriod: dietPeriod)
    }
    
    /**
     * @Parameter : Int32 height (키)
     * @return :    normal_below (scale[0]), normal_morethan (scale[1])
     (표준이하 <= scale[0]:) (scale[0] < 표준 <= scale[1]) (scale[1] < 표준이상).
     * @Description : 체중의 표준 범위를 구함.
     */
    open func getScaleWeight(_ height: Int32) -> (normal_below: Float32, normal_morethan: Float32) {
        let tmp: Float32 = Float32(height) / 100
        
        let lowWeight = BMI_LOW_WEIGHT*tmp*tmp
        let normalWeight = BMI_NORMAL_WEIGHT*tmp*tmp
        
        return (lowWeight, normalWeight)
    }
    
    /**
     * @Parameter : Float32 weight (현재 체중), Float32 goalWeight(목표 체중)
     * @return :    enough (scale[0]), suitable (scale[1]), over (scale[2])
     (scale[0] < 충분 <= scale[1]) (scale[1] < 적당 <= scale[2]) (scale[2] < 무리).
     * @Description : 체중에 따른 감량 기간 판단 범위를 구함.
     */
    open func getScaleDietPeriod(_ weight: Float32, goalWeight: Float32)-> (enough: Int32, suitable: Int32, over: Int32) {
        if weight < goalWeight {
            return (0, 0, 0)
        }
        
        let start = Int32((weight - goalWeight) / 0.3 * 4)
        let enough = Int32((weight - goalWeight) / 0.5 * 4)
        let normal = Int32((weight - goalWeight) / 1.2 * 4)
        
        return (start, enough, normal)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 미들웨어 내부 시간 변수 변환용
     */
    open static func getConvertedTime(_ time: Int64) -> Int32 {
        return DataControlBase.getConvertedTime(time)
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 미들웨어 내부 시간 변수 변환용
     */
    open static func getReturnedTime(_ time: Int32) -> Int64 {
        return DataControlBase.getReturnedTime(time)
    }
    
    fileprivate func getTzOffset() -> Int16 {
        var offset: Int16 = 0
        let tz = TimeZone.current
        if tz.isDaylightSavingTime() {
            offset = Int16(tz.secondsFromGMT()/60+60)
        } else {
            offset = Int16(tz.secondsFromGMT()/60)
        }
        
        return offset
    }
    
    @objc fileprivate func timeZoneChange() {
        mCal.setTimeZone(TimeZone.current)
        mBleManager.setTimeZoneOffset(getTzOffset());
    }
    
    // 사용예정인 프로퍼티 미리 구현.
    /*************** Video ***************/
    open var ActivityName: String {
        return mDatabase.ActivityName
    }
    
    open var BottomComment: String {
        return mDatabase.BottomComment
    }
    
    open var TotalScore: (duration: Double, point: Int, count_percent: Int, accuracy_percent: Int, comment: String) {
        return mDatabase.TotalScore
    }
    
    open var Accuracy: Int {
        return mDatabase.Accuracy
    }
    
    open var Point: Int {
        return mDatabase.Point
    }
    
    open var Count: (count: Int, refCount: Int) {
        return mDatabase.Count
    }
    
    open var VideoCalorie: Float {
        return mDatabase.VideoCalorie
    }
    
    open var HRCmp: Int {
        return mDatabase.HRCmp
    }
    
    open var HRWarnning: String {
        return mDatabase.HRWarnning
    }
    
    open var ExerData: (videoID:Int, video_full_count:Int, exer_idx:Int, exer_count:Int, start_time:Int64, end_time:Int64, consume_calorie:Int, count:Int, count_percent:Int, perfect_count:Int, minAccuracy:Int, maxAccuracy:Int, avgAccuracy:Int, minHeartRate:Int, maxHeartRate:Int, avgHeartRate:Int , cmpHeartRate:Int, point:Int) {
        return mDatabase.ExerData
    }
    
    /*************** Bluetooth ***************/
    open var Battery: (status: Int16, voltage: Int16) {
        return mDatabase.Battery
    }
    
    open var Step: Int16 {
        return mDatabase.Step
    }
    
    open var TotalActivityCalorie: Double {
        return mDatabase.TotalActivityCalorie
    }
    
    open var TotalSleepCalorie: Double {
        return mDatabase.TotalSleepCalorie
    }
    
    open var TotalDailyCalorie: Double {
        return mDatabase.TotalDailyCalorie
    }
    
    open var TotalCoachCalorie: Double {
        return mDatabase.TotalCoachCalorie
    }
    
    open var ActivityData: (act_calorie: Double, intensityL: Int16, intensityM: Int16, intensityH: Int16, intensityD: Int16, minHR: Int16, maxHR: Int16, avgHR: Int16) {
        return mDatabase.ActivityData
    }
    
    open var SleepData: (rolled: Int16, awaken: Int16, stabilityHR: Int16) {
        return mDatabase.SleepData
    }
    
    open var Stress: Int16 {
        return mDatabase.Stress
    }
    
    open var State: StatePeripheral {
        let ret = StatePeripheral(rawValue: mDatabase.State)
        return ret == nil ? StatePeripheral.idle : ret!
    }
    
    open var Version: String {
        return mDatabase.Version
    }
    
    /*************** User ***************/
    open var Profile: (age :Int32, sex: Int32, height: Int32, weight: Float32, goalWeight: Float32) {
        get {
            return mDBHelper!.getUserProfile()
        }
        set {
            mDBHelper?.setUserProfile(newValue.age, sex: newValue.sex, height: newValue.height, weight: newValue.weight, goalWeight: newValue.goalWeight)
            mDatabase.Profile = newValue
        }
    }
    
    open var DietPeriod: Int32 {
        get {
            return mDBHelper!.getUserDietPeriod()
        }
        set {
            mDBHelper?.setUserDietPeriod(newValue)
            mDatabase.DietPeriod = newValue
        }
    }
    
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 코치 노말 스트레스 측정 명령 전달
     */
    open func sendNomalCoachStressMeasure(_ send: Bool) {
        if send {
            mStressNManager?.play()
            mSender.append((.acc, 0, .start, false, .empty))
        } else {
            mSender.append((.acc, 0, .end, false, .empty))
            mStressNManager?.end()
        }
    }
    /* 
     규창 --- SDNN계산 후 최고, 최저, 평균심박과 RMSSD를 함께 보여지게 했었음
    public var StressNResult:(maxBPM: Double, minBPM: Double, avgBPM: Double, SDNN: Double, RMSSD: Double) {
        //print("노티옴!!!! \(mDatabase.StressNResult)")
        return mDatabase.StressNResult
    }
     */
    open var StressNResult:Int16 {
        //print("노티옴!!!! \(mDatabase.StressNResult)")
        return mDatabase.StressNResult
    }
    
    
    //규창 --- DFU
    open func sendFirmwareUrl(_ url:URL){
        mBleManager.url = url
        mBleManager.sendReset()
        
    }
    
    //규창 16.12.27 강제 동기화
    open func sendForceRefresh(){
        if !mSender.isBusy {
            mSender.notifySync(true)
            mSender.append((.stepCount_Calorie, MWCalendar.currentTimeMillis(), .start, true, .empty))
        }
    }
    
    //규창 --- Firminfo.swift에서 BLEManager에 URL과 업데이트루틴을 시작하는 메서드를 기동 이 값을 체크하지않으면 BLE에서 상태변경통지나 연결이 끊겼을때 밴드에 리셋명령을 계속내리게됨
    open func FlagDFU()-> Bool {
        return MWControlCenter.flagDFU
    }
    
    open func RssiResult() -> NSNumber? {
        return MWControlCenter.thisRSSI
    }
    
    
    
    //규창 171030 이전 피쳐정보 요청
    /**
     * @Parameter :
     * @return :
     * @Description : 블루투스 이전 피쳐 정보 요청
     */
    open func sendpastFeatureReq(_ firsttime: Int64, _ lasttime: Int64 ) {
        //mSender.append((.pastFeatureRequest, firsttime, lasttime))
        //mSender.append((.activity, time, .inform, true, .empty))
        //        sendBluetoothCmd(.Activity, action: .Inform, time: time)
        mBleManager.sendpastFeatureRequest(reqtimeFirst: firsttime, reqtimeLast: lasttime)
    }
    
    
    
    
    //규창 171027 피쳐 동기화 플래그....
    open func getStateFeatureSync()-> Bool {
        return MWControlCenter.stateFeatureSync
    }
    open func setStateFeatureSync(state:Bool) {
        MWControlCenter.stateFeatureSync = state
    }
    
    
    //규창 171026 앱 db상에 데이터 없을 때 호출 메서드.....
    open func requestFeature(time:Int64) {
        mBleManager.requestFeature(reqtime: time)
    }
    
    //규창 171024 피쳐데이터 앱 전송용 메서드들.....
    open var FeatureData: (actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) {
        return mDatabase.FeatureData
    }
    
    static var tmpData: (act_index: Int32, time: Int64) = (-1, 0)
    fileprivate static var homeData: (act_index: Int32, time: Int64) = (-1, 0)
    /**
     * @Parameter :
     * @return : Int32 activity_index (행동 Index)
     *               Int64 activity_indextime (해당 행동 데이터의 시간)
     * @Description : 앱 홈화면의 상단 화면 응답방송.
     */
    open func getHomeData() -> (activity_index: Int32, activity_indextime: Int64) {
        return (MWControlCenter.homeData.0, MWControlCenter.homeData.1)
    }
    
    //Database...(actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double)
    //open func getPLResult() -> (act_index:Int32, start_date: Int64, c_intensity:Float32, c_calorie:Float32, c_unit:Int32, c_speed:Float32, c_heartrate:Int32, c_step:Int32){
    open func getPLResult() -> (actIndex: Int32, start_date: Int64, intensity: Double, calorie: Double, speed: Double, heartrate: Int32, step: Int32, swing: Int32, press_var: Double, coach_intensity: Double) {
        
//        _exercise: Int32(actIndex), c_intensity: Float32(intensity), c_calorie: Float32(consumeCalorie), c_unit: Int32(unit), c_intensity_number: Float32(speed), c_heartrate: Int32(heartrate), c_step: Int32(step), c_swing: Int32(swing), c_press_variance: 0.0, c_coach_intensity: Float32(coach_intensity),
        //return (PL_Result.getC_Exercise(), PL_Result.getC_year_month_day() , PL_Result.getC_intensity(), PL_Result.getC_calorie(), PL_Result.getC_unit(), PL_Result.getC_intensity_number(), PL_Result.getC_heartrate(), PL_Result.getC_step())
        return (PL_Result.getC_Exercise(), PL_Result.getC_year_month_day() , Double(PL_Result.getC_intensity()), Double(PL_Result.getC_calorie()), Double(PL_Result.getC_intensity_number()), PL_Result.getC_heartrate(), PL_Result.getC_step(), PL_Result.getC_swing(), Double(PL_Result.getC_press_variance()), Double(PL_Result.getC_coach_intensity()))
    }
    open func setPLResult(result:Contact.ActInfo) {
        PL_Result = result
    }
    
    
    
}
