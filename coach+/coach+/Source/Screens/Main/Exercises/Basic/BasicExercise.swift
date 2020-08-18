//
//  BasicExercise.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 19..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit

class BasicExercise: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate static let tag = BasicExercise.className
    
    
    override func viewDidLoad() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if let icon = cell.viewWithTag(11) as? UIImageView {
            icon.image = UIImage(named: "CoachBasic_photo_sel.png")
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch ((indexPath as NSIndexPath).row) {
        case 0:
            if let icon = cell.viewWithTag(11) as? UIImageView {
                icon.image = UIImage(named: "CoachBasic_photo_001.png")
            }
            if let name = cell.viewWithTag(12) as? UILabel {
                name.text = Common.ResString("prepare_exercise")
            }
        case 1:
            if let icon = cell.viewWithTag(11) as? UIImageView {
                icon.image = UIImage(named: "CoachBasic_photo_002.png")
            }
            if let name = cell.viewWithTag(12) as? UILabel {
                name.text = Common.ResString("15min_exercise")
            }
        case 2:
            if let icon = cell.viewWithTag(11) as? UIImageView {
                icon.image = UIImage(named: "CoachBasic_photo_003.png")
            }
            if let name = cell.viewWithTag(12) as? UILabel {
                name.text = Common.ResString("mat_exercise")
            }
        case 3:
            if let icon = cell.viewWithTag(11) as? UIImageView {
                icon.image = UIImage(named: "CoachBasic_photo_004.png")
            }
            if let name = cell.viewWithTag(12) as? UILabel {
                name.text = Common.ResString("active_exercise")
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BaseViewController.trainer = TrainerCode.기초
        switch ((indexPath as NSIndexPath).row) {
        case 0:
            BaseViewController.program = ProgramCode.기초
        case 1:
            BaseViewController.program = ProgramCode.전신
        case 2:
            BaseViewController.program = ProgramCode.매트
        case 3:
            BaseViewController.program = ProgramCode.액티브
        default:
            break
        }
        
        performSegue(withIdentifier: "BasicSelect", sender: self)
        tableView.reloadData()
    }
}
