//
//  ViewController.swift
//  AuthCodeExample
//
//  Created by Liu Chuan on 2018/3/4.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - 懒加载视图
    /// 文本输入框
    private lazy var textField: UITextField = {
        let textfield = UITextField(frame: CGRect(x: 30, y: 210, width: 200, height: 40))
        textfield.layer.borderColor = UIColor.gray.cgColor
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 5
        textfield.font = UIFont.systemFont(ofSize: 12)
        textfield.placeholder = "请输入验证码,不区分大小写."
        textfield.backgroundColor = .clear
        textfield.textAlignment = .center
        return textfield
    }()
    
    /// 验证按钮
    private lazy var verifyButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 230, y: 210, width: 100, height: 40))
        btn.backgroundColor = .blue
        btn.setTitle("验证", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(verifyBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    /**** AuthCodeView ****/
    private lazy var authCode: AuthCodeView = {
        let viewFrame = CGRect(x: 30, y: 100, width: 300, height: 100)
        let auth = AuthCodeView(frame: viewFrame, with: IdentifyingCodeType.defaultType)
        auth.kCharCount = 4
        auth.kLineCount = 9
        auth.isRotation = true
        return auth
    }()
    
    // MARK: - 视图的生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textField)
        view.addSubview(verifyButton)
        view.addSubview(authCode)
    }
}

// MARK: - 事件监听
extension ViewController {

    /// 验证按钮点击事件
    @objc private func verifyBtnClicked() {
        if textField.text == authCode.defaultString {
            let alert = UIAlertController(title: "恭喜您", message: "验证成功", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "", message: "您输入的验证码有误,请重试.", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            // 验证不匹配，验证码 和 输入框 晃动动画
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.repeatCount = 1
            animation.repeatDuration = 2
            animation.values = [-20, 20, -20]
            authCode.layer.add(animation, forKey: nil)
            textField.layer.add(animation, forKey: nil)
            verifyButton.layer.add(animation, forKey: nil)
        }
    }
}
