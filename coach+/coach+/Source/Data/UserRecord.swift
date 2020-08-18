//
//  UserRecord.swift
//  MiddleWare
//
//  Created by 김영일 이사 on 2016. 4. 19..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation
import MiddleWare

class UserRecord: BaseJsonParser, WebRequestDelegate, WebResponseDelegate
{
    fileprivate let TAG = String(describing: UserRecord.self)
    
    static let SEX_MAN: Int = 1;
    static let SEX_WOMAN: Int = 2;
    fileprivate let EMPTY: Int = -1;
    
    fileprivate var m_email: String? = nil;
    fileprivate var m_password: String? = nil;
    fileprivate var m_code: String? = nil;
    fileprivate var m_name: String? = nil;
    fileprivate var m_birthday: MWCalendar? = nil;
    fileprivate var m_gender: Int = 0;
    fileprivate var m_height: Int = 0;
    fileprivate var m_current_weight: Float = 0.0;
    fileprivate var m_target_weight: Float = 0.0;
    fileprivate var m_diet_period: Int = 0;
    fileprivate var m_device_name: String? = nil;
    fileprivate var m_device_address: String? = nil;
    
    func finalize() {
        Log.d(TAG, msg: "finalize");
        m_email = nil;
        m_password = nil;
        m_code = nil;
        m_name = nil;
        m_birthday = nil;
        m_device_name = nil;
        m_device_address = nil;
    }
    
    func empty() {
        m_email = "";
        m_password = "";
        m_code = UUID().uuidString;
        m_birthday = nil;
        m_height = 0;
        m_current_weight = 0;
        m_gender = 0;
        m_target_weight = 0;
        m_diet_period = 0;
        m_device_name = "";
        m_device_address = "";
    }
    
    //--------------------------------------------------
    // 이메일 주소
    //--------------------------------------------------
    var Email: String? {
        get { return m_email; }
        set { m_email = newValue; }
    }
    
    //--------------------------------------------------
    // 비밀번호
    //--------------------------------------------------
    var Password: String? {
        get { return m_password; }
        set { m_password = newValue; }
    }
    
    //--------------------------------------------------
    // 사용자 코드
    //--------------------------------------------------
    var Code: String? {
        get { return m_code; }
        set { m_code = newValue; }
    
    }
    
    //--------------------------------------------------
    // 사용자 이름
    //--------------------------------------------------
    var Name: String? {
        get {
            // TODO : UTF8 인코딩
            // ret = new String(m_name.getBytes("UTF-8"));
            return m_name;
        }
        set { m_name = newValue; }
    }
    
    //--------------------------------------------------
    // 장치 이름
    //--------------------------------------------------
    var DeviceName: String? {
        get { return m_device_name; }
        set { m_device_name = newValue; }
    }
    
    //--------------------------------------------------
    // 장치 주소
    //--------------------------------------------------
    var DeviceAddress: String? {
        get { return m_device_address; }
        set { m_device_address = newValue; }
    }
    
    //--------------------------------------------------
    // 생년월일
    //--------------------------------------------------
    var Birthday: MWCalendar? {
        get { return m_birthday; }
        set { m_birthday = newValue; }
    }
    
    func SetBirthday(_ millisec: Int64) {
        m_birthday = MWCalendar.getInstance();
        m_birthday?.setTimeInMillis(millisec);
    }
    
    func SetBirthday(_ year: Int, _ month: Int, _ day: Int) {
        m_birthday = MWCalendar.getInstance();
        let calendar = Calendar.current;
        var components = DateComponents();
        components.year = year;
        components.month = month;
        components.day = day;
        let date = calendar.date(from: components);
        m_birthday = MWCalendar.getInstance();
        m_birthday!.date = date!;
    }
    
    func SetBirthdayDate(_ date: Date) {
        m_birthday = MWCalendar.getInstance();
        m_birthday!.date = date;
    }
    
    var BirthString: String {
        get {
            let fomt = DateFormatter();
            fomt.dateFormat = "yyyy년 MM월 dd일";
            return fomt.string(from: m_birthday!.date);
        }
    }

