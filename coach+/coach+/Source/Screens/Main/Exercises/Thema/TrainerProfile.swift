//
//  TrainerProfile.swift
//  coach+
//
//  Created by 양정은 on 2016. 7. 21..
//  Copyright © 2016년 Company Green Comm. All rights reserved.
//

import Foundation
import UIKit

class TrainerProfile: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var categorie: UILabel!
    @IBOutlet var job: UILabel!
    
    @IBOutlet weak var scroll_Width: NSLayoutConstraint!
    @IBOutlet weak var scroll_Height: NSLayoutConstraint!
    
    @IBOutlet var mWebView: UIWebView!
    
    fileprivate var photoArray: [UIImage] = []
    
    private func setDeviceWidth() {
        let rect = UIScreen.main.bounds;
        scroll_Width.constant = rect.size.width;
        print("Set Screen Width: \(rect.size.width)");
        mWebView.scrollView.isScrollEnabled = false;
        mWebView.scrollView.bounces = false;
    }
    
    private func setContentHeight() {
        let m_frame = mWebView.frame;
        let m_org_height = m_frame.size.height;
        print("WebView Old Size: \(m_frame.size.width), \(m_frame.size.height)");
        //m_frame.size.height = 1;
        //mWebView.frame = m_frame;
        let m_fit_size = mWebView.sizeThatFits(CGSize.zero);
        print("WebView Fit Size: \(m_fit_size.width), \(m_fit_size.height)");
        let m_inc_height = m_fit_size.height - m_org_height;
        print("WebView Inc Size: \(m_inc_height)");
        
        let m_new_height = scroll_Height.constant + m_inc_height;
        scroll_Height.constant = m_new_height;
        print("Set Screen Height: \(m_new_height)");
    }

    override func viewDidLoad() {
        setDeviceWidth();
        
        setImageViewProperty()
        setProfile()
        setHtml()
        
        if !photo.isAnimating {
            photo.startAnimating()
        }
        
        //mWebView.loadHTMLString("아무거나 적어놓음", baseURL: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        setContentHeight();
    }

    override func viewDidAppear(_ animated: Bool) {
    }
    
    fileprivate func setProfile() {
        switch BaseViewController.trainer {
        case .권도예:
            categorie?.text = Common.ResString("yoga_weight_trainning")
            name?.text = Common.ResString("kwon_do_ye")
            job?.text = Common.ResString("eagle_ship_team_ladyz")
        case .이주영:
            categorie?.text = Common.ResString("pilates")
            name?.text = Common.ResString("lee_joo_young")
            job?.text = Common.ResString("trainer")
        case .홍두한:
            categorie?.text = Common.ResString("muscle")
            name?.text = Common.ResString("hong_doo_han")
            job?.text = Common.ResString("trainer")
        default:
            break
        }
    }
    
    fileprivate func setHtml() {
        let url = Bundle.main.url(forResource: BaseViewController.trainer.profileTrainerHtml, withExtension:"html")
        let request = URLRequest(url: url!)
        mWebView.loadRequest(request)
    }
    
    fileprivate func setImageViewProperty() {
        let len = BaseViewController.trainer.photoNumber
        if len == 0 {
            return
        }
        
        for i in 1...len {
            let imageName = String(format: "FitnessProgram_trainer_%02d_photo_%02d.png", BaseViewController.trainer.rawValue, i)
            if let image = UIImage(named: imageName) {
                photoArray.append(image)
            }
        }
        
        photo.animationImages = photoArray
        photo.animationRepeatCount = 0
        photo.animationDuration = 6
        photo.image = photoArray[0]
    }
}
