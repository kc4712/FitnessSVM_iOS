//
//  UIViewExtension.swift
//  CoachPlus
//
//  Created by 양정은 on 2016. 8. 3..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation

extension UIView {
    fileprivate static var isRotate = false
    var isRotating: Bool {
        return UIView.isRotate
    }
    
    func startRotate(_ duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        UIView.isRotate = true
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        //규창 171010 M_Pi->Double.pi or .pi
        //rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .infinity
        
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func stopRotate() {
        UIView.isRotate = false
        self.layer.removeAllAnimations()
    }
}
