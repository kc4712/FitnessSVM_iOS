//
//  RegisterViewController.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 3. 1..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare;

class RegisterScreen : BaseViewController, UITextFieldDelegate
{
    @IBOutlet var m_email_TextField: UITextField!
    @IBOutlet var m_password_TextField: UITextField!
    @IBOutlet var m_confirm_TextField: UITextField!
    
    @IBOutlet weak var ButtonTerms: UIButton!
    fileprivate var m_check = false;
    fileprivate var m_image_normal = UIImage();
    fileprivate var m_image_press = UIImage();
    
    override func viewDidLoad() {
        print("VC: 회원가입 화면");
        super.viewDidLoad();
        m_image_normal = ButtonTerms.image(for: UIControlState())!;
        m_image_press = ButtonTerms.image(for: .highlighted)!;
        m_check = false;
        ButtonTerms.setImage(m_image_normal, for: UIControlState())
    }

    override func viewDidAppear(_ animated: Bool) {
        // 네비게이션바 보이기
        showNavigationBar();
    }
    
    // 텍스트 입력 상자에서 엔터키 입력 이벤트 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Press Return");
        if (textField.isEqual(m_email_TextField)) {
            m_password_TextField.becomeFirstResponder();
            return true;
        }
        if (textField.isEqual(m_password_TextField)) {
            m_confirm_TextField.becomeFirstResponder();
            return true;
        }
        self.view.endEditing(true);
        return true;
    }

    @IBAction func ButtonCheckClick() {
        if (m_check == false) {
            ButtonTerms.setImage(m_image_press, for: UIControlState());
            m_check = true;
        }
        else {
            ButtonTerms.setImage(m_image_normal, for: UIControlState());
            m_check = false;
        }
    }
    
    // 이용약관 클릭 이벤트 처리
    @IBAction func ButtonTermsClick() {
        m_email_TextField.resignFirstResponder();
        m_password_TextField.resignFirstResponder();
        m_confirm_TextField.resignFirstResponder();
        self.performSegue(withIdentifier: "ViewTerms", sender: self);
    }
   
    // Done(완료) 버튼 클릭 이벤트 처리
    @IBAction func ButtonDoneClick(_ sender: AnyObject) {
        print("Click Done");

        m_email_TextField.resignFirstResponder();
        m_password_TextField.resignFirstResponder();
        m_confirm_TextField.resignFirstResponder();
        
        if(m_check != true) {
            showPopup(NSLocalizedString("agree_term", comment: "이용 약관에 동의해야 합니다."));
            return;
        }
        
        if (m_email_TextField.text?.length == 0) {
            showPopup(NSLocalizedString("enter_email", comment: "이메일 항목이 비었습니다!"));
            return;
        }

        if (m_password_TextField.text?.length == 0) {
            showPopup(NSLocalizedString("enter_pass", comment: "비밀번호 항목이 비었습니다!"));
            return;
        }
        
        if (m_confirm_TextField.text?.length == 0) {
            showPopup(NSLocalizedString("enter_pass_confirm", comment: "비밀번호 체크 항목이 비었습니다!"));
            return;
        }
        
        if (Common.IsValidEmail(m_email_TextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) == false) {
            showPopup(NSLocalizedString("email_not_valid", comment: "잘못된 이메일입니다.\n올바른 형식으로 다시 입력해주세요."));
            return;
        }
        
        if (m_password_TextField.text! != m_confirm_TextField.text!) {
            showPopup(NSLocalizedString("pass_not_match", comment: "비밀번호 확인이 일치하지 않습니다.\n다시한번 확인해주세요."));
            return;
        }
        
        if (Common.IsValidPassword(m_password_TextField.text!) == false) {
            showPopup(NSLocalizedString("pass_not_valid", comment: "비밀번호는 영문+숫자 조합 8~16자리\n사이로 설정하여 주시기 바랍니다."));
            return;
        }

        // 입력된 정보 사용자 레코드에 설정
        BaseViewController.User.Email = m_email_TextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
        BaseViewController.User.Password = m_password_TextField.text;
        
        // 웹 쿼리 실행 (사용자 등록)
        BaseViewController.User.executQuery(.CreateUser, success: SuccessProc, fail: failProc);
    }

    // 웹 쿼리 성공 콜백
    func SuccessProc() {
        print("웹쿼리 성공 !!");
        self.performSegue(withIdentifier: "RegisterSuccess", sender: self);
        //let vc = getViewController("Main", "Main")!;
        //self.presentViewController(vc, animated: true, completion: nil);
    }
    
    func failProc(_ queryStatus: QueryStatus) {
        print("웹쿼리 실패 !!");
        switch queryStatus {
        case .ERROR_Account_Not_Match:
            showPopup(Common.ResString("error_not_account"));
        case .ERROR_Exists_Email:
            showPopup(Common.ResString("error_exists_email"));
        default:
            showPopup(Common.ResString("error_register_account"));
        }
    }
}
