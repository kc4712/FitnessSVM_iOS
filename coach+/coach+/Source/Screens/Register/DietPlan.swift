//
//  DietPlan.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 12..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare;

class DietPlan : UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    @IBOutlet weak var TextField_Current: UITextField!
    @IBOutlet weak var TextField_Target: UITextField!
    @IBOutlet weak var TextField_Period: UITextField!
    
    @IBOutlet weak var Label_Calorie: UILabel!
    
    @IBOutlet weak var Selector_Current: WeightSelector!
    @IBOutlet weak var Selector_Target: WeightSelector!
    @IBOutlet weak var Selector_Period: WeightSelector!
    
    @IBOutlet weak var Label_Info_Weight: UILabel!
    @IBOutlet weak var Label_Info_Calorie: UILabel!
    
    @IBOutlet weak var BarButton_Next: UIBarButtonItem!
    
    
    // 미들웨어
    fileprivate var mc: MWControlCenter?
    
    fileprivate var m_mode = 0;

    fileprivate var m_current_weight = 0;
    fileprivate var m_target_weight = 0;
    fileprivate var m_diet_period = 0;
    
    fileprivate func setCurrentWeight(_ val: Int) {
        m_current_weight = val;
        if (m_current_weight < Weight.Minimum || m_current_weight > Weight.Maximum) {
            m_current_weight = Weight.Default;
        }
        if (m_target_weight > m_current_weight) {
            m_target_weight = m_current_weight;
        }
        if (m_target_weight < Weight.Minimum) {
            m_target_weight = Weight.Default < m_current_weight ? Weight.Default : m_current_weight;
        }
        TextField_Current.text = String(m_current_weight);
        TextField_Target.text = String(m_target_weight);
        Selector_Current.NowValue = m_current_weight;

        displayRenge();
    }
    
    fileprivate func setTargetWeight(_ val: Int) {
        m_target_weight = val;
        if (m_target_weight > m_current_weight) {
            m_target_weight = m_current_weight;
        }
        if (m_target_weight < Weight.Minimum) {
            m_target_weight = Weight.Default < m_current_weight ? Weight.Default : m_current_weight;
        }
        TextField_Target.text = String(m_target_weight);
        Selector_Target.NowValue = m_target_weight;
        
        displayRenge();
    }
    
    fileprivate func setPeriod(_ val: Int) {
        m_diet_period = val;
        if (m_diet_period < 1) {
            m_diet_period = 1;
        }
        if (m_diet_period > 199) {
            m_diet_period = 199;
        }
        TextField_Period.text = String(m_diet_period);
        displayRenge();
    }

    fileprivate func makeColorText(_ format: String, segment: String, color: UIColor) -> NSAttributedString {
        let msg = String(format: format, segment);
        let ret = NSMutableAttributedString(string: msg);
        let range = (msg as NSString).range(of: segment);
        ret.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range);
        return ret;
    }

    fileprivate func displayRenge() {
        let current = Float32(m_current_weight);
        let target = Float32(m_target_weight);
        let period = Int32(m_diet_period);
        
        if let scalePeriod = mc?.getScaleDietPeriod(current, goalWeight: target) {
            Selector_Period.MinValue = Int(scalePeriod.over);
            Selector_Period.MaxValue = Int(scalePeriod.suitable);
            Selector_Period.NowValue = m_diet_period;
        }
        
        if (mc != nil) {
            let cal = mc!.getCalorieConsumeDaily(current, goalWeight: target, dietPeriod: period);
            print("Cur=\(current), Tar=\(target), Prd=\(period), Cal=\(cal)");
            let intCal = Int(cal);
            Label_Calorie.text = "\(intCal) kcal";
            let info = String(format: "%d kcal", intCal);
            let format = Common.ResString("dietplan_daily_calorie_format");
            Label_Info_Calorie.attributedText = makeColorText(format, segment: info, color: UIColor.blue);
        }
    }
    
    fileprivate func setNextMode(_ mode: Int) {
        m_mode = mode;
        switch mode {
        case 3:
            BarButton_Next.title = Common.ResString("navigation_bar_save");
        default:
            BarButton_Next.title = Common.ResString("navigation_bar_next");
        }
    }
    
    fileprivate func LoadUserProfile() {
        let user = BaseViewController.User;
        setCurrentWeight(Int(user.CurrentWeight));
        setTargetWeight(Int(user.TargetWeight));
        setPeriod(user.DietPeriod);
        
        let height = user.Height;
        
        if let scaleWeight = mc?.getScaleWeight(Int32(height)) {
            //규창 그래프 범주 최소 최대 + 1 되서 보이게끔 변경 
            //Selector_Current.MinValue = Int(scaleWeight.normal_below)
            //Selector_Current.MaxValue = Int(scaleWeight.normal_morethan)
            Selector_Current.MinValue = Int(scaleWeight.normal_below)+1;
            Selector_Current.MaxValue = Int(scaleWeight.normal_morethan)+1;
            Selector_Current.NowValue = m_current_weight;
            
            //Selector_Target.MinValue = Int(scaleWeight.normal_below)
            //Selector_Target.MaxValue = Int(scaleWeight.normal_morethan)
            Selector_Target.MinValue = Int(scaleWeight.normal_below)+1;
            Selector_Target.MaxValue = Int(scaleWeight.normal_morethan)+1;
            Selector_Target.NowValue = m_target_weight;
            
            //let info = String(format: "%d ~ %d kg", Int(scaleWeight.normal_below), Int(scaleWeight.normal_morethan));
            let info = String(format: "%d ~ %d kg", Int(scaleWeight.normal_below)+1, Int(scaleWeight.normal_morethan)+1);
            let format = Common.ResString("BMI_WHO");
            Label_Info_Weight.attributedText = makeColorText(format, segment: info, color: UIColor.green);
        }
        
        displayRenge();
    }
    
    fileprivate func SaveUserProfile() {
        // 입력된 정보 사용자 레코드에 설정
        let user = BaseViewController.User;
        user.CurrentWeight = Float(m_current_weight);
        user.TargetWeight = Float(m_target_weight);
        user.DietPeriod = m_diet_period;
        
        // 웹 쿼리 실행
        BaseViewController.User.executQuery(QueryCode.SetTarget, success: SuccessProc, fail: nil);
    }
    
    // 웹 쿼리 성공 콜백
    func SuccessProc() {
        print("웹쿼리 성공 !!");
        // 메인화면으로 이동
        let mc = MWControlCenter.getInstance()
        
        let user = BaseViewController.User
        Preference.putWeight(Float32(user.CurrentWeight));
        Preference.putGoalWeight(Float32(user.TargetWeight));
        Preference.putDietPeriod(Int32(user.DietPeriod))
        
        mc.sendUserData()
        if (BaseViewController.MainMode) {
            performSegue(withIdentifier: "unwindToSetting", sender: self);
            return;
        }
        let vc = BaseViewController.changeScreenUserValid()
        if vc.restorationIdentifier != "Main" {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            present(vc, animated: true, completion: nil)
        }
//        Common.changeScreen(self, story: "Main", view: "Main");
    }
    
    override func viewDidLoad() {
        print("Load: 감량 계획 화면");
        super.viewDidLoad();
        
        mc = MWControlCenter.getInstance();
        
       
        // 테이블 뷰 하단의 빈 라인 제거
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        tableView.allowsSelection = false
        // 사용자 테이블에서 프로필 가져오기
        setNextMode(0);
        LoadUserProfile();
    }

    //-----------------------------------------------
    // 테이블 뷰 위임 처리
    //-----------------------------------------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9;
    }
    
    //-----------------------------------------------
    // 픽커 뷰 위임 처리
    //-----------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 픽커의 범위
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch m_mode {
        // 현재 몸무게
        case 1:
            return Weight.Length;
        // 목표 몸무게
        case 2:
            return m_current_weight - Weight.Minimum + 1;
        // 감량기간
        case 3:
            return 199;
        default:
            return 1;
        }
    }
    
    // 픽커에 표시될 항목
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch m_mode {
        case 1:
            return Weight.ToString(Weight.FromIndex(row));
        case 2:
            return Weight.ToString(Weight.FromIndex(row));
        case 3:
            return "\(row + 1)" + Common.ResString("weight_selector_week");
        default:
            return "??";
        }
    }
    
    // 선택 픽커가 선택 되었을때 (값 적용)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch m_mode {
        case 1:
            setCurrentWeight(Weight.FromIndex(row));
            break;
        case 2:
            setTargetWeight(Weight.FromIndex(row));
            break;
        case 3:
            setPeriod(row + 1);
            break;
        default:
            break;
        }
    }
    
    func makePicker(_ mode: Int, row: Int) -> UIPickerView {
        setNextMode(mode);
        
        let pickerView = UIPickerView();
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.reloadAllComponents();
        
        pickerView.selectRow(row, inComponent: 0, animated: false);
        return pickerView;
    }
    
    //-----------------------------------------------
    // 텍스트 필드 위임 처리
    //-----------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 현재 몸무게
        if (textField.isEqual(TextField_Current)) {
            textField.inputView = makePicker(1, row: m_current_weight - Weight.Minimum);
            return;
        }
        // 목표 몸무게
        if (textField.isEqual(TextField_Target)) {
            textField.inputView = makePicker(2, row: m_target_weight - Weight.Minimum);
            return;
        }
        // 다이어트 기간
        if (textField.isEqual(TextField_Period)) {
            textField.inputView = makePicker(3, row: m_diet_period - 1);
            return;
        }
    }
    
    @IBAction func Button_Next_Click(_ sender: UIBarButtonItem) {
        switch m_mode {
        case 0:
            TextField_Current.becomeFirstResponder();
        case 1:
            TextField_Target.becomeFirstResponder();
        case 2:
            TextField_Period.becomeFirstResponder();
        case 3:
            self.view.endEditing(true);
            SaveUserProfile();
        default:
            break;
        }
    }
    
}
