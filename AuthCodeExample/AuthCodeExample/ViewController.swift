//
//  ViewController.swift
//  AuthCodeExample
//
//  Created by Liu Chuan on 2018/3/4.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**** AuthCodeView ****/
        let viewFrame = CGRect(x: 30, y: 100, width: 300, height: 100)
        let authCode = AuthCodeView(frame: viewFrame, with: IdentifyingCodeType.defaultType)
        authCode.isRotation = false
        view.addSubview(authCode)
    }
}

