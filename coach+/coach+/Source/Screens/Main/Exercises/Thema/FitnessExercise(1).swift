//
//  FitnessExercise.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 20..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit

class FitnessExercise: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate static let tag = FitnessExercise.className
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BaseViewController.trainer.trainerNumber
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)!
        
        let icon = cell.viewWithTag(31) as? UIImageView
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            icon?.image = UIImage(named: "FitnessProgram_trainer_03_p.png")
        case 1:
            icon?.image = UIImage(named: "FitnessProgram_trainer_01_p.png")
        case 2:
            icon?.image = UIImage(named: "FitnessProgram_trainer_02_p.png")
        default:
            break
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        
        let icon = cell.viewWithTag(31) as? UIImageView
        let categorie = cell.viewWithTag(32) as? UILabel
        let name = cell.viewWithTag(33) as? UILabel
        let job = cell.viewWithTag(34) as? UILabel

        
        switch ((indexPath as NSIndexPath).row) {
        case 0:
            icon?.image = UIImage(named: "FitnessProgram_trainer_03_n.png")
            categorie?.text = Common.ResString("yoga_weight_trainning")
            name?.text = Common.ResString("kwon_do_ye")
            job?.text = Common.ResString("eagle_ship_team_ladyz")
        case 1:
            icon?.image = UIImage(named: "FitnessProgram_trainer_01_n.png")
            categorie?.text = Common.ResString("pilates")
            name?.text = Common.ResString("lee_joo_young")
            job?.text = Common.ResString("trainer")
        case 2:
            icon?.image = UIImage(named: "FitnessProgram_trainer_02_n.png")
            categorie?.text = Common.ResString("muscle")
            name?.text = Common.ResString("hong_doo_han")
            job?.text = Common.ResString("trainer")
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).row) {
        case 0:
            BaseViewController.trainer = TrainerCode.권도예
        case 1:
            BaseViewController.trainer = TrainerCode.이주영
        case 2:
            BaseViewController.trainer = TrainerCode.홍두한
        default:
            break
        }
        
        performSegue(withIdentifier: "TrainerProfile", sender: self)
        
        tableView.reloadData()
    }
}
