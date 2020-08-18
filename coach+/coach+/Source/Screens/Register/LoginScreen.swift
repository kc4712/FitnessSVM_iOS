//
//  LoginViewController.swift
//  DevBaseTool
//
//  Created by 김영일 이사 on 2016. 3. 1..
//  Copyright © 2016년 그린콤 김영일. All rights reserved.
//

import UIKit;
import MiddleWare;

class LoginScreen : BaseViewController, UITextFieldDelegate
{
    override func viewDidLoad() {
        print("VC: 로그인 화면");
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 네비게이션바 보이기
        showNavigationBar();
        // 저장된 로그인 정보 사용
        if Preference.Email != nil {
            TextFieldEmail.text = Preference.Email;
        }
        if Preference.Password != nil {
            TextFieldPassword.text = Preference.Password;
        }
        //setNoti();
        // 사용자 데이터베이스 처리에 성공한 경우 콜백 설정
        BaseViewController.User.SetSuccess(SuccessProc);
    }

    // 텍스트 입력 상자에서 엔터키 입력 이벤트 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return true;
    }
    
    /*
    func setNoti() {
        let nc = NSNotificationCenter.defaultCenter();
        nc.addObserver(self, selector: #selector(SuccessProc), name: QueryStatus.Success.rawValue, object: nil);
    }
    */
    
    open func SuccessProc() {
        print("웹쿼리 성공 !!");
        
        if let name = BaseViewController.User.DeviceName {
            if let prefix = name.substringToIndex(ProductCode.coach.bluetoothDeviceName.length) {
                var code: ProductCode = .fitness
                switch prefix {
                case ProductCode.coach.bluetoothDeviceName:
                    code = ProductCode.coach
                case ProductCode.fitness.bluetoothDeviceName:
                    code = ProductCode.fitness
                default:
                    code = ProductCode.fitness
                }
                
                MWControlCenter.getInstance().selectProduct(code)
            } else {
                MWControlCenter.getInstance().selectProduct(ProductCode.fitness)
            }
        }

        let vc = BaseViewController.getViewController("Main", "Main")!;
        self.present(vc, animated: true, completion: nil);
    }
    
    open func failProc(_ queryStatus: QueryStatus) {
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

    @IBOutlet var TextFieldEmail: UITextField!
    @IBOutlet var TextFieldPassword: UITextField!
    
    @IBAction func ButtonLogin(_ sender: AnyObject) {
        //규창  ---- Swift2당시의 코드 원형
        //BaseViewController.User
        /*
        guard let email = TextFieldEmail.text, (TextFieldEmail.text?.length)! <= 0 else {
            showMessage(
                nil,
                message: NSLocalizedString("enter_email", comment: "이메일을 입력해주세요."),
                buttonCaption: NSLocalizedString("OK", comment: "확인"),
                viewController: self);
            return;
        }
        guard let password = TextFieldPassword.text, (TextFieldPassword.text?.length)! <= 0 else {
            showMessage(
                nil,
                message: NSLocalizedString("enter_password", comment: "비밀번호를 입력해주세요."),
                buttonCaption: NSLocalizedString("OK", comment: "확인"),
                viewController: self);
            return;
        }*/
        
        let email = TextFieldEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = TextFieldPassword.text
        
        if ((email?.length)! <= 0) {
            showMessage(
                nil,
                message: NSLocalizedString("enter_email", comment: "이메일을 입력해주세요."),
                buttonCaption: NSLocalizedString("OK", comment: "확인"),
                viewController: self);
            return;
        }
        if ((password?.length)! <= 0) {
            showMessage(
                nil,
                message: NSLocalizedString("enter_password", comment: "비밀번호를 입력해주세요."),
                buttonCaption: NSLocalizedString("OK", comment: "확인"),
                viewController: self);
            return;
        }
        Preference.Email = email;
        Preference.Password = password;
        
        BaseViewController.User.Email = email;
        BaseViewController.User.Password = password;

        BaseViewController.User.executQuery(QueryCode.LoginUser, success: SuccessProc, fail: failProc);
    }
    
}
