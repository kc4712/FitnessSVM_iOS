//
//  WeightSelector.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 12..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;


@IBDesignable
open class WeightSelector: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame);
        xibSetup();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        xibSetup();
    }
    
    var view : UIView!;
    
    
    @IBOutlet fileprivate weak var m_slide: UISlider!
    
    @IBOutlet fileprivate weak var m_label_min: UILabel!
    @IBOutlet fileprivate weak var m_label_max: UILabel!
    
    @IBOutlet fileprivate weak var m_label_left: UILabel!
    @IBOutlet fileprivate weak var m_label_center: UILabel!
    @IBOutlet fileprivate weak var m_label_right: UILabel!
    
    fileprivate func xibSetup() {
        view = loadViewFromNib();
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight];
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        SelectMode = 0;
        
        MinValue = 56;
        MaxValue = 75;
        NowValue = (56+75)/2;
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WeightSelector", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    fileprivate var m_mode: Int = 0;
    fileprivate var m_image_thumb: UIImage?;
    fileprivate var m_image_min: UIImage?;
    fileprivate var m_image_max: UIImage?;
    
    fileprivate var m_value_min: Int = 0;
    fileprivate var m_value_max: Int = 0;
    fileprivate var m_value_now: Int = 0;
    
    fileprivate func ModeDisplay() {
        if (m_mode == 0) {
            m_label_left.text = Common.ResString("weight_selector_below_standard")
            m_label_center.text = Common.ResString("weight_selector_standard")
            m_label_right.text = Common.ResString("weight_selector_more_than_standard")
        }
        else {
            m_label_left.text = Common.ResString("weight_selector_over")
            m_label_center.text = Common.ResString("weight_selector_suitability")
            m_label_right.text = Common.ResString("weight_selector_enough")
        }
        m_label_min.text = "\(m_value_min)" + (m_mode == 0 ? "kg" : Common.ResString("weight_selector_week"));
        m_label_max.text = "\(m_value_max)" + (m_mode == 0 ? "kg" : Common.ResString("weight_selector_week"));
    }
    
    @IBInspectable open var SelectMode: Int {
        get { return m_mode; }
        set {
            m_mode = newValue;
            ModeDisplay();
        }
    }
    
    @IBInspectable open var MinImage: UIImage? {
        get { return m_image_min; }
        set(image) {
            m_image_min = image;
            m_slide.setMinimumTrackImage(image, for: UIControlState());
        }
    }

    @IBInspectable open var MaxImage: UIImage? {
        get { return m_image_max; }
        set(image) {
            m_image_max = image;
            m_slide.setMaximumTrackImage(image, for: UIControlState());
        }
    }

    @IBInspectable open var ThumbImage: UIImage? {
        get { return m_image_thumb; }
        set(image) {
            m_image_thumb = image;
            m_slide.setThumbImage(image, for: UIControlState());
            m_slide.setThumbImage(image, for: UIControlState.highlighted);
        }
    }
    
    @IBInspectable open var MinValue: Int {
        get { return m_value_min; }
        set {
            m_value_min = newValue;
            m_slide.minimumValue = Float(m_value_min - 20);
            ModeDisplay();
        }
    }
    
    @IBInspectable open var MaxValue: Int {
        get { return m_value_max; }
        set {
            m_value_max = newValue;
            m_slide.maximumValue = Float(m_value_max + 20);
            ModeDisplay();
        }
    }
    
    @IBInspectable open var NowValue: Int {
        get { return m_value_now; }
        set {
            m_value_now = newValue;
            m_slide.value = Float(m_value_now);
        }
    }

}
