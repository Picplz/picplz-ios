//
//  MainViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit

final class MainViewController: UIViewController {
    let label = UILabel()
    let logoutButton = UIButton()
    
    var viewModel: MainViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MainView"
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16)
        ])
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.logoutButtonTapped()
    }
}
