//
//  ExerciseList.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 21..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit

class ExerciseList: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate static let tag = ExerciseList.className
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var categorie: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var job: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BaseViewController.trainer.programList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        
        switch BaseViewController.trainer {
        case .권도예:
            photo?.image = UIImage(named: "FitnessProgram_trainer_03_photo_01.png")
            categorie?.text = Common.ResString("yoga_weight_trainning")
            name?.text = Common.ResString("kwon_do_ye")
            job?.text = Common.ResString("eagle_ship_team_ladyz")
        case .이주영:
            photo?.image = UIImage(named: "FitnessProgram_trainer_01_photo_01.png")
            categorie?.text = Common.ResString("pilates")
            name?.text = Common.ResString("lee_joo_young")
            job?.text = Common.ResString("trainer")
        case .홍두한:
            photo?.image = UIImage(named: "FitnessProgram_trainer_02_photo_01.png")
            categorie?.text = Common.ResString("muscle")
            name?.text = Common.ResString("hong_doo_han")
            job?.text = Common.ResString("trainer")
        default:
            break
        }
        
        let description = cell.viewWithTag(41) as? UILabel
        
        for i in 0..<BaseViewController.trainer.programList.count {
            if (indexPath as NSIndexPath).row == i {
                description?.text = BaseViewController.trainer.programList[i].programName
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<BaseViewController.trainer.programList.count {
            if (indexPath as NSIndexPath).row == i {
                BaseViewController.program = BaseViewController.trainer.programList[i]
                break
            }
        }
        
        tableView.reloadData()
        
        performSegue(withIdentifier: "FitnessSelect", sender: self)
    }
}
