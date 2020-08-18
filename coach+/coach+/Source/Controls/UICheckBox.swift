//
//  UICheckBox.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 3. 9..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit

class UICheckBox: UIButton
{
    // Images
    let imageNormal = UIImage(named: "CheckBox_Normal")! as UIImage;
    let imageCheck = UIImage(named: "CheckBox_Check")! as UIImage;
    
    var isCheck = false {
        didSet {
            if (isCheck == true) {
                self.setImage(imageCheck, for: UIControlState());
            }
            else {
                self.setImage(imageNormal, for: UIControlState());
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(UICheckBox.buttonClicked(_:)), for: .touchUpInside);
        self.isCheck = false;
    }
    
    @objc func buttonClicked(_ sender: AnyObject) {
        if (sender as! NSObject == self) {
            if (isCheck == true) {
                isCheck = false;
            }
            else {
                isCheck = true;
            }
        }
    }
}
