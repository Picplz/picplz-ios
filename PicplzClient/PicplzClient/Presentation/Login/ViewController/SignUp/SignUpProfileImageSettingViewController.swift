//
//  SignUpProfileImageSettingViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/18/25.
//

import Foundation

import UIKit
import Combine
import OSLog

final class SignUpProfileImageSettingViewController: UIViewController {
//    var viewModel: SignUpProfileImageSettingViewModelProtocol!
    private var subscriptions: Set<AnyCancellable> = []
    
    private let contentView = SignUpProfileImageSettingView()
    private let nextButton = UIButton()
    
    private var log = Logger.of("SignUpNicknamePageViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "프로필 이미지 업로드"
        
        setup()
//        bind()
        
        contentView.setUserNickname(for: "임영택")
    }
    
    private func setup() {
        view.backgroundColor = .picplzWhite
        
        // MARK: ContentView
        contentView.isUserInteractionEnabled = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15.0),
            contentView.heightAnchor.constraint(equalToConstant: 450),
        ])
        
        contentView.profileImageButton.addTarget(self, action: #selector(didSelectButtonTapped), for: .touchUpInside)
        contentView.selectImageButton.addTarget(self, action: #selector(didSelectButtonTapped), for: .touchUpInside)
        
        // MARK: Next Button
        // FIXME: Duplicated
        nextButton.setTitle("다음에 설정하기", for: .normal)
        nextButton.setTitleColor(.grey2, for: .normal)
        nextButton.titleLabel?.font = .buttonTitle
        nextButton.backgroundColor = .picplzBlack
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            view.rightAnchor.constraint(equalTo: nextButton.rightAnchor, constant: 15),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 47),
        ])
    }
    
    @objc private func nextButtonTapped() {
        log.debug("nextButtonTapped")
    }
    
    @objc private func didSelectButtonTapped() {
        log.debug("didSelectButtonTapped")
    }
}
