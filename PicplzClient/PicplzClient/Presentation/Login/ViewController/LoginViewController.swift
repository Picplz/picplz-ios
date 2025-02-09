//
//  LoginViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit

final class LoginViewController: UIViewController {
    private let label = UILabel()
    private let loginButton = UIButton()
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LoginView"
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("로그인", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16)
        ])
    }
    
    @objc private func loginButtonTapped() {
        viewModel.loginButtonTapped()
    }
}
