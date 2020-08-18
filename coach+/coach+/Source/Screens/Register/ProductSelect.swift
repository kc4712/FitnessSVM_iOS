//
//  ProductSelect.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 20..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import Foundation
import UIKit;
import MiddleWare

class ProductSelect : UITableViewController {
    override func viewDidLoad() {
        print("기종 선택");
        super.viewDidLoad();
        
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sender: ProductCode
        switch (indexPath as NSIndexPath).row {
        case 2:
            sender = .coach
        case 3:
            sender = .fitness
        default:
            return
        }
        
        MWControlCenter.getInstance().selectProduct(sender)
        
        performSegue(withIdentifier: "SG_SelectDevice", sender: sender.rawValue)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SG_SelectDevice" {
            if let dest = segue.destination as? SelectDevice {
                if let productCode = sender as? Int {
                    dest._ProductCode = ProductCode(rawValue: productCode)!
                }
            }
        }
    }
}
