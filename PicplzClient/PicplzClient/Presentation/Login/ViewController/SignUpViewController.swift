//
//  SignUpViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/15/25.
//

import UIKit
import OSLog

final class SignUpViewController: UIViewController {
    private let contentView = SignUpCommonNicknameFormView()
    
    private var log = Logger.of("LoginViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "닉네임 설정하기"
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .picplzWhite
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15.0),
        ])
    }
}
