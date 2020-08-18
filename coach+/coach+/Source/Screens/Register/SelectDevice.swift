//
//  SelectDevice.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 10..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare

class SelectDevice : BaseViewController, UITableViewDelegate, UITableViewDataSource, BaseProtocol
{
    @IBOutlet var m_tableView: UITableView!
    
    @IBOutlet var desc: UILabel!
    
    fileprivate var m_productCode: ProductCode = .coach
    var _ProductCode: ProductCode {
        get {
            return m_productCode
        }
        set {
            m_productCode = newValue
        }
    }
    
    @IBAction func m_startScan(_ sender: UIButton) {
        if MiddleWare.isRetrieveConnectedPeripherals() {
            showPopup(Common.ResString("exist_retrieve_device"))
            return
        }
        MiddleWare.tryConnectionBluetooth(); // 연결이 끊어져야 스캔 가능.
        m_dev_list?.removeAll()
        m_tableView.reloadData()
    }
    
    @IBAction func BarButtonTouch(_ sender: AnyObject) {
        BaseViewController.SkipMode = true
        performSegue(withIdentifier: "SegueProfile", sender: self);
    }
    
    //fileprivate var mc: MWControlCenter?;
    fileprivate var m_dev_list: [DeviceRecord]?;
    
    override func viewDidLoad() {
        print("VC: 밴드 선택 화면");
        super.viewDidLoad();
        
        desc.text = String(format: Common.ResString("select_device"), _ProductCode.productName)
        
        // 테이블 뷰 데이터 소스 설정
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        
        // mc = MWControlCenter.getInstance();
        MiddleWare.setScanMode(ScanMode.manual);
        
        if BaseViewController.MainMode {
            navigationItem.rightBarButtonItem? = UIBarButtonItem()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        TabBarCenter.selecter = nil
        if !BaseViewController.MainMode {
            let nc = NotificationCenter.default;
            nc.removeObserver(self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 네비게이션바 보이기
        TabBarCenter.selecter = self
        showNavigationBar();
        
        if !BaseViewController.MainMode {
            receiveNotification(MWNotification.Bluetooth.RaiseConnectionState)
            receiveNotification(MWNotification.Bluetooth.GenerateScanList)
            receiveNotification(MWNotification.Bluetooth.EndOfScanList)
            receiveNotification(MWNotification.Bluetooth.FailedConnection)
        }
        
        if MiddleWare.isRetrieveConnectedPeripherals() {
            showPopup(Common.ResString("exist_retrieve_device"))
            return
        }
        
        MiddleWare.tryConnectionBluetooth(); // 연결이 끊어져야 스캔 가능.
    }
    
    //---------------------------------------------------------
    // 기기 목록 표시용 테이블 뷰에 스캔된 밴드 목록 표시
    //---------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = m_dev_list {
            return list.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell";
        
        // Configure the cell...
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier);
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: CellIdentifier);
        }
        else {
            for view: UIView in (cell?.contentView.subviews)! {
                view.removeFromSuperview();
            }
        }
        //cell!.textLabel!.text = "12345:\(indexPath.row)";
        cell!.textLabel!.text = m_dev_list![indexPath.row].getName;
        return cell!;
    }
    
    var m_index = 0;
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        m_index = (indexPath as NSIndexPath).row;
        let msg = NSLocalizedString("confirm_equipment_connection", comment: "기기를 연결하시겠습니까?");
        dialogConfirm(msg, yesCall: yesCallback, noCall: noCallback);
    }
    
    //---------------------------------------------------------
    // 연결 팝업 창의 예 / 아니요 버튼 콜백 처리
    //---------------------------------------------------------
    
    func yesCallback() {
        print("YES: \(m_index)");
        // m_dev_list![m_index] 항목이 선택되었음
        // 이 항목을 미들웨어에 저장하고 연결을 해야 함
        //mc?.stopBluetooth(); // scanBluetooth를 사용하는 경우, 해당 코드 활성화 필요.
        Preference.putBluetoothName(m_dev_list![m_index].getName);
        _ = MiddleWare.connect(m_dev_list![m_index].getName);
    }
    
    func noCallback() {
        print("NO: \(m_index)");
    }
    
    fileprivate func receiveNotification(_ name: String) {
        let nc = NotificationCenter.default;
        nc.addObserver(self, selector: #selector(run), name: NSNotification.Name(rawValue: name), object: nil);
    }
    
    @objc func run(_ notification: Notification) {
        switch notification.name.rawValue {
        case MWNotification.Bluetooth.GenerateScanList:
            m_dev_list = MiddleWare.getScanList();
            self.m_tableView.reloadData()
        case MWNotification.Bluetooth.RaiseConnectionState:
            if MiddleWare.getConnectionState() == ConnectStatus.state_CONNECTED {
                // 연결 성공인 경우, 쿼리 보내고 진행
                connectSuccess();
            }
        case MWNotification.Bluetooth.EndOfScanList, MWNotification.Bluetooth.FailedConnection:
            // 스캔 종료되었는데, 리스트가 공백인 경우. 연결 실패인 경우.
            if m_dev_list == nil || m_dev_list!.isEmpty || m_dev_list!.count == 0 {
                connectFail();
            }
        default:
            break;
        }
    }

    //---------------------------------------------------------
    // 연결 팝업 창의 예 / 아니요 버튼 콜백 처리
    //---------------------------------------------------------

    // 선택된 밴드 연결 성공시 처리
    func connectSuccess() {
        // 입력된 정보 사용자 레코드에 설정
        BaseViewController.User.DeviceName = Preference.getBluetoothName();
        
        // 웹 쿼리 실행 (장치 명칭 등록)
        BaseViewController.User.executQuery(.SetDevice, success: SuccessProc, fail: nil);
    }
    
    // 웹 쿼리 성공 콜백
    func SuccessProc() {
        print("웹쿼리 성공 !!");
        // 프로필 입력 화면으로 이동
        if (BaseViewController.MainMode) {
            performSegue(withIdentifier: "unwindNavigation", sender: nil)
            return
        }
        let vc = BaseViewController.changeScreenUserValid()
        if vc.restorationIdentifier != "Main" {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            present(vc, animated: true, completion: nil)
        }
//        performSegue(withIdentifier: "SegueProfile", sender: self);
    }

    // 선택된 밴드 연결 실패시 처리
    // 본 실패 처리는 스캔이 일정 시간동안 되지 않았을때도 발생하여야 함
    func connectFail() {
        print("밴드 연결 실패 !!");
        self.performSegue(withIdentifier: "ConnectFail", sender: self);
    }
    
    func getCurrentChildViewController() -> UIViewController {
        return self
    }
}