    func GetAge() ->Int {
        if (m_birthday == nil) {
            return 1;
        }
        let bir = m_birthday!.year;
        let now = MWCalendar.getInstance().year;
        return Int(now - bir + Int32(1));
    }

    //--------------------------------------------------
    // 성별
    //--------------------------------------------------
    var Gender: Int {
        get { return m_gender; }
        set
        {
            if (newValue == UserRecord.SEX_MAN || newValue == UserRecord.SEX_WOMAN) {
                m_gender = newValue;
            }
        }
    }
    
    //--------------------------------------------------
    // 신장
    //--------------------------------------------------
    var Height: Int {
        get {
            if (m_height == 0) {
                return 170
            }
            return m_height;
        }
        set { m_height = newValue; }
    }
    
    //--------------------------------------------------
    // 체중
    //--------------------------------------------------
    var CurrentWeight: Float {
        get {
            if (m_current_weight == 0) {
                return 80;
            }
            return m_current_weight;
        }
        set { m_current_weight = newValue; }
    }
    
    var TargetWeight: Float {
        get {
            if (m_target_weight == 0) {
                return 78;
            }
            return m_target_weight;
        }
        set { m_target_weight = newValue; }
    }

    //--------------------------------------------------
    // 다이어트 기간
    //--------------------------------------------------
    var DietPeriod: Int {
        get {
            if (m_diet_period == 0) {
                return 30;
            }
            return m_diet_period;
        }
        set { m_diet_period = newValue; }
    }

    //--------------------------------------------------
    // 데이터 유효성 검사
    //--------------------------------------------------
    var isValidDevice: Bool {
        get {
            if (m_device_name == nil || (m_device_name?.isEmpty)!) {
                return false;
            }
            return true;
        }
    }
    
    var isValidProfile: Bool {
        get {
            if (m_name == nil || m_name!.isEmpty) {
                return false;
            }
            if (m_birthday == nil) {
                return false;
            }
            if (m_gender < 1 || m_gender > 2) {
                return false;
            }
            if (m_height < 40) {
                return false;
            }
            return true;
        }
    }
    
    var isValidTarget: Bool {
        get {
            print("m_current_weight \(m_current_weight) m_target_weight \(m_target_weight) m_diet_period \(m_diet_period)")
            if (m_current_weight < 10) {
                return false;
            }
            if (m_target_weight < 10) {
                return false;
            }
            if (m_target_weight > m_current_weight) {
                return false;
            }
            if (m_diet_period < 1) {
                return false;
            }
            return true;
        }
    }

    fileprivate func readFromJSON(_ json: NSDictionary) {
        //{"Result":1,"UserInfo":{"CreatDate":"\/Date(1439794620000+0900)\/",}}
        // String szValue;
        
        let code = getString(json, "Code");
        Log.d(TAG, msg: "Code: \(String(describing: code))");
        m_code = code;
 
        let email = getString(json, "Email");
        Log.d(TAG, msg: "Email: \(email!)");
        m_email = email;

        let password = getString(json, "Password");
        Log.d(TAG, msg: "Password: \(password!)");
        m_password = password;

        let username = getString(json, "Name");
        Log.d(TAG, msg: "Name: \(String(describing: username))");
        m_name = username;

        let birth = getString(json, "Birthday");
        if (birth == nil) {
            m_birthday = nil;
        }
        else {
            SetBirthday(UtilsWeb.convertDate(birth!));
        }

        m_gender = getInt(json, "Gender");
        
        m_height = getInt(json, "Height");
        
        m_current_weight = getFloat(json, "CurrentWeight");
        
        m_target_weight = getFloat(json, "TargetWeight");
        
        m_diet_period = getInt(json, "DietPeriod");

        m_device_name = getString(json, "DeviceName");

        if let addr = getString(json, "DeviceAddress"){
            if addr.contains(",") {
                let arr = addr.components(separatedBy: ",")
                for dev in arr {
                    if dev.contains(":") {
                        m_device_address = dev
                    } else {
                        m_device_name = dev
                    }
                }
            } else {
                if addr.contains(":") {
                    m_device_address = addr
                } else {
                    m_device_name = addr
                }
            }
        }
    }
    
