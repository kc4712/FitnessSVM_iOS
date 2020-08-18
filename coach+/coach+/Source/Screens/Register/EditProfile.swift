//
//  EditProfile.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 5. 11..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare;

class EditProfile : UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate
{
  
    @IBOutlet weak var TextField_Name: UITextField!
    @IBOutlet weak var TextField_Birth: UITextField!
    @IBOutlet weak var TextField_Height: UITextField!
    @IBOutlet weak var TextField_Weight: UITextField!
    @IBOutlet weak var TextField_Gender: UITextField!
    
    @IBOutlet weak var Button_Next: UIBarButtonItem!
    
    fileprivate var m_mode = 0;
    fileprivate var m_birth = Date();
    fileprivate var m_height = 0;
    fileprivate var m_weight = 0;
    fileprivate var m_gender = 0;
    
    
    fileprivate func setNextMode(_ mode: Int) {
        m_mode = mode;
        switch mode {
        case 5:
            Button_Next.title = Common.ResString("navigation_bar_save");
        default:
            Button_Next.title = Common.ResString("navigation_bar_next");
        }
    }
    
    fileprivate func LoadUserProfile() {
        let user = BaseViewController.User;
        if let name = user.Name {
            TextField_Name.text = name;
        }
        else {
            TextField_Name.text = nil;
        }
        
        if let birth = user.Birthday {
            m_birth = birth.date;
        }
        else {
            m_birth = Date();
        }
        TextField_Birth.text = Common.getDateString(m_birth);
        
        m_height = user.Height;
        if (m_height < Height.Minimum) {
            m_height = Height.Default;
        }
        TextField_Height.text = Height.ToString(m_height);
        
        m_weight = Int(user.CurrentWeight);
        if (m_weight < Weight.Minimum) {
            m_weight = Weight.Default;
        }
        TextField_Weight.text = Weight.ToString(m_weight);
        
        m_gender = user.Gender;
        if (m_gender < UserRecord.SEX_MAN || m_gender > UserRecord.SEX_WOMAN) {
            m_gender = UserRecord.SEX_MAN;
        }
        TextField_Gender.text = Common.getGenderString(m_gender);
    }
    
    fileprivate func SaveUserProfile() {
        // 입력된 정보 사용자 레코드에 설정
        BaseViewController.User.Name = TextField_Name.text;
        BaseViewController.User.SetBirthdayDate(m_birth);
        BaseViewController.User.Height = m_height;
        
        //BaseViewController.User.CurrentWeight = Float(m_weight);
        BaseViewController.User.Gender = m_gender;
        
        // 웹 쿼리 실행
        BaseViewController.User.executQuery(QueryCode.SetProfile, success: SuccessProc, fail: nil);
        
        //규창 --- 현재 몸무게랑 설정한 몸무게가 다를 때 몸무게 변경 쿼리 실행
        if BaseViewController.User.CurrentWeight != Float(m_weight) {
            BaseViewController.User.CurrentWeight = Float(m_weight);
            BaseViewController.User.executQuery(QueryCode.SetTarget, success: SuccessProc, fail: nil);
        }
    }
    
    // 웹 쿼리 성공 콜백
    func SuccessProc() {
        print("웹쿼리 성공 !!");
        let mc = MWControlCenter.getInstance()
        
        let user = BaseViewController.User
        Preference.putAge(Int32(user.GetAge()));
        Preference.putSex(Int32(user.Gender));
        Preference.putHeight(Int32(user.Height));
        Preference.putWeight(Float32(user.CurrentWeight));
        
        mc.sendUserData()
        
        if (BaseViewController.MainMode) {
            performSegue(withIdentifier: "unwindToSetting", sender: self);
            return;
        }
        // 프로필 입력 화면으로 이동
        let vc = BaseViewController.changeScreenUserValid()
        if vc.restorationIdentifier != "Main" {
            print("p 1")
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("p 2")
            present(vc, animated: true, completion: nil)
        }
//        self.performSegue(withIdentifier: "SeguePlan", sender: self);
//        Common.changeScreen(self, story: "Main", view: "Main");
    }
    
    override func viewDidLoad() {
        print("Load: 프로필 수정 화면");
        super.viewDidLoad();
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
        return 6;
    }

    //-----------------------------------------------
    // 픽커 뷰 위임 처리
    //-----------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch m_mode {
        // 신장
        case 3:
            return Height.Length;
        // 몸무게
        case 4:
            return Weight.Length;
        // 성별
        case 5:
            return 2;
        default:
            return 1;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch m_mode {
        case 3:
            return Height.ToString(Height.FromIndex(row));
        case 4:
            return Weight.ToString(Weight.FromIndex(row));
        case 5:
            return Common.getGenderString(row + 1);
        default:
            return "??";
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch m_mode {
        case 3:
            m_height = Height.FromIndex(row);
            TextField_Height.text = Height.ToString(m_height);
        case 4:
            m_weight = Weight.FromIndex(row);
            TextField_Weight.text = Weight.ToString(m_weight);
        case 5:
            m_gender = row + 1;
            TextField_Gender.text = Common.getGenderString(m_gender);
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
        // 이름 수정
        if (textField.isEqual(TextField_Name)) {
            setNextMode(1);
            return;
        }
        // 생년월일 수정
        if (textField.isEqual(TextField_Birth)) {
            setNextMode(2);
            let datePickerView = UIDatePicker();
            datePickerView.datePickerMode = UIDatePickerMode.date;
            datePickerView.setDate(m_birth, animated: false);
            textField.inputView = datePickerView;
            datePickerView.addTarget(
                self,
                action: #selector(datePickerValueChanged),
                for: UIControlEvents.valueChanged);
            return;
        }
        // 신장 수정
        if (textField.isEqual(TextField_Height)) {
            textField.inputView = makePicker(3, row: Height.ToIndex(m_height));
            return;
        }
        // 몸무게 수정
        if (textField.isEqual(TextField_Weight)) {
            textField.inputView = makePicker(4, row: Weight.ToIndex(m_weight));
            return;
        }
        // 성별 수정
        if (textField.isEqual(TextField_Gender)) {
            textField.inputView = makePicker(5, row: m_gender - 1);
            return;
        }
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        m_birth = sender.date;
        TextField_Birth.text = Common.getDateString(m_birth);
    }

    //-----------------------------------------------
    // 네비게이션 바 처리
    //-----------------------------------------------

    // 다음 버튼 클릭
    @IBAction func Button_Next_Click(_ sender: UIBarButtonItem) {
        switch m_mode {
        case 0:
            TextField_Name.becomeFirstResponder();
            return;
        case 1:
            TextField_Birth.becomeFirstResponder();
            return;
        case 2:
            TextField_Height.becomeFirstResponder();
            return;
        case 3:
            TextField_Weight.becomeFirstResponder();
            return;
        case 4:
            TextField_Gender.becomeFirstResponder();
            return;
        default:
            self.view.endEditing(true);
            SaveUserProfile();
            break;
        }
    }
}
