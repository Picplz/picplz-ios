//
//  MainViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    let label = UILabel()
    let logoutButton = UIButton()
    
    var viewModel: MainViewModelProtocol!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupLayout()
        
        label.text = "로그인됨 accessToken=\(viewModel.accessToken ?? "nil")"
        
        bind()
        viewModel.viewPrepared()
    }
    
    private func setupStyle() {
        view.backgroundColor = .picplzWhite
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MainView"
        label.numberOfLines = 0
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(.picplzBlack, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            view.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8),
        ])
        
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16)
        ])
    }
    
    private func bind() {
        viewModel.accessTokenPublisher
            .receive(on: RunLoop.main)
            .compactMap({ $0 })
            .sink { [weak self] accessToken in
                self?.label.text = "로그인됨 accessToken=\(accessToken)"
            }
            .store(in: &subscriptions)
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.logoutButtonTapped()
    }
}