    func makeRequest(_ queryCode: QueryCode) -> String {
        var ret = "";
        ret += WebQuery.SERVER_ADDR;
        ret += queryCode.rawValue;

        switch queryCode {
        case .CreateUser:
            ret += "?id=\(Email!)";
            ret += "&pw=\(Password!)";
            break;
        case .LoginUser:
            ret += "?id=\(Email!)";
            ret += "&pw=\(Password!)";
            break;
        case .SetDevice:
            ret += "?code=\(Code!)";
            ret += "&mac=\(DeviceName!)";
            //ret += "&mac=\(DeviceAddress!)";
            break;
        case .SetProfile:
            ret += "?code=\(Code!)";
            //ret += "&name=\(Name!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()))";
            ret += "&name=\(Name!)";
            ret += "&birthday=\(BirthString)";
            ret += "&gender=\(Gender)";
            ret += "&height=\(Height)";
            break;
        case .SetTarget:
            ret += "?code=\(Code!)";
            ret += "&current=\(CurrentWeight)";
            ret += "&target=\(TargetWeight)";
            ret += "&period=\(DietPeriod)";
            break;
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

        if (result == 2) {
            return QueryStatus.ERROR_Exists_Email;
        }
        
        if (result == 3) {
            return QueryStatus.ERROR_Account_Not_Match;
        }
        
        if let userInfo = json["UserInfo"] as? NSDictionary? {
            if (userInfo == nil) {
                return QueryStatus.ERROR_Non_Information;
            }
            
            print("UserInfo = \(userInfo!)");
            
            readFromJSON(userInfo!);
            
            let mc = MWControlCenter.getInstance()
            mc.Profile = (Int32(GetAge()), sex: Int32(Gender), height: Int32(Height), weight: Float32(CurrentWeight), goalWeight: Float32(TargetWeight))
            mc.DietPeriod = Int32(DietPeriod)
            Preference.putUrlUsercode(Code)
            Preference.putBluetoothName(DeviceName)
            Preference.putBluetoothMac(DeviceAddress)
        }
        
        return QueryStatus.Success;
    }
    
    typealias VoidMethod = (()->());
    typealias VoidError = ((QueryStatus) -> ());
    
    var successProc: VoidMethod?;
    var failProc: VoidError?;
    
    func SetSuccess(_ callback: VoidMethod?) {
        successProc = callback;
    }

    func SetFail(_ callback: VoidError?) {
        failProc = callback;
    }

    func OnQuerySuccess(_ queryCode: QueryCode) {
//        if queryCode == QueryCode.LoginUser {
//            MWNotification.postNotification(MWNotification.Etc.getLogin);
//        }
        // 성공 콜백을 UI 스레드에서 실행
        DispatchQueue.main.async(execute: {
            () -> () in
            self.successProc?();
        })
    }
    
    func OnQueryFail(_ queryStatus: QueryStatus) {
        DispatchQueue.main.async(execute: {
            () -> () in
            self.failProc?(queryStatus);
        })
    }
    
    func executQuery(_ code: QueryCode, success: VoidMethod?, fail: VoidError?) {
        // 사용자 데이터베이스 처리에 성공한 경우 콜백 설정
        //print("\(success.debugDescription) \(fail.debugDescription)")
        SetSuccess(success);
        SetFail(fail);
        // 웹 쿼리 실행
        let query = WebQuery(queryCode: code, request: self, response: self);
        query.start();
    }
    
    override init() {
        super.init();
        empty();
        m_code = Preference.getUrlUsercode()
        if (m_code == nil) {
            m_code = UUID().uuidString;
        }
    }
    
    init(email: String) {
        super.init();
        empty();
        m_email = email;
        m_code = Preference.getUrlUsercode()
        if (m_code == nil) {
            m_code = UUID().uuidString;
        }
    }
}
