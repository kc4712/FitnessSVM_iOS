//
//  ViewController.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 2. 27..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit
import MiddleWare

typealias Today = (year: Int32, month: Int32, day: Int32)

class HomeTabScreen: UITableViewController {
    fileprivate static let tag = HomeTabScreen.className
    
    @IBOutlet var txtAccuracy: UILabel!
    @IBOutlet var txtExerTime: UILabel!
    @IBOutlet var txtCalorie: UILabel!
    @IBOutlet var txtMyLevel: UILabel!
    
//규창 --- 코치 노말 스트레스
    @IBOutlet var m_StressStateTxt: UILabel!
    @IBOutlet var m_stressNoTxt: UILabel!

    fileprivate var mc: MWControlCenter?
    fileprivate var calendar: MWCalendar?
    
    // 미들웨어 또는 각종 갱신되고자 하는 부분 처리
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("새로고침");
        BaseViewController.getTodayData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let image = UIImage(named: "메인_상단_로고.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        //규창 171011 Swift4 마이그레이션 iOS11 헤더로고 크기 달라짐 문제
        // https://stackoverflow.com/questions/46408510/header-logo-is-wrong-size-on-swift-4-xcode-9-ios-11
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true;
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true;
        
        self.navigationItem.titleView = imageView
        
        BaseViewController.setTodayDataHandler(reloadHome)
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadHome()
    }
    
    func reloadHome() {
        let datas = BaseViewController.HomeInfo
        txtAccuracy.text = String(datas.today.Point)
        txtExerTime.text = String(datas.today.RunSec / 60)
        txtCalorie.text = String(datas.today.Calorie)
        txtMyLevel.text = String(getLevel(datas.today.UserLevel))
        
        let lvl = Preference.StressState
        if let id = StressIdentifier(rawValue: Int16(lvl)) {
            print("1 \(lvl)")
            m_StressStateTxt.text = id.toString
            m_StressStateTxt.isHidden = false
            m_stressNoTxt.isHidden = true
        } else {
            print("2 \(lvl)")
            m_StressStateTxt.isHidden = true
            m_stressNoTxt.isHidden = false
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//규창 --- 코치 노말 스트레스용 테이블 선택 오픈
        switch ((indexPath as NSIndexPath).row) {
        case 5:
            performSegue(withIdentifier: "Home_Stress", sender: 2);
        //print("callme???????????????????????????????????????")
        default:
            break;
        }
        tableView.reloadData()
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

